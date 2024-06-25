Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04DC1465A8;
	Tue, 25 Jun 2024 09:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308391; cv=none; b=Of1CQgrwUtwdTOxhoiO5sbOjnEYDdYQsBpDqJL0BMOGvzL7v4mze/lCLUStlSByOYiM7sv2yi8UuPKF3UNSpR/L3udhGW+M36wE8hu8kJGTeZWG2CCT6IzeYdOdeLK/E5gIMLswLLfy7sDUxTv+kbzoA0GXgDawk6MVIxmB+iIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308391; c=relaxed/simple;
	bh=6oboRPOa4epSK5BtCOXzTleQbxP3/7Hty5TETV385HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sO6BNGIrrKy8F3zg9iYWS9D86EgoLpMa6kSp4k+6n0VhlwhXTFVTar9wTlcYZB01jIXTqmtSCUsYceVfxL4sUzrHSSYl97XB3njsEdX4qvDuNo1yjwpL/VnjTo6huigTQR8scrSzmeijCr9Jqor6gliHI697LMu9dxuyFE1KJfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfFb+Pqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfFb+Pqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537BAC32781;
	Tue, 25 Jun 2024 09:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308391;
	bh=6oboRPOa4epSK5BtCOXzTleQbxP3/7Hty5TETV385HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfFb+PqdpwRhy5iXOvPE2pSlsu3Un9UM4Mm7jzxaVP6No//VvLupXsDvOqKwSiiSt
	 KnRuoDJhVZdET8vxhka5AQIT/bHxdntuqXUSrHnwU08mDF8l8jAICcqPB+4UJAvnzF
	 aTr9egxBsWRr56KNJwFsMvD0Qs73eI5tCrTDQ7bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.9 106/250] ice: implement AQ download pkg retry
Date: Tue, 25 Jun 2024 11:31:04 +0200
Message-ID: <20240625085552.141437541@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wojciech Drewek <wojciech.drewek@intel.com>

[ Upstream commit a27f6ac9d404ea84196639dcc456f969ef813c0f ]

ice_aqc_opc_download_pkg (0x0C40) AQ sporadically returns error due
to FW issue. Fix this by retrying five times before moving to
Safe Mode. Sleep for 20 ms before retrying. This was tested with the
4.40 firmware.

Fixes: c76488109616 ("ice: Implement Dynamic Device Personalization (DDP) download")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ddp.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ddp.c b/drivers/net/ethernet/intel/ice/ice_ddp.c
index 4df561d64bc38..6e7d58243c7cb 100644
--- a/drivers/net/ethernet/intel/ice/ice_ddp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ddp.c
@@ -1329,6 +1329,7 @@ ice_dwnld_cfg_bufs_no_lock(struct ice_hw *hw, struct ice_buf *bufs, u32 start,
 
 	for (i = 0; i < count; i++) {
 		bool last = false;
+		int try_cnt = 0;
 		int status;
 
 		bh = (struct ice_buf_hdr *)(bufs + start + i);
@@ -1336,8 +1337,26 @@ ice_dwnld_cfg_bufs_no_lock(struct ice_hw *hw, struct ice_buf *bufs, u32 start,
 		if (indicate_last)
 			last = ice_is_last_download_buffer(bh, i, count);
 
-		status = ice_aq_download_pkg(hw, bh, ICE_PKG_BUF_SIZE, last,
-					     &offset, &info, NULL);
+		while (1) {
+			status = ice_aq_download_pkg(hw, bh, ICE_PKG_BUF_SIZE,
+						     last, &offset, &info,
+						     NULL);
+			if (hw->adminq.sq_last_status != ICE_AQ_RC_ENOSEC &&
+			    hw->adminq.sq_last_status != ICE_AQ_RC_EBADSIG)
+				break;
+
+			try_cnt++;
+
+			if (try_cnt == 5)
+				break;
+
+			msleep(20);
+		}
+
+		if (try_cnt)
+			dev_dbg(ice_hw_to_dev(hw),
+				"ice_aq_download_pkg number of retries: %d\n",
+				try_cnt);
 
 		/* Save AQ status from download package */
 		if (status) {
-- 
2.43.0



