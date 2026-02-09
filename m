Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0B92690EC;
	Mon,  9 Feb 2026 14:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648537; cv=none; b=nW7px0CPaB98g5D/6kFrpmqSyAf/gInZ9SuZ47u77V5VfGLM6jXEM8HteB/WLfAA7P+02YU7qmaMQyXIrYiJixSQbLH7dj8bThtsZTQTQkWALf+kQ0EZGsPR9/4q7bAOK6rrPatjxXd/jdS6h7UA7Loi0wLf5tNn+fZlJBoD/6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648537; c=relaxed/simple;
	bh=xN8rNWLfPB1u6Zx6Sh38A8YMowgqrQUJ4P28Szt8jSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOWa7NLRrXJlM0+HTsEZ5WhpChXYXPPnFIaJBE5WJ/j53yATezczU8t+ZcKIExRnGwrkARDtSVXGp1Gp7QFo930b0s/nCecyXCygjcOcsNW/+jid/20jpfGYmAMnqpNCNp6li3e6atoCQoO/krVuuaxyxF2a8HaZOLiWetPpNXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBFP9rqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBFP9rqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183A6C116C6;
	Mon,  9 Feb 2026 14:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648537;
	bh=xN8rNWLfPB1u6Zx6Sh38A8YMowgqrQUJ4P28Szt8jSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBFP9rqcwB2Q/ee7Bi3zJBo6K9ikSOZg0USrghgNAJEKVAHd2ekSd4X049+gzYt7F
	 imDv8FNYrb3toxVhqTssN/uqYqrg6L0m+72CsZRXKQwHLXVIryBFyBXEoVCChHsKlc
	 /H8sYmjmbhIcE7oGBbmVr6nWqaLITj7WKNwDznGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 68/86] net: dont touch dev->stats in BPF redirect paths
Date: Mon,  9 Feb 2026 15:24:31 +0100
Message-ID: <20260209142307.224784326@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit fdf3f6800be36377e045e2448087f12132b88d2f ]

Gal reports that BPF redirect increments dev->stats.tx_errors
on failure. This is not correct, most modern drivers completely
ignore dev->stats so these drops will be invisible to the user.
Core code should use the dedicated core stats which are folded
into device stats in dev_get_stats().

Note that we're switching from tx_errors to tx_dropped.
Core only has tx_dropped, hence presumably users already expect
that counter to increment for "stack" Tx issues.

Reported-by: Gal Pressman <gal@nvidia.com>
Link: https://lore.kernel.org/c5df3b60-246a-4030-9c9a-0a35cd1ca924@nvidia.com
Fixes: b4ab31414970 ("bpf: Add redirect_neigh helper as redirect drop-in")
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260130033827.698841-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 99e931bc9e9aa..ddb6d3dd34deb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2281,12 +2281,12 @@ static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
 
 	err = bpf_out_neigh_v6(net, skb, dev, nh);
 	if (unlikely(net_xmit_eval(err)))
-		DEV_STATS_INC(dev, tx_errors);
+		dev_core_stats_tx_dropped_inc(dev);
 	else
 		ret = NET_XMIT_SUCCESS;
 	goto out_xmit;
 out_drop:
-	DEV_STATS_INC(dev, tx_errors);
+	dev_core_stats_tx_dropped_inc(dev);
 	kfree_skb(skb);
 out_xmit:
 	return ret;
@@ -2389,12 +2389,12 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
 
 	err = bpf_out_neigh_v4(net, skb, dev, nh);
 	if (unlikely(net_xmit_eval(err)))
-		DEV_STATS_INC(dev, tx_errors);
+		dev_core_stats_tx_dropped_inc(dev);
 	else
 		ret = NET_XMIT_SUCCESS;
 	goto out_xmit;
 out_drop:
-	DEV_STATS_INC(dev, tx_errors);
+	dev_core_stats_tx_dropped_inc(dev);
 	kfree_skb(skb);
 out_xmit:
 	return ret;
-- 
2.51.0



