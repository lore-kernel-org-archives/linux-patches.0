Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09619279903;
	Mon, 17 Aug 2026 15:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980457; cv=none; b=h8fugzvRYKhCef+oHoojr6Tia7MZrSq8gHwAjXDucyU4qWrjlLpkeXJLVz1+Jy7v4DWmNRAwBfvDOpHlAG2w6PZoRK9MnbyXuh69j9x1Lgi9dYBzifXLIQfRRRnJabSP0drk6rOcgcdKJ3WPtUk3y/hQPcccd0JsuT/RcbG759o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980457; c=relaxed/simple;
	bh=Q/KnRHUuPWO9oN+QRZv8Guv3UvbQYqC0Wnqgn9ILTDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4J5FVEp9MQKg5AFfRvp/I2SsNjj234djsU9p1Ztf/Z50CdMklqMcyXnwN8R//lERv+gpFxxWfkI8miV+ZE83h/evelL7lkIa2CfouNd1dp02vwG25czRgI55sBLNDrD35qqvtaGBze9DL3CcEoEDSm/esgcOAnEHSHlaoju7aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krk/LEMe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krk/LEMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5B81F000E9;
	Mon, 17 Aug 2026 15:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980455;
	bh=OCtft4M4+ikH18bQ/VjlJv7dV2fEj39JEekzxgEzhvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=krk/LEMeUHYXxIIc8EYOSXENPrADvzVX2inunZLxrHHQMYyQo/1HNi2/5qqYF3zvc
	 Sn/pLS/N89iYuUabkmUnZE27cM/eP2JlbVvkYMKSLk1+jza5qPL8LPiXEUjiEBMPXx
	 nUZbHCo5CqUZbMqEXGq36/3/DizIrgryCdtbiNyc=
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
Subject: [PATCH 6.1 580/609] net: smc: fix splice entry lifetime imbalance in smc_rx_splice
Date: Mon, 17 Aug 2026 15:34:36 +0200
Message-ID: <20260817132603.105440173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -146,7 +146,12 @@ static const struct pipe_buf_operations
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
@@ -205,6 +210,10 @@ static int smc_rx_splice(struct pipe_ino
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
@@ -213,16 +222,8 @@ static int smc_rx_splice(struct pipe_ino
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


