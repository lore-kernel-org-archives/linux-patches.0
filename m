Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDFF246327;
	Tue, 20 May 2025 14:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750300; cv=none; b=sXoDay/AKesh7vOIk43z00Wp26OyHR/3sC3VOo/ivb/RsalJhYZbjdYGyA8MyrlLQ4QTlC6sBBeXnw7JURwggdVt97015WpLeovuLnlVEIB7fdFgdeiVSufoRYZc4lqKDxxgGrmI+bDK3UP+G4lx7jdoINTSUvg1G10W8yiSjw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750300; c=relaxed/simple;
	bh=A3py9v57tVl3h34swCfUX6zXvkmgqn7ugeIz2hiIqjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZF+gG4Dx3FEcrjPgyteoNakkoPZ8Rq8uzSSLwtTG7lGP8h74f+899vQAKU1xrfapw7TizkZ83McRbMszqYjAgaQNJy0jPLbEAdpz9U5UKLPqwq51KI0yWdKhvkYsYWPTF01n5D+RuXFmUXRrlztkXN031soAzaaqvGMnvLcPFJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhX5nEK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhX5nEK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E838C4CEE9;
	Tue, 20 May 2025 14:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750300;
	bh=A3py9v57tVl3h34swCfUX6zXvkmgqn7ugeIz2hiIqjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhX5nEK4huaposwNYcAgkSa21Vc/qEWvtMstdCdfHuXb6avYxfYtTehEvSUFVZ2BD
	 Klo+8+B6ItQ9zUZmLd7dr3JJIF9pZkQ09W7uXVSPX4T0JlyAUnkZ3jZuUCQtPMqdEU
	 ncZ1fxlbGBzHIG0SCOArnlSOFbxsRab1KIbSRC2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 077/143] LoongArch: uprobes: Remove user_{en,dis}able_single_step()
Date: Tue, 20 May 2025 15:50:32 +0200
Message-ID: <20250520125813.094935820@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 0b326b2371f94e798137cc1a3c5c2eef2bc69061 upstream.

When executing the "perf probe" and "perf stat" test cases about some
cryptographic algorithm, the output shows that "Trace/breakpoint trap".
This is because it uses the software singlestep breakpoint for uprobes
on LoongArch, and no need to use the hardware singlestep. So just remove
the related function call to user_{en,dis}able_single_step() for uprobes
on LoongArch.

How to reproduce:

Please make sure CONFIG_UPROBE_EVENTS is set and openssl supports sm2
algorithm, then execute the following command.

cd tools/perf && make
./perf probe -x /usr/lib64/libcrypto.so BN_mod_mul_montgomery
./perf stat -e probe_libcrypto:BN_mod_mul_montgomery openssl speed sm2

Cc: stable@vger.kernel.org
Fixes: 19bc6cb64092 ("LoongArch: Add uprobes support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/uprobes.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/loongarch/kernel/uprobes.c
+++ b/arch/loongarch/kernel/uprobes.c
@@ -42,7 +42,6 @@ int arch_uprobe_pre_xol(struct arch_upro
 	utask->autask.saved_trap_nr = current->thread.trap_nr;
 	current->thread.trap_nr = UPROBE_TRAP_NR;
 	instruction_pointer_set(regs, utask->xol_vaddr);
-	user_enable_single_step(current);
 
 	return 0;
 }
@@ -59,8 +58,6 @@ int arch_uprobe_post_xol(struct arch_upr
 	else
 		instruction_pointer_set(regs, utask->vaddr + LOONGARCH_INSN_SIZE);
 
-	user_disable_single_step(current);
-
 	return 0;
 }
 
@@ -70,7 +67,6 @@ void arch_uprobe_abort_xol(struct arch_u
 
 	current->thread.trap_nr = utask->autask.saved_trap_nr;
 	instruction_pointer_set(regs, utask->vaddr);
-	user_disable_single_step(current);
 }
 
 bool arch_uprobe_xol_was_trapped(struct task_struct *t)


