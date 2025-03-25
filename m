Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E896426F455;
	Tue, 25 Mar 2025 12:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906368; cv=none; b=UJ7im7f4+dFuNI7Y+MZHkwBEA4GFpta2JLVkPev27ohOSkmS5muNjoSvs7IHGQKSSPfrLBqxl+fJdIC0qBDObhIe6guk+3I3o5/ftDhjfBIEWNXy+aBcYnc5PN8Z7Wwp546YBmz/NuzLQsOWPcjKaZklBSOakm9/m5ffdecqT8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906368; c=relaxed/simple;
	bh=xXoObsU5IiMyGt2kJki6C9oLkeqAO9zJp4FvfGlKKPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/RqPVAys+2USaeyANYehKTThvWVgcqBYdcSV3sIee1IAe3EhIqKSNXSmdi9/u1t4mt5F/opEb69jxUjjTotdSUHbE6ZgA0j2EPrw1N2tdKMn5cwEPeLe5WwSs+7KLi7ZaM1BhnevdEbpLcSJYW/jFnfKhC72AYCmJBfnOp3sjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkJw3OvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkJw3OvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29884C4CEE4;
	Tue, 25 Mar 2025 12:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906367;
	bh=xXoObsU5IiMyGt2kJki6C9oLkeqAO9zJp4FvfGlKKPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkJw3OvUOm+cc6RtU5ziCRkm4STNWuihvsqVUSbHM48GUtXzk/yE87KTqRKSTAUmM
	 7NOkW2mTJYluUYVsspaEppjJh8Svk5/H3K5DrJ73H4MwKmtFTgZX+ax/xxWka2DovW
	 tSmQQPbBdkD7W15wbfQyx32bnLsxrsCl697L3hlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 080/116] ARM: dts: imx6qdl-apalis: Fix poweroff on Apalis iMX6
Date: Tue, 25 Mar 2025 08:22:47 -0400
Message-ID: <20250325122151.256494461@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


