Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0701487F4;
	Tue, 30 Sep 2025 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244803; cv=none; b=QOn3Jh8aOAwh/L8UitHIOTv95/68uhEbqD4rHfhZHK0Ht2I2o8drBMLg1ktNCDjZmNhU/vFlNetAFJnthYLdatkET/hJ/3Pd5dpucjxa2vgQePqba2+mosomVlg8a/wvf9lYlttOk74w4L7ZqlgY2B3sOykGUyu6xHraV7EEJIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244803; c=relaxed/simple;
	bh=OuERbUtzBYlOjw+Is4ti/TZD36pfqwtFTmd2qHkyICE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5cZQZnvFu9qsAlC04wKGFyQM+5q1t99y/Qa8v97NmnrrKmpP0M9S3aBd3sARS5LaNNn9yzmRcCOLm3iCXK6Xw04oA1uVpJb4zoSWWuEW92FmfouPaTAv4BzS0pvv6jkl5SpYwSkV8sRfUHeOf9nkrLnsspdOq1ez6hlDE4ljbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnJuuVJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnJuuVJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63D2C4CEF0;
	Tue, 30 Sep 2025 15:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244803;
	bh=OuERbUtzBYlOjw+Is4ti/TZD36pfqwtFTmd2qHkyICE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnJuuVJ+76gAJuqMl3h0ZGRWUuNDLVQOtUqV9MlBVl1P/skxfCTzSpva4sNXRPdGm
	 slak+FkV5CarM4gB307JUoIWaa2WKdPD5Sz+EiyhMG9C9WpOQHPNkakOajWbkoHYJi
	 EUwJCEO0lMcjtPJyEclKnDECr+PjK6vOvldjIEpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.16 117/143] arm64: dts: marvell: cn9132-clearfog: fix multi-lane pci x2 and x4 ports
Date: Tue, 30 Sep 2025 16:47:21 +0200
Message-ID: <20250930143835.893003496@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

commit 794a066688038df46c01e177cc6faebded0acba4 upstream.

The mvebu-comphy driver does not currently know how to pass correct
lane-count to ATF while configuring the serdes lanes.

This causes the system to hard reset during reconfiguration, if a pci
card is present and has established a link during bootloader.

Remove the comphy handles from the respective pci nodes to avoid runtime
reconfiguration, relying solely on bootloader configuration - while
avoiding the hard reset.

When bootloader has configured the lanes correctly, the pci ports are
functional under Linux.

This issue may be addressed in the comphy driver at a future point.

Fixes: e9ff907f4076 ("arm64: dts: add description for solidrun cn9132 cex7 module and clearfog board")
Cc: stable@vger.kernel.org
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/marvell/cn9132-clearfog.dts |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/marvell/cn9132-clearfog.dts
+++ b/arch/arm64/boot/dts/marvell/cn9132-clearfog.dts
@@ -413,7 +413,13 @@
 /* SRDS #0,#1,#2,#3 - PCIe */
 &cp0_pcie0 {
 	num-lanes = <4>;
-	phys = <&cp0_comphy0 0>, <&cp0_comphy1 0>, <&cp0_comphy2 0>, <&cp0_comphy3 0>;
+	/*
+	 * The mvebu-comphy driver does not currently know how to pass correct
+	 * lane-count to ATF while configuring the serdes lanes.
+	 * Rely on bootloader configuration only.
+	 *
+	 * phys = <&cp0_comphy0 0>, <&cp0_comphy1 0>, <&cp0_comphy2 0>, <&cp0_comphy3 0>;
+	 */
 	status = "okay";
 };
 
@@ -475,7 +481,13 @@
 /* SRDS #0,#1 - PCIe */
 &cp1_pcie0 {
 	num-lanes = <2>;
-	phys = <&cp1_comphy0 0>, <&cp1_comphy1 0>;
+	/*
+	 * The mvebu-comphy driver does not currently know how to pass correct
+	 * lane-count to ATF while configuring the serdes lanes.
+	 * Rely on bootloader configuration only.
+	 *
+	 * phys = <&cp1_comphy0 0>, <&cp1_comphy1 0>;
+	 */
 	status = "okay";
 };
 


