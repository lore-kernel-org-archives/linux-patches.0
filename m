Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07FE17744
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62106C433C8;
	Wed,  9 Aug 2023 11:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580619;
	bh=9be2Msyzn0FY9q7rUKK/lLASQ3pcrCS7a1nu7Td4GaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auLST5dJkhWYX/bBZvakp2POH3o1w1dIjkuxDhhEqjxnCtpYkeP3HL2fXNQUXTKue
	 z19iRmpT7SkuA5xcw/r3+QATqye6g2cmAIzotTlpfW2EyXm1WkOtZJxlm7ix7t6/cz
	 LelMqQvG9xPvKNCRSXxabuPDTTMpuk/CD4J4bY7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 090/154] arm64: Fix bit-shifting UB in the MIDR_CPU_MODEL() macro
Date: Wed,  9 Aug 2023 12:42:01 +0200
Message-ID: <20230809103639.969695530@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: D Scott Phillips <scott@os.amperecomputing.com>

commit 8ec8490a1950efeccb00967698cf7cb2fcd25ca7 upstream.

CONFIG_UBSAN_SHIFT with gcc-5 complains that the shifting of
ARM_CPU_IMP_AMPERE (0xC0) into bits [31:24] by MIDR_CPU_MODEL() is
undefined behavior. Well, sort of, it actually spells the error as:

 arch/arm64/kernel/proton-pack.c: In function 'spectre_bhb_loop_affected':
 arch/arm64/include/asm/cputype.h:44:2: error: initializer element is not constant
   (((imp)   << MIDR_IMPLEMENTOR_SHIFT) | \
   ^

This isn't an issue for other Implementor codes, as all the other codes
have zero in the top bit and so are representable as a signed int.

Cast the implementor code to unsigned in MIDR_CPU_MODEL to remove the
undefined behavior.

Fixes: 0e5d5ae837c8 ("arm64: Add AMPERE1 to the Spectre-BHB affected list")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
Link: https://lore.kernel.org/r/20221102160106.1096948-1-scott@os.amperecomputing.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cputype.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -41,7 +41,7 @@
 	(((midr) & MIDR_IMPLEMENTOR_MASK) >> MIDR_IMPLEMENTOR_SHIFT)
 
 #define MIDR_CPU_MODEL(imp, partnum) \
-	(((imp)			<< MIDR_IMPLEMENTOR_SHIFT) | \
+	((_AT(u32, imp)		<< MIDR_IMPLEMENTOR_SHIFT) | \
 	(0xf			<< MIDR_ARCHITECTURE_SHIFT) | \
 	((partnum)		<< MIDR_PARTNUM_SHIFT))
 


