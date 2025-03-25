Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B932C2561A2;
	Tue, 25 Mar 2025 12:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906084; cv=none; b=PXLylKKWOGVgWDvlaH9P0oEGYugyBWLDvmgkaUKeS/I8KQKylQkL/q3GZDi6FRFimy2aAbicr7Wq3eUg369vdr7e+CgfX2I25pC/YgVvDkCUK4UzaeYGelRkU9T85ejLso5GT2gOXZK3qWZmjPxD4EtVnA6DnVXHU7qO5IYF5Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906084; c=relaxed/simple;
	bh=KnnB9cw0q4FDpYPC6jDTP37hmXAitHkPmm62lQQqybM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eV6y0XnNhEB555ZhzZKyK13NoXOVPBgbMpJOgV7kIF7vk6oAot2OGndZDM3XmBnXgGfxuKTjOtcGHqDiDncZsruWm163fvmywAyYJDIm8mK4yyovenktHSuJl4n8Ot6/BtnDNKEm8XMgNKd67CHMLgOG0xVXRgEctJ0B5fmes+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQjNWuLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQjNWuLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B4EC4CEE4;
	Tue, 25 Mar 2025 12:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906083;
	bh=KnnB9cw0q4FDpYPC6jDTP37hmXAitHkPmm62lQQqybM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQjNWuLJIdAJPiqVOTVglcEk9QdKC3RrDIssozAGvcWmbQST4UDhGCp5hAAgqLHFL
	 r9JB9E6uyJRiazR5kUJwJ+EYABS2uUhiHCoBOsUdAUgFRLIbY8pDFIqaY5t0BlSG0p
	 0YhAUbg6jd9+CKEsvOuIw12Lf9n24L1+fFz962H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.13 085/119] ARM: dts: imx6qdl-apalis: Fix poweroff on Apalis iMX6
Date: Tue, 25 Mar 2025 08:22:23 -0400
Message-ID: <20250325122151.230998120@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

commit 83964a29379cb08929a39172780a4c2992bc7c93 upstream.

The current solution for powering off the Apalis iMX6 is not functioning
as intended. To resolve this, it is necessary to power off the
vgen2_reg, which will also set the POWER_ENABLE_MOCI signal to a low
state. This ensures the carrier board is properly informed to initiate
its power-off sequence.

The new solution uses the regulator-poweroff driver, which will power
off the regulator during a system shutdown.

Cc: <stable@vger.kernel.org>
Fixes: 4eb56e26f92e ("ARM: dts: imx6q-apalis: Command pmic to standby for poweroff")
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/nxp/imx/imx6qdl-apalis.dtsi |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/boot/dts/nxp/imx/imx6qdl-apalis.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6qdl-apalis.dtsi
@@ -108,6 +108,11 @@
 		};
 	};
 
+	poweroff {
+		compatible = "regulator-poweroff";
+		cpu-supply = <&vgen2_reg>;
+	};
+
 	reg_module_3v3: regulator-module-3v3 {
 		compatible = "regulator-fixed";
 		regulator-always-on;
@@ -236,10 +241,6 @@
 	status = "disabled";
 };
 
-&clks {
-	fsl,pmic-stby-poweroff;
-};
-
 /* Apalis SPI1 */
 &ecspi1 {
 	cs-gpios = <&gpio5 25 GPIO_ACTIVE_LOW>;
@@ -527,7 +528,6 @@
 
 	pmic: pmic@8 {
 		compatible = "fsl,pfuze100";
-		fsl,pmic-stby-poweroff;
 		reg = <0x08>;
 
 		regulators {


