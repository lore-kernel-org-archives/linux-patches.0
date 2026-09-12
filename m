Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC17391E72;
	Sat, 12 Sep 2026 19:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243125; cv=none; b=pjx2EMf2na/mW2snWoUjNu1aDKTdFgGkjnjvjRu7KYrHt1uL3t8+FpttDfuaOkvZNc/Ml6LilaikybCMOYHvu2KEtTgBN6s2OxSZQD/lU31+Lwql9lGSi/ehemuD8vnlrmVvfMmogMhHdfF1JM7st8rCPlvZhg7/ETpHlA8gY1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243125; c=relaxed/simple;
	bh=q1L64ael0V+5NG4brB2a9/ShDAXi3F6MOpPPAZtyK0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=No1g0Q12Gk+uraFJPrg99MKCFR+iHzGHMrFy+L+1irqIYs7DnjsyjRYDaR+Owyy5rVRE14gvKeTmHVs1+Vb1I4GXJlpea9akIFSjCP5vgCwICi74VNQc2zTEUEZbYSA25mxj4LAImB0mXytdYw6bppATUQttIffL/4oIvwSUydE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKtB/mHq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKtB/mHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EE91F000FF;
	Sat, 12 Sep 2026 19:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243123;
	bh=bcoGruZt8wRsFlmUgjdDJ+6xf6PCbPFq+dVTpHkmjCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKtB/mHqiRbFqDQEueCDpayKY5mJFXRS/mcDx47gRrytbPAYgGBIAihkheusQ9Kd5
	 1LRPet04wrr5OdwcHjjeJaJEITLpA9YvRH3V5+3TSPbJdHvq0B+cFnhB7lOCAqjiIj
	 riEUdOPyJGaymdcUujipFphl6Y7jLRQrER4cht7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Glass <sjg@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 643/798] pinctrl: rockchip: Reset the pin count when recalculating SoC data
Date: Sat, 12 Sep 2026 09:04:31 +0200
Message-ID: <20260912065531.853929022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Glass <sjg@chromium.org>

[ Upstream commit 5b695c191cc85f0fd62eec885b55d01468dc9f2c ]

rockchip_pinctrl_get_soc_data() mutates the static per-SoC data. The
iomux and drive offsets are recalculated idempotently, since a rerun
anchors at the values calculated before, but the total pin count only
accumulates: each run adds every bank's pins again. When the probe is
deferred and runs a second time, nr_pins doubles and every bank's
pin_base shifts, so later pin lookups resolve to the wrong bank and
the wrong registers.

Reset the pin count at the start of the calculation, so that a rerun
produces the same values.

This is verified on a Luckfox Pico Mini B (RV1103, with the pending
RV1106 series applied) by forcing the probe to defer once: without
this patch the second probe calculates nr_pins=304 instead of 152 and
no GPIO bank comes up; with it the recalculation matches the first
run and all banks work.

Fixes: d3e5116119bd ("pinctrl: add pinctrl driver for Rockchip SoCs")
Link: https://sashiko.dev/#/patchset/20260729132736.3807082-1-sjg@chromium.org?part=4
Assisted-by: Claude:claude-opus-5
Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index b85c1ce210f6e..50c051abcacaa 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -3193,6 +3193,16 @@ static struct rockchip_pin_ctrl *rockchip_pinctrl_get_soc_data(
 	pmu_offs = ctrl->pmu_mux_offset;
 	drv_pmu_offs = ctrl->pmu_drv_offset;
 	drv_grf_offs = ctrl->grf_drv_offset;
+
+	/*
+	 * This function mutates the static per-SoC data. Most of it is
+	 * idempotent: recalculated iomux and drv offsets anchor at the
+	 * values calculated by a previous run. The pin count is not, so
+	 * reset it here; otherwise it accumulates when the probe runs
+	 * again after a probe deferral, shifting every bank's pin_base.
+	 */
+	ctrl->nr_pins = 0;
+
 	bank = ctrl->pin_banks;
 	for (i = 0; i < ctrl->nr_banks; ++i, ++bank) {
 		int bank_pins = 0;
-- 
2.53.0



