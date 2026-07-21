Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE3E46A5E3;
	Tue, 21 Jul 2026 15:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648958; cv=none; b=FhOKa1o4wWloPdIxUqHvDQViNpMUY0bCXRE4ox78E1dwipzTt+uZiDZHZfrHtA6o0BsgxGqUkNBtPHwphRyJqP15gX00/tHgJRMG0UOUZmj+ScubEbucKUqQPgf5ZgMaYkWrTk/rxIx1aurUUTNqwRKTNUz4QrxwKwENjL2Amio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648958; c=relaxed/simple;
	bh=zKqRdV5eEdMpBJPg8deFELj/Sta7qSxYZaXbQwvZCFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/A1O4kghZbXNzhQglzZobAD4ceaud4qak6H9qyGRN29wB67jGkdPguyYfxSmqC8qbIYe+7qE3iFnKSF72b5gk0j2vu7Hjv8Yl3mtbstP/WVQ0UEJLUd1qkH2OM2OLdPqZplyW8sxJp587XFdqeYIoiI/cd2aFCDdVlP4ZQ3dpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MoZpOLrJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MoZpOLrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53F61F000E9;
	Tue, 21 Jul 2026 15:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648957;
	bh=EBkNiOQo5Rxj0LTgBAqVIe39jJ63Ki02dChN5J+ceJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MoZpOLrJSeoTBQwuwQEqeD7u85rfuNhnJXiJv2f9/EnSV1sgXZTD+cxXRatSNO7TI
	 CBI0E7hHQ2YgmgiIbbM+BXzghTUCpnsTdUvjJv3wa3C4qd4uqZzswDZhzm6zvCzwn8
	 k/dB67sT+AGJQ9yHZUr9jENb4UPGPIgpSH7NFehc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0395/2077] arm64: dts: renesas: ironhide: Describe all reserved memory
Date: Tue, 21 Jul 2026 17:01:08 +0200
Message-ID: <20260721152602.029582400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 5250b3b1ad99d216b31c98b2b321f1dee362a1b5 ]

Fully describe all available DRAM in the DT, and describe regions which
are not accessible because they are used by firmware in reserved-memory
nodes.

Replace the first memory bank memory@60600000 with memory@40000000 and a
518 MiB long reserved-memory no-map subnode. This memory region is used
by other cores in the system.

Reserve 32 kiB of memory at 0x8c100000 for parameters shared by IPL,
SCP, TFA BL31 and TEE.

Reserve 512 kiB of memory at 0x8c200000 for TFA BL31.  The upcoming
upstream TFA 2.15 BL31 uses memory from 0x8c200000..0x8c242fff; rounding
up to 512 kiB is slight future-proofing.

Reserve 32 MiB of memory at 0x8c400000 for OPTEE-OS, which is the entire
OPTEE-OS TZ protected DRAM area.

Neither TFA BL31 nor OPTEE-OS modify the DT passed to Linux in any way
with any new reserved-memory {} nodes to reserve memory areas used by
the TFA BL31 or OPTEE-OS to prevent the next stage from using those
areas, which lets Linux use all of the available DRAM as it is described
in the DT that was passed in by U-Boot, including the areas that are
newly utilized by TFA BL31 or OPTEE-OS.

In case of high DRAM utilization, unless the memory used by TFA BL31 or
OPTEE-OS is properly reserved, Linux may use and corrupt the memory used
by TFA BL31 or OPTEE-OS, which would lead to the system becoming
unresponsive.

Fixes: ad142a4ef710 ("arm64: dts: renesas: r8a78000: Add initial Ironhide board support")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260517163212.18016-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/renesas/r8a78000-ironhide.dts    | 35 +++++++++++++++++--
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a78000-ironhide.dts b/arch/arm64/boot/dts/renesas/r8a78000-ironhide.dts
index a721734fbd5d01..ed027a6c356ed1 100644
--- a/arch/arm64/boot/dts/renesas/r8a78000-ironhide.dts
+++ b/arch/arm64/boot/dts/renesas/r8a78000-ironhide.dts
@@ -20,10 +20,9 @@ chosen {
 		stdout-path = "serial0:1843200n8";
 	};
 
-	memory@60600000 {
+	memory@40000000 {
 		device_type = "memory";
-		/* first 518MiB is reserved for other purposes. */
-		reg = <0x0 0x60600000 0x0 0x5fa00000>;
+		reg = <0x0 0x40000000 0x0 0x80000000>;
 	};
 
 	memory@1080000000 {
@@ -65,6 +64,36 @@ memory@1e00000000 {
 		device_type = "memory";
 		reg = <0x1e 0x00000000 0x1 0x00000000>;
 	};
+
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		/* First 518 MiB is reserved for other purposes. */
+		firmware@40000000 {
+			reg = <0x0 0x40000000 0x0 0x20600000>;
+			no-map;
+		};
+
+		/* Parameters set by IPL. */
+		parameters@8c100000 {
+			reg = <0x0 0x8c100000 0x0 0x00008000>;
+			no-map;
+		};
+
+		/* TFA BL31. */
+		tfa-bl31@8c200000 {
+			reg = <0x0 0x8c200000 0x0 0x00080000>;
+			no-map;
+		};
+
+		/* TEE TZ DRAM. */
+		tee@8c400000 {
+			reg = <0x0 0x8c400000 0x0 0x02000000>;
+			no-map;
+		};
+	};
 };
 
 &extal_clk {
-- 
2.53.0



