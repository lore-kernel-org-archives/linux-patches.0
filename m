Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C783321D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301220; cv=none; b=i1do6r+gGplKlCEYrQdkK5sWVtlUVB+p6+wKshxIQaMIbMsLjWjuqjBaKLKJ14Iy6iDe5kE+He13iBoIb9Hlq2j/QMFfzmNTvOQHHGnRubr30TpuwDtceU09srAcox3Qi8lZ1OFaNYM49myAgeEwqewMmDYETA1nNMW/+avV30c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301220; c=relaxed/simple;
	bh=nq9qkBe4okAHoTat6O8vzfoeylYqMxsyWvi3bxn5F+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAJ3+k4oQOummzFjKgCEagBMmRET3wrA+FjdzdxKn5AL5kSMWeO2Y5Fn895v0mh9wxg+zOkc2BtiIo7Oix0OsgEsPRaVqIpZrez5nZFb/MsNMrgXrzf8oJKGrqAiGSe4ZrvCTJsvWkKpE3lH37Z6ZMywJGtqGV0f5g7bjClMW/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=buN6LaVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buN6LaVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13A1C116D0;
	Sat, 28 Feb 2026 17:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301220;
	bh=nq9qkBe4okAHoTat6O8vzfoeylYqMxsyWvi3bxn5F+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buN6LaVFgY49yhtCzr11w3CeKNSgriN2dAr+ETOTrDRZlTt9vaXqyHYtAFHcs7CVx
	 xvNSWuLtcQGKmeqqOlZlCFuI67SatrcANRX4fzTf/tvp/xTMaJMia4MXtEFnYJUOBY
	 css8IK2YAY3GFvdjmwSwxeIcWAQtmz62Yg+XCeCKEPmfi7KzAyBp7sdoMJpe+jMNJ4
	 ETQi34cMpiLOGbg51qEZW9KG9EfbNsw+TgEiIcU5gmD7L+g8x6ZNiQ4dHq0bEdLYmz
	 Kbm/yBEiIGSKcwOPShtd946ZW0mEL6gMokfX9EVM3pN8fYL8L0l59KZFpZJRaxAK4u
	 Z+LXYFOgpUSLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	syzbot+e136d86d34b42399a8b1@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 397/752] xfrm6: fix uninitialized saddr in xfrm6_get_saddr()
Date: Sat, 28 Feb 2026 12:41:48 -0500
Message-ID: <20260228174750.1542406-397-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 1799d8abeabc68ec05679292aaf6cba93b343c05 ]

xfrm6_get_saddr() does not check the return value of
ipv6_dev_get_saddr(). When ipv6_dev_get_saddr() fails to find a suitable
source address (returns -EADDRNOTAVAIL), saddr->in6 is left
uninitialized, but xfrm6_get_saddr() still returns 0 (success).

This causes the caller xfrm_tmpl_resolve_one() to use the uninitialized
address in xfrm_state_find(), triggering KMSAN warning:

=====================================================
BUG: KMSAN: uninit-value in xfrm_state_find+0x2424/0xa940
 xfrm_state_find+0x2424/0xa940
 xfrm_resolve_and_create_bundle+0x906/0x5a20
 xfrm_lookup_with_ifid+0xcc0/0x3770
 xfrm_lookup_route+0x63/0x2b0
 ip_route_output_flow+0x1ce/0x270
 udp_sendmsg+0x2ce1/0x3400
 inet_sendmsg+0x1ef/0x2a0
 __sock_sendmsg+0x278/0x3d0
 __sys_sendto+0x593/0x720
 __x64_sys_sendto+0x130/0x200
 x64_sys_call+0x332b/0x3e70
 do_syscall_64+0xd3/0xf80
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Local variable tmp.i.i created at:
 xfrm_resolve_and_create_bundle+0x3e3/0x5a20
 xfrm_lookup_with_ifid+0xcc0/0x3770
=====================================================

Fix by checking the return value of ipv6_dev_get_saddr() and propagating
the error.

Fixes: a1e59abf8249 ("[XFRM]: Fix wildcard as tunnel source")
Reported-by: syzbot+e136d86d34b42399a8b1@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68bf1024.a70a0220.7a912.02c2.GAE@google.com/T/
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/xfrm6_policy.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index 1f19b6f14484c..125ea9a5b8a08 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -57,6 +57,7 @@ static int xfrm6_get_saddr(xfrm_address_t *saddr,
 	struct dst_entry *dst;
 	struct net_device *dev;
 	struct inet6_dev *idev;
+	int err;
 
 	dst = xfrm6_dst_lookup(params);
 	if (IS_ERR(dst))
@@ -68,9 +69,11 @@ static int xfrm6_get_saddr(xfrm_address_t *saddr,
 		return -EHOSTUNREACH;
 	}
 	dev = idev->dev;
-	ipv6_dev_get_saddr(dev_net(dev), dev, &params->daddr->in6, 0,
-			   &saddr->in6);
+	err = ipv6_dev_get_saddr(dev_net(dev), dev, &params->daddr->in6, 0,
+				 &saddr->in6);
 	dst_release(dst);
+	if (err)
+		return -EHOSTUNREACH;
 	return 0;
 }
 
-- 
2.51.0

