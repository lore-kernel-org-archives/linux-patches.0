Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34471D0492;
	Tue, 15 Oct 2024 11:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993215; cv=none; b=WqNcduIdnTDsMuJ2PiwKw+WY5n4+I2FrPZLbAuzDWghn2RJkESE//iK8fblhv36ELJuXSF4GsFRrBZHQy7Lv0Di3BjehEhwVNBll0gQbGbbsXrLQPHewAX+x8lsJdqMlR4qXCJ5lUCUOUqcN85Y3oUGPWD59KVUUt3B91muAUGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993215; c=relaxed/simple;
	bh=vCxUyCA4vdLNLEYwh9b9SbMbbXYxDUtVp9G05zjxHFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmooT2BpVrCpfo/Gs/VaYRnkLbB9xpxWO9VczZpAwYx9n3pnq3xVGJTdFSXg0Lr47ghwmE38CNDdIY4CY1UEdblz8XbmjlaJjgS9uGfJzAMUTeyPnkMd2mun2qKi5sbPY/oRIV7VjvHZ+2hFGeQeQFDTn0c7dghdCm2WuKws61g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4A/zl6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4A/zl6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF59C4CEC6;
	Tue, 15 Oct 2024 11:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993215;
	bh=vCxUyCA4vdLNLEYwh9b9SbMbbXYxDUtVp9G05zjxHFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4A/zl6+umc0BbVegkifSZWL0UUI/pm+LXKRinCDLn8881WYXYrdCRyfyytSZ1X7s
	 pQo6tl/dUivjnhr+htPb6eknkaV6cydNX1Abp/UatWLFh19o8hur2sW2XFHwtJ9U3Q
	 8TKFI+S/rkGn8q0W8PHwH/tzobabSgfWzqsdI3bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Kraus <gamiee@pine64.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.15 344/691] arm64: dts: rockchip: Correct the Pinebook Pro battery design capacity
Date: Tue, 15 Oct 2024 13:24:52 +0200
Message-ID: <20241015112453.992526480@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

commit def33fb1191207f5afa6dcb681d71fef2a6c1293 upstream.

All batches of the Pine64 Pinebook Pro, except the latest batch (as of 2024)
whose hardware design was revised due to the component shortage, use a 1S
lithium battery whose nominal/design capacity is 10,000 mAh, according to the
battery datasheet. [1][2]  Let's correct the design full-charge value in the
Pinebook Pro board dts, to improve the accuracy of the hardware description,
and to hopefully improve the accuracy of the fuel gauge a bit on all units
that don't belong to the latest batch.

The above-mentioned latest batch uses a different 1S lithium battery with
a slightly lower capacity, more precisely 9,600 mAh.  To make the fuel gauge
work reliably on the latest batch, a sample battery would need to be sent to
CellWise, to obtain its proprietary battery profile, whose data goes into
"cellwise,battery-profile" in the Pinebook Pro board dts.  Without that data,
the fuel gauge reportedly works unreliably, so changing the design capacity
won't have any negative effects on the already unreliable operation of the
fuel gauge in the Pinebook Pros that belong to the latest batch.

According to the battery datasheet, its voltage can go as low as 2.75 V while
discharging, but it's better to leave the current 3.0 V value in the dts file,
because of the associated Pinebook Pro's voltage regulation issues.

[1] https://wiki.pine64.org/index.php/Pinebook_Pro#Battery
[2] https://files.pine64.org/doc/datasheet/pinebook/40110175P%203.8V%2010000mAh%E8%A7%84%E6%A0%BC%E4%B9%A6-14.pdf

Fixes: c7c4d698cd28 ("arm64: dts: rockchip: add fuel gauge to Pinebook Pro dts")
Cc: stable@vger.kernel.org
Cc: Marek Kraus <gamiee@pine64.org>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/731f8ef9b1a867bcc730d19ed277c8c0534c0842.1721065172.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -36,7 +36,7 @@
 
 	bat: battery {
 		compatible = "simple-battery";
-		charge-full-design-microamp-hours = <9800000>;
+		charge-full-design-microamp-hours = <10000000>;
 		voltage-max-design-microvolt = <4350000>;
 		voltage-min-design-microvolt = <3000000>;
 	};


