Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39856346A08;
	Sat, 12 Sep 2026 07:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196978; cv=none; b=imb3tx3Xyd+0JP8HlaOvXa/VQ5N3oPY5RT/FqAG/GPqRWQp5APUWCPiFR/SkwFfCae9DXgYri27e4GojSKzOMpCNaDMhIQ6ZSfB4c8pKaOe0CBouXGscZC/64RUQS7E4+lc9yp0+Vus0hXkltrZcNExyGJJp5xoWzZuixif9v6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196978; c=relaxed/simple;
	bh=3PPr/hF0eFt4AJXZf9/tiCYsJktdTZ4lGRwLKMLpsUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QawKNgY+er4DLI2/ITq3qyAQCHCKHDNfku3Bn7JSrbRohkILCebUk9IiIHJMfc7FbswR3VQkC8OgJmbWwcZiEGZJIbwH5MC5N53Q0HqudG7hQFAtjK1aPpAgPRj3i4EP1Zj4aCtWmmLUegB8i8QC9GrcS7ef0qWCahR4eZVJ9WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubtXA+Hy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubtXA+Hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FAE1F000FF;
	Sat, 12 Sep 2026 07:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196976;
	bh=26AZmQBea6Q2kk/xA9+uwDnbS9ozdwUFx+EIGyc/oaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ubtXA+Hyo6aTbPRt5J6RqOWtM1Yx0gM8L+PhnOUoLHjINt3lVWx110gB6Uc5s4zQA
	 hl0/NXhQYL1FcQ138n2Q0IG17h+DeY1OeJxWTiyuMjuEsEeUMeyCGJP1EyJ8OEeujM
	 gEiaUY4mG6EdL3wCJivUXz4SsQtNWIG5FPOh+Fkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0075/1815] arm64: dts: imx943: Correct PCIe outbound address space configuration
Date: Sat, 12 Sep 2026 08:30:25 +0200
Message-ID: <20260912065650.773901280@linuxfoundation.org>
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

[ Upstream commit 6de3a7d7a4f653be4901d07425719c4e55805167 ]

Fix the PCIe outbound memory ranges for both pcie1 controllers on i.MX943.

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

Fixes: fa6067fd8ea7 ("arm64: dts: imx943: Add pcie1 and pcie1-ep supports")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx943.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx943.dtsi b/arch/arm64/boot/dts/freescale/imx943.dtsi
index ed030d4bc7bd9..cf5b3dbb47ff7 100644
--- a/arch/arm64/boot/dts/freescale/imx943.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx943.dtsi
@@ -218,8 +218,9 @@ pcie1: pcie@4c380000 {
 			      <0 0x4c3e0000 0 0x10000>,
 			      <0 0x4c3c0000 0 0x4000>;
 			reg-names = "dbi", "config", "atu", "app";
-			ranges = <0x81000000 0 0x00000000 0x8 0x8ff00000 0 0x00100000>,
-				 <0x82000000 0 0x10000000 0xa 0x10000000 0 0x80000000>;
+			ranges = <0x43000000 0xa 0x00000000 0xa 0x00000000 0x0 0xe0000000>,
+				 <0x82000000 0x0 0xe0000000 0xa 0xe0000000 0x0 0x10000000>,
+				 <0x81000000 0x0 0x00000000 0xa 0xf0000000 0x0 0x00100000>;
 			#address-cells = <3>;
 			#size-cells = <2>;
 			device_type = "pci";
-- 
2.53.0



