Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C05F43E9C6;
	Mon, 17 Aug 2026 13:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974574; cv=none; b=tDX/Oq+NrpFMRKZbeJw2GXBYHxwVOAOvDT8AEAcJBbOPo5yPjQums0pjDnaqvStx6G3514jZCIiQ9npgTQJ6CmCRcX8LWQtXJy0mACQCpZwNOcs5eKQV/TzTkJuuWKpHNzEbaMai3JBdT/hQqCrqZqS92NYM0PQ0tDTWY0d86Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974574; c=relaxed/simple;
	bh=g449n2U3e3pyO43ykrRCCxxrz8xM7vmcI5VVhWQa7LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuZnghheBVs4iZQRVz3yA4S0WgH7zTH99Pi4XZeDkBvjJ4moVs1AAuPbfHj/vQPvt8iTys+fev55Rl0/t9HAITqhaD3bqshwWQ13XqeamgapWkYeDGmhKuAiQ1dkRMqEjyxskBanwacAMlOpTeehi5/qvY4vIpXJjfyjZPEwC+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSYJjCa8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSYJjCa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A31B1F000E9;
	Mon, 17 Aug 2026 13:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974569;
	bh=Hb+xjwDM7AA/TaYN5Thqnwr/xoMCv0hf+V0J3EbXC9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSYJjCa8XeRWirS0PQMwcit+8r9A6GPQu8ACUdE5CiN780bg8/27EzRAsiZispixd
	 8lI5XUnONRNkkvCDYdRQNgtXu3DI9nA/f7ZAY+HxEBEfTfW2lTH3R8/Fwe4D5oQ92q
	 HqAZQ5i96ewPQQuLmdDI2G+lNiziUAyQHOAdRC9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Xiao Liu <lx24@stu.ynu.edu.cn>,
	Daming Li <d4n.for.sec@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 212/271] net: smc: fix splice entry lifetime imbalance in smc_rx_splice
Date: Mon, 17 Aug 2026 15:32:17 +0200
Message-ID: <20260817132545.524253033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daming Li <d4n.for.sec@gmail.com>

commit 5d9686af2976741bbd79b150d1c9e60b81e7f12e upstream.

smc_rx_splice() passes pages to splice_to_pipe() before taking the
references that cover the lifetime of each splice entry. In the
VM-backed RMB path, splice_to_pipe() may drop unqueued entries through
smc_rx_spd_release(), while queued entries are released later via the
pipe buffer callback.

The old post-splice accounting also derives the number of queued VM pages
from an offset mutated while building the descriptor, and a multi-page
splice pairs one sock_hold() with multiple sock_put() calls.

Take the page and socket references for every candidate entry before
splice_to_pipe(), and drop the matching private state, page reference,
and socket reference from smc_rx_spd_release() for entries that never
get queued. This fixes a refcount imbalance that can underflow page
refcounts and trigger a use-after-free.

Fixes: 9014db202cb7 ("smc: add support for splice()")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Co-developed-by: Xiao Liu <lx24@stu.ynu.edu.cn>
Signed-off-by: Xiao Liu <lx24@stu.ynu.edu.cn>
Signed-off-by: Daming Li <d4n.for.sec@gmail.com>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Link: https://patch.msgid.link/20260730145552.360287-2-enjou1224z@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_rx.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -150,7 +150,12 @@ static const struct pipe_buf_operations
 static void smc_rx_spd_release(struct splice_pipe_desc *spd,
 			       unsigned int i)
 {
+	struct smc_spd_priv *priv = (struct smc_spd_priv *)spd->partial[i].private;
+	struct sock *sk = &priv->smc->sk;
+
+	kfree(priv);
 	put_page(spd->pages[i]);
+	sock_put(sk);
 }
 
 static int smc_rx_splice(struct pipe_inode_info *pipe, char *src, size_t len,
@@ -209,6 +214,10 @@ static int smc_rx_splice(struct pipe_ino
 			offset = 0;
 		}
 	}
+	for (i = 0; i < nr_pages; i++) {
+		get_page(pages[i]);
+		sock_hold(&smc->sk);
+	}
 	spd.nr_pages_max = nr_pages;
 	spd.nr_pages = nr_pages;
 	spd.pages = pages;
@@ -217,16 +226,8 @@ static int smc_rx_splice(struct pipe_ino
 	spd.spd_release = smc_rx_spd_release;
 
 	bytes = splice_to_pipe(pipe, &spd);
-	if (bytes > 0) {
-		sock_hold(&smc->sk);
-		if (!lgr->is_smcd && smc->conn.rmb_desc->is_vm) {
-			for (i = 0; i < PAGE_ALIGN(bytes + offset) / PAGE_SIZE; i++)
-				get_page(pages[i]);
-		} else {
-			get_page(smc->conn.rmb_desc->pages);
-		}
+	if (bytes > 0)
 		atomic_add(bytes, &smc->conn.splice_pending);
-	}
 	kfree(priv);
 	kfree(partial);
 	kfree(pages);


