Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CB5415F04;
	Tue, 21 Jul 2026 18:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657766; cv=none; b=IrBGlr+/i2sBG/XRPGRfFqxBaRvP8utE+ztAKIAYg9tMTS9Z2gEUGXBjXyHbC4o4vrMudip904bO8NB96sDfYVYw1tcb8B+4YwGNHlyMtwk04Lk+aJVc0VYI99tWS7Xx6fh3VXn4/sk/zOdFV/9P/koVms37EPC5rWIgGeKg6/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657766; c=relaxed/simple;
	bh=WPtIQmMrtW7xTXkJ80J5SDvBzSjISMaVbWc9+t2101Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEysc3RlUZ5yXSD8WD9QRuIemcylftmqPOJOzzzNf0XrZ47E3CU8C4osCpGl4znwK5qJgy1w9OAv6Na0fDU5iyCXlUf0STNKMsGR/yYy2sUR3EU0K2rOjXumtA9/xK/046Ei2QWc1Ix2eX7KAGaMitTbujYoNvUTtz1+5UTRk6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqPEctVb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqPEctVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1811F000E9;
	Tue, 21 Jul 2026 18:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657765;
	bh=UaqL7mFjFEG6ab9+jMQSUU2bTfcOccaifR5DlnADQkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GqPEctVbotQ1fifnMGYEcma+G5PHCXliSMuNE8T93DGS+AWa56AhC96dfGv8SWnM6
	 7thOX4XZiSjGD0bIQok5ia2xesuhshKO8PL8WwJYV3zQgjFxoWQhNveXW0gW7+Hemi
	 GrX02tvSOgW0nfYomBnCJMaixPtrkIXXAFJ+QSag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 0890/1611] ice: dpll: fix memory leak in ice_dpll_init_info error paths
Date: Tue, 21 Jul 2026 17:16:46 +0200
Message-ID: <20260721152535.408682710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: ZhaoJinming <zhaojinming@uniontech.com>

[ Upstream commit 20da495f2df0fd4adc435d3d621366e8c807539c ]

Several error return paths in ice_dpll_init_info() directly return
without freeing previously allocated resources, causing memory leaks:

- When de->input_prio allocation fails, d->inputs is leaked
- When dp->input_prio allocation fails, d->inputs and de->input_prio
  are leaked
- When ice_get_cgu_rclk_pin_info() fails, all previously allocated
  inputs/outputs/input_prio are leaked
- When ice_dpll_init_pins_info(RCLK_INPUT) fails, same resources
  are leaked

Fix this by jumping to the deinit_info label which properly calls
ice_dpll_deinit_info() to free all allocated resources.

Fixes: d7999f5ea64b ("ice: implement dpll interface to control cgu")
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index f3a7129d91d3ea..023d0de12670c4 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -3826,12 +3826,16 @@ static int ice_dpll_init_info(struct ice_pf *pf, bool cgu)
 
 	alloc_size = sizeof(*de->input_prio) * d->num_inputs;
 	de->input_prio = kzalloc(alloc_size, GFP_KERNEL);
-	if (!de->input_prio)
-		return -ENOMEM;
+	if (!de->input_prio) {
+		ret = -ENOMEM;
+		goto deinit_info;
+	}
 
 	dp->input_prio = kzalloc(alloc_size, GFP_KERNEL);
-	if (!dp->input_prio)
-		return -ENOMEM;
+	if (!dp->input_prio) {
+		ret = -ENOMEM;
+		goto deinit_info;
+	}
 
 	ret = ice_dpll_init_pins_info(pf, ICE_DPLL_PIN_TYPE_INPUT);
 	if (ret)
@@ -3856,12 +3860,12 @@ static int ice_dpll_init_info(struct ice_pf *pf, bool cgu)
 	ret = ice_get_cgu_rclk_pin_info(&pf->hw, &d->base_rclk_idx,
 					&pf->dplls.rclk.num_parents);
 	if (ret)
-		return ret;
+		goto deinit_info;
 	for (i = 0; i < pf->dplls.rclk.num_parents; i++)
 		pf->dplls.rclk.parent_idx[i] = d->base_rclk_idx + i;
 	ret = ice_dpll_init_pins_info(pf, ICE_DPLL_PIN_TYPE_RCLK_INPUT);
 	if (ret)
-		return ret;
+		goto deinit_info;
 	de->mode = DPLL_MODE_AUTOMATIC;
 	dp->mode = DPLL_MODE_AUTOMATIC;
 
-- 
2.53.0



