Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1014C97;
	Tue, 11 Nov 2025 00:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822595; cv=none; b=jFyaIfA/NHyqUharPTN7Yscd2AS5cKiNNFY4D8qus00EVGtjka6sk1hDDD8VlYhopmhE+EZd4JEfg/54HblckfL04cBXNLgC55OqfYhLwX+Zs0Y0sY/9Wl1WS1gRAkN6S1GJwrRz5IODrg2VZtwiyAt9TQ1/PyaLPU2IuEwLz8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822595; c=relaxed/simple;
	bh=X4bHshdUPSahY1+xvfvgsQP8sE/bWi76sCWOjyQ0Rxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2vw6qNrCI3ygt2cMWQyh/uBIblES00HC1feTEcOIlIQnQciYk8VpLQ2HMc2oq8xB/PzM3LWKTze6u2gdEqDx9LF9/4FIFkYe8h8NWDmyeMTEZUKxBhaX32TIOuirOX+uoYEvxTaC5P6qSqxzI3hX9EEqvCdjPDemuOyu+2PWtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bz7KHwTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bz7KHwTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8526DC19421;
	Tue, 11 Nov 2025 00:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822594;
	bh=X4bHshdUPSahY1+xvfvgsQP8sE/bWi76sCWOjyQ0Rxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bz7KHwTK9ok+Rft4GGfmVMt8witjUz4+4Po+3GJ9OFSeVWobW9/TUFUArzQOE5JQQ
	 ayir05I8k10sWq9W2+ncC+SCucF7CvDUmnZhv4IdeOu19FkW0pIsVS+G7UCYdV11hD
	 WuoltDUFod/mnpntdgECc4MQHAJPgj3MUVx3aw5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Price <gourry@gourry.net>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 081/565] x86/CPU/AMD: Add RDSEED fix for Zen5
Date: Tue, 11 Nov 2025 09:38:57 +0900
Message-ID: <20251111004528.790455929@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price <gourry@gourry.net>

commit 607b9fb2ce248cc5b633c5949e0153838992c152 upstream.

There's an issue with RDSEED's 16-bit and 32-bit register output
variants on Zen5 which return a random value of 0 "at a rate inconsistent
with randomness while incorrectly signaling success (CF=1)". Search the
web for AMD-SB-7055 for more detail.

Add a fix glue which checks microcode revisions.

  [ bp: Add microcode revisions checking, rewrite. ]

Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20251018024010.4112396-1-gourry@gourry.net
[ bp: 6.12 backport: use the alternative microcode version checking. ]
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1018,8 +1018,43 @@ static void init_amd_zen4(struct cpuinfo
 	}
 }
 
+static bool check_rdseed_microcode(void)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	union zen_patch_rev p;
+	u32 min_rev = 0;
+
+	p.ext_fam	= c->x86 - 0xf;
+	p.model		= c->x86_model;
+	p.ext_model	= c->x86_model >> 4;
+	p.stepping	= c->x86_stepping;
+	/* reserved bits are expected to be 0 in test below */
+	p.__reserved	= 0;
+
+	if (cpu_has(c, X86_FEATURE_ZEN5)) {
+		switch (p.ucode_rev >> 8) {
+		case 0xb0021:	min_rev = 0xb00215a; break;
+		case 0xb1010:	min_rev = 0xb101054; break;
+		default:
+			pr_debug("%s: ucode_rev: 0x%x, current revision: 0x%x\n",
+				 __func__, p.ucode_rev, c->microcode);
+			return false;
+		}
+	}
+
+	if (!min_rev)
+		return false;
+
+	return c->microcode >= min_rev;
+}
+
 static void init_amd_zen5(struct cpuinfo_x86 *c)
 {
+	if (!check_rdseed_microcode()) {
+		clear_cpu_cap(c, X86_FEATURE_RDSEED);
+		msr_clear_bit(MSR_AMD64_CPUID_FN_7, 18);
+		pr_emerg_once("RDSEED32 is broken. Disabling the corresponding CPUID bit.\n");
+	}
 }
 
 static void init_amd(struct cpuinfo_x86 *c)


