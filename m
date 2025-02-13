Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E06926B0B4;
	Thu, 13 Feb 2025 15:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460445; cv=none; b=BHrgLtEh48vqajbf9J1/gaK/KTXVjCqw7Aw0vRK7UrlLiBCEA7Dmo1x4SjBweYoxji34WIh+mj6IJ3jTO1icdu0/lCrJr5PCZPZXJ6ryHqjHPiPBgXeN9t75BP8F9JrD/ODOCrB8sF6EDHNia6T8u+Q2K94OCSLBw7S5L30QZoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460445; c=relaxed/simple;
	bh=vnQICQvIKrqbyVo29+V5cCwkUkoh8spZM52nxOAM8cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkNBSw2xV2UjOIsUywSfzF0A9Oii4+XPrnCluTrjapHP+Ck42Mu5XDgEXaWpg/0ghS/aFfGzH+7LIjpzxE44VYshqWfy07kT9vfO+smDsh7YBfrvl1c/rV2vlKnDH8+9dmJAuoo3mx0yxMUT+cadAOeHWSgs2BwTwbNlepSU7YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zu3iY3ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zu3iY3ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81316C4CEE4;
	Thu, 13 Feb 2025 15:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460445;
	bh=vnQICQvIKrqbyVo29+V5cCwkUkoh8spZM52nxOAM8cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zu3iY3wsh7fx4G89DY63uLlESwRLAfzPDGM6vmeY/a8kphExkgB321Xb6ijxDtJ9z
	 X3XaZqlonqvoYIiv+num+sfHwg15dSmm+u2zJIbR+QC0helTWUY1/uGG6NU7OXz7JQ
	 W5HqSX5joRKNDc/9Yu+LCdPk59xVINXTRa3Kaysw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.6 115/273] clk: mediatek: mt2701-aud: fix conversion to mtk_clk_simple_probe
Date: Thu, 13 Feb 2025 15:28:07 +0100
Message-ID: <20250213142411.888552971@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

commit 5fba40be5fbad563914e3ce9d5129a6baaea1ff5 upstream.

Some of the audio subsystem clocks defined in clk-mt2701.h aren't
actually used by the driver. This broke conversion to
mtk_clk_simple_probe which expects that the highest possible clk id is
defined by the ARRAY_SIZE.

Add additional dummy clocks to fill the gaps and remain compatible with
the existing DT bindings.

Fixes: 0f69a423c458 ("clk: mediatek: Switch to mtk_clk_simple_probe() where possible")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/a07584d803af57b9ce4b5df5e122c09bf5a56ac9.1734300668.git.daniel@makrotopia.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/mediatek/clk-mt2701-aud.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/clk/mediatek/clk-mt2701-aud.c
+++ b/drivers/clk/mediatek/clk-mt2701-aud.c
@@ -55,10 +55,16 @@ static const struct mtk_gate audio_clks[
 	GATE_DUMMY(CLK_DUMMY, "aud_dummy"),
 	/* AUDIO0 */
 	GATE_AUDIO0(CLK_AUD_AFE, "audio_afe", "aud_intbus_sel", 2),
+	GATE_DUMMY(CLK_AUD_LRCK_DETECT, "audio_lrck_detect_dummy"),
+	GATE_DUMMY(CLK_AUD_I2S, "audio_i2c_dummy"),
+	GATE_DUMMY(CLK_AUD_APLL_TUNER, "audio_apll_tuner_dummy"),
 	GATE_AUDIO0(CLK_AUD_HDMI, "audio_hdmi", "audpll_sel", 20),
 	GATE_AUDIO0(CLK_AUD_SPDF, "audio_spdf", "audpll_sel", 21),
 	GATE_AUDIO0(CLK_AUD_SPDF2, "audio_spdf2", "audpll_sel", 22),
 	GATE_AUDIO0(CLK_AUD_APLL, "audio_apll", "audpll_sel", 23),
+	GATE_DUMMY(CLK_AUD_TML, "audio_tml_dummy"),
+	GATE_DUMMY(CLK_AUD_AHB_IDLE_EXT, "audio_ahb_idle_ext_dummy"),
+	GATE_DUMMY(CLK_AUD_AHB_IDLE_INT, "audio_ahb_idle_int_dummy"),
 	/* AUDIO1 */
 	GATE_AUDIO1(CLK_AUD_I2SIN1, "audio_i2sin1", "aud_mux1_sel", 0),
 	GATE_AUDIO1(CLK_AUD_I2SIN2, "audio_i2sin2", "aud_mux1_sel", 1),
@@ -76,10 +82,12 @@ static const struct mtk_gate audio_clks[
 	GATE_AUDIO1(CLK_AUD_ASRCI2, "audio_asrci2", "asm_h_sel", 13),
 	GATE_AUDIO1(CLK_AUD_ASRCO1, "audio_asrco1", "asm_h_sel", 14),
 	GATE_AUDIO1(CLK_AUD_ASRCO2, "audio_asrco2", "asm_h_sel", 15),
+	GATE_DUMMY(CLK_AUD_HDMIRX, "audio_hdmirx_dummy"),
 	GATE_AUDIO1(CLK_AUD_INTDIR, "audio_intdir", "intdir_sel", 20),
 	GATE_AUDIO1(CLK_AUD_A1SYS, "audio_a1sys", "aud_mux1_sel", 21),
 	GATE_AUDIO1(CLK_AUD_A2SYS, "audio_a2sys", "aud_mux2_sel", 22),
 	GATE_AUDIO1(CLK_AUD_AFE_CONN, "audio_afe_conn", "aud_mux1_sel", 23),
+	GATE_DUMMY(CLK_AUD_AFE_PCMIF, "audio_afe_pcmif_dummy"),
 	GATE_AUDIO1(CLK_AUD_AFE_MRGIF, "audio_afe_mrgif", "aud_mux1_sel", 25),
 	/* AUDIO2 */
 	GATE_AUDIO2(CLK_AUD_MMIF_UL1, "audio_ul1", "aud_mux1_sel", 0),
@@ -100,6 +108,8 @@ static const struct mtk_gate audio_clks[
 	GATE_AUDIO2(CLK_AUD_MMIF_AWB2, "audio_awb2", "aud_mux1_sel", 15),
 	GATE_AUDIO2(CLK_AUD_MMIF_DAI, "audio_dai", "aud_mux1_sel", 16),
 	/* AUDIO3 */
+	GATE_DUMMY(CLK_AUD_DMIC1, "audio_dmic1_dummy"),
+	GATE_DUMMY(CLK_AUD_DMIC2, "audio_dmic2_dummy"),
 	GATE_AUDIO3(CLK_AUD_ASRCI3, "audio_asrci3", "asm_h_sel", 2),
 	GATE_AUDIO3(CLK_AUD_ASRCI4, "audio_asrci4", "asm_h_sel", 3),
 	GATE_AUDIO3(CLK_AUD_ASRCI5, "audio_asrci5", "asm_h_sel", 4),


