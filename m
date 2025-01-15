Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664B3248BB2;
	Wed, 15 Jan 2025 10:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938216; cv=none; b=VHkLeCMOr3mtYUBYOznImJu8IQmnibpyNq8qdbHHMMO1Bze2ItcWB4WFbw1L/jGdXH1d47btnUIGDJpMR8vxYdXJWsD2nke1GhXko4Fa9+bvHoKhGOQmnFheLiQSi2NJpwzcjQKmT6iI8TpVFzMFFZ52+EEBV8tuB4J/luVv0Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938216; c=relaxed/simple;
	bh=umRDkJ49bTZeUumtIXM+FG6byoj5/8DFlmonhfmuChM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sc66/r3dN5lho3gbWP0ZMEUZr3tZ7R3SMmp40F9AGcDQXPg2PCRJRban8H4lJ3MtZ5hD7XVfhmgssvIjegmffy/66pT4RzSoa4fEqppKTsHea+9VVdbAFfAZWiLa+4a8zeJY3jU/ZuSoJjf07/E/4fWbjcPOQq7kNYOd4pIfoqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvpUVmTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvpUVmTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6C2C4CEDF;
	Wed, 15 Jan 2025 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938216;
	bh=umRDkJ49bTZeUumtIXM+FG6byoj5/8DFlmonhfmuChM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvpUVmTQ/KlvTxk3HKW9lYA78B2eQkh1f6Ra+3GyM2qQwg3dAMtCPCUsiSIDeTIFV
	 UwBd2/UpzZwowq/WHmSuwGKTvMJI4+HEUilcyvgZAaF04jBUIjg59wgey1bXRdvmsw
	 wyid660J48kf0Nbt8761qMygyVgVMBg9qYHiSDrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.12 117/189] riscv: kprobes: Fix incorrect address calculation
Date: Wed, 15 Jan 2025 11:36:53 +0100
Message-ID: <20250115103611.129223109@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Nam Cao <namcao@linutronix.de>

commit 13134cc949148e1dfa540a0fe5dc73569bc62155 upstream.

p->ainsn.api.insn is a pointer to u32, therefore arithmetic operations are
multiplied by four. This is clearly undesirable for this case.

Cast it to (void *) first before any calculation.

Below is a sample before/after. The dumped memory is two kprobe slots, the
first slot has

  - c.addiw a0, 0x1c (0x7125)
  - ebreak           (0x00100073)

and the second slot has:

  - c.addiw a0, -4   (0x7135)
  - ebreak           (0x00100073)

Before this patch:

(gdb) x/16xh 0xff20000000135000
0xff20000000135000:	0x7125	0x0000	0x0000	0x0000	0x7135	0x0010	0x0000	0x0000
0xff20000000135010:	0x0073	0x0010	0x0000	0x0000	0x0000	0x0000	0x0000	0x0000

After this patch:

(gdb) x/16xh 0xff20000000125000
0xff20000000125000:	0x7125	0x0073	0x0010	0x0000	0x7135	0x0073	0x0010	0x0000
0xff20000000125010:	0x0000	0x0000	0x0000	0x0000	0x0000	0x0000	0x0000	0x0000

Fixes: b1756750a397 ("riscv: kprobes: Use patch_text_nosync() for insn slots")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20241119111056.2554419-1-namcao@linutronix.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/probes/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -30,7 +30,7 @@ static void __kprobes arch_prepare_ss_sl
 	p->ainsn.api.restore = (unsigned long)p->addr + len;
 
 	patch_text_nosync(p->ainsn.api.insn, &p->opcode, len);
-	patch_text_nosync(p->ainsn.api.insn + len, &insn, GET_INSN_LENGTH(insn));
+	patch_text_nosync((void *)p->ainsn.api.insn + len, &insn, GET_INSN_LENGTH(insn));
 }
 
 static void __kprobes arch_prepare_simulate(struct kprobe *p)


