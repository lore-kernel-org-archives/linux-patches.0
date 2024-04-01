Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF5846420;
	Mon,  1 Apr 2024 15:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986763; cv=none; b=MyQH3CrvwPeNBlTdGei+WQu7jq5sg6cYGjQIdVN92fVJz9F+fziWGSC2CWC33gygrg4/GxbilWO/juG5+iqOypdPKOYg6jUrA/Y6+dsnQUHjjUygi+a1RYCInzUKJ1CnpIDz/DaBVYzEwCVPgWhCv3R9xbzHl8VustlPq5ytfvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986763; c=relaxed/simple;
	bh=4NqSPQPPVhuYUlqYN1Bjh3h9IqipgsUpJfias/3VXlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8eUQWQy3W6ohUvQLwDTe5hgCQoGCWEjOgIleHpFgNFshW4IMLs3zme5spOhYdDKoNDd9wut35Fu2EQGD9bJ3E4Q3cKSSHR6DndZ/w4GsGf5ANDe2zvns1pLEbEDBDHjwATw1hQKBtY49xPdcHsDOrKfzoUNyVlPPkfI/tzZiQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wuxl8E4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wuxl8E4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48496C433C7;
	Mon,  1 Apr 2024 15:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986763;
	bh=4NqSPQPPVhuYUlqYN1Bjh3h9IqipgsUpJfias/3VXlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wuxl8E4ZoE9IuevR5hleAAYn7/p3JlHAIPPOOyRRaLw6ERooaNoT+wKMZvoFiDtMO
	 ToB2JljTqrIsVuJCM4mggWPubKw7FmDDSv/QugLmnW4Sr7MWJQMRPD6PMGbgq2sBgZ
	 7EbTIoMv1jE518ZtBD3jrVsruHaaJsMDG1iTRJog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan-Benedict Glaw <jbglaw@lug-owl.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 078/399] powerpc/fsl: Fix mfpmr build errors with newer binutils
Date: Mon,  1 Apr 2024 17:40:44 +0200
Message-ID: <20240401152551.510962656@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 5f491356b7149564ab22323ccce79c8d595bfd0c ]

Binutils 2.38 complains about the use of mfpmr when building
ppc6xx_defconfig:

    CC      arch/powerpc/kernel/pmc.o
  {standard input}: Assembler messages:
  {standard input}:45: Error: unrecognized opcode: `mfpmr'
  {standard input}:56: Error: unrecognized opcode: `mtpmr'

This is because by default the kernel is built with -mcpu=powerpc, and
the mt/mfpmr instructions are not defined.

It can be avoided by enabling CONFIG_E300C3_CPU, but just adding that to
the defconfig will leave open the possibility of randconfig failures.

So add machine directives around the mt/mfpmr instructions to tell
binutils how to assemble them.

Cc: stable@vger.kernel.org
Reported-by: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240229122521.762431-3-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/reg_fsl_emb.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/reg_fsl_emb.h b/arch/powerpc/include/asm/reg_fsl_emb.h
index a21f529c43d96..8359c06d92d9f 100644
--- a/arch/powerpc/include/asm/reg_fsl_emb.h
+++ b/arch/powerpc/include/asm/reg_fsl_emb.h
@@ -12,9 +12,16 @@
 #ifndef __ASSEMBLY__
 /* Performance Monitor Registers */
 #define mfpmr(rn)	({unsigned int rval; \
-			asm volatile("mfpmr %0," __stringify(rn) \
+			asm volatile(".machine push; " \
+				     ".machine e300; " \
+				     "mfpmr %0," __stringify(rn) ";" \
+				     ".machine pop; " \
 				     : "=r" (rval)); rval;})
-#define mtpmr(rn, v)	asm volatile("mtpmr " __stringify(rn) ",%0" : : "r" (v))
+#define mtpmr(rn, v)	asm volatile(".machine push; " \
+				     ".machine e300; " \
+				     "mtpmr " __stringify(rn) ",%0; " \
+				     ".machine pop; " \
+				     : : "r" (v))
 #endif /* __ASSEMBLY__ */
 
 /* Freescale Book E Performance Monitor APU Registers */
-- 
2.43.0



