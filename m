Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821923A4526;
	Wed, 20 May 2026 17:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297039; cv=none; b=IdMsdT9BjbnbGMvSsg5ZyQdrQ17tsyEuKDmkWnrmktC9MaosW7GoVRSLdQUsSzrqSQ76I5OOcRRVP4Sh5pMtyymdaHR467G886Ti5Kpu/rtwCnisQu2vEDRvNQD9PvDUxmgKAy+Nb6QIeO7neuyM6AsUZX9iKckM27w6rrpWbKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297039; c=relaxed/simple;
	bh=pRMo647xnhVF4xcTloFUZuk61ATQ413WJbetDJHCFxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKaXNalZO7lrr1GYVL9X2qvfBDObV4A3du9O6MsjisYvjHDhOsThd8gnx3D247SgeMMYivsBy+yPVGikyPeOK6hzAo53t6CT56U59GLbOkS8G8QqAX/R9qMtWrJc5CAIFfBpfq0INwWzyzqjAuRuS1qJr4ysz4MHSmAB72hld/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDqY9GtP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDqY9GtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3A71F000E9;
	Wed, 20 May 2026 17:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297038;
	bh=ha5tRcaKHahVjTi6HJUmA3vDTPrHjrpYDNblmyXoL5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pDqY9GtPm3oZFAKPYlbuNonIkHxtJMHPzco3KXJrlUTcalHXkJEe+VcF/DCZn08Y2
	 Ul9fcJHhPoUqGZrHwunUAKxIZ0BzknXZ3WFRoCHPADW8yfS3K/sh8cfZqi2quxj9yV
	 WpkTKXzhQlTUmAsxCDXkptPnCG0MEpFQbBoH60SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1027/1146] ice: fix SMA and U.FL pin state changes affecting paired pin
Date: Wed, 20 May 2026 18:21:17 +0200
Message-ID: <20260520162211.472329091@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Petr Oros <poros@redhat.com>

[ Upstream commit 6f9d8393c9f50fbc68b9c9e99f78ca5a7b43ff44 ]

SMA and U.FL pins share physical signal paths in pairs (SMA1/U.FL1 and
SMA2/U.FL2) controlled by the PCA9575 GPIO expander.  Each pair can
only have one active pin at a time: SMA1 output and U.FL1 output share
the same CGU output, SMA2 input and U.FL2 input share the same CGU
input.  The PCA9575 register bits determine which connector in each
pair owns the signal path.

The driver does not account for this pairing in two places:

ice_dpll_ufl_pin_state_set() modifies PCA9575 bits and disables the
backing CGU pin without checking whether the U.FL pin is currently
active.  Disconnecting an already inactive U.FL pin flips bits that
the paired SMA pin relies on, breaking its connection.

ice_dpll_sma_direction_set() does not propagate direction changes to
the paired U.FL pin.  For SMA2/U.FL2 the ICE_SMA2_UFL2_RX_DIS bit is
never managed, so U.FL2 stays disconnected after SMA2 switches to
output.  For both pairs the backing CGU pin of the U.FL side is never
enabled when a direction change activates it, so userspace sees the
pin as disconnected even though the routing is correct.

Fix by guarding the U.FL disconnect path against inactive pins and by
updating the paired U.FL pin fully on SMA direction changes: manage
ICE_SMA2_UFL2_RX_DIS for the SMA2/U.FL2 pair and enable the backing
CGU pin whenever the peer becomes active.

Fixes: 2dd5d03c77e2 ("ice: redesign dpll sma/u.fl pins control")
Signed-off-by: Petr Oros <poros@redhat.com>
Tested-by: Alexander Nowlin <alexander.nowlin@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260427-jk-iwl-net-petr-oros-fixes-v1-8-cdcb48303fd8@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 50 ++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index 498ec2c045f38..3f8cd5b8298b5 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -1171,6 +1171,8 @@ static int ice_dpll_sma_direction_set(struct ice_dpll_pin *p,
 				      enum dpll_pin_direction direction,
 				      struct netlink_ext_ack *extack)
 {
+	struct ice_dplls *d = &p->pf->dplls;
+	struct ice_dpll_pin *peer;
 	u8 data;
 	int ret;
 
@@ -1189,8 +1191,9 @@ static int ice_dpll_sma_direction_set(struct ice_dpll_pin *p,
 	case ICE_DPLL_PIN_SW_2_IDX:
 		if (direction == DPLL_PIN_DIRECTION_INPUT) {
 			data &= ~ICE_SMA2_DIR_EN;
+			data |= ICE_SMA2_UFL2_RX_DIS;
 		} else {
-			data &= ~ICE_SMA2_TX_EN;
+			data &= ~(ICE_SMA2_TX_EN | ICE_SMA2_UFL2_RX_DIS);
 			data |= ICE_SMA2_DIR_EN;
 		}
 		break;
@@ -1202,6 +1205,34 @@ static int ice_dpll_sma_direction_set(struct ice_dpll_pin *p,
 		ret = ice_dpll_pin_state_update(p->pf, p,
 						ICE_DPLL_PIN_TYPE_SOFTWARE,
 						extack);
+	if (ret)
+		return ret;
+
+	/* When a direction change activates the paired U.FL pin, enable
+	 * its backing CGU pin so the pin reports as connected. Without
+	 * this the U.FL routing is correct but the CGU pin stays disabled
+	 * and userspace sees the pin as disconnected.  Do not disable the
+	 * backing pin when U.FL becomes inactive because the SMA pin may
+	 * still be using it.
+	 */
+	peer = &d->ufl[p->idx];
+	if (peer->active) {
+		struct ice_dpll_pin *target;
+		enum ice_dpll_pin_type type;
+
+		if (peer->output) {
+			target = peer->output;
+			type = ICE_DPLL_PIN_TYPE_OUTPUT;
+		} else {
+			target = peer->input;
+			type = ICE_DPLL_PIN_TYPE_INPUT;
+		}
+		ret = ice_dpll_pin_enable(&p->pf->hw, target,
+					  d->eec.dpll_idx, type, extack);
+		if (!ret)
+			ret = ice_dpll_pin_state_update(p->pf, target,
+							type, extack);
+	}
 
 	return ret;
 }
@@ -1253,6 +1284,14 @@ ice_dpll_ufl_pin_state_set(const struct dpll_pin *pin, void *pin_priv,
 			data &= ~ICE_SMA1_MASK;
 			enable = true;
 		} else if (state == DPLL_PIN_STATE_DISCONNECTED) {
+			/* Skip if U.FL1 is not active, setting TX_EN
+			 * while DIR_EN is set would also deactivate
+			 * the paired SMA1 output.
+			 */
+			if (data & (ICE_SMA1_DIR_EN | ICE_SMA1_TX_EN)) {
+				ret = 0;
+				goto unlock;
+			}
 			data |= ICE_SMA1_TX_EN;
 			enable = false;
 		} else {
@@ -1267,6 +1306,15 @@ ice_dpll_ufl_pin_state_set(const struct dpll_pin *pin, void *pin_priv,
 			data &= ~ICE_SMA2_UFL2_RX_DIS;
 			enable = true;
 		} else if (state == DPLL_PIN_STATE_DISCONNECTED) {
+			/* Skip if U.FL2 is not active, setting
+			 * UFL2_RX_DIS could also disable the paired
+			 * SMA2 input.
+			 */
+			if (!(data & ICE_SMA2_DIR_EN) ||
+			    (data & ICE_SMA2_UFL2_RX_DIS)) {
+				ret = 0;
+				goto unlock;
+			}
 			data |= ICE_SMA2_UFL2_RX_DIS;
 			enable = false;
 		} else {
-- 
2.53.0



