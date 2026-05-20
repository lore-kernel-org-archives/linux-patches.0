Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378DB1684BE;
	Wed, 20 May 2026 17:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299793; cv=none; b=Dzuwaed+Ww1V6TQ13T8f9W8Aawqx66esOVYUUXxrjFK0QcGYMKfsyjEzHkP0cW5KrBP02OOkx4CqEhF4v5OvcD04WWstj+iJAcTiHXlFNQef2VXOQuQedX0VieA8jz57Ok8yzUTSIMc1+6N6zI9Mc8muf35C4/hfl52KWSLChJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299793; c=relaxed/simple;
	bh=Dgo0CewfoW4m0GBksQlajvnXYRHjC4VrGZfRh9fHVVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qhyG4cuMadbyTMHucCtYY3Mgj3XDkE7hebv/KHSObic6zVdORYng52MkzebaNZ9uq1wRN1TzxahncOOBrNEGpY5saPsoN/wAZCJ7yuESLd3HFWHatEdtSn7/cXb9h0pUxP9ff4sHt1HMyd6AtzxIqnUHqTmi1rG/0Q1uuCpHswA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmVsWJ4k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmVsWJ4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B19F1F000E9;
	Wed, 20 May 2026 17:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299791;
	bh=pjfEQRWKu2apwmLPJvgMrAbhLpqtqdwoAlyMiAP9gRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VmVsWJ4k83Hmj75IbOLr0oAQl5t9D4x5MvAERZEYgmc5Y94D6qW28WKZGkD602C7w
	 ugD9O4HLp1Y3ry97T2WeKgmsQNekbUEsn5j7b8l4Cj0QQqIomL9gRkFApFJ+rRZ7FT
	 K3yGFqPsFVgvd/Sii3YP5SLO6W2dTTaiHEfrA+no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 847/957] ice: fix missing SMA pin initialization in DPLL subsystem
Date: Wed, 20 May 2026 18:22:10 +0200
Message-ID: <20260520162152.933577918@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit 56a643aed0f0af5c29ebb4593d4917b78344dd48 ]

The DPLL SMA/U.FL pin redesign introduced ice_dpll_sw_pin_frequency_get()
which gates frequency reporting on the pin's active flag. This flag is
determined by ice_dpll_sw_pins_update() from the PCA9575 GPIO expander
state. Before the redesign, SMA pins were exposed as direct HW
input/output pins and ice_dpll_frequency_get() returned the CGU
frequency unconditionally — the PCA9575 state was never consulted.

The PCA9575 powers on with all outputs high, setting ICE_SMA1_DIR_EN,
ICE_SMA1_TX_EN, ICE_SMA2_DIR_EN and ICE_SMA2_TX_EN. Nothing in the
driver writes the register during initialization, so
ice_dpll_sw_pins_update() sees all pins as inactive and
ice_dpll_sw_pin_frequency_get() permanently returns 0 Hz for every
SW pin.

Fix this by writing a default SMA configuration in
ice_dpll_init_info_sw_pins(): clear all SMA bits, then set SMA1 and
SMA2 as active inputs (DIR_EN=0) with U.FL1 output and U.FL2 input
disabled. Each SMA/U.FL pair shares a physical signal path so only
one pin per pair can be active at a time. U.FL pins still report
frequency 0 after this fix: U.FL1 (output-only) is disabled by
ICE_SMA1_TX_EN which keeps the TX output buffer off, and U.FL2
(input-only) is disabled by ICE_SMA2_UFL2_RX_DIS. They can be
activated by changing the corresponding SMA pin direction via dpll
netlink.

Fixes: 2dd5d03c77e2 ("ice: redesign dpll sma/u.fl pins control")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Alexander Nowlin <alexander.nowlin@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260427-jk-iwl-net-petr-oros-fixes-v1-7-cdcb48303fd8@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index 53b54e395a2ed..c2ad39bfe177d 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -3545,6 +3545,7 @@ static int ice_dpll_init_info_sw_pins(struct ice_pf *pf)
 	struct ice_dpll_pin *pin;
 	u32 phase_adj_max, caps;
 	int i, ret;
+	u8 data;
 
 	if (pf->hw.device_id == ICE_DEV_ID_E810C_QSFP)
 		input_idx_offset = ICE_E810_RCLK_PINS_NUM;
@@ -3604,6 +3605,22 @@ static int ice_dpll_init_info_sw_pins(struct ice_pf *pf)
 		}
 		ice_dpll_phase_range_set(&pin->prop.phase_range, phase_adj_max);
 	}
+
+	/* Initialize the SMA control register to a known-good default state.
+	 * Without this write the PCA9575 GPIO expander retains its power-on
+	 * default (all outputs high) which makes all SW pins appear inactive.
+	 * Set SMA1 and SMA2 as active inputs, disable U.FL1 output and
+	 * U.FL2 input.
+	 */
+	ret = ice_read_sma_ctrl(&pf->hw, &data);
+	if (ret)
+		return ret;
+	data &= ~ICE_ALL_SMA_MASK;
+	data |= ICE_SMA1_TX_EN | ICE_SMA2_TX_EN | ICE_SMA2_UFL2_RX_DIS;
+	ret = ice_write_sma_ctrl(&pf->hw, data);
+	if (ret)
+		return ret;
+
 	ret = ice_dpll_pin_state_update(pf, pin, ICE_DPLL_PIN_TYPE_SOFTWARE,
 					NULL);
 	if (ret)
-- 
2.53.0



