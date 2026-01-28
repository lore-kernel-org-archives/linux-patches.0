Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BF1302779;
	Wed, 28 Jan 2026 15:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615082; cv=none; b=Ttp34FzaM1Gxs38I0JDBKMbzcbyKJ92f1iWCNLJb3/jMi0f0c0v/7CPnKGb6u96f5Po0gwMaa6WczNNB8VxphL45rh96/wziBsrd+o3DE7UgRcOvIgkU/7XgBTKcrw51Aw8w6ESY79nhF7BW4C3zbepJcz4vPMJP2BrC5tvqbEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615082; c=relaxed/simple;
	bh=DEok7o50vj7Vtfe6DYvNJK8QmoiWYmqD5Zj9Tp14iCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8+K8rlqmOABULQwxwQrZWZtV92D8YBbtnbokDVBDE9aGTiGdyybAKEv+peLPPaPizLmuMpFFwBUQ3t9YKujhWmBE0bD9ahSPlMXnJmmWq3MYCZMQ1p61h1r7nX8FhjTB4+QNJ1YHwr5Swij7vmw0Mv4cdvi6Dt4o0gtA1KJN18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLqyHquc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLqyHquc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253E6C4CEF1;
	Wed, 28 Jan 2026 15:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615082;
	bh=DEok7o50vj7Vtfe6DYvNJK8QmoiWYmqD5Zj9Tp14iCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLqyHqucF20HR3qSLvBPv7y6wyrxYCx1Caq4uQMgzhVofG/2gOkj9VupWdm/IMN/X
	 QTwvF/uUw58iv/J3yKyUSxaO6hgdlWll0OsW0Qv397k97sK9X0s9/gXMC7VPvQAdFe
	 VUnnH1BvfnmOTLASPFRI/8W8KyxBGT/yhhBgaZp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cody Haas <chaas@riotgames.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 073/169] ice: Fix persistent failure in ice_get_rxfh
Date: Wed, 28 Jan 2026 16:22:36 +0100
Message-ID: <20260128145336.634682225@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cody Haas <chaas@riotgames.com>

[ Upstream commit f406220eb8e227ca344eef1a6d30aff53706b196 ]

Several ioctl functions have the ability to call ice_get_rxfh, however
all of these ioctl functions do not provide all of the expected
information in ethtool_rxfh_param. For example, ethtool_get_rxfh_indir does
not provide an rss_key. This previously caused ethtool_get_rxfh_indir to
always fail with -EINVAL.

This change draws inspiration from i40e_get_rss to handle this
situation, by only calling the appropriate rss helpers when the
necessary information has been provided via ethtool_rxfh_param.

Fixes: b66a972abb6b ("ice: Refactor ice_set/get_rss into LUT and key specific functions")
Signed-off-by: Cody Haas <chaas@riotgames.com>
Closes: https://lore.kernel.org/intel-wired-lan/CAH7f-UKkJV8MLY7zCdgCrGE55whRhbGAXvgkDnwgiZ9gUZT7_w@mail.gmail.com/
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h         |  1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  6 +----
 drivers/net/ethernet/intel/ice/ice_main.c    | 28 ++++++++++++++++++++
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 0e699a0432c5b..bffdf537dafa8 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -952,6 +952,7 @@ void ice_map_xdp_rings(struct ice_vsi *vsi);
 int
 ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	     u32 flags);
+int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 int ice_set_rss_lut(struct ice_vsi *vsi, u8 *lut, u16 lut_size);
 int ice_get_rss_lut(struct ice_vsi *vsi, u8 *lut, u16 lut_size);
 int ice_set_rss_key(struct ice_vsi *vsi, u8 *seed);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 2a2acbeb57221..5379fbe06b073 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3649,11 +3649,7 @@ ice_get_rxfh(struct net_device *netdev, struct ethtool_rxfh_param *rxfh)
 	if (!lut)
 		return -ENOMEM;
 
-	err = ice_get_rss_key(vsi, rxfh->key);
-	if (err)
-		goto out;
-
-	err = ice_get_rss_lut(vsi, lut, vsi->rss_table_size);
+	err = ice_get_rss(vsi, rxfh->key, lut, vsi->rss_table_size);
 	if (err)
 		goto out;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4f4678607e55f..d024e71722de3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -8042,6 +8042,34 @@ int ice_get_rss_key(struct ice_vsi *vsi, u8 *seed)
 	return status;
 }
 
+/**
+ * ice_get_rss - Get RSS LUT and/or key
+ * @vsi: Pointer to VSI structure
+ * @seed: Buffer to store the key in
+ * @lut: Buffer to store the lookup table entries
+ * @lut_size: Size of buffer to store the lookup table entries
+ *
+ * Return: 0 on success, negative on failure
+ */
+int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size)
+{
+	int err;
+
+	if (seed) {
+		err = ice_get_rss_key(vsi, seed);
+		if (err)
+			return err;
+	}
+
+	if (lut) {
+		err = ice_get_rss_lut(vsi, lut, lut_size);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 /**
  * ice_set_rss_hfunc - Set RSS HASH function
  * @vsi: Pointer to VSI structure
-- 
2.51.0



