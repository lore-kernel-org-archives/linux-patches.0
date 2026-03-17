Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809813F54BD;
	Tue, 17 Mar 2026 16:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766625; cv=none; b=APdbB3eDjltkI0Zy384Nycbe3BGeF6MiJH7FmnZueL6gK/OjdtMv50wiSEFQtRj83WCtkLemgm864tTgT8YJsGvzwtHYvt4IFtkk/oReS50q1akEjlCuVAWPIwi3HT4KEjtvUiZRmbSfmaNb6ummzEtXfL6rMeuKbFCTjbpyvDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766625; c=relaxed/simple;
	bh=3Sv6leqd5b4ZhPgmDwj5jv0mNbh6lsgWOqvRhy4B+eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzcoh174pszRJ4W0LxsgZ98B6NXvhfPPqi8PtJa4Gr62sRisuewsXv7fR4Wc4Muctb/wouIpWn18rA8n3oCulRKtB0VE0TmYAyK5h7cO3e16cpkP8C0u8W0Mv4Vn3hcSifsepobjHNujPlxpzqgpRGVd2UuJXvU1KFLl2ILxCLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCF7kVhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCF7kVhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DB0C2BC86;
	Tue, 17 Mar 2026 16:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766625;
	bh=3Sv6leqd5b4ZhPgmDwj5jv0mNbh6lsgWOqvRhy4B+eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCF7kVhlWSF0Xuofo0p8G10vmpl9m3a+zpxqgsH8znPeKfIpqZG3qbtmhOl5MDwb7
	 Kjmusd2XTz7DbTu1CDq3xvGlY7kHJetM7pmoLyNbCj5upUvWHH8P/ev0zOaaU2rqx6
	 gPREjh4x6irP+OpLT/Gl0vom0+Dg0giMBEj2+jMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaoyi Chen <chaoyi.chen@rock-chips.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.19 269/378] pmdomain: rockchip: Fix PD_VCODEC for RK3588
Date: Tue, 17 Mar 2026 17:33:46 +0100
Message-ID: <20260317163016.908028714@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

commit 0fb59eaca18f1254ecdce34354eec3cb1b3b5e10 upstream.

>From the RK3588 TRM Table 7-1 RK3588 Voltage Domain and Power Domain Summary,
PD_RKVDEC0/1 and PD_VENC0/1 rely on VD_VCODEC which require extra voltages to
be applied, otherwise it breaks RK3588-evb1-v10 board after vdec support landed[1].
The panic looks like below:

  rockchip-pm-domain fd8d8000.power-management:power-controller: failed to set domain 'rkvdec0' on, val=0
  rockchip-pm-domain fd8d8000.power-management:power-controller: failed to set domain 'rkvdec1' on, val=0
  ...
  Hardware name: Rockchip RK3588S EVB1 V10 Board (DT)
  Workqueue: pm genpd_power_off_work_fn
  Call trace:
  show_stack+0x18/0x24 (C)
  dump_stack_lvl+0x40/0x84
  dump_stack+0x18/0x24
  vpanic+0x1ec/0x4fc
  vpanic+0x0/0x4fc
  check_panic_on_warn+0x0/0x94
  arm64_serror_panic+0x6c/0x78
  do_serror+0xc4/0xcc
  el1h_64_error_handler+0x3c/0x5c
  el1h_64_error+0x6c/0x70
  regmap_mmio_read32le+0x18/0x24 (P)
  regmap_bus_reg_read+0xfc/0x130
  regmap_read+0x188/0x1ac
  regmap_read+0x54/0x78
  rockchip_pd_power+0xcc/0x5f0
  rockchip_pd_power_off+0x1c/0x4c
  genpd_power_off+0x84/0x120
  genpd_power_off+0x1b4/0x260
  genpd_power_off_work_fn+0x38/0x58
  process_scheduled_works+0x194/0x2c4
  worker_thread+0x2ac/0x3d8
  kthread+0x104/0x124
  ret_from_fork+0x10/0x20
  SMP: stopping secondary CPUs
  Kernel Offset: disabled
  CPU features: 0x3000000,000e0005,40230521,0400720b
  Memory Limit: none
  ---[ end Kernel panic - not syncing: Asynchronous SError Interrupt ]---

Chaoyi pointed out the PD_VCODEC is the parent of PD_RKVDEC0/1 and PD_VENC0/1, so checking
the PD_VCODEC is enough.

[1] https://lore.kernel.org/linux-rockchip/20251020212009.8852-2-detlev.casanova@collabora.com/

Fixes: db6df2e3fc16 ("pmdomain: rockchip: add regulator support")
Cc: stable@vger.kernel.org
Suggested-by: Chaoyi Chen <chaoyi.chen@rock-chips.com>
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Chaoyi Chen <chaoyi.chen@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/rockchip/pm-domains.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/rockchip/pm-domains.c
+++ b/drivers/pmdomain/rockchip/pm-domains.c
@@ -1311,7 +1311,7 @@ static const struct rockchip_domain_info
 static const struct rockchip_domain_info rk3588_pm_domains[] = {
 	[RK3588_PD_GPU]		= DOMAIN_RK3588("gpu",     0x0, BIT(0),  0,       0x0, 0,       BIT(1),  0x0, BIT(0),  BIT(0),  false, true),
 	[RK3588_PD_NPU]		= DOMAIN_RK3588("npu",     0x0, BIT(1),  BIT(1),  0x0, 0,       0,       0x0, 0,       0,       false, true),
-	[RK3588_PD_VCODEC]	= DOMAIN_RK3588("vcodec",  0x0, BIT(2),  BIT(2),  0x0, 0,       0,       0x0, 0,       0,       false, false),
+	[RK3588_PD_VCODEC]	= DOMAIN_RK3588("vcodec",  0x0, BIT(2),  BIT(2),  0x0, 0,       0,       0x0, 0,       0,       false, true),
 	[RK3588_PD_NPUTOP]	= DOMAIN_RK3588("nputop",  0x0, BIT(3),  0,       0x0, BIT(11), BIT(2),  0x0, BIT(1),  BIT(1),  false, false),
 	[RK3588_PD_NPU1]	= DOMAIN_RK3588("npu1",    0x0, BIT(4),  0,       0x0, BIT(12), BIT(3),  0x0, BIT(2),  BIT(2),  false, false),
 	[RK3588_PD_NPU2]	= DOMAIN_RK3588("npu2",    0x0, BIT(5),  0,       0x0, BIT(13), BIT(4),  0x0, BIT(3),  BIT(3),  false, false),


