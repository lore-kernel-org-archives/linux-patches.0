Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F79F254B03;
	Wed, 25 Feb 2026 01:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984009; cv=none; b=WTWNeKKsrOILz57/kmf8KX5Rb8S+6fPYwXFkoBCGIsb4S2EnvNaN/d9wlT6W5t8u8/ydiosrcF3/5o5brrZe7kqNE20lOMaDmJXeNYLFIZpKHmFU4XcHkZg0NlPSYXbBEn7QwVHeLeOecepM8asE9VnVKGLHG+Y4dEq7X5y2ndE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984009; c=relaxed/simple;
	bh=A1AMkFjAQcwWmRqHwV39JSf3Ri4YDQsqCCZHA5YCoVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvdUl10TMtENMVOutJKmg8j62pEdDk9kvGjFvWnEbvBSQMfyaIFR6OgxeUZ8U4Vu9EfVTNc3oNbonqdHCx2exG5KEST7Enpu4JR9tz5shgllUKiRwO1C2+JfmkQb2Va+tbzU4Z90J00Bc7LUTYgkOqxH7ZZywSgxXIfKmy0ltW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BgwUUoIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BgwUUoIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DA0C116D0;
	Wed, 25 Feb 2026 01:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984009;
	bh=A1AMkFjAQcwWmRqHwV39JSf3Ri4YDQsqCCZHA5YCoVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgwUUoIAEAiGLh/NMGzv+8+u6rqbmZzSRinzBTvhc4QzdtroaCpzL9eFE0D8gyLFq
	 Qmxc2vimuY+T9AYU7qMJ4tkwpXze3u5ETJz9qTQBMZYtGdz7e2ybCDZ4q6iefPNjCY
	 gHZM3GwgnQJEuN1+CGB1ArRe+4L1noarqwYnuHJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Slabihoudek <michal.slabihoudek@gooddata.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 260/641] netfilter: nf_conncount: fix tracking of connections from localhost
Date: Tue, 24 Feb 2026 17:19:46 -0800
Message-ID: <20260225012355.125156323@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 288936f5c1bf9..14e62b3263cd9 100644
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



