Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F85A19F485;
	Tue, 27 Aug 2024 14:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770670; cv=none; b=BL5+g3rIafg8GbfMMBUHFrpb0neqeORvSOWyiOnYhbFDeB7+T0uCf7SHzBOcbmDxyBSau/8JzDiuLR9DT2qOpjrOAP83wXIVM/oj9hQ0OoNT05b28Cl4xDBS4xifkltY1uQn8YHKQuNLqBRkhctoyvzefJqLVV56VxupOsEwaAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770670; c=relaxed/simple;
	bh=Js6Nz3bDZSu4imB1Px2C9hDBq84Lbz3AcJSEpITv4pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvlDLp82RtWRXXKK81VguRsqv1GQ1tHRuB1NMTcVPEhCi2FYESszfHynrvR3e6oednSvJ9nFDqg2KOydFT/ffatLfPR1aOMOKgoOB4Sp1HbYqJBoxALNuALuqecVtcbbdKdz+UzPEtCYQy+YY0Bp0es7N603kkSrJ20dYNYTY2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hC2XXCb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hC2XXCb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA847C61044;
	Tue, 27 Aug 2024 14:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770670;
	bh=Js6Nz3bDZSu4imB1Px2C9hDBq84Lbz3AcJSEpITv4pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hC2XXCb+s6+ZiKQFv8lAuY+7f0o+S5ft0tN1DZjeaJChnve/LNOfHOO9uRL/GwjIJ
	 1an9gIsMxwcdw+WLiQqzm5Yo76+/l8sYbbhE775pCyk/RWR3zvN16bNSpPYaFii/sA
	 vQiOqRUXUhUNKZHmESBcGf7AmMqaG54M5BRqgynM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 299/341] MIPS: Loongson64: Set timer mode in cpu-probe
Date: Tue, 27 Aug 2024 16:38:50 +0200
Message-ID: <20240827143854.771602590@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1725,12 +1725,16 @@ static inline void cpu_probe_loongson(st
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


