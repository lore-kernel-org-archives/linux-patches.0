Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09DB1DE8AD;
	Mon,  9 Feb 2026 14:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647553; cv=none; b=hXjxZjlrBfHd3AbyxDJ9VIS0DYVNGYIbdL+L65Kv0wrrUVXWfcPBW47MhV+Bqvu22NFfoS4Ncw+LjxP9GArVBSbQGZnawyqvtbHPhh3rl+Gnk8keZ2vInR/j0IBrJFYqVo+ne58r/U1nF7XeOS49jz5rdlfspNCNkKAstuRwg2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647553; c=relaxed/simple;
	bh=tDBentILjiT29K/mQ5ywcRsdqs+ciHKFMuxagRebWV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbToj+044Rrnk0LBLhje04UpwwCN/Yo84WB1qKlwu6oXX4Y/WbfMoGLCiDi3hQwO1THyj7pc1VYqq+4aSuhmmrjJ0ngySM14l/0aQ//21YP+6Mel3bP1VJjrr3vaY6FDawwTlD6+w4VWgq/YSytBozAKmuUw54PUTv6Qyk8CJrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=temW2p7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="temW2p7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4168CC116C6;
	Mon,  9 Feb 2026 14:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647553;
	bh=tDBentILjiT29K/mQ5ywcRsdqs+ciHKFMuxagRebWV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=temW2p7kH3H7iHuLiyYFW6Y/iYT8DwkvFnJM3jUFiH2gI2U2JmC+tmuYOZO93R1r5
	 YYfMMKPt6XcR02cD73iHHYbNBe5Lj6jMPzT6TU/Mq+MzQwhN9fhW5UuQEDEhukNEm3
	 utqaOqioiRK6e6Lb0dIrbx18LysUcGkkRqhzh5/g=
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
Subject: [PATCH 6.18 135/175] net: dont touch dev->stats in BPF redirect paths
Date: Mon,  9 Feb 2026 15:23:28 +0100
Message-ID: <20260209142325.367873461@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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
index 6431ef3e9f7dd..88b265f6ccf89 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2289,12 +2289,12 @@ static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
 
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
@@ -2396,12 +2396,12 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
 
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



