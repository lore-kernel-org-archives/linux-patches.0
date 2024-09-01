Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE06F17C;
	Sun,  1 Sep 2024 17:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210344; cv=none; b=T7Y1hmQMeTLVxia4/oYQj7+J+fuqEncijz3BZl7GTYwS/EMGZhm/Jr9HtDi+YpGpbdxSGwfz5bevDD+Yvc3BMemCISeIK/Snufz4Hvr+xmZ8EGRF8r5FcYiz847iGx62jePZS+UFs8h6leZhIv0FkQq975Cqgpm9Bu7tQ3iQ5kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210344; c=relaxed/simple;
	bh=31lq7xDYnvlE29v+n8mpThpwNg8/4SQIdSjVBsT+RM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oq1IMtmxq4Z78o6WlR3kAHnLIEgQGC/fd4Bv01xS5pEf8uWrPLcxTo4f13Osq8mgcbYD2mJonMCfiLBV2XCh4de1qLEMkKbuQ7j3mueYkFzI33dAfTKT+SAWEN39ZFdt24b1LkeCzWu6JX985MNFVtYira3mHNBy9kGkeE+LbpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z41VaOSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z41VaOSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDF3C4CEC3;
	Sun,  1 Sep 2024 17:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210344;
	bh=31lq7xDYnvlE29v+n8mpThpwNg8/4SQIdSjVBsT+RM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z41VaOSpye44Je7nz2B3MJgd6odFdJ1ntQJJduBwQLOvQ5pTOttjSLdQwSFV4mWa4
	 arkakUn82F2jTGuyJnjNMnDDqrqou2S9x1QexVhLs7ZuBxuqyBKhMMxesGXC6C90qT
	 11TGrVPRKWJJowfIdrrWZujqamo5GtOUdUfrHsbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 161/215] MIPS: Loongson64: Set timer mode in cpu-probe
Date: Sun,  1 Sep 2024 18:17:53 +0200
Message-ID: <20240901160829.447342868@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1782,12 +1782,16 @@ static inline void cpu_probe_loongson(st
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


