Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F3C27A476;
	Thu, 28 May 2026 20:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998578; cv=none; b=gDixlCAXslZ3R2Gqi6BX2npsf1gtdlxpZKgke8RCNshyePTOfN+oxuqnDMxzzyR62NcfoSt1TGAYlYf+vsgrmgQH/+vus+ju97BN4TCBNdtQf//6v0tQQC5w/CfJdl07/NnOjVAlENH7KUSg+QR5iDZEWAcBSAFqvda0K8DL+BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998578; c=relaxed/simple;
	bh=uS5q4Pb6LbYguAkd68+82DPqYxucHv5ipUobHdYcuN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mot6OpWV8ljdbbgK1lW6DwcFoC6Eytm35AtKhU/8NagFw97zRrIfFdbmxvNKlf6P9BrblNhvlV1krGy8VrEW8JqLDfbnjG5rK+4SzwpsS/IpnFPkJCJdGCy2gAkABDiwqTgSoKYuOukTCVrQFXVVeTS+vQY18sT/vLVreJueMZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRa1Ul/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRa1Ul/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F6F1F000E9;
	Thu, 28 May 2026 20:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998577;
	bh=zQip+9yV+J5J78J4esF06qPeV5tVG1fiTsSYXVlv01I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TRa1Ul/ep6BwIq2fzFs2dGh2IzvMLv+dsyHO3JYJboJPX8HOZ/7YXks6yM/i86du4
	 psrayLEFAut9R1UgS8YEGLlfIt2LCnbf6b0EmT0CFQ63cg1jM3h+Hx7XUz7CCYggd0
	 mHGzpkZKe+3ZDLYj98WHdxfLD/VVy6l0vnMF91Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 223/461] ice: fix setting RSS VSI hash for E830
Date: Thu, 28 May 2026 21:45:52 +0200
Message-ID: <20260528194653.586818940@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit b3cda96feb60d91fe88d52b974ff110dcfa91239 ]

ice_set_rss_hfunc() performs a VSI update, in which it sets hashing
function, leaving other VSI options unchanged. However, ::q_opt_flags is
mistakenly set to the value of another field, instead of its original
value, probably due to a typo. What happens next is hardware-dependent:

On E810, only the first bit is meaningful (see
ICE_AQ_VSI_Q_OPT_PE_FLTR_EN) and can potentially end up in a different
state than before VSI update.

On E830, some of the remaining bits are not reserved. Setting them
to some unrelated values can cause the firmware to reject the update
because of invalid settings, or worse - succeed.

Reproducer:
  sudo ethtool -X $PF1 equal 8

Output in dmesg:
  Failed to configure RSS hash for VSI 6, error -5

Fixes: 352e9bf23813 ("ice: enable symmetric-xor RSS for Toeplitz hash function")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260506-jk-iwl-net-2026-05-04-v2-5-a5ea4dc837a9@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4718799263721..b5df8e052467a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -8052,7 +8052,7 @@ int ice_set_rss_hfunc(struct ice_vsi *vsi, u8 hfunc)
 	ctx->info.q_opt_rss |=
 		FIELD_PREP(ICE_AQ_VSI_Q_OPT_RSS_HASH_M, hfunc);
 	ctx->info.q_opt_tc = vsi->info.q_opt_tc;
-	ctx->info.q_opt_flags = vsi->info.q_opt_rss;
+	ctx->info.q_opt_flags = vsi->info.q_opt_flags;
 
 	err = ice_update_vsi(hw, vsi->idx, ctx, NULL);
 	if (err) {
-- 
2.53.0



