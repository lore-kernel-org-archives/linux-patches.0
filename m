Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C053B6C1E;
	Fri,  4 Sep 2026 05:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498623; cv=none; b=ZgSszLZ/dmk5pewMNcW5rHnDLfWwry7aNQtnUvi/ufvwYglLKp/Aw4TyzJtwk+Gy16gqm0hCHPzWciTtYaaM3JwRPeCjEqPvUsE8zHGXBEyn4UIRSjDxrPuFj7GxXbasjbWYfdCy4AGI82Ka6AS6BSERvjNBKiXrLfxxB1q9Lmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498623; c=relaxed/simple;
	bh=MRpvrkRaEzmcM0almDFv4zVxYmorkb49bJuvUSl8Kbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1Qd4+DU7fPEp79kU4fD+BCgsrYtydy3OwwMTmHCP1PaGv/izgp6DA2+A/d/2ac77L32iqEb/Dr0m66LnrOVIw1SQ1PIFadQbY+ba3Gf6cssw7UcCVMhpqgqkDBPkREmKzTgks60aRUpRIAh3mf12wOcXL7LgTKcHRmqzHLAsM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtrWYuwP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtrWYuwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC8C1F00A3E;
	Fri,  4 Sep 2026 05:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498621;
	bh=I5SP1FJ8qGfpH7hXZ0ez0FHGLkvlZvrlY8Ry7ikpE80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GtrWYuwPNNVc5YiehLnoa2/JCiOSHUHoeDPkKVrDPDIvSX/Ofimm7s6CsWTNNwJl1
	 XtQ6ji9xK7NZdol0RcTlaqSBux+H0PgfIa6vMW74GXxAn1oKXRfhLdNaw5AKsPkhjN
	 C+PB4G4yQuw/NBswhSI/9m8kzKkYCbbTskA+wvt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borys Tsyrulnikov <tsyrulnikov.borys@gmail.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH 7.2 085/713] x86/tdx: Fix zero-extension for 32-bit port I/O
Date: Fri,  4 Sep 2026 06:50:53 +0200
Message-ID: <20260904045805.744993743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

commit 941370fc93cc3474e26811f4d3b062903eefe2cf upstream.

According to x86 architecture rules, 32-bit operations zero-extend the
result to 64 bits. The current implementation of handle_in() only masks
the lower 32 bits, which preserves the upper 32 bits of RAX when a
32-bit port IN instruction is emulated.

Use insn_assign_reg() to write the result back into RAX with proper
partial-register-write semantics: 1- and 2-byte forms leave the upper
bits untouched, the 4-byte form zero-extends to the full register.

Fixes: 03149948832a ("x86/tdx: Port I/O: Add runtime hypercalls")
Reported-by: Borys Tsyrulnikov <tsyrulnikov.borys@gmail.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Link: https://lore.kernel.org/all/CAKw_Dz96rfSQc6Rn+9QBcUFHhmkK+9zu+P=bxowfZwxrATCBRg@mail.gmail.com/
Cc:stable@vger.kernel.org
Link: https://patch.msgid.link/20260713133753.223947-4-kirill@shutemov.name
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/tdx/tdx.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -694,8 +694,8 @@ static bool handle_in(struct pt_regs *re
 		.r13 = PORT_READ,
 		.r14 = port,
 	};
-	u64 mask = GENMASK(BITS_PER_BYTE * size - 1, 0);
 	bool success;
+	u64 val;
 
 	/*
 	 * Emulate the I/O read via hypercall. More info about ABI can be found
@@ -703,11 +703,9 @@ static bool handle_in(struct pt_regs *re
 	 * "TDG.VP.VMCALL<Instruction.IO>".
 	 */
 	success = !__tdx_hypercall(&args);
+	val = success ? args.r11 : 0;
 
-	/* Update part of the register affected by the emulated instruction */
-	regs->ax &= ~mask;
-	if (success)
-		regs->ax |= args.r11 & mask;
+	insn_assign_reg(&regs->ax, val, size);
 
 	return success;
 }


