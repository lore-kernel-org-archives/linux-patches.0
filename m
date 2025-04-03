Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63187250C0C;
	Thu,  3 Apr 2025 15:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693781; cv=none; b=Im+LbKMrGgYjBxFesomrJJk2u3kTOma/D6xRGipCAUSvjkOApJxKDfb5L4XowVnAkZ4U8S0KuU2oeroT70bjldT+L4cYD9hWkZznfIWkc57C+vxcjCHKP+GGWhIjTqZDwJOdqJlEnmotrQfyxpx9ESCo7jYkxuNqvLyc8B5FYE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693781; c=relaxed/simple;
	bh=P0ZE6g/oe83yw1lv+asdx+ndZPrp3IUYc0FY387OT0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fW3p9VMT8ec4sgg4NnveUfZ53jnvdJ6xvTV8YqskpR4tqiMJoB9jvd/T5qjciT5O0unUpS2xVBCdlPB8gyV/PRkSjNUP2uIZHBuw+8NalC4kQVcmSOuGkuyYfZJXLY/C81ml7DnPagE4y0+b29eIybFtiNsmsay1eC5Usbpy51M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuOSbZcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuOSbZcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9166AC4CEE3;
	Thu,  3 Apr 2025 15:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693779;
	bh=P0ZE6g/oe83yw1lv+asdx+ndZPrp3IUYc0FY387OT0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nuOSbZcASNSt4MUKFRDU9gt5Wbw5jl++dMG2yxr09eeOLfpy/fXRtF5VEdw82eQB2
	 FafwhHOOg//hFZPuAKVxHPGreSSks96SLLmxJ44RRNFr/KsbJSBlr5ZBIVoUDq82CH
	 SmStcCA1qX26LbZvOIt1q81oB/GJXkYf4Dd77mDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.1 22/22] ARM: dts: imx6qdl-apalis: Fix poweroff on Apalis iMX6
Date: Thu,  3 Apr 2025 16:20:17 +0100
Message-ID: <20250403151621.559365552@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
References: <20250403151620.960551909@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx6qdl-apalis.dtsi |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/boot/dts/imx6qdl-apalis.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-apalis.dtsi
@@ -101,6 +101,11 @@
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
@@ -220,10 +225,6 @@
 	status = "disabled";
 };
 
-&clks {
-	fsl,pmic-stby-poweroff;
-};
-
 /* Apalis SPI1 */
 &ecspi1 {
 	cs-gpios = <&gpio5 25 GPIO_ACTIVE_LOW>;
@@ -511,7 +512,6 @@
 
 	pmic: pmic@8 {
 		compatible = "fsl,pfuze100";
-		fsl,pmic-stby-poweroff;
 		reg = <0x08>;
 
 		regulators {


