Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E4535AC0E;
	Thu, 28 May 2026 20:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999846; cv=none; b=lS5bLqAlLrg/02oFw4Odgkog5DKPiek4sDqOlMIgqXX/Y8kKiZ7Am4SAYoYqYjUCUX5GxSVTbkisfo/jowoaPSqVZy74rd5zBo+3XJisl9lTbh3jyriMpHiA1TLoQiw5M9TdCjvOidYvb4ntkHHM0ZF/BQ0DxJFNx+ajhomcGrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999846; c=relaxed/simple;
	bh=Bk6Sb8a0NvaoPtQiSs/obN/zkdIkOyiQZ1FTqQzeN5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5Gp5gnUIStjQoE8U7XiI5q8wyxl792U+esqwr/Vz+1pODOpYVc20J8JGLjHd1Sc64bQzowjGCng/9dlpXY2VWpVo5M7ymDl9tvwb6styFiMN0fBGgxAaJbje7HYqApEBu9+M00ZQpSILRiWIFFBKXReR4/XbN16Hr+NenBkb3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHI+6AJ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHI+6AJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070541F000E9;
	Thu, 28 May 2026 20:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999844;
	bh=YOpJfzsgKzIa9M4H1eshWXDH4LrQnGLNnTCFMvPI+Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHI+6AJ4hXTSOtO74nQJb3mtNEKyB+7TPrUTkAsEfGnGSNlT7ZPlBWY2x7Nsl3m0J
	 SUmTFZjXarvQR9C7Di/GsQjPafs3jnFHyFwD7Lz66lXc1nKloysSKsh6IpYRdRhBUE
	 ZwnHlaie51xe5Uy4xPW2n+7VKnk9hMSwDFuJxP/I=
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
Subject: [PATCH 6.18 211/377] ice: fix setting RSS VSI hash for E830
Date: Thu, 28 May 2026 21:47:29 +0200
Message-ID: <20260528194644.510356919@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
index d42b65e29e485..dc5d821bf3348 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -8075,7 +8075,7 @@ int ice_set_rss_hfunc(struct ice_vsi *vsi, u8 hfunc)
 	ctx->info.q_opt_rss |=
 		FIELD_PREP(ICE_AQ_VSI_Q_OPT_RSS_HASH_M, hfunc);
 	ctx->info.q_opt_tc = vsi->info.q_opt_tc;
-	ctx->info.q_opt_flags = vsi->info.q_opt_rss;
+	ctx->info.q_opt_flags = vsi->info.q_opt_flags;
 
 	err = ice_update_vsi(hw, vsi->idx, ctx, NULL);
 	if (err) {
-- 
2.53.0



