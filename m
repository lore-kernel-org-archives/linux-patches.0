Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CD21714D9;
	Thu, 15 Aug 2024 14:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732207; cv=none; b=hWdkjgDD4IYT3wpqyU2FVYOu1PFCGtexzSoZjFx8kjGRorPuDTqgtOyEVDqXzQIOvY/BN6Nmxg0YeIt9Mtg7qPY0/7UkP9yKa0HwM2EvyYlTDLrQJxrT8gpxYgGDIO/0mtyXlYrQMiG5TYSlAxiirP1OwWMj1EjFiQFiPr6kJjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732207; c=relaxed/simple;
	bh=BajY4aW/4A5p6qIGKaCS+P3Vo+YVSaN62aLtDVu9QZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IS2JuPIxCUXVypjG1Sr+YtD7bw0i0Ukonvn8B3Shpnff+rdGIfak94V7AYNFrGu10hRMl3Kj/FSmhcUDSyu5/wosyJjKOtIN78hcH5GZRxjXNbTVOEYekmA55EE/5VOQgiWfA6lEjpiIc2JN001ZfzVRyiE/sz0TNBYocjFJGnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFDd/Ifz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFDd/Ifz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BECC32786;
	Thu, 15 Aug 2024 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732207;
	bh=BajY4aW/4A5p6qIGKaCS+P3Vo+YVSaN62aLtDVu9QZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFDd/Ifz5Lg+45aoipB52PYyLqBgZSYPHQjaunI6ANzMcKrEBo2iLuGYSGWsCzQA6
	 +Zky/UIjlKH+jSuhelUcZOa5kTOSx6fvjUXDhsgVuYozS7gbPMkU35U9RiY6SNsn2/
	 Kjq9MvTrRik7sPvGeNVB9iFv1zed/eywJ/dy44Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/352] powerpc/xmon: Fix disassembly CPU feature checks
Date: Thu, 15 Aug 2024 15:22:53 +0200
Message-ID: <20240815131923.393212966@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 14196e47c5ffe32af7ed5a51c9e421c5ea5bccce ]

In the xmon disassembly code there are several CPU feature checks to
determine what dialects should be passed to the disassembler. The
dialect controls which instructions the disassembler will recognise.

Unfortunately the checks are incorrect, because instead of passing a
single CPU feature they are passing a mask of feature bits.

For example the code:

  if (cpu_has_feature(CPU_FTRS_POWER5))
      dialect |= PPC_OPCODE_POWER5;

Is trying to check if the system is running on a Power5 CPU. But
CPU_FTRS_POWER5 is a mask of *all* the feature bits that are enabled on
a Power5.

In practice the test will always return true for any 64-bit CPU, because
at least one bit in the mask will be present in the CPU_FTRS_ALWAYS
mask.

Similarly for all the other checks against CPU_FTRS_xx masks.

Rather than trying to match the disassembly behaviour exactly to the
current CPU, just differentiate between 32-bit and 64-bit, and Altivec,
VSX and HTM.

That will cause some instructions to be shown in disassembly even
on a CPU that doesn't support them, but that's OK, objdump -d output
has the same behaviour, and if anything it's less confusing than some
instructions not being disassembled.

Fixes: 897f112bb42e ("[POWERPC] Import updated version of ppc disassembly code for xmon")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240509121248.270878-2-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/xmon/ppc-dis.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/xmon/ppc-dis.c b/arch/powerpc/xmon/ppc-dis.c
index 75fa98221d485..af105e1bc3fca 100644
--- a/arch/powerpc/xmon/ppc-dis.c
+++ b/arch/powerpc/xmon/ppc-dis.c
@@ -122,32 +122,21 @@ int print_insn_powerpc (unsigned long insn, unsigned long memaddr)
   bool insn_is_short;
   ppc_cpu_t dialect;
 
-  dialect = PPC_OPCODE_PPC | PPC_OPCODE_COMMON
-            | PPC_OPCODE_64 | PPC_OPCODE_POWER4 | PPC_OPCODE_ALTIVEC;
+  dialect = PPC_OPCODE_PPC | PPC_OPCODE_COMMON;
 
-  if (cpu_has_feature(CPU_FTRS_POWER5))
-    dialect |= PPC_OPCODE_POWER5;
+  if (IS_ENABLED(CONFIG_PPC64))
+    dialect |= PPC_OPCODE_64 | PPC_OPCODE_POWER4 | PPC_OPCODE_CELL |
+	PPC_OPCODE_POWER5 | PPC_OPCODE_POWER6 | PPC_OPCODE_POWER7 | PPC_OPCODE_POWER8 |
+	PPC_OPCODE_POWER9;
 
-  if (cpu_has_feature(CPU_FTRS_CELL))
-    dialect |= (PPC_OPCODE_CELL | PPC_OPCODE_ALTIVEC);
+  if (cpu_has_feature(CPU_FTR_TM))
+    dialect |= PPC_OPCODE_HTM;
 
-  if (cpu_has_feature(CPU_FTRS_POWER6))
-    dialect |= (PPC_OPCODE_POWER5 | PPC_OPCODE_POWER6 | PPC_OPCODE_ALTIVEC);
+  if (cpu_has_feature(CPU_FTR_ALTIVEC))
+    dialect |= PPC_OPCODE_ALTIVEC | PPC_OPCODE_ALTIVEC2;
 
-  if (cpu_has_feature(CPU_FTRS_POWER7))
-    dialect |= (PPC_OPCODE_POWER5 | PPC_OPCODE_POWER6 | PPC_OPCODE_POWER7
-                | PPC_OPCODE_ALTIVEC | PPC_OPCODE_VSX);
-
-  if (cpu_has_feature(CPU_FTRS_POWER8))
-    dialect |= (PPC_OPCODE_POWER5 | PPC_OPCODE_POWER6 | PPC_OPCODE_POWER7
-		| PPC_OPCODE_POWER8 | PPC_OPCODE_HTM
-		| PPC_OPCODE_ALTIVEC | PPC_OPCODE_ALTIVEC2 | PPC_OPCODE_VSX);
-
-  if (cpu_has_feature(CPU_FTRS_POWER9))
-    dialect |= (PPC_OPCODE_POWER5 | PPC_OPCODE_POWER6 | PPC_OPCODE_POWER7
-		| PPC_OPCODE_POWER8 | PPC_OPCODE_POWER9 | PPC_OPCODE_HTM
-		| PPC_OPCODE_ALTIVEC | PPC_OPCODE_ALTIVEC2
-		| PPC_OPCODE_VSX | PPC_OPCODE_VSX3);
+  if (cpu_has_feature(CPU_FTR_VSX))
+    dialect |= PPC_OPCODE_VSX | PPC_OPCODE_VSX3;
 
   /* Get the major opcode of the insn.  */
   opcode = NULL;
-- 
2.43.0



