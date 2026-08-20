Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEDF47D46A;
	Thu, 20 Aug 2026 16:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244613; cv=none; b=ZrAbVwycFdUWjGuMCA8hKr/EJDfRdcfY2fMY6oTTv/a4m0tabU17wcF4YbLyK/du1c8czm/4mRP/5RA2/mquWeG5ilMuj4Y5jIDPNCVjRBE9OAOVf+rIhnrZBG89ErUalbjRW8LJJaCF89f+GXdj9IkHe/OZk4m482HzfuGt2fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244613; c=relaxed/simple;
	bh=vMuEJ+xLMEGc/VBJBAm6reNESefAFlPzCCbBUssNZls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6iPlojxMIcrystNs/tUeRHhB/g+CltbNYhTtfj1ANmMFgthc0vjcrhYubp/OrdcwBx3cPoPhNAPM79NIOGwZPXZxLNFNus1GMrzKogdyhiao79+PGXw30NrnfUh/Rcr0d8ZAMoQ8eKyHGvKqUi8tNLr/V9t14aeDOftEeLm3i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILghakoE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILghakoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2501F00A3A;
	Thu, 20 Aug 2026 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244611;
	bh=uHRDwdgyOcnQfacPRV1zUNZy8GJ4S4sTy3062DzOtRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILghakoEd4J6ErDqwvnYA2QuK8M6WHeTCAT2fD7FyEZtWjtlioR1GxHe6Fb7zgRib
	 Xox7fNDyCPbDpUmnqDGFnGjxjFQEwvHtXfGqJYzJ5M2eJ0mqdp81psmli03T5XJygq
	 Z4D/6QvI1B55zkornV21hoUt4yjHM2XKBrFBewWE=
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
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/235] net: smc: fix splice entry lifetime imbalance in smc_rx_splice
Date: Thu, 20 Aug 2026 16:57:46 +0200
Message-ID: <20260820145223.591479022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ collapsed the multi-page get_page()/sock_hold() loop to a single get_page()/sock_hold() pair and dropped the trailing kfree() calls, as 5.15 lacks the multi-page pages[]/partial[]/priv[] arrays ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_rx.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -144,7 +144,12 @@ static const struct pipe_buf_operations
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
@@ -164,6 +169,8 @@ static int smc_rx_splice(struct pipe_ino
 	partial.len = len;
 	partial.private = (unsigned long)priv;
 
+	get_page(smc->conn.rmb_desc->pages);
+	sock_hold(&smc->sk);
 	spd.nr_pages_max = 1;
 	spd.nr_pages = 1;
 	spd.pages = &smc->conn.rmb_desc->pages;
@@ -172,11 +179,8 @@ static int smc_rx_splice(struct pipe_ino
 	spd.spd_release = smc_rx_spd_release;
 
 	bytes = splice_to_pipe(pipe, &spd);
-	if (bytes > 0) {
-		sock_hold(&smc->sk);
-		get_page(smc->conn.rmb_desc->pages);
+	if (bytes > 0)
 		atomic_add(bytes, &smc->conn.splice_pending);
-	}
 
 	return bytes;
 }


