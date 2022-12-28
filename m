Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29101C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719CEC433EF;
	Wed, 28 Dec 2022 16:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245406;
	bh=l/uTSJpkb7iF9/bwE+UEqemQYnCtWxrWUH9JUkWJkGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsW4D8dCW6bCOKW2ufuLspQFr4cSodUSeiQ8DYheaBXlsl51fwcOvXtmTrqexAgAR
	 6966iXP8fxSclXlwXje7l/Tn4eiNHk/0fjBUbdEm5QV3cVepnpNzi6LoUplSGGbPBd
	 Op0PAT8leYYsMeLlQZEsNJr6YkEHyW7/f0UOeC5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adriana Kobylak <anoo@us.ibm.com>,
	Andrew Jeffery <andrew@aj.id.au>,
	Joel Stanley <joel@jms.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0887/1073] ARM: dts: aspeed: rainier,everest: Move reserved memory regions
Date: Wed, 28 Dec 2022 15:41:15 +0100
Message-Id: <20221228144352.120037306@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adriana Kobylak <anoo@us.ibm.com>

[ Upstream commit e184d42a6e085f95f5c4f1a4fbabebab2984cb68 ]

Move the reserved regions to account for a decrease in DRAM when ECC is
enabled. ECC takes 1/9th of memory.

Running on HW with ECC off, u-boot prints:
DRAM:  already initialized, 1008 MiB (capacity:1024 MiB, VGA:16 MiB, ECC:off)

And with ECC on, u-boot prints:
DRAM:  already initialized, 896 MiB (capacity:1024 MiB, VGA:16 MiB, ECC:on, ECC size:896 MiB)

This implies that MCR54 is configured for ECC to be bounded at the
bottom of a 16MiB VGA memory region:

1024MiB - 16MiB (VGA) = 1008MiB
1008MiB / 9 (for ECC) = 112MiB
1008MiB - 112MiB = 896MiB (available DRAM)

The flash_memory region currently starts at offset 896MiB:
0xb8000000 (flash_memory offset) - 0x80000000 (base memory address) = 0x38000000 = 896MiB

This is the end of the available DRAM with ECC enabled and therefore it
needs to be moved.

Since the flash_memory is 64MiB in size and needs to be 64MiB aligned,
it can just be moved up by 64MiB and would sit right at the end of the
available DRAM buffer.

The ramoops region currently follows the flash_memory, but it can be
moved to sit above flash_memory which would minimize the address-space
fragmentation.

Signed-off-by: Adriana Kobylak <anoo@us.ibm.com>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20220916195535.1020185-1-anoo@linux.ibm.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts | 17 ++++++++---------
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts | 16 +++++++++-------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
index a6a2bc3b855c..fcc890e3ad73 100644
--- a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
@@ -162,16 +162,9 @@ reserved-memory {
 		#size-cells = <1>;
 		ranges;
 
-		/* LPC FW cycle bridge region requires natural alignment */
-		flash_memory: region@b8000000 {
-			no-map;
-			reg = <0xb8000000 0x04000000>; /* 64M */
-		};
-
-		/* 48MB region from the end of flash to start of vga memory */
-		ramoops@bc000000 {
+		ramoops@b3e00000 {
 			compatible = "ramoops";
-			reg = <0xbc000000 0x200000>; /* 16 * (4 * 0x8000) */
+			reg = <0xb3e00000 0x200000>; /* 16 * (4 * 0x8000) */
 			record-size = <0x8000>;
 			console-size = <0x8000>;
 			ftrace-size = <0x8000>;
@@ -179,6 +172,12 @@ ramoops@bc000000 {
 			max-reason = <3>; /* KMSG_DUMP_EMERG */
 		};
 
+		/* LPC FW cycle bridge region requires natural alignment */
+		flash_memory: region@b4000000 {
+			no-map;
+			reg = <0xb4000000 0x04000000>; /* 64M */
+		};
+
 		/* VGA region is dictated by hardware strapping */
 		vga_memory: region@bf000000 {
 			no-map;
diff --git a/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts b/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
index bf59a9962379..4879da4cdbd2 100644
--- a/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
@@ -95,14 +95,9 @@ reserved-memory {
 		#size-cells = <1>;
 		ranges;
 
-		flash_memory: region@b8000000 {
-			no-map;
-			reg = <0xb8000000 0x04000000>; /* 64M */
-		};
-
-		ramoops@bc000000 {
+		ramoops@b3e00000 {
 			compatible = "ramoops";
-			reg = <0xbc000000 0x200000>; /* 16 * (4 * 0x8000) */
+			reg = <0xb3e00000 0x200000>; /* 16 * (4 * 0x8000) */
 			record-size = <0x8000>;
 			console-size = <0x8000>;
 			ftrace-size = <0x8000>;
@@ -110,6 +105,13 @@ ramoops@bc000000 {
 			max-reason = <3>; /* KMSG_DUMP_EMERG */
 		};
 
+		/* LPC FW cycle bridge region requires natural alignment */
+		flash_memory: region@b4000000 {
+			no-map;
+			reg = <0xb4000000 0x04000000>; /* 64M */
+		};
+
+		/* VGA region is dictated by hardware strapping */
 		vga_memory: region@bf000000 {
 			no-map;
 			compatible = "shared-dma-pool";
-- 
2.35.1



