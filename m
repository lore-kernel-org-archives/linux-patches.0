Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B16519ABA1;
	Tue, 10 Sep 2024 10:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963018; cv=none; b=ijvpbL8yy3EG0aLf5tcR67KkWTUX1z4Jy5w8LMKqr07lQV1+gHKKBU3wDl7FZiDmC95DzV8m9yDBhAYIhMExvn5Cq8qingEwp0kH5xUt719Jq6AAsN8FYg2mkoQsSnu3NGRYrl0E9WPYxvKqHiSBUVyZt0j+NeAUvu5HvRRXk6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963018; c=relaxed/simple;
	bh=MqYqfshstCmkT8IvjTV73NXMVqKOBx+qZEbYJot0J3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qye8oxpew0fLpEOw4WSNdYV9aCBmWpmHI8BUGSz2cp0T6ow67IKEc1EGRLyu76cNufIUdjCcJhmV34fn6YS3qgBOU8f6d7bTLRa9Tq3z0AY2v+aLwLyWoI8zZqfdFUF4PSxNArsso87LKGNRUpbSPWmPEhM2PcXe8h39Zhr7BDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F890yl27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F890yl27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61FFC4CEDB;
	Tue, 10 Sep 2024 10:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963018;
	bh=MqYqfshstCmkT8IvjTV73NXMVqKOBx+qZEbYJot0J3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F890yl27lk1GclC3TVjEe/TQp/euc+ZfeOhtsepmRntEK9/tBvUmMjMC4ayITp+0n
	 /P/nfVl0J/8hAWxoQ1+3McFLSQbcyyzmaMqwwnjlQUnIqA+5CoKosF3vgM9cGqdcFs
	 PWaawpDetIUC7F6Y9S4FBS9dv1owg/GsnO6sel0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/192] ice: Use ice_max_xdp_frame_size() in ice_xdp_setup_prog()
Date: Tue, 10 Sep 2024 11:31:44 +0200
Message-ID: <20240910092601.279199687@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 60bc72b3c4e9127f29686770005da40b10be0576 ]

This should have been used in there from day 1, let us address that
before introducing XDP multi-buffer support for Rx side.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Link: https://lore.kernel.org/bpf/20230131204506.219292-8-maciej.fijalkowski@intel.com
Stable-dep-of: 04c7e14e5b0b ("ice: do not bring the VSI up, if it was down before the XDP setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 28 +++++++++++------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 15876f388d68..cd9bcc3536fb 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2886,6 +2886,18 @@ int ice_vsi_determine_xdp_res(struct ice_vsi *vsi)
 	return 0;
 }
 
+/**
+ * ice_max_xdp_frame_size - returns the maximum allowed frame size for XDP
+ * @vsi: Pointer to VSI structure
+ */
+static int ice_max_xdp_frame_size(struct ice_vsi *vsi)
+{
+	if (test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags))
+		return ICE_RXBUF_1664;
+	else
+		return ICE_RXBUF_3072;
+}
+
 /**
  * ice_xdp_setup_prog - Add or remove XDP eBPF program
  * @vsi: VSI to setup XDP for
@@ -2896,11 +2908,11 @@ static int
 ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 		   struct netlink_ext_ack *extack)
 {
-	int frame_size = vsi->netdev->mtu + ICE_ETH_PKT_HDR_PAD;
+	unsigned int frame_size = vsi->netdev->mtu + ICE_ETH_PKT_HDR_PAD;
 	bool if_running = netif_running(vsi->netdev);
 	int ret = 0, xdp_ring_err = 0;
 
-	if (frame_size > vsi->rx_buf_len) {
+	if (frame_size > ice_max_xdp_frame_size(vsi)) {
 		NL_SET_ERR_MSG_MOD(extack, "MTU too large for loading XDP");
 		return -EOPNOTSUPP;
 	}
@@ -7329,18 +7341,6 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 	dev_err(dev, "Rebuild failed, unload and reload driver\n");
 }
 
-/**
- * ice_max_xdp_frame_size - returns the maximum allowed frame size for XDP
- * @vsi: Pointer to VSI structure
- */
-static int ice_max_xdp_frame_size(struct ice_vsi *vsi)
-{
-	if (test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags))
-		return ICE_RXBUF_1664;
-	else
-		return ICE_RXBUF_3072;
-}
-
 /**
  * ice_change_mtu - NDO callback to change the MTU
  * @netdev: network interface device structure
-- 
2.43.0



