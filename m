Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8672E79DBF;
	Wed, 21 Feb 2024 14:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525719; cv=none; b=tcaKYthsOw+y7jmYNqjtA5zPnw4GgibC/Bhl5w2n9zNyY5wLCQC6hX/WGi5W4WY39HhmMubtxYfpk+iTDbSvZ31XtnazN7vc591Bu1mIXnDUle0MW6PnluoQ9yxtGHO4YhMXa3K2Uq90Gb/5H1UFcBeBc+3Oyu+kMv1Xk8OQiys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525719; c=relaxed/simple;
	bh=Qaz8uEiEuh3KXk+IFHaIPXPF0vIrgJqZBd96zMwbJr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovwniJAjE9EgNMjj+PwQ8pPEw/hjYL4ijAWs9c5LiSR9G3ohzOIU8GKunAsXO44HXIH25LhuEUttwe+08bwHowJpgNeddkCjJz4iBdYnAOD6+rQPQhdQPs+uxogaj8aYZ1biK26s3xwYGpgzf4vhhsn+s8StD5Wtel0ppV+Y38U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsIN1+s+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsIN1+s+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07CEC433F1;
	Wed, 21 Feb 2024 14:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525719;
	bh=Qaz8uEiEuh3KXk+IFHaIPXPF0vIrgJqZBd96zMwbJr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsIN1+s+mCnLe5ejcAxrdZx+SjDxf18EKeTlPMCGheyMSheM1GTxS3XGn3AGJeYDv
	 vSnD7N1lh8mNCVA7JSVbFc0xgriIXFV6MMXUT/hGyegLoDNWeZIYcy9lh/ZAY0atiU
	 glsV+rHS83+xwNi8026kmN/aat6j8secJolZbqk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel de Villiers <daniel.devilliers@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 243/267] nfp: flower: prevent re-adding mac index for bonded port
Date: Wed, 21 Feb 2024 14:09:44 +0100
Message-ID: <20240221125947.876437166@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -593,7 +593,7 @@ nfp_tunnel_add_shared_mac(struct nfp_app
 	u16 nfp_mac_idx = 0;
 
 	entry = nfp_tunnel_lookup_offloaded_macs(app, netdev->dev_addr);
-	if (entry && nfp_tunnel_is_mac_idx_global(entry->index)) {
+	if (entry && (nfp_tunnel_is_mac_idx_global(entry->index) || netif_is_lag_port(netdev))) {
 		if (entry->bridge_count ||
 		    !nfp_flower_is_supported_bridge(netdev)) {
 			nfp_tunnel_offloaded_macs_inc_ref_and_link(entry,


