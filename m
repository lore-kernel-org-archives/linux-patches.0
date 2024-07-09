Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1168D1487F6;
	Tue,  9 Jul 2024 11:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523886; cv=none; b=QeaQOrKP+vQMivgH8WRze7F1AB/x3zooX9yRkASkzUj0KajDOqvTXkvWIfL7T/vGJQpxzQh6ExTrLq/Ez7HJLVD1xUiY6h8SG+KUn0UK5i1SVvNSaSdzTkUyHc2h8zC8Qfs0EF6++y2RF5o07TkIOCT6uwAs3V6jfbfx5eoF7Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523886; c=relaxed/simple;
	bh=P+1BJIlS3EtITmKUyD9kRYRbfl3L4Boqdn67qLIZoQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cA7OLsp4RMH9vA3YEKqAFtDFORenbGX8jhnNcZz+06vKaA0Ps+1h6auAurTjl1KwwqZQ4ImGf9CLr3CgtrF96CLqxD0ZmwTzrtzUJdeJKwhXK3jEyQtmQfkcCqsWPYBKaPG2HhK8DTeBg+hibshURRfh5aRQRZuUmH7STPt++W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMh3hEoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMh3hEoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE34C32786;
	Tue,  9 Jul 2024 11:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523885;
	bh=P+1BJIlS3EtITmKUyD9kRYRbfl3L4Boqdn67qLIZoQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMh3hEohRHJAY/i+Ooc1MDd0g0tDaNxg/uff7J/bUfWEBRS6Pv08DHOEBvZAm965x
	 WGcl7gBTDOGXf24Okg8Mwmp2vdXBZA78HZgaNJY0drDFTUrUhPCabgnL6GLCZHT5nX
	 lXLCbOH+JRVv6T3E0zDntUU5gjAdHpbMRhv/i5AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.6 115/139] arm64: dts: rockchip: Fix the DCDC_REG2 minimum voltage on Quartz64 Model B
Date: Tue,  9 Jul 2024 13:10:15 +0200
Message-ID: <20240709110702.617079402@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


