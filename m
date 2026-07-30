Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E94C3B38B8;
	Thu, 30 Jul 2026 15:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427097; cv=none; b=f9+XM/xPKJozAFCKbR7QfRnFUp9co4pibWMqlOn4VwWrdYDI5WJarJSUiwdrNgbT+6p8sfdYOCdWSCaVUmjc2Jfx4cqEvAQklz8Hei+/4CQVbM5k7rrabry7v5o7wwIasyi+o8Gbp2s1zRMxcqST46NutBh1pjTrZ5rJLR+sIsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427097; c=relaxed/simple;
	bh=C4KjOBx7H/H06mKRR2Pj9y3AT1xpTxEm217Liyj+nfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAu6tHFenDXBQ3j6Mu/F2QDonBNTZm6iCeuXCIyoyVnEdVOYCjUw5tXIrXR6dURyIkc8PbdNWlySOPPNdBLNLf1mLMxLw9UjxVEhfwnUS/JfUs24pOzBLDSxSx2qv/nZDFe511pvlg3cg0G2qPx12nW8Q69LoZNjhMaIwT/70iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTh3NYWe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTh3NYWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396391F000E9;
	Thu, 30 Jul 2026 15:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427095;
	bh=7HHV0PTkqD9H6NZkniDmxk5Un8daVuHvZSNvGx43NbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTh3NYWeJeuBPatqGK64xpk5qAee8aJ0FCkObDGcojOhkfWaUN3XTac3J3klQQLrW
	 WHQZoBN4gGPCldrXQmGx04NNWJFHal8qeqFDbUT5utd5f/or8JtlGtBW4khWJ1sTPS
	 1QwzVcEPtB+ica6PUQnyZ5ShaP3YSVZKPz9fR944=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/484] xfrm6: clear dst.dev on error to avoid double netdev_put in xfrm6_fill_dst()
Date: Thu, 30 Jul 2026 16:09:08 +0200
Message-ID: <20260730141424.534150548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit 136992de9bb91871084ae52d172610541c76e4d2 ]

On the error path where in6_dev_get(dev) returns NULL, xfrm6_fill_dst()
releases the device reference with netdev_put() but leaves
xdst->u.dst.dev set. dst_destroy() later calls netdev_put(dst->dev)
again, so the same net_device reference is released twice, underflowing
its refcount (ref_tracker WARNING + "unregister_netdevice: waiting for
<dev> to become free").

Clear xdst->u.dst.dev after the netdev_put(), the same way the XFRM
device-offload paths xfrm_dev_state_add() and xfrm_dev_policy_add() in
net/xfrm/xfrm_device.c NULL ->dev when releasing the reference on error.

  ref_tracker: reference already released.
  ref_tracker: allocated in:
   xfrm6_fill_dst (net/ipv6/xfrm6_policy.c:86)
   ...
   udpv6_sendmsg (net/ipv6/udp.c:1696)
   ...
  ref_tracker: freed in:
   xfrm6_fill_dst (net/ipv6/xfrm6_policy.c:90)
   ...
  WARNING: lib/ref_tracker.c:322 at ref_tracker_free+0x58b/0x780
   dst_destroy (net/core/dst.c:115)
   rcu_core
   handle_softirqs
   ...

Fixes: 84c4a9dfbf43 ("xfrm6: release dev before returning error")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/xfrm6_policy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index e5d76e782b9613..6bf22fd9cd3802 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -88,6 +88,7 @@ static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 	xdst->u.rt6.rt6i_idev = in6_dev_get(dev);
 	if (!xdst->u.rt6.rt6i_idev) {
 		netdev_put(dev, &xdst->u.dst.dev_tracker);
+		xdst->u.dst.dev = NULL;
 		return -ENODEV;
 	}
 
-- 
2.53.0



