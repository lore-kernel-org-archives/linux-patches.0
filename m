Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228DD3D0A1;
	Wed, 21 Feb 2024 14:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524763; cv=none; b=avYzXAp42EWdJXHQrXob0z1pnOpoYrKbA6HlqtTDQmKVfrP4DS/IL2gEusGgUnD8uBhzTQdRe8aPF0EsH+mRJanQauOLkhJis7hV25vbskTQ/QIGmEuZLJubdM5QHkhM+6MO86ogaOm7QQduLeNcpbbNNbYPPUzA+GsVqYlbaM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524763; c=relaxed/simple;
	bh=romxvoU/8p5rhvK4h0SrjMCaTkbHsdHC/KfMSC1vjvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJ0HQp2lJGL4cU2E7DQlKAtYICB49exlT/FVsfYYHwcJKi9VmnAlHEyJZ0UO23zREPq+QUrUX5TMDOlypzRzULEwD8qpgepCUUPXc+aUMV8MhMfDoyVR5UATA/nR+FLmfQNm6OP54qxVKQsujYUS4g/1IeLioxTxkw3p9eqrhcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Syr9fKEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Syr9fKEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C079C433C7;
	Wed, 21 Feb 2024 14:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524763;
	bh=romxvoU/8p5rhvK4h0SrjMCaTkbHsdHC/KfMSC1vjvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Syr9fKExbN7Pigk+0klfLc9hSbI2k4/VLIYM1Iq9mVzsJYAtm3AQ0Y153VYzP8mBh
	 wWQTmz9o6g0QxubuhYKvfTlfbmBZ7hj/d2LmYhLGFPYACRVLlRKMDth6k78aOaMoDO
	 C+jX9fytx9gCkF1qTet+IPDktgW3eYgSatvLQIu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel de Villiers <daniel.devilliers@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 339/379] nfp: flower: prevent re-adding mac index for bonded port
Date: Wed, 21 Feb 2024 14:08:38 +0100
Message-ID: <20240221130005.015456854@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -927,7 +927,7 @@ nfp_tunnel_add_shared_mac(struct nfp_app
 	u16 nfp_mac_idx = 0;
 
 	entry = nfp_tunnel_lookup_offloaded_macs(app, netdev->dev_addr);
-	if (entry && nfp_tunnel_is_mac_idx_global(entry->index)) {
+	if (entry && (nfp_tunnel_is_mac_idx_global(entry->index) || netif_is_lag_port(netdev))) {
 		if (entry->bridge_count ||
 		    !nfp_flower_is_supported_bridge(netdev)) {
 			nfp_tunnel_offloaded_macs_inc_ref_and_link(entry,


