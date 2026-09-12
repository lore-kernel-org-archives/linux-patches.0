Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B453E4369A;
	Sat, 12 Sep 2026 19:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239787; cv=none; b=bGAZuDbc/3h7L1T53tYglyjL4YsovEMfpNuXq7rd/DAWbLtt7t9VSPqmZ5kET03ObDHsLrrR+YKpnAS51iaWRgKfSbGz9lgmmMQ+bYF6pfX1eKv6k8UnBbSCDnoXXLHIpU2bTD0Uke8kAp7sm5yTTmFQj0dzOhB2wpzYiosakKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239787; c=relaxed/simple;
	bh=Xa5Mj2fXHOt7x/uvCPILUAgwnr60W1+ai2AhsqV586E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isN0buwbTw/SyjcoabHhZdvqFX2P/05gn2XlEUqxE+6LljIOPhYVgfhcM33cabDp3aq0oKsq7cLyFBWDo/ZdopBFlOQH76eANgC5cv7wi54+C57qmuQppnH3fmPNdsIbp3UskEfLFSeyfCZETIx8RPplNiar8fzMWP3hMeJn90s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/D7zqBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/D7zqBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A301F000FF;
	Sat, 12 Sep 2026 19:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239786;
	bh=XtCqC7xtGzQSnY/VeqtYELJg+B8/ntuDGz7Gsa/dn9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/D7zqBUZgBFnKKbENXnDM5Rp4ZjHYN94r0emsW+cumnd5dgUg8L4+fc3wTZVjs8j
	 gj80LHV6JQDb5To4m9q6MHJAROIHImGkUG01090ATHZL3E/ITXts4Em1iAgqUBM/p8
	 ZaH9B1d0vtekhkh0ViiwW8CB56Q6G/JLzhpJnNAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Glass <sjg@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 736/935] pinctrl: rockchip: Reset the pin count when recalculating SoC data
Date: Sat, 12 Sep 2026 09:02:46 +0200
Message-ID: <20260912065543.712724288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f473585d93d28..7e9639db930ee 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2693,6 +2693,16 @@ static struct rockchip_pin_ctrl *rockchip_pinctrl_get_soc_data(
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



