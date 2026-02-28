Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B97B36C9E9
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302370; cv=none; b=jF96mkdyp28zw7f+wOrHQRl1ytDqo93Fmmf7tPAp8cwLp4YXc2dknCuuilk68VxsRVemOr2MnmrWz/2DIzLgWdE7xMSsxTh4ur40wTuvdvNuhpsMWvpNxR9vEEN6FkZ0UAIc7krm4C2BhePPMml+xI3dhsQHaITMb2t1Pn4k35o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302370; c=relaxed/simple;
	bh=cFerpC6LS+ixNP18CNWOWni/nA1eSJPozPxdi0l6n6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9lNd8HNFmtW50DKzwyCk7mKPlh3SHh8aS9n/RBGqFDQLgHPz4pcLCsKHE7/6sBdG7dTQzFiO5lidOxDMKoicu8vEkUADgyriE3E71LfOXgg3QbWcoe6MSMqGfHlT8aeMZwCGG2nwewrMGJo0L8uBmMuSzS7/Zdkw3UFTCaPK8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c3O9MirQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c3O9MirQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98F2C116D0;
	Sat, 28 Feb 2026 18:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302370;
	bh=cFerpC6LS+ixNP18CNWOWni/nA1eSJPozPxdi0l6n6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3O9MirQD/CFnhlWnmPSV9hXArL1fhlBChoWbwVwYWQLUhtYdAkuhXvVcvh6R3yah
	 RqwRAud10I3mb+EQCN+5TZhfdttS6Wm+mb/aAe7b5KENDSm4hS807OdYEGk0jN0pvL
	 NfsUHhz+uFD9+UVieLt5ZoWmijcnstvYeC6kSZhHxCYYnEblnCtI5RGpLy9glRSZCM
	 QdClUdW5TJlSUGSTIDXDV3C120h7ZZ6F0Ykr5Hn1hyE2F4OHdZIq1rLI76Dm4TWJ67
	 RRP2kVfNIaTN3Zaodb46SjMQGvvIr8iYLwoBGxFDVzAoy6ifne3BbbJp/PMjPYs3UO
	 KiOuMUiBbGacg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Michal Slabihoudek <michal.slabihoudek@gooddata.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/232] netfilter: nf_conncount: fix tracking of connections from localhost
Date: Sat, 28 Feb 2026 13:09:12 -0500
Message-ID: <20260228181127.1592657-99-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit de8a70cefcb26cdceaafdc5ac144712681419c29 ]

Since commit be102eb6a0e7 ("netfilter: nf_conncount: rework API to use
sk_buff directly"), we skip the adding and trigger a GC when the ct is
confirmed. For connections originated from local to local it doesn't
work because the connection is confirmed on POSTROUTING, therefore
tracking on the INPUT hook is always skipped.

In order to fix this, we check whether skb input ifindex is set to
loopback ifindex. If it is then we fallback on a GC plus track operation
skipping the optimization. This fallback is necessary to avoid
duplicated tracking of a packet train e.g 10 UDP datagrams sent on a
burst when initiating the connection.

Tested with xt_connlimit/nft_connlimit and OVS limit and with a HTTP
server and iperf3 on UDP mode.

Fixes: be102eb6a0e7 ("netfilter: nf_conncount: rework API to use sk_buff directly")
Reported-by: Michal Slabihoudek <michal.slabihoudek@gooddata.com>
Closes: https://lore.kernel.org/netfilter/6989BD9F-8C24-4397-9AD7-4613B28BF0DB@gooddata.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conncount.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 47bdd8d121bb5..ae9ad439449fa 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -179,14 +179,25 @@ static int __nf_conncount_add(struct net *net,
 		return -ENOENT;
 
 	if (ct && nf_ct_is_confirmed(ct)) {
-		err = -EEXIST;
-		goto out_put;
+		/* local connections are confirmed in postrouting so confirmation
+		 * might have happened before hitting connlimit
+		 */
+		if (skb->skb_iif != LOOPBACK_IFINDEX) {
+			err = -EEXIST;
+			goto out_put;
+		}
+
+		/* this is likely a local connection, skip optimization to avoid
+		 * adding duplicates from a 'packet train'
+		 */
+		goto check_connections;
 	}
 
 	if ((u32)jiffies == list->last_gc &&
 	    (list->count - list->last_gc_count) < CONNCOUNT_GC_MAX_COLLECT)
 		goto add_new_node;
 
+check_connections:
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
 		if (collect > CONNCOUNT_GC_MAX_COLLECT)
-- 
2.51.0

