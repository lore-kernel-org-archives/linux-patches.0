Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67226214813;
	Tue, 26 Aug 2025 12:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212891; cv=none; b=Im0S2BjSDT1X2O07mZeQCh1oAT1V3jnrAxS5qMIqgSvlU1o1zWm4kJL8vTytnESlTSBwnxhEYymyfv3oa9HDj98RbarZp5gLsEyhvq1wX22rgvcNilAZphKGpkKunV50XKdNWAhyoCVDaotuDbhNt32DmfDv2NFu+2+7qkZG7b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212891; c=relaxed/simple;
	bh=F1dgpP8beS5l7TGwGeOF9OrzDVOiC8jNz7SolQ7dm4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0r3ig28mG2jLDMQuFNP3Sae/NEOZxmwFBXVAHKH3pRX3wAVtBanpZkx1X7wycALGSaCkN4jrMBPyi/TC69vVJq+TNjDf9Pv+a9LpD15oqAloLyBDGvQgR/R047wtGymP+Xna4kG/kjlqhgwdVlG+loeY/6Q6qLVGAbNhIFAd+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpilGxLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpilGxLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C2BC4CEF4;
	Tue, 26 Aug 2025 12:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212891;
	bh=F1dgpP8beS5l7TGwGeOF9OrzDVOiC8jNz7SolQ7dm4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpilGxLLQaPe1vIl29mQU6/DEcY2z7X+CtGVCM621ykFoOWUUlDG+H1pnAXsq1zZU
	 I7E1pfo4cISW+sOMlhoUblMmBR75xpcSvKh51Zsl2xRpE4HcthNnb3BoNzyJvdp+1s
	 ShAlpbqKLkNXiqxPxweKY3JwxNZGFnTR+E7lPiFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthoine Bourgeois <anthoine.bourgeois@vates.tech>,
	Juergen Gross <jgross@suse.com>,
	Elliott Mitchell <ehem+xen@m5p.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/587] xen/netfront: Fix TX response spurious interrupts
Date: Tue, 26 Aug 2025 13:04:50 +0200
Message-ID: <20250826110956.539980125@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Anthoine Bourgeois <anthoine.bourgeois@vates.tech>

[ Upstream commit 114a2de6fa86d99ed9546cc9113a3cad58beef79 ]

We found at Vates that there are lot of spurious interrupts when
benchmarking the xen-net PV driver frontend. This issue appeared with a
patch that addresses security issue XSA-391 (b27d47950e48 "xen/netfront:
harden netfront against event channel storms"). On an iperf benchmark,
spurious interrupts can represent up to 50% of the interrupts.

Spurious interrupts are interrupts that are rised for nothing, there is
no work to do. This appends because the function that handles the
interrupts ("xennet_tx_buf_gc") is also called at the end of the request
path to garbage collect the responses received during the transmission
load.

The request path is doing the work that the interrupt handler should
have done otherwise. This is particurary true when there is more than
one vcpu and get worse linearly with the number of vcpu/queue.

Moreover, this problem is amplifyed by the penalty imposed by a spurious
interrupt. When an interrupt is found spurious the interrupt chip will
delay the EOI to slowdown the backend. This delay will allow more
responses to be handled by the request path and then there will be more
chance the next interrupt will not find any work to do, creating a new
spurious interrupt.

This causes performance issue. The solution here is to remove the calls
from the request path and let the interrupt handler do the processing of
the responses. This approch removes most of the spurious interrupts
(<0.05%) and also has the benefit of freeing up cycles in the request
path, allowing it to process more work, which improves performance
compared to masking the spurious interrupt one way or another.

This optimization changes a part of the code that is present since the
net frontend driver was upstreamed. There is no similar pattern in the
other xen PV drivers. Since the first commit of xen-netfront is a blob
that doesn't explain all the design choices I can only guess why this
specific mecanism was here. This could have been introduce to compensate
a slow backend at the time (maybe the backend was fixed or optimize
later) or a small queue. In 18 years, both frontend and backend gain lot
of features and optimizations that could have obsolete the feature of
reaping completions from the TX path.

Some vif throughput performance figures from a 8 vCPUs, 4GB of RAM HVM
guest(s):

Without this patch on the :
vm -> dom0: 4.5Gb/s
vm -> vm:   7.0Gb/s

Without XSA-391 patch (revert of b27d47950e48):
vm -> dom0: 8.3Gb/s
vm -> vm:   8.7Gb/s

With XSA-391 and this patch:
vm -> dom0: 11.5Gb/s
vm -> vm:   12.6Gb/s

v2:
- add revewed and tested by tags
- resend with the maintainers in the recipients list

v3:
- remove Fixes tag but keep the commit ref in the explanation
- add a paragraph on why this code was here

Signed-off-by: Anthoine Bourgeois <anthoine.bourgeois@vates.tech>
Reviewed-by: Juergen Gross <jgross@suse.com>
Tested-by: Elliott Mitchell <ehem+xen@m5p.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250721093316.23560-1-anthoine.bourgeois@vates.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netfront.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 0115f8f5b724..5b59c0ee6c66 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -637,8 +637,6 @@ static int xennet_xdp_xmit_one(struct net_device *dev,
 	tx_stats->packets++;
 	u64_stats_update_end(&tx_stats->syncp);
 
-	xennet_tx_buf_gc(queue);
-
 	return 0;
 }
 
@@ -848,9 +846,6 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 	tx_stats->packets++;
 	u64_stats_update_end(&tx_stats->syncp);
 
-	/* Note: It is not safe to access skb after xennet_tx_buf_gc()! */
-	xennet_tx_buf_gc(queue);
-
 	if (!netfront_tx_slot_available(queue))
 		netif_tx_stop_queue(netdev_get_tx_queue(dev, queue->id));
 
-- 
2.39.5



