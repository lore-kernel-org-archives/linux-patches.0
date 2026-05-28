Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F0932ABC0;
	Thu, 28 May 2026 20:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999019; cv=none; b=HfdaH6RTlx6HcxkMncLL8rBH28iguDn6YZgm/sanahMpsq7dMyJQbvhSH4b9xWO+HOwYby9Jb9ra2dCdJGYdGKlE471b589gj+YfqXIHI9+lM2VW2+d9YcZ08/4GGW/6p7qMkgLtmYaGGXXriSyfLsQ8+PK7rZd2qQOwWzyDhKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999019; c=relaxed/simple;
	bh=78ZxGxFIs8MVHNOwUR+V0OnaJd25jDEKVIRGSaivYUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjLh9DxjHbQ4VIMe4zsmfxMf75XPQBgE5Wr99bGS2xzLjESnKn18LAuGfC0cGGAfqmHoqH80JbRBLx7BdosvqY9z3Eb9Oj/yK7MWtqe4zr0f5qTW4dU76mSpPM8lBg4BvppPPAu6AxNe51216vF7XlnUZjiYEVIIqT9cAvDjgQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j91if/fx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j91if/fx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DB71F000E9;
	Thu, 28 May 2026 20:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999018;
	bh=YIvZ9I4M9INXjilgvCPlv2MQC8cxB2+Yh1IwkZffQfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j91if/fxcG+Hog3791syy5VVLRmZngwfA+416oKuVuvMMt5e8KQZsV6DyBKzPcajP
	 Tb8zWA3s6M/nQC4KifRkmUUYxOxYLDbONcURm3415Utj4qfyoMeUvDHFYOPNF3IMfL
	 D9UjYiAxXmgsB+GNPVjm3l72/3KWt6ucaCQu5N8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arkadiusz Kubalewski <Arkadiusz.kubalewski@intel.com>,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 379/461] ice: ptp: use primary NAC semaphore on E825
Date: Thu, 28 May 2026 21:48:28 +0200
Message-ID: <20260528194658.424038679@linuxfoundation.org>
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

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit 7b28523546c7e4adbb8436f2986efcfc8382985e ]

For E825 2xNAC configurations, PTP semaphore operations must hit the
primary NAC register block so both sides coordinate on the same lock.

Commit e2193f9f9ec9 ("ice: enable timesync operation on 2xNAC E825
devices") updated other primary-only PTP register accesses to
use the primary NAC on non-primary functions, but left ice_ptp_lock()
and ice_ptp_unlock() operating on the local NAC. As a result, secondary
NAC PTP paths can take a different semaphore than the primary side.

Select the primary hardware in ice_ptp_lock() and ice_ptp_unlock() when
the current function is not primary, keeping semaphore operations
symmetric and consistent with the rest of the 2xNAC PTP register access
path.

Fixes: e2193f9f9ec9 ("ice: enable timesync operation on 2xNAC E825 devices")
Reviewed-by: Arkadiusz Kubalewski <Arkadiusz.kubalewski@intel.com>
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Alexander Nowlin <alexander.nowlin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260515182419.1597859-6-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 8bb94e785f2a8..2c18e16fe053e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -5264,9 +5264,13 @@ static void ice_ptp_init_phy_e830(struct ice_ptp_hw *ptp)
  */
 bool ice_ptp_lock(struct ice_hw *hw)
 {
+	struct ice_pf *pf = container_of(hw, struct ice_pf, hw);
 	u32 hw_lock;
 	int i;
 
+	if (!ice_is_primary(hw))
+		hw = ice_get_primary_hw(pf);
+
 #define MAX_TRIES 15
 
 	for (i = 0; i < MAX_TRIES; i++) {
@@ -5293,6 +5297,11 @@ bool ice_ptp_lock(struct ice_hw *hw)
  */
 void ice_ptp_unlock(struct ice_hw *hw)
 {
+	struct ice_pf *pf = container_of(hw, struct ice_pf, hw);
+
+	if (!ice_is_primary(hw))
+		hw = ice_get_primary_hw(pf);
+
 	wr32(hw, PFTSYN_SEM + (PFTSYN_SEM_BYTES * hw->pf_id), 0);
 }
 
-- 
2.53.0



