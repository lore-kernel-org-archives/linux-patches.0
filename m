Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E74D1547F5;
	Mon, 16 Sep 2024 12:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488619; cv=none; b=iJey90VO7duevzk7HgdqooRVmxvC0hw4dtNXed98XVMQQdpLlAgTB3ZhKfL5XZco1piujl4swMnaWANzRU9pJRTIW10C9zPR2deJIngS3gqK7MrRNvvucblXDfYgRV9VzUvuFtKA4LwYtJ+Vg14FDOYtzXH2w3gSHJqKv4hNHBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488619; c=relaxed/simple;
	bh=v7fl1c8Mt97BvRAhytzYQPWI9Mu0OdKlVDa2FWE6jxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EaUje+RmZq+7HtmrTApBZGsJS/LmJ69OyMv8MrJMPU+SKg5JZHlnb2W9Hy+S4Zm8Rnr0VGz2qPOuEJtm0ib/OPhsFSbHhyLUYsxz4S/wGqgxPUvHS+4IZTFvJ9JhYolPnZZnpuUPxzmGIXlZ+MUW9cAM+RAXa9dBuB9MYAi8f+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtgFwcNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtgFwcNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89775C4CEC4;
	Mon, 16 Sep 2024 12:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488618;
	bh=v7fl1c8Mt97BvRAhytzYQPWI9Mu0OdKlVDa2FWE6jxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtgFwcNoRDZ340fzgfj73JdMKCXYWI7AhrkS44SN4ReEwoUyiovQUGJa86v4fgnb2
	 GzftD3fNPbEWA+3S1eFjESD4nuZxjpQPVihwz4ALtlqsoYVPifo11HU92ZZjGNVft5
	 fKZOG2UKeo+02hVrDdG2MbOnpAjrz7hmvUKYMj7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mat=C4=9Bj=20Gr=C3=A9gr?= <mgregr@netx.as>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 55/91] ice: Fix lldp packets dropping after changing the number of channels
Date: Mon, 16 Sep 2024 13:44:31 +0200
Message-ID: <20240916114226.324413114@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>

[ Upstream commit 9debb703e14939dfafa5d403f27c4feb2e9f6501 ]

After vsi setup refactor commit 6624e780a577 ("ice: split ice_vsi_setup
into smaller functions") ice_cfg_sw_lldp function which removes rx rule
directing LLDP packets to vsi is moved from ice_vsi_release to
ice_vsi_decfg function. ice_vsi_decfg is used in more cases than just in
vsi_release resulting in unnecessary removal of rx lldp packets handling
switch rule. This leads to lldp packets being dropped after a change number
of channels via ethtool.
This patch moves ice_cfg_sw_lldp function that removes rx lldp sw rule back
to ice_vsi_release function.

Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
Reported-by: Matěj Grégr <mgregr@netx.as>
Closes: https://lore.kernel.org/intel-wired-lan/1be45a76-90af-4813-824f-8398b69745a9@netx.as/T/#u
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index b3010a53f1b4..3a0ef56d3edc 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2600,13 +2600,6 @@ void ice_vsi_decfg(struct ice_vsi *vsi)
 	struct ice_pf *pf = vsi->back;
 	int err;
 
-	/* The Rx rule will only exist to remove if the LLDP FW
-	 * engine is currently stopped
-	 */
-	if (!ice_is_safe_mode(pf) && vsi->type == ICE_VSI_PF &&
-	    !test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
-		ice_cfg_sw_lldp(vsi, false, false);
-
 	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
 	err = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
 	if (err)
@@ -2953,6 +2946,14 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		ice_rss_clean(vsi);
 
 	ice_vsi_close(vsi);
+
+	/* The Rx rule will only exist to remove if the LLDP FW
+	 * engine is currently stopped
+	 */
+	if (!ice_is_safe_mode(pf) && vsi->type == ICE_VSI_PF &&
+	    !test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
+		ice_cfg_sw_lldp(vsi, false, false);
+
 	ice_vsi_decfg(vsi);
 
 	/* retain SW VSI data structure since it is needed to unregister and
-- 
2.43.0



