Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D590A1C7B60;
	Tue, 27 Aug 2024 15:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771696; cv=none; b=rdpdBV97C/i8CAxpESlAdNcSusDAltZIN9i6yhPD99VLI2k3eea1BHEg5a3GY6ngHJ6KOe1ApkYVmjwtk/2ZtRC/wq7NBMtoYDFJ0rO3aL5tY4bsjWka+NU2Xq0sFRhyDPkKym4ie8fjIH3qcB+us+ii/4wBAuVfuet7o9YSZws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771696; c=relaxed/simple;
	bh=z3KjcKF53Eb1WGsEy25QBXGaWa7qQ4MSkA755tVr1ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtzWQiglBp8zoeEtGDC5kLwxjcifyxPJTuZ+Nbl10WtJatks7gWt+rZ8f3LzADo0uknmpfIuXJYgwBV3oX0WE7/NVjweLUG051F9yekgUYbNHcu786z+gimTXHx+rW6MtE4Un9+s7SjSVYcDArDj+m3sYyF5Woe7ZMMhz4EPFoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1q064BBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1q064BBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4CBC6106E;
	Tue, 27 Aug 2024 15:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771696;
	bh=z3KjcKF53Eb1WGsEy25QBXGaWa7qQ4MSkA755tVr1ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1q064BBaPn6cb6qT/OFco0ZR5kXPXF262SOCnF+Z+fRN0yethIfNN43KWp08nz5B2
	 Wh/jOIvR61QoYzQ/Lne3pUHDANV/gjPQTKXRe+8tKk7D294vEETXezlXJt+TaelzkP
	 Nu7yTrdWzZZLHwCK2TRk/LykmF2Uiu2jApQ4y4kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.10 235/273] MIPS: Loongson64: Set timer mode in cpu-probe
Date: Tue, 27 Aug 2024 16:39:19 +0200
Message-ID: <20240827143842.349356291@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 1cb6ab446424649f03c82334634360c2e3043684 upstream.

Loongson64 C and G processors have EXTIMER feature which
is conflicting with CP0 counter.

Although the processor resets in EXTIMER disabled & INTIMER
enabled mode, which is compatible with MIPS CP0 compare, firmware
may attempt to enable EXTIMER and interfere CP0 compare.

Set timer mode back to MIPS compatible mode to fix booting on
systems with such firmware before we have an actual driver for
EXTIMER.

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/cpu-probe.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1724,12 +1724,16 @@ static inline void cpu_probe_loongson(st
 		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
 			MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);
 		c->ases &= ~MIPS_ASE_VZ; /* VZ of Loongson-3A2000/3000 is incomplete */
+		change_c0_config6(LOONGSON_CONF6_EXTIMER | LOONGSON_CONF6_INTIMER,
+				  LOONGSON_CONF6_INTIMER);
 		break;
 	case PRID_IMP_LOONGSON_64G:
 		__cpu_name[cpu] = "ICT Loongson-3";
 		set_elf_platform(cpu, "loongson3a");
 		set_isa(c, MIPS_CPU_ISA_M64R2);
 		decode_cpucfg(c);
+		change_c0_config6(LOONGSON_CONF6_EXTIMER | LOONGSON_CONF6_INTIMER,
+				  LOONGSON_CONF6_INTIMER);
 		break;
 	default:
 		panic("Unknown Loongson Processor ID!");


