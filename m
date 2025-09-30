Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C045F846F;
	Tue, 30 Sep 2025 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244790; cv=none; b=lA17Etc+BmYBq6iGX0QISVLeG1XsqslijHc1gMGZdDzxgWEKhf6U8FgnJru3ZHeKhGg8WI2Qvx32cHaRqau+ZBZbu1sWMYL9bvc/ksIU0WKlnyVvShvBT7vIzVhii+4M9X45dOeRXE2Oo6vVzzZg9YmOyuFMNYT34tR2ajFTAOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244790; c=relaxed/simple;
	bh=eF3YAYD+uovL6DaOqJdZ6bK9LGWIB9ksYieLItafcpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdRZWEIb7iKhseS/a6slmoFK1zaFZwO635YUput82TaMnu04ySjLxb1+LNJydjxL/HnbQxE/DzZQ8fu14mjxmz8g2qI+E3GbC5UUohqgQMf5sSvUdyi30ReQSZr6OiibMJ6b/Rc1jJtH6kjdIldWlBhPQLjzvV5w6gssHj3rBAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qs6f9m/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qs6f9m/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E678FC4CEF0;
	Tue, 30 Sep 2025 15:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244790;
	bh=eF3YAYD+uovL6DaOqJdZ6bK9LGWIB9ksYieLItafcpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qs6f9m/bKHQmMf6r8GMbVZDVs1VHh0gCcjTYjsuZ3Rw0+b/Gb8u051ULT3EZuTf5e
	 Li0iN+6LJinjyXwwRQEyeyIFJnr09BheF63eyYkEeyDLcGmVoIlHxCds9QDQayXaUu
	 JiS+LtFA79aGZucQpm/bV9/wgQIaBXE9jXqDQG9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.16 114/143] ARM: dts: socfpga: sodia: Fix mdio bus probe and PHY address
Date: Tue, 30 Sep 2025 16:47:18 +0200
Message-ID: <20250930143835.775713884@linuxfoundation.org>
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

From: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>

commit ea9da67e2add7bd5f1e4b38dc2404480e711f4d8 upstream.

On SoCFPGA/Sodia board, mdio bus cannot be probed, so the PHY cannot be
found and the network device does not work.

```
stmmaceth ff702000.ethernet eth0: __stmmac_open: Cannot attach to PHY (error: -19)
```

To probe the mdio bus, add "snps,dwmac-mdio" as compatible string of the
mdio bus. Also the PHY address connected to this board is 4. Therefore,
change to 4.

Cc: stable@vger.kernel.org # 6.3+
Signed-off-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/intel/socfpga/socfpga_cyclone5_sodia.dts |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/intel/socfpga/socfpga_cyclone5_sodia.dts
+++ b/arch/arm/boot/dts/intel/socfpga/socfpga_cyclone5_sodia.dts
@@ -66,8 +66,10 @@
 	mdio0 {
 		#address-cells = <1>;
 		#size-cells = <0>;
-		phy0: ethernet-phy@0 {
-			reg = <0>;
+		compatible = "snps,dwmac-mdio";
+
+		phy0: ethernet-phy@4 {
+			reg = <4>;
 			rxd0-skew-ps = <0>;
 			rxd1-skew-ps = <0>;
 			rxd2-skew-ps = <0>;


