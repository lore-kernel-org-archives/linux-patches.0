Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E6E14F9DA;
	Tue, 20 Feb 2024 21:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465142; cv=none; b=VQBU5ASARVDgh2sxUo9CHS6AFVyMamtRjAy2vD4MUFpJswn5rjASS57RUpCKqp6m1cfXzE+SzSqQniXONuNtsLPUu8s7m0c/i8gwFrslOQYjmogC5lKLzpJOx55bPmiijd5KFle/+V7qQEygaVsJz7/AhgWlJvwziNKfIK9M7cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465142; c=relaxed/simple;
	bh=m3GgkY4P48a6SyukMaNKHg2I92UOS04RQgyAY4OW0S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rP3rUeiMfvSqyBCYhEb671EXNauebvWpX//2eQLgc7+y0jMIV8Bu7L7M2zeLaFzhQ5rJRYsdcYrtpRbFpWqU5X+dJCIK0KzkeiLksG3FGzBR/C229iX3OataF8cbWQR42ThXCaDoE7Xbyvj8hVl8UBQho5pxCzEmTMJmPkySgh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWln/ZwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWln/ZwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7960C433F1;
	Tue, 20 Feb 2024 21:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465142;
	bh=m3GgkY4P48a6SyukMaNKHg2I92UOS04RQgyAY4OW0S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWln/ZwKLFLTqChrdm9tVTRUDhwQTCO9rBOmNLr3TG+ll3ujVB/sXZ5dxQqL6YlTs
	 ck7/CYum/oeQeGDy1heIORbf8LMzByzP27L6rM86e/VbhG9MsCSwi4WOCBoiCHzvnR
	 b4X6Dw5Vasec9Rbqo42+QoDQ5ztT07uG8pisNZjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel de Villiers <daniel.devilliers@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 249/309] nfp: flower: prevent re-adding mac index for bonded port
Date: Tue, 20 Feb 2024 21:56:48 +0100
Message-ID: <20240220205640.961878770@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel de Villiers <daniel.devilliers@corigine.com>

commit 1a1c13303ff6d64e6f718dc8aa614e580ca8d9b4 upstream.

When physical ports are reset (either through link failure or manually
toggled down and up again) that are slaved to a Linux bond with a tunnel
endpoint IP address on the bond device, not all tunnel packets arriving
on the bond port are decapped as expected.

The bond dev assigns the same MAC address to itself and each of its
slaves. When toggling a slave device, the same MAC address is therefore
offloaded to the NFP multiple times with different indexes.

The issue only occurs when re-adding the shared mac. The
nfp_tunnel_add_shared_mac() function has a conditional check early on
that checks if a mac entry already exists and if that mac entry is
global: (entry && nfp_tunnel_is_mac_idx_global(entry->index)). In the
case of a bonded device (For example br-ex), the mac index is obtained,
and no new index is assigned.

We therefore modify the conditional in nfp_tunnel_add_shared_mac() to
check if the port belongs to the LAG along with the existing checks to
prevent a new global mac index from being re-assigned to the slave port.

Fixes: 20cce8865098 ("nfp: flower: enable MAC address sharing for offloadable devs")
CC: stable@vger.kernel.org # 5.1+
Signed-off-by: Daniel de Villiers <daniel.devilliers@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -1084,7 +1084,7 @@ nfp_tunnel_add_shared_mac(struct nfp_app
 	u16 nfp_mac_idx = 0;
 
 	entry = nfp_tunnel_lookup_offloaded_macs(app, netdev->dev_addr);
-	if (entry && nfp_tunnel_is_mac_idx_global(entry->index)) {
+	if (entry && (nfp_tunnel_is_mac_idx_global(entry->index) || netif_is_lag_port(netdev))) {
 		if (entry->bridge_count ||
 		    !nfp_flower_is_supported_bridge(netdev)) {
 			nfp_tunnel_offloaded_macs_inc_ref_and_link(entry,


