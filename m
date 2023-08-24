Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C1C125AE
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD0FC433C7;
	Thu, 24 Aug 2023 15:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889339;
	bh=QonmRdTxdpL+G6HSdx0K+WCV09Io5aZAUm19cwL4MWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NxThHqt/iI4/mEEpoNZH4mtOQ/utHkvAXPa+I3dFqd7lnOwNS1k32/EaadqrKO7jS
	 sTs+la4wyecWjxU9z76BjohYqqDX5EGC04Y3fpB0vIl9MuEz8pIiVhAMUG/5WWu7yj
	 XRRpdg0dG+NJ3D7fZC7CRRSLR6mfXHrZmC7krYMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Obbard <chris.obbard@collabora.com>,
	Folker Schwesinger <dev@folker-schwesinger.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/135] arm64: dts: rockchip: Disable HS400 for eMMC on ROCK Pi 4
Date: Thu, 24 Aug 2023 16:50:44 +0200
Message-ID: <20230824145031.329414763@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christopher Obbard <chris.obbard@collabora.com>

[ Upstream commit cee572756aa2cb46e959e9797ad4b730b78a050b ]

There is some instablity with some eMMC modules on ROCK Pi 4 SBCs running
in HS400 mode. This ends up resulting in some block errors after a while
or after a "heavy" operation utilising the eMMC (e.g. resizing a
filesystem). An example of these errors is as follows:

    [  289.171014] mmc1: running CQE recovery
    [  290.048972] mmc1: running CQE recovery
    [  290.054834] mmc1: running CQE recovery
    [  290.060817] mmc1: running CQE recovery
    [  290.061337] blk_update_request: I/O error, dev mmcblk1, sector 1411072 op 0x1:(WRITE) flags 0x800 phys_seg 36 prio class 0
    [  290.061370] EXT4-fs warning (device mmcblk1p1): ext4_end_bio:348: I/O error 10 writing to inode 29547 starting block 176466)
    [  290.061484] Buffer I/O error on device mmcblk1p1, logical block 172288
    [  290.061531] Buffer I/O error on device mmcblk1p1, logical block 172289
    [  290.061551] Buffer I/O error on device mmcblk1p1, logical block 172290
    [  290.061574] Buffer I/O error on device mmcblk1p1, logical block 172291
    [  290.061592] Buffer I/O error on device mmcblk1p1, logical block 172292
    [  290.061615] Buffer I/O error on device mmcblk1p1, logical block 172293
    [  290.061632] Buffer I/O error on device mmcblk1p1, logical block 172294
    [  290.061654] Buffer I/O error on device mmcblk1p1, logical block 172295
    [  290.061673] Buffer I/O error on device mmcblk1p1, logical block 172296
    [  290.061695] Buffer I/O error on device mmcblk1p1, logical block 172297

Disabling the Command Queue seems to stop the CQE recovery from running,
but doesn't seem to improve the I/O errors. Until this can be investigated
further, disable HS400 mode on the ROCK Pi 4 SBCs to at least stop I/O
errors from occurring.

While we are here, set the eMMC maximum clock frequency to 1.5MHz to
follow the ROCK 4C+.

Fixes: 1b5715c602fd ("arm64: dts: rockchip: add ROCK Pi 4 DTS support")
Signed-off-by: Christopher Obbard <chris.obbard@collabora.com>
Tested-By: Folker Schwesinger <dev@folker-schwesinger.de>
Link: https://lore.kernel.org/r/20230705144255.115299-2-chris.obbard@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
index 360a31d2c56cc..2f52b91b72152 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
@@ -607,9 +607,9 @@
 };
 
 &sdhci {
+	max-frequency = <150000000>;
 	bus-width = <8>;
-	mmc-hs400-1_8v;
-	mmc-hs400-enhanced-strobe;
+	mmc-hs200-1_8v;
 	non-removable;
 	status = "okay";
 };
-- 
2.40.1



