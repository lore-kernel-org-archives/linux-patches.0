Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEDB1F4266;
	Mon, 21 Oct 2024 10:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507050; cv=none; b=PhKKlUomQlEqPWz5JtIxwRgpJTGEBUi2eCwN27aqBuVy0qTLh5f5n7eJMkili3kg9dJziUpqRKC5fitZASJv7dA6yvyJ+d9plUrdnt9UNLi0l2DkT295cVOpA8dBD9PBI/VIDILISDgIvRYE/htiKAWCUYVwotV1yNVsFlVx7J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507050; c=relaxed/simple;
	bh=Wr7FTMzp20OhCFGzkRUrk37wlBRxYNLqwgnZVl5dn+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBB2eODJVWh3hz4Zmp/x57/uVAnCRHYA5Ywk0xEvJpocG51fZKdPDqavOH5fhw5yM18vbZDVoer+FwULoo1riom4I+xM60R7qFtl6kxGR1eAJ8FaiDjvlsywJjU1lX+OiBtDRaL3e8wn8oQ1TgmhB+MhG/NbQwFxW9N1b9Vg8+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDbKiYxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDbKiYxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E70C4CEC3;
	Mon, 21 Oct 2024 10:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507049;
	bh=Wr7FTMzp20OhCFGzkRUrk37wlBRxYNLqwgnZVl5dn+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDbKiYxibc+YoN1Q3N2DboEcDAKV5xhksIU7/bboQD2WbxSkpzhOlj6vbh0Iw1Iot
	 kKwWuoBgADMPKgf/LCn8Nci3YzK+Op7EdFkineEZWsw/d1Y6PpmD1BZa8HrCZ+5lyH
	 BS8Gl/4xtW2zlMGTq8i/dNFzz4I+Hla0HibRt0Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Wikner <kwikner@ethz.ch>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.6 055/124] x86/cpufeatures: Add a IBPB_NO_RET BUG flag
Date: Mon, 21 Oct 2024 12:24:19 +0200
Message-ID: <20241021102258.859450907@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

From: Johannes Wikner <kwikner@ethz.ch>

commit 3ea87dfa31a7b0bb0ff1675e67b9e54883013074 upstream.

Set this flag if the CPU has an IBPB implementation that does not
invalidate return target predictions. Zen generations < 4 do not flush
the RSB when executing an IBPB and this bug flag denotes that.

  [ bp: Massage. ]

Signed-off-by: Johannes Wikner <kwikner@ethz.ch>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/kernel/cpu/common.c       |    3 +++
 2 files changed, 4 insertions(+)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -517,4 +517,5 @@
 #define X86_BUG_DIV0			X86_BUG(1*32 + 1) /* AMD DIV0 speculation bug */
 #define X86_BUG_RFDS			X86_BUG(1*32 + 2) /* CPU is vulnerable to Register File Data Sampling */
 #define X86_BUG_BHI			X86_BUG(1*32 + 3) /* CPU is affected by Branch History Injection */
+#define X86_BUG_IBPB_NO_RET		X86_BUG(1*32 + 4) /* "ibpb_no_ret" IBPB omits return target predictions */
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1483,6 +1483,9 @@ static void __init cpu_set_bug_bits(stru
 	     boot_cpu_has(X86_FEATURE_HYPERVISOR)))
 		setup_force_cpu_bug(X86_BUG_BHI);
 
+	if (cpu_has(c, X86_FEATURE_AMD_IBPB) && !cpu_has(c, X86_FEATURE_AMD_IBPB_RET))
+		setup_force_cpu_bug(X86_BUG_IBPB_NO_RET);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 


