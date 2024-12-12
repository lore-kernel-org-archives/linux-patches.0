Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A618221504F;
	Thu, 12 Dec 2024 15:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016418; cv=none; b=cL8XQ+hVPZtbaxDFrRu6wt8FnS097n1JWePodRN8gkT18wuso5z9t+imFH5gEIUChj1v0M9HADxmcNuH6n6V86JEzhrgFsC8dT7ri/jifXeu3i88oJ3k6/CP5Rde9mRxUkfQOcvLYTvSZQ73WDr+Y0eaIapELba65LjMV+9TzQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016418; c=relaxed/simple;
	bh=+NvXcWMPKlwRl7iH/lRvuPKBRqMFmXb1/QUW2zvu+f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyzll2N8xdubUTWkthHn2TfTUn4bR1eOFKJi8hAvJB2ga3/R8lLCn34NzJflrjZAzQ3vn5Q4m0TS0tdjbBh4WF557hQoJa10QlftIRv+j8Lcz/sHObs9cNjrEWMk6sfjVtBR757mLyCDRMSCj9xj6wS18Xf2BhmjHO2V4w1w4VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wp9429Iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wp9429Iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE56BC4CED0;
	Thu, 12 Dec 2024 15:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016418;
	bh=+NvXcWMPKlwRl7iH/lRvuPKBRqMFmXb1/QUW2zvu+f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wp9429IyZj7aF4j8zDJaaYuh2qyFbJZNwAVipZCF1kQWBtXYJwIFYdek4jCDPw32l
	 BufzuVIYi4JteXK7o2S6svUCTib4uXocxRtJ2RbjJLyOxbh+Kcdn0JRs78MBfuI8dE
	 W+QsfCcfNTu6Fn4i4X13hPbPz8WqHwEAQ5zB2hcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco@dolcini.it>,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 163/466] pmdomain: imx: gpcv2: Adjust delay after power up handshake
Date: Thu, 12 Dec 2024 15:55:32 +0100
Message-ID: <20241212144313.242694728@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit 2379fb937de5333991c567eefd7d11b98977d059 upstream.

The udelay(5) is not enough, sometimes below kernel panic
still be triggered:

[    4.012973] Kernel panic - not syncing: Asynchronous SError Interrupt
[    4.012976] CPU: 2 UID: 0 PID: 186 Comm: (udev-worker) Not tainted 6.12.0-rc2-0.0.0-devel-00004-g8b1b79e88956 #1
[    4.012982] Hardware name: Toradex Verdin iMX8M Plus WB on Dahlia Board (DT)
[    4.012985] Call trace:
[...]
[    4.013029]  arm64_serror_panic+0x64/0x70
[    4.013034]  do_serror+0x3c/0x70
[    4.013039]  el1h_64_error_handler+0x30/0x54
[    4.013046]  el1h_64_error+0x64/0x68
[    4.013050]  clk_imx8mp_audiomix_runtime_resume+0x38/0x48
[    4.013059]  __genpd_runtime_resume+0x30/0x80
[    4.013066]  genpd_runtime_resume+0x114/0x29c
[    4.013073]  __rpm_callback+0x48/0x1e0
[    4.013079]  rpm_callback+0x68/0x80
[    4.013084]  rpm_resume+0x3bc/0x6a0
[    4.013089]  __pm_runtime_resume+0x50/0x9c
[    4.013095]  pm_runtime_get_suppliers+0x60/0x8c
[    4.013101]  __driver_probe_device+0x4c/0x14c
[    4.013108]  driver_probe_device+0x3c/0x120
[    4.013114]  __driver_attach+0xc4/0x200
[    4.013119]  bus_for_each_dev+0x7c/0xe0
[    4.013125]  driver_attach+0x24/0x30
[    4.013130]  bus_add_driver+0x110/0x240
[    4.013135]  driver_register+0x68/0x124
[    4.013142]  __platform_driver_register+0x24/0x30
[    4.013149]  sdma_driver_init+0x20/0x1000 [imx_sdma]
[    4.013163]  do_one_initcall+0x60/0x1e0
[    4.013168]  do_init_module+0x5c/0x21c
[    4.013175]  load_module+0x1a98/0x205c
[    4.013181]  init_module_from_file+0x88/0xd4
[    4.013187]  __arm64_sys_finit_module+0x258/0x350
[    4.013194]  invoke_syscall.constprop.0+0x50/0xe0
[    4.013202]  do_el0_svc+0xa8/0xe0
[    4.013208]  el0_svc+0x3c/0x140
[    4.013215]  el0t_64_sync_handler+0x120/0x12c
[    4.013222]  el0t_64_sync+0x190/0x194
[    4.013228] SMP: stopping secondary CPUs

The correct way is to wait handshake, but it needs BUS clock of
BLK-CTL be enabled, which is in separate driver. So delay is the
only option here. The udelay(10) is a data got by experiment.

Fixes: e8dc41afca16 ("pmdomain: imx: gpcv2: Add delay after power up handshake")
Reported-by: Francesco Dolcini <francesco@dolcini.it>
Closes: https://lore.kernel.org/lkml/20241007132555.GA53279@francesco-nb/
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Cc: stable@vger.kernel.org
Message-ID: <20241121075231.3910922-1-shengjiu.wang@nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/gpcv2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/imx/gpcv2.c
+++ b/drivers/pmdomain/imx/gpcv2.c
@@ -403,7 +403,7 @@ static int imx_pgc_power_up(struct gener
 		 * already reaches target before udelay()
 		 */
 		regmap_read_bypassed(domain->regmap, domain->regs->hsk, &reg_val);
-		udelay(5);
+		udelay(10);
 	}
 
 	/* Disable reset clocks for all devices in the domain */


