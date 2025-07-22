Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D35F7263D;
	Tue, 22 Jul 2025 13:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192752; cv=none; b=JSs3bAUrA2qssN9e5hnaNimECAiw7sZil7dv0qDo6gOhIToK3f7O01SJNOX9eBY20QoQzimhemrwfUyyjhIPKLb+ClAe9e7bLfZuDF69rHVDnZNOwekCuu4922qQiFh3M52ZykZlc6Jb06aucJbMHCJymSooj4mKj4j2CGPQNkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192752; c=relaxed/simple;
	bh=DxonLdkSFce7VPSExcP1S2jkd25lOERu8KIR+pTePDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qU3fmA/LAUqtPbH5ntuxFEHWvZhOC1rHeko+2qoRRnHelHEw3HIP4ovKE7tOsAF7rWVrDgaHVJEOPRlD4yoKJs3iOUWuS4SxQPqTqcPEMnG7c+AqCRTB9WYAAaENhKJaNoPxEWyBz5ZsIOTSXZ7UFv11b9VXttdNGVRmmKJrKRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxW0558h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxW0558h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A123AC4CEEB;
	Tue, 22 Jul 2025 13:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192752;
	bh=DxonLdkSFce7VPSExcP1S2jkd25lOERu8KIR+pTePDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxW0558hhh2tCamsa7MwdIvh+bHUr6j1vzBL6B68Ltmc00QFr4j/ctfbzpSq0BUdJ
	 WmqIByEMceDxV4YRMr78s6dB/womK97rmMPdWjrgTnSDsVRRfrltJpmYRgqPqUcdP+
	 N0Xwr9eLfbIpf0jxvRhbNP6Zc01djej3tyI2YhMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 047/158] arm64: dts: rockchip: use cs-gpios for spi1 on ringneck
Date: Tue, 22 Jul 2025 15:43:51 +0200
Message-ID: <20250722134342.493705750@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>

commit 53b6445ad08f07b6f4a84f1434f543196009ed89 upstream.

Hardware CS has a very slow rise time of about 6us,
causing transmission errors when CS does not reach
high between transaction.

It looks like it's not driven actively when transitioning
from low to high but switched to input, so only the CPU
pull-up pulls it high, slowly. Transitions from high to low
are fast. On the oscilloscope, CS looks like an irregular sawtooth
pattern like this:
                         _____
              ^         /     |
      ^      /|        /      |
     /|     / |       /       |
    / |    /  |      /        |
___/  |___/   |_____/         |___

With cs-gpios we have a CS rise time of about 20ns, as it should be,
and CS looks rectangular.

This fixes the data errors when running a flashcp loop against a
m25p40 spi flash.

With the Rockchip 6.1 kernel we see the same slow rise time, but
for some reason CS is always high for long enough to reach a solid
high.

The RK3399 and RK3588 SoCs use the same SPI driver, so we also
checked our "Puma" (RK3399) and "Tiger" (RK3588) boards.
They do not have this problem. Hardware CS rise time is good.

Fixes: c484cf93f61b ("arm64: dts: rockchip: add PX30-µQ7 (Ringneck) SoM with Haikou baseboard")
Cc: stable@vger.kernel.org
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>
Link: https://lore.kernel.org/r/20250627131715.1074308-1-jakob.unterwurzacher@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
@@ -344,6 +344,18 @@
 				<0 RK_PA7 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
 	};
+
+	spi1 {
+		spi1_csn0_gpio_pin: spi1-csn0-gpio-pin {
+			rockchip,pins =
+				<3 RK_PB1 RK_FUNC_GPIO &pcfg_pull_up_4ma>;
+		};
+
+		spi1_csn1_gpio_pin: spi1-csn1-gpio-pin {
+			rockchip,pins =
+				<3 RK_PB2 RK_FUNC_GPIO &pcfg_pull_up_4ma>;
+		};
+	};
 };
 
 &pmu_io_domains {
@@ -361,6 +373,17 @@
 	vqmmc-supply = <&vccio_sd>;
 };
 
+&spi1 {
+	/*
+	 * Hardware CS has a very slow rise time of about 6us,
+	 * causing transmission errors.
+	 * With cs-gpios we have a rise time of about 20ns.
+	 */
+	cs-gpios = <&gpio3 RK_PB1 GPIO_ACTIVE_LOW>, <&gpio3 RK_PB2 GPIO_ACTIVE_LOW>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&spi1_clk &spi1_csn0_gpio_pin &spi1_csn1_gpio_pin &spi1_miso &spi1_mosi>;
+};
+
 &tsadc {
 	status = "okay";
 };


