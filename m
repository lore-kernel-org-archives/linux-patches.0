Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C380610B;
	Mon, 14 Oct 2024 14:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916229; cv=none; b=nEtMwY/Jx1Pzjfq4We9bk1b11R6o+ZFad7NlLd/NweJ+4ZDzOFQuFZTWWJBo2oMZGZQongRooBbhtA5SQmLHKtPL+NeZzKFpAy3geoBTp/7U8Jg+dEcnQtGP4hUiwWIcX2zUSb0IHLEr2mIL86p1AqImMVV94qX5NWrvo9vQpDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916229; c=relaxed/simple;
	bh=Qlg4GzrfhRZ+W2WBhsBPEaPTk1Qi/tK3EqizDhBNGxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyMK8G+cn25o3OlH7nU3VusIKKfbyYUhCc6OHWZe4G3MkRFoXLTVpxFbmKjCgH7DgY7qvVuOD1L+02RTGK8dswL3IKvBg2huKa4H2MpzWRfuz/k5/JflkdhicaFzMu0r0DfhdLIXiG6f6DmJg1R+IoFPVveN3GbCmzIIFyIU3+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eAcBSM9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAcBSM9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD184C4CEC3;
	Mon, 14 Oct 2024 14:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916229;
	bh=Qlg4GzrfhRZ+W2WBhsBPEaPTk1Qi/tK3EqizDhBNGxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eAcBSM9xM1e9ODOfSC8ZLrKl4Rrw5KxAYHbdwPDgPEW6Ep4HO15/RehYanjPw6Xlo
	 rt2vTnbv9eCfbnuvoEXfqtSU01sx5meIoozsOjQ4h9mpKgOE6OY4IyyURvE/tAphL3
	 Oex2m3MVeO6xaCCYh/y6W9Xlbi1GaqBbSVnBRuwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.11 120/214] ice: Fix entering Safe Mode
Date: Mon, 14 Oct 2024 16:19:43 +0200
Message-ID: <20241014141049.673875107@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit b972060a47780aa2d46441e06b354156455cc877 ]

If DDP package is missing or corrupted, the driver should enter Safe Mode.
Instead, an error is returned and probe fails.

To fix this, don't exit init if ice_init_ddp_config() returns an error.

Repro:
* Remove or rename DDP package (/lib/firmware/intel/ice/ddp/ice.pkg)
* Load ice

Fixes: cc5776fe1832 ("ice: Enable switching default Tx scheduler topology")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a06dcf8367db0..5bd0d7252081c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4779,14 +4779,12 @@ int ice_init_dev(struct ice_pf *pf)
 	ice_init_feature_support(pf);
 
 	err = ice_init_ddp_config(hw, pf);
-	if (err)
-		return err;
 
 	/* if ice_init_ddp_config fails, ICE_FLAG_ADV_FEATURES bit won't be
 	 * set in pf->state, which will cause ice_is_safe_mode to return
 	 * true
 	 */
-	if (ice_is_safe_mode(pf)) {
+	if (err || ice_is_safe_mode(pf)) {
 		/* we already got function/device capabilities but these don't
 		 * reflect what the driver needs to do in safe mode. Instead of
 		 * adding conditional logic everywhere to ignore these
-- 
2.43.0



