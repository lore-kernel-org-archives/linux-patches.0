Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBC33C10A7;
	Sat, 12 Sep 2026 07:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196973; cv=none; b=mDJ1dMogJ9I89QjTKYlc2NYKKUoEa9cTPQOqTCKdfLr7BwL5oLJhBORvBAlLk/nQacubrdgDUBraS4IY8KkJ0kg577ocVFqPNOwKJma9k9OyHtgUh7BOHEE0wjflnUur4atVR82bSCTE6r071RRVoxjNfM6lzo8h9LbL5V6Uub8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196973; c=relaxed/simple;
	bh=ZVcqFxzzn/lrXQGit6cFoef/XfJxIQ79ILAexPfF4UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEXMEO4drJ2nyp60tEi/dnU/sjvQheQqoDK2WrSS1LAiZQxDMPScHFB/buULFak8JSaCJ8TFcq3Pu5C9psgxrhsmI910QUYUGpW5Lpte7Tzhaza9ustBkixa1DkGSe/NI2oujYWZv2guj1hBw+VOREerE62cjmwuTxrY+uGOSFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jP3EL1LW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jP3EL1LW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7EF1F000FF;
	Sat, 12 Sep 2026 07:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196972;
	bh=VJeOMAa+ZCh8pYESubPBnBDHsL/2cRHYzDJGowz8rr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jP3EL1LW2R1A4/rPnbgUxbE9fdJuAh4ATBX9lE0aUiabNyKfRq5lpqesPlz+nBuro
	 l2FQaScrGpcxxAYEtIE+W33cWKoaethPOqIqxcfE79DPd5if9PSRybyR5JJnftcwWz
	 Q0BevkPP2UC/f4C4NHD+p+dI7bvMMhRziZidPe3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0074/1815] arm64: dts: imx94: Correct PCIe outbound address space configuration
Date: Sat, 12 Sep 2026 08:30:24 +0200
Message-ID: <20260912065650.751091853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit ffccbd6804e885f0fc23f0005f6bee7789a7a887 ]

Fix the PCIe outbound memory ranges for both pcie0 controllers on i.MX94.

The memory window size was incorrectly set to 256MB during initial
bring-up, but the hardware supports up to 4GB of outbound address space
per controller.

Additionally, the ECAM region cannot be mapped as I/O space. Use a
memory-mapped region for I/O space instead, and relocate the 1MB I/O
region to immediately follow the memory region at offset 0xf0000000
within each window.

Update the outbound address space layout per controller as follows:

  - 3.5GB  64-bit prefetchable memory
  - 256MB  32-bit non-prefetchable memory
  - 1MB    I/O

Fixes: 8cd439f17758 ("arm64: dts: imx94: Add pcie0 and pcie0-ep supports")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx94.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx94.dtsi b/arch/arm64/boot/dts/freescale/imx94.dtsi
index a6cb5a6e848b3..1f9035e6cf159 100644
--- a/arch/arm64/boot/dts/freescale/imx94.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx94.dtsi
@@ -1374,8 +1374,9 @@ pcie0: pcie@4c300000 {
 			      <0 0x4c360000 0 0x10000>,
 			      <0 0x4c340000 0 0x4000>;
 			reg-names = "dbi", "config", "atu", "app";
-			ranges = <0x81000000 0x0 0x00000000 0x0 0x6ff00000 0 0x00100000>,
-				 <0x82000000 0x0 0x10000000 0x9 0x10000000 0 0x80000000>;
+			ranges = <0x43000000 0x9 0x00000000 0x9 0x00000000 0x0 0xe0000000>,
+				 <0x82000000 0x0 0xe0000000 0x9 0xe0000000 0x0 0x10000000>,
+				 <0x81000000 0x0 0x00000000 0x9 0xf0000000 0x0 0x00100000>;
 			#address-cells = <3>;
 			#size-cells = <2>;
 			device_type = "pci";
-- 
2.53.0



