Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C508C46C4D3;
	Tue, 21 Jul 2026 17:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655204; cv=none; b=FG6dRnspOozlEZh9bEn8ua2oNNsiblmJPuY+Qjuxw09Ay+k/yxrcMJ+29gunPc9XaNJhaZOl5rKQ3HW+WAqt9F0jp/17jvaShkRfSkqcFH2hEkG6D65hgQlP5SMmeToXcY3buyKvNplHNnIAGaPcXE5TtMHlHzJI7cf623HOlME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655204; c=relaxed/simple;
	bh=32Z8j6kLtKaduOLk61LlTosDr5iCDAAKy85xW+nkKgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmakKceDpD20YeNdo9MLk0+BS7CF5l8huAzwFe7sP+IflshxgNuXdaAzV9bJct6w7Oh+mQJ+FEQW1Za42HRRBNSwUHqB8SHBf+bqWcb5kl3aVgaSmWRTXKqlcMWI/LVMx4cF7MBeZRJrm2fQmiI2GALaw19HThDpKTQG/hpTTr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdXyprQJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdXyprQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3041B1F00A3A;
	Tue, 21 Jul 2026 17:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655203;
	bh=AOmHmufiHhLnrwKEWH56YXX4R8QfbGzhScXgBKmMqm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VdXyprQJoGyxuvo+QOd6mNVJIE0ZWCeHs+a8TDYvpm3h11idd5a1qPBN4G7/KHYG+
	 k1roIZK8ORqVi+r8+pE7ZXIZGfgIHZtut8HwvD4oaUP9GXDGyTfy0CQKU2bsX2M6ma
	 c0yhDA5Vi2g5Nzf9UC/5gHkcC7RZ7vnlwHjLHg6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 1996/2077] pmdomain: imx: Fix i.MX8MP power notifier
Date: Tue, 21 Jul 2026 17:27:49 +0200
Message-ID: <20260721152639.788923869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

commit 72422525f641f68bed6ca3389d29ee3f41fdea33 upstream.

Using imx8mm_vpu_power_notifier() for i.MX8MP is wrong, as it ungates
the VPU clocks to provide the ADB clock, which is necessary on i.MX8MM,
but on i.MX8MP there is a separate gate (bit 3) for the NoC. So add
imx8mp_vpu_power_notifier() for i.MX8MP.

Fixes: a1a5f15f7f6cb ("soc: imx: imx8m-blk-ctrl: add i.MX8MP VPU blk ctrl")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx8m-blk-ctrl.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/pmdomain/imx/imx8m-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx8m-blk-ctrl.c
@@ -514,9 +514,34 @@ static const struct imx8m_blk_ctrl_domai
 	},
 };
 
+static int imx8mp_vpu_power_notifier(struct notifier_block *nb,
+				     unsigned long action, void *data)
+{
+	struct imx8m_blk_ctrl *bc = container_of(nb, struct imx8m_blk_ctrl,
+						 power_nb);
+
+	if (action == GENPD_NOTIFY_ON) {
+		/*
+		 * On power up we have no software backchannel to the GPC to
+		 * wait for the ADB handshake to happen, so we just delay for a
+		 * bit. On power down the GPC driver waits for the handshake.
+		 */
+
+		udelay(5);
+
+		/* set "fuse" bits to enable the VPUs */
+		regmap_set_bits(bc->regmap, 0x8, 0xffffffff);
+		regmap_set_bits(bc->regmap, 0xc, 0xffffffff);
+		regmap_set_bits(bc->regmap, 0x10, 0xffffffff);
+		regmap_set_bits(bc->regmap, 0x14, 0xffffffff);
+	}
+
+	return NOTIFY_OK;
+}
+
 static const struct imx8m_blk_ctrl_data imx8mp_vpu_blk_ctl_dev_data = {
 	.max_reg = 0x18,
-	.power_notifier_fn = imx8mm_vpu_power_notifier,
+	.power_notifier_fn = imx8mp_vpu_power_notifier,
 	.domains = imx8mp_vpu_blk_ctl_domain_data,
 	.num_domains = ARRAY_SIZE(imx8mp_vpu_blk_ctl_domain_data),
 };


