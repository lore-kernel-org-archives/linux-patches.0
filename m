Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446B8217F55;
	Tue, 30 Sep 2025 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244713; cv=none; b=VAhpg82mKdUAbmT/I9aeYpCfPku11dv4q+/REKlH4g/8vvSOfLRWVevF/K0hITDqhPbrg2S4Bo3VzmSHe3iRKGq0K83RkJy5hMyXJJcAfOoH1LIiC0mGmz57V8UbLuBFrXPOf+6svlCedALWeHDx1NIZEXXO+scv0xfjrBXdTxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244713; c=relaxed/simple;
	bh=MZ1P2yeymS5/0fMUTMn6MGmEsGNUYC1lRCwuQGehN3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwJ/hoXIfRG+Pz1ZETAsWRUJVzewC5YfGaIRj3tO7lZqrL4lB2RwRehhKV91e+1+dDLRnHhGolN3HJANmkZmbjruXvUq+ulgPg//cmMX6O3l0HNtu2FMUx13BnmZOIFNUFN1a3B3yJgR7WHWQFyodds2ZsGh6yztAaMmdvU0ZZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e11KxyGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e11KxyGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD48AC4CEF0;
	Tue, 30 Sep 2025 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244713;
	bh=MZ1P2yeymS5/0fMUTMn6MGmEsGNUYC1lRCwuQGehN3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e11KxyGANU4KDcdXcTxe/afSIwcPj6l2fuI5LQFtXuaX03X9aG6j04KSorKJTYT/z
	 c7OmTS97676xdDu11g3W6KYHKuMN2d29bcg6RnBiJPH4spP3g3W23Mx0vEAgWx+yL2
	 SIhUy270VwGwNBAbuY3f6q9gKGncIOiFkjqRcJXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiumei Mu <xmu@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Leon Romanovsky <leonro@nvidia.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 059/143] xfrm: fix offloading of cross-family tunnels
Date: Tue, 30 Sep 2025 16:46:23 +0200
Message-ID: <20250930143833.579801906@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 91d8a53db2199eefc73ecf3682e0665ea6895696 ]

Xiumei reported a regression in IPsec offload tests over xfrmi, where
the traffic for IPv6 over IPv4 tunnels is processed in SW instead of
going through crypto offload, after commit
cc18f482e8b6 ("xfrm: provide common xdo_dev_offload_ok callback
implementation").

Commit cc18f482e8b6 added a generic version of existing checks
attempting to prevent packets with IPv4 options or IPv6 extension
headers from being sent to HW that doesn't support offloading such
packets. The check mistakenly uses x->props.family (the outer family)
to determine the inner packet's family and verify if
options/extensions are present.

In the case of IPv6 over IPv4, the check compares some of the traffic
class bits to the expected no-options ihl value (5). The original
check was introduced in commit 2ac9cfe78223 ("net/mlx5e: IPSec, Add
Innova IPSec offload TX data path"), and then duplicated in the other
drivers. Before commit cc18f482e8b6, the loose check (ihl > 5) passed
because those traffic class bits were not set to a value that
triggered the no-offload codepath. Packets with options/extension
headers that should have been handled in SW went through the offload
path, and were likely dropped by the NIC or incorrectly
processed. Since commit cc18f482e8b6, the check is now strict (ihl !=
5), and in a basic setup (no traffic class configured), all packets go
through the no-offload codepath.

The commits that introduced the incorrect family checks in each driver
are:
2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data path")
8362ea16f69f ("crypto: chcr - ESN for Inline IPSec Tx")
859a497fe80c ("nfp: implement xfrm callbacks and expose ipsec offload feature to upper layer")
32188be805d0 ("cn10k-ipsec: Allow ipsec crypto offload for skb with SA")
[ixgbe/ixgbevf commits are ignored, as that HW does not support tunnel
mode, thus no cross-family setups are possible]

Fixes: cc18f482e8b6 ("xfrm: provide common xdo_dev_offload_ok callback implementation")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index c7a1f080d2de3..44b9de6e4e778 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -438,7 +438,7 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 
 	check_tunnel_size = x->xso.type == XFRM_DEV_OFFLOAD_PACKET &&
 			    x->props.mode == XFRM_MODE_TUNNEL;
-	switch (x->props.family) {
+	switch (x->inner_mode.family) {
 	case AF_INET:
 		/* Check for IPv4 options */
 		if (ip_hdr(skb)->ihl != 5)
-- 
2.51.0



