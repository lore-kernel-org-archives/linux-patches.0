Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753DC24677F;
	Thu, 28 May 2026 20:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998586; cv=none; b=A1L2Z+C4epXxaK6D67Tymu65sPwRkiL8trHlhAApf/igQL92uNnisR4KzI8S0cEP2Ge4Ko7WdnOt0BIFBkYCLFkOhgnYHiaM9P7htIc+iiY4Ghv/vs8apPWpMshJH/14myOK4m7esgpHfVlGLgoNkwkUhhJdtyslAXbc+0W9KFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998586; c=relaxed/simple;
	bh=qzQZp453gF9gDScvT0x9boet7ibOEKpkEX2CH5uLHIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfpjoQ0+Ba39pg81NgWV9ziF0TKuRrNSq/5QRkdpOq3ZSL7ME5g3iWTJ8V65x21EE5gsktiO0dhHP+hpf/OC0W+m40Xf5LMgzNn8TsS4qDIHW7Ui160WRWIDz6dHJWGHHiQvaPGc3/1vdypUJuSK+vGX0XRF1gtRu+YWhwBLh5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvuVOmfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvuVOmfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B6D1F000E9;
	Thu, 28 May 2026 20:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998585;
	bh=qwuhrKY4SDp9FUlu0xnbuzonpL4g7/iI8vN7hMDrQ3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nvuVOmfow0dTmEQdY7mLoaSr25G9Xm7D7Z7RiLI1I2ShX+YD0BU61HU1WOfjBVpSI
	 WsMtMiC4VgxgwvGX0NxeEZCI128zqFbZlb0X1qO8HdKiZRhTE8Y3fHCHYgN4Ej23tt
	 u1RSmvtCG899ur0yxL95quCXz+XUCBSPiXyEHuLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 225/461] ice: dpll: fix rclk pin state get for E810
Date: Thu, 28 May 2026 21:45:54 +0200
Message-ID: <20260528194653.645240128@linuxfoundation.org>
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit cce709d8df6ba6d2a0a0dbf34acc2cdd9e23bd46 ]

The refactoring of ice_dpll_rclk_state_on_pin_get() to use
ice_dpll_pin_get_parent_idx() omitted the base_rclk_idx adjustment that was
correctly added in the ice_dpll_rclk_state_on_pin_set() path. This breaks
E810 devices where base_rclk_idx is non-zero, causing the wrong hardware
index to be used for pin state lookup and incorrect recovered clock state
to be reported via the DPLL subsystem. E825C is unaffected as its
base_rclk_idx is 0.

While at it, add bounds check against ICE_DPLL_RCLK_NUM_MAX on hw_idx after
the base_rclk_idx subtraction in both ice_dpll_rclk_state_on_pin_{get,set}()
to prevent out-of-bounds access on the pin state array.

Fixes: ad1df4f2d591 ("ice: dpll: Support E825-C SyncE and dynamic pin discovery")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260506-jk-iwl-net-2026-05-04-v2-7-a5ea4dc837a9@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index 27b460926bace..892bc7c2e28b4 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -2523,6 +2523,8 @@ ice_dpll_rclk_state_on_pin_set(const struct dpll_pin *pin, void *pin_priv,
 	if (hw_idx < 0)
 		goto unlock;
 	hw_idx -= pf->dplls.base_rclk_idx;
+	if (hw_idx >= ICE_DPLL_RCLK_NUM_MAX)
+		goto unlock;
 
 	if ((enable && p->state[hw_idx] == DPLL_PIN_STATE_CONNECTED) ||
 	    (!enable && p->state[hw_idx] == DPLL_PIN_STATE_DISCONNECTED)) {
@@ -2586,6 +2588,9 @@ ice_dpll_rclk_state_on_pin_get(const struct dpll_pin *pin, void *pin_priv,
 	hw_idx = ice_dpll_pin_get_parent_idx(p, parent_pin);
 	if (hw_idx < 0)
 		goto unlock;
+	hw_idx -= pf->dplls.base_rclk_idx;
+	if (hw_idx >= ICE_DPLL_RCLK_NUM_MAX)
+		goto unlock;
 
 	ret = ice_dpll_pin_state_update(pf, p, ICE_DPLL_PIN_TYPE_RCLK_INPUT,
 					extack);
-- 
2.53.0



