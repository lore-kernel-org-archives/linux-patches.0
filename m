Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BB839B94B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302560; cv=none; b=UYMu3gDMNS1Ytr282wMnqxIO90lcVgtyKUyGATpU9b2GavnaHIydJGKOidCJk5wdacsnZlegvkUUuoSNu0w0swJy6KOFxBqk6wlGlPe8ux2IPMgSjlVFJlNsxD5VzIHgyJErIxwJ1rHShbHnRG5EbWE4cja7aIi1KuOR+JCLqzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302560; c=relaxed/simple;
	bh=cFerpC6LS+ixNP18CNWOWni/nA1eSJPozPxdi0l6n6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQvGjjDili8abAz5oCPiQ8Q8prLvV3k9YGJsz39GEhcIGOukEVDLfeeV9sJ/sOrAjQaap2lJpfaYk2cm1bm5E2d9d95jDbBAJ8STRCpM69l4OHJCA0E1zI7bK6Csn04SKFUxxDlg4jz9lrBmRu27LKzyj8pR0IMJq/wcnQ54y58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LOpHjJNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LOpHjJNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FE5C19423;
	Sat, 28 Feb 2026 18:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302560;
	bh=cFerpC6LS+ixNP18CNWOWni/nA1eSJPozPxdi0l6n6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOpHjJNFHyDeL1I1U/NI1pcyIJoeJguMpP9sPYcRKl0FZhMaV9LZkgY+7ZOu11oIG
	 9N0gzOLpxF0hThbU9Tcjgl9mZoMZtnwINNqVG2PiDLNCGfzmgcwmr2/eBBRLepFxTT
	 IW+bHaJ/JNHLWeUqB4f9tbKf0WZCjwmnvzuFSZqbIUof6LZmb5qisyllKcaILguYWR
	 d/Om7uCp3ldPUc+Lx+c7nchLCuaD43WdJ6I5vo4KxyR/oNqEtFPdvdlUVa0/TL3KTJ
	 AOm6nRjpl+s0nHC6fjnurIKXRRthEBrB+9QjpAcN2DZ3OtP9j8V249YyLtgYyRZ/3X
	 6miIN/sNVe/zw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Michal Slabihoudek <michal.slabihoudek@gooddata.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/164] netfilter: nf_conncount: fix tracking of connections from localhost
Date: Sat, 28 Feb 2026 13:13:24 -0500
Message-ID: <20260228181505.1600663-65-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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

