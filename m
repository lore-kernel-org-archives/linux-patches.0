Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C260B27713;
	Tue,  9 Jul 2024 11:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524497; cv=none; b=DErrGyZ1IEZP4eMU/JdlCXu2i3CWkTe+X8+kUV5XrAMjn5xo6AEkVLII9ZHDcfIIlPOnTOE6v4AXd69YTCIt4pWyr1fFixKEUNkYFOOIMf0GZuu9S217vrRbI4W/jHH7bEwJ+z7yylCjHEVUGNtPKyJ24hSDO05yGkGKLr7s520=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524497; c=relaxed/simple;
	bh=YN8V5GQbAJ7kA8yY8LSv6ThzuVgDYogXvriX4d7OGU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4ITtJ+z1A9K69gL/xYPWHB+Ma+Tj3Q+mcWemSY7yvDORxALUetrqo2Glkv12S1z9h7u5YcPJjQ7UJraxgITNCrgWbOmbVOP/1kkYGJPF3Arh096GLOt8NX0riy6ucJgP5x9SOzdaxM3DVEKKmnSOTdOFMaBJeRId2tJi2ilLAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgZKxT7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgZKxT7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F30C3277B;
	Tue,  9 Jul 2024 11:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524497;
	bh=YN8V5GQbAJ7kA8yY8LSv6ThzuVgDYogXvriX4d7OGU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AgZKxT7WO+6xmabCgs6TuKFaGB85hSlMl0Ia537hi0V7XHYf9LPk8WiNgUX77U9lr
	 Xw1s+lB6jsuLysEDugs++C5It/LVrJ0DaQ0LLTMwInxEGtD5H9zEj1Rb5WuQQ4OA9f
	 bZE0TEWcSjO5Qbfgo5wG+EOJOKvJY2SCXqQFyFAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.9 169/197] arm64: dts: rockchip: Fix the DCDC_REG2 minimum voltage on Quartz64 Model B
Date: Tue,  9 Jul 2024 13:10:23 +0200
Message-ID: <20240709110715.488534326@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

commit d201c92bff90f3d3d0b079fc955378c15c0483cc upstream.

Correct the specified regulator-min-microvolt value for the buck DCDC_REG2
regulator, which is part of the Rockchip RK809 PMIC, in the Pine64 Quartz64
Model B board dts.  According to the RK809 datasheet, version 1.01, this
regulator is capable of producing voltages as low as 0.5 V on its output,
instead of going down to 0.9 V only, which is additionally confirmed by the
regulator-min-microvolt values found in the board dts files for the other
supported boards that use the same RK809 PMIC.

This allows the DVFS to clock the GPU on the Quartz64 Model B below 700 MHz,
all the way down to 200 MHz, which saves some power and reduces the amount of
generated heat a bit, improving the thermal headroom and possibly improving
the bursty CPU and GPU performance on this board.

This also eliminates the following warnings in the kernel log:

  core: _opp_supported_by_regulators: OPP minuV: 825000 maxuV: 825000, not supported by regulator
  panfrost fde60000.gpu: _opp_add: OPP not supported by regulators (200000000)
  core: _opp_supported_by_regulators: OPP minuV: 825000 maxuV: 825000, not supported by regulator
  panfrost fde60000.gpu: _opp_add: OPP not supported by regulators (300000000)
  core: _opp_supported_by_regulators: OPP minuV: 825000 maxuV: 825000, not supported by regulator
  panfrost fde60000.gpu: _opp_add: OPP not supported by regulators (400000000)
  core: _opp_supported_by_regulators: OPP minuV: 825000 maxuV: 825000, not supported by regulator
  panfrost fde60000.gpu: _opp_add: OPP not supported by regulators (600000000)

Fixes: dcc8c66bef79 ("arm64: dts: rockchip: add Pine64 Quartz64-B device tree")
Cc: stable@vger.kernel.org
Reported-By: Diederik de Haas <didi.debian@cknow.org>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Tested-by: Diederik de Haas <didi.debian@cknow.org>
Link: https://lore.kernel.org/r/e70742ea2df432bf57b3f7de542d81ca22b0da2f.1716225483.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dts
@@ -289,7 +289,7 @@
 				regulator-name = "vdd_gpu";
 				regulator-always-on;
 				regulator-boot-on;
-				regulator-min-microvolt = <900000>;
+				regulator-min-microvolt = <500000>;
 				regulator-max-microvolt = <1350000>;
 				regulator-ramp-delay = <6001>;
 


