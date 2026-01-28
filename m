Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175302874FE;
	Wed, 28 Jan 2026 15:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615865; cv=none; b=QsdgU3OxjTBUC4n5M28CALLm+95G4xNi+WKyIpS8ghlXcXe3/pJNeD4XGFhMQT2ITH9Efv536dFrokyMIRZ+PfRIuEV97JrDJqv1M14ZP5M76k80rHdThyNJD8/eaM0BprMoWmyA50wqh+fDuGXiCBVi69lHKiPhdM5L8u+4mOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615865; c=relaxed/simple;
	bh=gyagi02eS/b7bh42eGLvYLwCecnfP7g/ZV8QgxfG6Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fg++hppaH9M6E2KY3kZyS58HQjiSI8nMYmrkUpnpB0ltHUnYhzD2B7u/kFzEv/oqQk1zlLpvKXiU4xgCir56B1PabiB7c4LgaT2v8LAdukQMrmnxYK/bEhSOZTssMZC1rmLwsh88Yy/SwXdCicNYNUpQHzp1A3whwz81glicf8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gs6TDxuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gs6TDxuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3909BC4CEF1;
	Wed, 28 Jan 2026 15:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615864;
	bh=gyagi02eS/b7bh42eGLvYLwCecnfP7g/ZV8QgxfG6Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gs6TDxuzdVPgfXD6872F6wCn3A3X70T47Il3v4eHrfNUEjVG6SfawNtXV85B+BDg3
	 hfeWtURYyADQ3svMLcIBd2vtCgCdWu0YnAJNnOoCpUYbZ4y2EObxmgffqPEDf+Gu1m
	 p+e8j2rehhZEvJyX1dj4xBWzt+AK4Tys6FJTOYcc=
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
Subject: [PATCH 6.18 104/227] ice: Fix persistent failure in ice_get_rxfh
Date: Wed, 28 Jan 2026 16:22:29 +0100
Message-ID: <20260128145348.205817679@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9ee596773f34e..a23ccd4ba08d2 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -977,6 +977,7 @@ void ice_map_xdp_rings(struct ice_vsi *vsi);
 int
 ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	     u32 flags);
+int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 int ice_set_rss_lut(struct ice_vsi *vsi, u8 *lut, u16 lut_size);
 int ice_get_rss_lut(struct ice_vsi *vsi, u8 *lut, u16 lut_size);
 int ice_set_rss_key(struct ice_vsi *vsi, u8 *seed);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index dc131779d4267..06b5677e9bff8 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3621,11 +3621,7 @@ ice_get_rxfh(struct net_device *netdev, struct ethtool_rxfh_param *rxfh)
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
index b0f8a96c13b47..6c392495f4a76 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -8002,6 +8002,34 @@ int ice_get_rss_key(struct ice_vsi *vsi, u8 *seed)
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



