Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9AC3B19D4;
	Mon, 23 Mar 2026 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274801; cv=none; b=Lzve8a5Ce2T/doYXnsV0KAsBfj2bc2EnjqXlbru6HOBqLvxl25lR7UFH7W/hrxU4fF6MdkoPM2QPrCaiw/ncgVunNtC/Y8TrnhmivQVipHKlVuX5ZgexdsYFWy6C/GrERL/EtCDvQCOMHFK+a5Jhl99vVmqVaoJ5WejvRG/8t04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274801; c=relaxed/simple;
	bh=aIUxPv1f0xRm/7lo3OvADgLYXvBQm44HhkFM92Fm4kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqZjB8TuMiv201ohr4+Q9zmEE43rqpgcJhfc/z0Pglb2kJacXuHVhq4P652NOBXW/alHglWOJpqD5JdTdmAW1+VzRmGNZzyCr8PHNzu8MKm0EZ9/EXqRFzWjPKoGxuDnq2Pfx7CU6ew7VE6NvnJvH43M8yd1v4gYmbb/iWAmmFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFKdGe+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFKdGe+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C93BC4CEF7;
	Mon, 23 Mar 2026 14:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274801;
	bh=aIUxPv1f0xRm/7lo3OvADgLYXvBQm44HhkFM92Fm4kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFKdGe+t495vC5RWDCIrbSub8f3Qq1Nzvd3eDK0b1/XsN5pEzDvvTjRLOjMMJipQc
	 uKRGCAXewU7eIHTylNpNjmlw+S6HsCWXYUNJOd49chdZrzEkFTl1Z3HNaA68FeJhj/
	 y4dbEBPTC5uqA2JCfu5jQs8F+M2hxqss65CR3EQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/212] arm64: dts: renesas: rzt2h-n2h-evk: Add ramp delay for SD0 card regulator
Date: Mon, 23 Mar 2026 14:45:33 +0100
Message-ID: <20260323134507.315915208@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit bb70589b67039e491dd60cf71272884e926a0f95 ]

Add a ramp delay of 60 uV/us to the vqmmc_sdhi0 voltage regulator to
fix UHS-I SD card detection failures.

Measurements on CN78 pin 4 showed the actual voltage ramp time to be
21.86ms when switching between 3.3V and 1.8V. A 25ms ramp delay has
been configured to provide adequate margin. The calculation is based
on the voltage delta of 1.5V (3.3V - 1.8V):
  1500000 uV / 60 uV/us = 25000 us (25ms)

Prior to this patch, UHS-I cards failed to initialize with:

    mmc0: error -110 whilst initialising SD card

After this patch, UHS-I cards are properly detected on SD0:

    mmc0: new UHS-I speed SDR104 SDXC card at address aaaa
    mmcblk0: mmc0:aaaa SR64G 59.5 GiB

Fixes: d065453e5ee09 ("arm64: dts: renesas: rzt2h-rzn2h-evk: Enable SD card slot")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260123225957.1007089-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/rzt2h-n2h-evk-common.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/renesas/rzt2h-n2h-evk-common.dtsi b/arch/arm64/boot/dts/renesas/rzt2h-n2h-evk-common.dtsi
index 5384a43837c1d..9c6f712a62eff 100644
--- a/arch/arm64/boot/dts/renesas/rzt2h-n2h-evk-common.dtsi
+++ b/arch/arm64/boot/dts/renesas/rzt2h-n2h-evk-common.dtsi
@@ -49,6 +49,7 @@ vqmmc_sdhi0: regulator-vqmmc-sdhi0 {
 		regulator-max-microvolt = <3300000>;
 		gpios-states = <0>;
 		states = <3300000 0>, <1800000 1>;
+		regulator-ramp-delay = <60>;
 	};
 #endif
 
-- 
2.51.0



