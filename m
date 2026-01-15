Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852F92D879F;
	Thu, 15 Jan 2026 17:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498408; cv=none; b=dxJm14ZbQg/G3+3eLYND1FWAkKUUV7gm9g5foM7Q77fKMD8ft002HtUERdEVPuEe3q/WDbuKU7rnPYyd1ORxk4NZIf6cf8ThkpynzAQe60JGE1zRsD3iAr6Y7oo/aAWarRmxRKxSkb/HjUAjjDdwGEabgxPYigUpWDD2CQ5PlYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498408; c=relaxed/simple;
	bh=F+yxZV9f2B6kvmdgiaFBg3nseRT3bSu67PWgSyF8mTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvcegexEcTe/RHnteQtTStewySjB5lrzAofoz3ebguNRmuKs/XQEbSp+ilDazoCIwmTs3b1Tr7tFhSAG9BHW7YW7MKQy83uHqVyZTSscqSLObSrLlUVSYKoV5qXJ8ijVTNcKWuI/HXXm/r/dN6b4+wPv4khEX+4c09Zxgx0qXgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqIdM8J9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqIdM8J9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B4CC116D0;
	Thu, 15 Jan 2026 17:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498408;
	bh=F+yxZV9f2B6kvmdgiaFBg3nseRT3bSu67PWgSyF8mTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqIdM8J94KcwpgdiFdZMGPejGYP0buP1axYZYcQMan8XB/vTiCGvCDQ+N7xl3hC9Q
	 vNwIQtmZT8Rgyjn1LJbrZ7QSwhOQYx56zAiivYEjbzQkudu2IDOR0RKIhxPS3sZTBK
	 sYubDAjzL3nPKdUW566OiyPDG9iQ04QhyJ/Rh5MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@stackframe.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 388/554] parisc: entry.S: fix space adjustment on interruption for 64-bit userspace
Date: Thu, 15 Jan 2026 17:47:34 +0100
Message-ID: <20260115164300.282163433@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@stackframe.org>

commit 1aa4524c0c1b54842c4c0a370171d11b12d0709b upstream.

In wide mode, the IASQ contain the upper part of the GVA
during interruption. This needs to be reversed before
the space is used - otherwise it contains parts of IAOQ.
See Page 2-13 "Processing Resources / Interruption Instruction
Address Queues" in the Parisc 2.0 Architecture Manual page 2-13
for an explanation.

The IAOQ/IASQ space_adjust was skipped for other interruptions
than itlb misses. However, the code in handle_interruption()
checks whether iasq[0] contains a valid space. Due to the not
masked out bits this match failed and the process was killed.

Also add space_adjust for IAOQ1/IASQ1 so ptregs contains sane values.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/entry.S |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -1072,8 +1072,6 @@ ENTRY_CFI(intr_save)		/* for os_hpmc */
 	STREG           %r17, PT_IOR(%r29)
 
 #if defined(CONFIG_64BIT)
-	b,n		intr_save2
-
 skip_save_ior:
 	/* We have a itlb miss, and when executing code above 4 Gb on ILP64, we
 	 * need to adjust iasq/iaoq here in the same way we adjusted isr/ior
@@ -1082,10 +1080,17 @@ skip_save_ior:
 	bb,COND(>=),n	%r8,PSW_W_BIT,intr_save2
 	LDREG		PT_IASQ0(%r29), %r16
 	LDREG		PT_IAOQ0(%r29), %r17
-	/* adjust iasq/iaoq */
+	/* adjust iasq0/iaoq0 */
 	space_adjust	%r16,%r17,%r1
 	STREG           %r16, PT_IASQ0(%r29)
 	STREG           %r17, PT_IAOQ0(%r29)
+
+	LDREG		PT_IASQ1(%r29), %r16
+	LDREG		PT_IAOQ1(%r29), %r17
+	/* adjust iasq1/iaoq1 */
+	space_adjust	%r16,%r17,%r1
+	STREG           %r16, PT_IASQ1(%r29)
+	STREG           %r17, PT_IAOQ1(%r29)
 #else
 skip_save_ior:
 #endif


