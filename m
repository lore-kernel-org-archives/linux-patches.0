Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B861DA23;
	Tue,  6 Jan 2026 17:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720646; cv=none; b=r+cdCG7Z1EeWy5ojJ9yo5w0Zz5E/w/ykucFMLo1G/9zRQf9OckWvfrobQjxxS8UzRbjdXcjkYALxQxKb2yt7KiyDJ8GAg0KLiU5c6eRaMmgK9oLtxRZ/KZbpHai9Y8PlmkkqyWdtCQ0idimGKQoTVxxageasNLidAwjX2j/o+Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720646; c=relaxed/simple;
	bh=AhyP0wd9kozF1Nz3NSDGm4g4nXUvTl0Kxm1SC1cBJVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quPpcAeTrkjK8yScYEoprqEKdoIuml/26hsnaZ7acvrKxMFLacCGJM3amBJGrBFdcWJhGJKy4Qn6F6p0YM/G91jutD7E68tLMmqlPgzdzKPNcTDP5CwNOLc3fBwP2Hdx1G5Y2dhPk2Nx+awn+pwCledfnvLoRSbWOlEzDXLFCG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2locVYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2locVYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95776C116C6;
	Tue,  6 Jan 2026 17:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720646;
	bh=AhyP0wd9kozF1Nz3NSDGm4g4nXUvTl0Kxm1SC1cBJVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2locVYv5Dwwg6mhY+9tk7w683ue0T8xCJHmmn7DqwaUL7KGrX3nILyY290vIajH+
	 0io7Xm5BW9T3JkT4bpc+InRSFt4THMVSG9rvSuy5Vhakze21R+tHxbTa68TcC5eB8a
	 IdBKWGL9EX8i17fgMyJzEiTnQxn5g335KPE0b+l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Herrero <gregory.herrero@oracle.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 299/567] i40e: validate ring_len parameter against hardware-specific values
Date: Tue,  6 Jan 2026 18:01:21 +0100
Message-ID: <20260106170502.393605503@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Gregory Herrero <gregory.herrero@oracle.com>

[ Upstream commit 69942834215323cd9131db557091b4dec43f19c5 ]

The maximum number of descriptors supported by the hardware is
hardware-dependent and can be retrieved using
i40e_get_max_num_descriptors(). Move this function to a shared header
and use it when checking for valid ring_len parameter rather than using
hardcoded value.

By fixing an over-acceptance issue, behavior change could be seen where
ring_len could now be rejected while configuring rx and tx queues if its
size is larger than the hardware-dependent maximum number of
descriptors.

Fixes: 55d225670def ("i40e: add validation for ring_len param")
Signed-off-by: Gregory Herrero <gregory.herrero@oracle.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h             | 11 +++++++++++
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     | 12 ------------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  4 ++--
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index b8de97343ad3..de3d5e5b8306 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1415,4 +1415,15 @@ static inline struct i40e_veb *i40e_pf_get_main_veb(struct i40e_pf *pf)
 	return (pf->lan_veb != I40E_NO_VEB) ? pf->veb[pf->lan_veb] : NULL;
 }
 
+static inline u32 i40e_get_max_num_descriptors(const struct i40e_pf *pf)
+{
+	const struct i40e_hw *hw = &pf->hw;
+
+	switch (hw->mac.type) {
+	case I40E_MAC_XL710:
+		return I40E_MAX_NUM_DESCRIPTORS_XL710;
+	default:
+		return I40E_MAX_NUM_DESCRIPTORS;
+	}
+}
 #endif /* _I40E_H_ */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index bce5b76f1e7a..9a96f67fb648 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2010,18 +2010,6 @@ static void i40e_get_drvinfo(struct net_device *netdev,
 		drvinfo->n_priv_flags += I40E_GL_PRIV_FLAGS_STR_LEN;
 }
 
-static u32 i40e_get_max_num_descriptors(struct i40e_pf *pf)
-{
-	struct i40e_hw *hw = &pf->hw;
-
-	switch (hw->mac.type) {
-	case I40E_MAC_XL710:
-		return I40E_MAX_NUM_DESCRIPTORS_XL710;
-	default:
-		return I40E_MAX_NUM_DESCRIPTORS;
-	}
-}
-
 static void i40e_get_ringparam(struct net_device *netdev,
 			       struct ethtool_ringparam *ring,
 			       struct kernel_ethtool_ringparam *kernel_ring,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 646e394f5190..3251ffa7d994 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -656,7 +656,7 @@ static int i40e_config_vsi_tx_queue(struct i40e_vf *vf, u16 vsi_id,
 
 	/* ring_len has to be multiple of 8 */
 	if (!IS_ALIGNED(info->ring_len, 8) ||
-	    info->ring_len > I40E_MAX_NUM_DESCRIPTORS_XL710) {
+	    info->ring_len > i40e_get_max_num_descriptors(pf)) {
 		ret = -EINVAL;
 		goto error_context;
 	}
@@ -726,7 +726,7 @@ static int i40e_config_vsi_rx_queue(struct i40e_vf *vf, u16 vsi_id,
 
 	/* ring_len has to be multiple of 32 */
 	if (!IS_ALIGNED(info->ring_len, 32) ||
-	    info->ring_len > I40E_MAX_NUM_DESCRIPTORS_XL710) {
+	    info->ring_len > i40e_get_max_num_descriptors(pf)) {
 		ret = -EINVAL;
 		goto error_param;
 	}
-- 
2.51.0



