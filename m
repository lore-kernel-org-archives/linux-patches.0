Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB3D266EFC;
	Tue,  8 Apr 2025 11:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110938; cv=none; b=dwg/ia5BTAnOHxucZzY0BKPxosadIRA4SBOJkH31wN+LV4ucNM5E5UtrWfpzgfUzH55APwRx21X7WnQ6583rKox9hsE3G4GAKORhON42ImttEHL59U2r117mXjtrurF58PAXXOstvsIJ2PRpXrpraUDb4nNOVj+DTEFvT/66i2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110938; c=relaxed/simple;
	bh=J59TDicmt2bWHVmVUu+9bCR36l9Vi9V1P4uU/4mRmz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPD3S7FFCBLCvZFtzdgWEuklxIyLpxZa/N8yB9ypGDk0A0AsQeDK74TXzu8R59/ci2ex3wfMZV/Wl4IvOEjsIAxQdigUVkYbBEkWoZRtqULtKON8FDSgwzkiBmV/u3KhNiXpedt8qRHriaPIjDiDsh4rCoJg0sFpPKcCm2jHyqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQXTUVgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQXTUVgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E66C4CEE5;
	Tue,  8 Apr 2025 11:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110938;
	bh=J59TDicmt2bWHVmVUu+9bCR36l9Vi9V1P4uU/4mRmz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQXTUVgrDwz+xOV1nzuKrFAB2WAqK/vMuUG4s36LBypkqONutiRYFSNCT4PgPtcWR
	 2deesp+eL1BwYzc6pZ0BpTUu7xUuJ9CffSeeVxE/ZM6f6WhMG4sxh86AgLJC4Ax5w3
	 6Shp1aOvNchaUopTc3bU+GbjfUE8GhVFIL4ZRQ/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 213/731] ice: fix using untrusted value of pkt_len in ice_vc_fdir_parse_raw()
Date: Tue,  8 Apr 2025 12:41:50 +0200
Message-ID: <20250408104919.238137494@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Polchlopek <mateusz.polchlopek@intel.com>

[ Upstream commit 1388dd564183a5a18ec4a966748037736b5653c5 ]

Fix using the untrusted value of proto->raw.pkt_len in function
ice_vc_fdir_parse_raw() by verifying if it does not exceed the
VIRTCHNL_MAX_SIZE_RAW_PACKET value.

Fixes: 99f419df8a5c ("ice: enable FDIR filters from raw binary patterns for VFs")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Signed-off-by: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    | 24 ++++++++++++-------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index 14e3f0f89c78d..9be4bd717512d 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -832,21 +832,27 @@ ice_vc_fdir_parse_raw(struct ice_vf *vf,
 		      struct virtchnl_proto_hdrs *proto,
 		      struct virtchnl_fdir_fltr_conf *conf)
 {
-	u8 *pkt_buf, *msk_buf __free(kfree);
+	u8 *pkt_buf, *msk_buf __free(kfree) = NULL;
 	struct ice_parser_result rslt;
 	struct ice_pf *pf = vf->pf;
+	u16 pkt_len, udp_port = 0;
 	struct ice_parser *psr;
 	int status = -ENOMEM;
 	struct ice_hw *hw;
-	u16 udp_port = 0;
 
-	pkt_buf = kzalloc(proto->raw.pkt_len, GFP_KERNEL);
-	msk_buf = kzalloc(proto->raw.pkt_len, GFP_KERNEL);
+	pkt_len = proto->raw.pkt_len;
+
+	if (!pkt_len || pkt_len > VIRTCHNL_MAX_SIZE_RAW_PACKET)
+		return -EINVAL;
+
+	pkt_buf = kzalloc(pkt_len, GFP_KERNEL);
+	msk_buf = kzalloc(pkt_len, GFP_KERNEL);
+
 	if (!pkt_buf || !msk_buf)
 		goto err_mem_alloc;
 
-	memcpy(pkt_buf, proto->raw.spec, proto->raw.pkt_len);
-	memcpy(msk_buf, proto->raw.mask, proto->raw.pkt_len);
+	memcpy(pkt_buf, proto->raw.spec, pkt_len);
+	memcpy(msk_buf, proto->raw.mask, pkt_len);
 
 	hw = &pf->hw;
 
@@ -862,7 +868,7 @@ ice_vc_fdir_parse_raw(struct ice_vf *vf,
 	if (ice_get_open_tunnel_port(hw, &udp_port, TNL_VXLAN))
 		ice_parser_vxlan_tunnel_set(psr, udp_port, true);
 
-	status = ice_parser_run(psr, pkt_buf, proto->raw.pkt_len, &rslt);
+	status = ice_parser_run(psr, pkt_buf, pkt_len, &rslt);
 	if (status)
 		goto err_parser_destroy;
 
@@ -876,7 +882,7 @@ ice_vc_fdir_parse_raw(struct ice_vf *vf,
 	}
 
 	status = ice_parser_profile_init(&rslt, pkt_buf, msk_buf,
-					 proto->raw.pkt_len, ICE_BLK_FD,
+					 pkt_len, ICE_BLK_FD,
 					 conf->prof);
 	if (status)
 		goto err_parser_profile_init;
@@ -885,7 +891,7 @@ ice_vc_fdir_parse_raw(struct ice_vf *vf,
 		ice_parser_profile_dump(hw, conf->prof);
 
 	/* Store raw flow info into @conf */
-	conf->pkt_len = proto->raw.pkt_len;
+	conf->pkt_len = pkt_len;
 	conf->pkt_buf = pkt_buf;
 	conf->parser_ena = true;
 
-- 
2.39.5



