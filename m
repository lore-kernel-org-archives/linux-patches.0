Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7DD17B421;
	Wed,  2 Oct 2024 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877033; cv=none; b=aL3Q/aacah6ZjXmBLanxR9Zj8N+oUwd0TM6W8w3ibGXHRFEsTHtp2tfy8GlGGf24yu0H7jF73nqOBcTePhMgR0NoyaihfMkhsGj3xOyxKltQBuiwb/VNXf5UjHf6oFM/Y/j1dB7iUys7YRYaja+bnrXQPY1LqCfgJWDIO4Upjzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877033; c=relaxed/simple;
	bh=i6hmUBema3y2BeKuc5dPKhmF4LKj2bThBcytrCQRtCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uoYTDHJT3kfacyvfiXnLjIT0CoyW5l9ezeRe6I69PRHTMdRAs1hT1fHU6HbWNBQingNt1LUL1yGBfOAL9ALGo07SzhGaITSJ65aQWIjqbYmRFXZGnzdLx5EjNBJc0UYr/VQhS5zcE88+MVwv7/pMuPlVH2OrpAbrkIE/wx8Xvto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEpAyqLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEpAyqLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A959DC4CEC2;
	Wed,  2 Oct 2024 13:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877033;
	bh=i6hmUBema3y2BeKuc5dPKhmF4LKj2bThBcytrCQRtCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEpAyqLZrvGQQEEKs4kpuLZvqRn4CaSsUVFDQvNBNEZrMzgdFsuOrjvF6xrflTXUU
	 kLcXP9ECrqy9kI9U7sc0yfP3V+j94ht4yibpR93GlkCLN7EVh/gDp4oheV2ZmsCv3d
	 PskANKFpS9DkCCSGI/1RBvLFC9pQidU9vIMfEQRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikola Radojevic <nikola@radojevic.rs>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.11 642/695] arm64: dts: rockchip: Raise Pinebook Pros panel backlight PWM frequency
Date: Wed,  2 Oct 2024 15:00:40 +0200
Message-ID: <20241002125848.143967537@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

commit 8c51521de18755d4112a77a598a348b38d0af370 upstream.

Increase the frequency of the PWM signal that drives the LED backlight of
the Pinebook Pro's panel, from about 1.35 KHz (which equals to the PWM
period of 740,740 ns), to exactly 8 kHz (which equals to the PWM period of
125,000 ns).  Using a higher PWM frequency for the panel backlight, which
reduces the flicker, can only be beneficial to the end users' eyes.

On top of that, increasing the backlight PWM signal frequency reportedly
eliminates the buzzing emitted from the Pinebook Pro's built-in speakers
when certain backlight levels are set, which cause some weird interference
with some of the components of the Pinebook Pro's audio chain.

The old value for the backlight PWM period, i.e. 740,740 ns, is pretty much
an arbitrary value that was selected during the very early bring-up of the
Pinebook Pro, only because that value seemed to minimize horizontal line
distortion on the display, which resulted from the old X.org drivers causing
screen tearing when dragging windows around.  That's no longer an issue, so
there are no reasons to stick with the old PWM period value.

The lower and the upper backlight PWM frequency limits for the Pinebook Pro's
panel, according to its datasheet, are 200 Hz and 10 kHz, respectively. [1]
These changes still leave some headroom, which may have some positive effects
on the lifetime expectancy of the panel's backlight LEDs.

[1] https://files.pine64.org/doc/datasheet/PinebookPro/NV140FHM-N49_Rev.P0_20160804_201710235838.pdf

Fixes: 5a65505a6988 ("arm64: dts: rockchip: Add initial support for Pinebook Pro")
Cc: stable@vger.kernel.org
Reported-by: Nikola Radojevic <nikola@radojevic.rs>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Tested-by: Nikola Radojević <nikola@radojevic.rs>
Link: https://lore.kernel.org/r/2a23b6cfd8c0513e5b233b4006ee3d3ed09b824f.1722805655.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -32,7 +32,7 @@
 	backlight: edp-backlight {
 		compatible = "pwm-backlight";
 		power-supply = <&vcc_12v>;
-		pwms = <&pwm0 0 740740 0>;
+		pwms = <&pwm0 0 125000 0>;
 	};
 
 	bat: battery {


