Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E7C387378;
	Tue, 10 Mar 2026 11:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141290; cv=none; b=DxtVieUZEjzNGa1hn+7Rul9rVz7BSiMsqOqP/aBu4kxkyT1SjEZubPJEJ/mktaJG5WEBgHEjct3a1HW8W3uyOBjaEoKPF94IeLYvKtCqpKuJMRFJJyEMnFYivdR8LqWoGpo9Dysb6ifub/9JyrN4XTZnhQvxEs1ZAZdu8LVXqeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141290; c=relaxed/simple;
	bh=WxpXT1tWEAb6K10l0yrPXrtyVFEs5RAIybYecO/Gvg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFoDEQd2qaqocGBhdyk7JPNARAWcHXa3iWqC0f052LIXPOtCP9np2nutB850F5SEAx4ontSKg+MfDiS3vcpAJdkIAVrAcakLcs+hDAfMtf4WAgUYRT7tzVe1HJrZ4+zpPp+FHrZ2YsEce/F24+2ixC+eghf4rGvRmVj6Mhg6RnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BTVodFip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BTVodFip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988F0C2BC9E;
	Tue, 10 Mar 2026 11:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141290;
	bh=WxpXT1tWEAb6K10l0yrPXrtyVFEs5RAIybYecO/Gvg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTVodFip/vGVf5WchJuppnCCPq4xTg9T70jj8Vw/OHlTOfCgMl/fUiY9aAPGqs1II
	 DSisLtz9qg53md1ix5ndAlD1TMWnZNB0bfwyfhKMmek8pRjb+jctLHdMewPeQRusql
	 ENSdRkObMoKYQ6QIHX/wKzfTTOZ91gRIeCGbqUbSpXfW0JG4CmLqVrVCtf6QZQbJYt
	 K581pOO+iTtI6jion3Gp6ZsOyTPzmN7lLlQeCqzebKJ/G5bPS0CFbdkwiqeLqRMURz
	 vx9i4M6SUdTz6Nnc/0ClGiCjmwkuHnBCOemXc1o2fY4k75YG7no/gtM0RQiB2mjFt9
	 /S5UT/RWjNzYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 294/311] net: vxlan: fix nd_tbl NULL dereference when IPv6 is disabled
Date: Tue, 10 Mar 2026 07:05:41 -0400
Message-ID: <c3ec6d6cca93a9346c7cfd1f2d9ffc494b569343.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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

[ Upstream commit 168ff39e4758897d2eee4756977d036d52884c7e ]

When booting with the 'ipv6.disable=1' parameter, the nd_tbl is never
initialized because inet6_init() exits before ndisc_init() is called
which initializes it. If an IPv6 packet is injected into the interface,
route_shortcircuit() is called and a NULL pointer dereference happens on
neigh_lookup().

 BUG: kernel NULL pointer dereference, address: 0000000000000380
 Oops: Oops: 0000 [#1] SMP NOPTI
 [...]
 RIP: 0010:neigh_lookup+0x20/0x270
 [...]
 Call Trace:
  <TASK>
  vxlan_xmit+0x638/0x1ef0 [vxlan]
  dev_hard_start_xmit+0x9e/0x2e0
  __dev_queue_xmit+0xbee/0x14e0
  packet_sendmsg+0x116f/0x1930
  __sys_sendto+0x1f5/0x200
  __x64_sys_sendto+0x24/0x30
  do_syscall_64+0x12f/0x1590
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fix this by adding an early check on route_shortcircuit() when protocol
is ETH_P_IPV6. Note that ipv6_mod_enabled() cannot be used here because
VXLAN can be built-in even when IPv6 is built as a module.

Fixes: e15a00aafa4b ("vxlan: add ipv6 route short circuit support")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260304120357.9778-2-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index e957aa12a8a44..2a140be86bafc 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2130,6 +2130,11 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
 	{
 		struct ipv6hdr *pip6;
 
+		/* check if nd_tbl is not initiliazed due to
+		 * ipv6.disable=1 set during boot
+		 */
+		if (!ipv6_stub->nd_tbl)
+			return false;
 		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 			return false;
 		pip6 = ipv6_hdr(skb);
-- 
2.51.0

