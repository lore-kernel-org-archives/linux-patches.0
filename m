Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172A21DFD1;
	Sun,  1 Sep 2024 16:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209672; cv=none; b=kpd/8bMysrxNY/vjtDAnw8vnh837p/pYZYGZGudBn8WGm/7IdxI6XNMZTfGXS4scAKkQbBP2w3G9nWjhm4X22FYmR06GZpqaDSQqCz6IzbdPWn6E+dvaHoNgvqLJh6UtLR+8ECKZoWvTX92muojS73R9EbZ//lckBzCJSb4SEg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209672; c=relaxed/simple;
	bh=Wk3llQ0VzXvLrNULPm6jRI5AHsWVIfhNAZIqqtbp6Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4KSrHXctuoDa05GcU2sWtn19nWmfNUGEF/bBBD73AJP9GN6KwV+rJrbcYT2A0vyCippiXFKaPktDkFqT2DKGvbhSisCR6p3F4b1Kaep37X1He8EUL46UeTSv0UpBT8vdI+bj2TcNrl9+2Klzh5bdBwxG5MKi3D6dgZZ/CpJCts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imd0btBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imd0btBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EE2C4CEC3;
	Sun,  1 Sep 2024 16:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209670;
	bh=Wk3llQ0VzXvLrNULPm6jRI5AHsWVIfhNAZIqqtbp6Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imd0btBovXsIIIIZWLEvU+ChvovbrIvf6OrQEvxtKCc8EUR70NeNi0MA52G+QRAyF
	 ob2c/TyG0WDbh7b4DWJdYuafXzz+PCj3/l8a9+EW1GlrveAlRsC8n/1okHYhXxvgKi
	 +bQ6bV3D40GzJVkD8ZQwkIGcpxJls+XqOx6RUKTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 109/151] MIPS: Loongson64: Set timer mode in cpu-probe
Date: Sun,  1 Sep 2024 18:17:49 +0200
Message-ID: <20240901160818.208938983@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1769,12 +1769,16 @@ static inline void cpu_probe_loongson(st
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


