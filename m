Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A15F3F39D7;
	Wed, 20 May 2026 17:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299895; cv=none; b=PywRMb5VXnHKoxt4wQKj6DKIYq3nbPUQWK6PuMhOk2wsAWq6eYoXA7kQzTxmQsTrCtnTH1CXiC7f+zrxEBzWszIJOBim6V5CQFP093iSsuiT3/wBO1yXGtc47HMtEbAXJqCwqAyh1Kl4J6LhuyLDCUkBf4Qt72pEY9spsZCx5yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299895; c=relaxed/simple;
	bh=FlGeZ0B6xicd+19aJ4dtVrD4Etmu84IZsYmd9lt4Jb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTFw5N7egpHm0umm+Dotw3MW0oiI71OnaQf/SX/h/iPI+tifSq11dSGCjX/bC1iqUVZbqwmNz5rIT1MrxwcX0cOZsbqiRNYDGmp6EfgQkKH2WOqeP74lbPS4P+Y3ZN5pop3BKmk2yFErC7mScnhzQ9yqgTlxaK2JEFKIPpWidrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdlNdMTn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdlNdMTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA631F000E9;
	Wed, 20 May 2026 17:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299891;
	bh=+uacOUMqOAL7ZcJAzWakX7lCQG1rR09fG4xRc2e8C6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xdlNdMTnyPefBcxqX8tu2PK3Zztq4GbSnB++Qa8Uhxvtd+SvbOPlD97HeA+sNDAX+
	 9YzYNZkNOMu0R7W4q7kfjQio2co8lEaFUy6G2bhncnj7wy8kqDKNaxK1a94ScLynCJ
	 98W2Ys0vjEOmDi4r/DAFcIVrWcuADEqsN9WaKsWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Conor Dooley <conor.dooley@microchip.com>,
	Paul Walmsley <pjw@kernel.org>,
	Songsong Zhang <U2FsdGVkX1@gmail.com>
Subject: [PATCH 6.18 924/957] riscv: misaligned: Make enabling delegation depend on NONPORTABLE
Date: Wed, 20 May 2026 18:23:27 +0200
Message-ID: <20260520162154.619467251@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivian Wang <wangruikang@iscas.ac.cn>

commit b69bcb13ed7024a84d6cd8ad330f1e32782fcf28 upstream.

The unaligned access emulation code in Linux has various deficiencies.
For example, it doesn't emulate vector instructions [1] [2], and doesn't
emulate KVM guest accesses. Therefore, requesting misaligned exception
delegation with SBI FWFT actually regresses vector instructions' and KVM
guests' behavior.

Until Linux can handle it properly, guard these sbi_fwft_set() calls
behind RISCV_SBI_FWFT_DELEGATE_MISALIGNED, which in turn depends on
NONPORTABLE. Those who are sure that this wouldn't be a problem can
enable this option, perhaps getting better performance.

The rest of the existing code proceeds as before, except as if
SBI_FWFT_MISALIGNED_EXC_DELEG is not available, to handle any remaining
address misaligned exceptions on a best-effort basis. The KVM SBI FWFT
implementation is also not touched, but it is disabled if the firmware
emulates unaligned accesses.

Cc: stable@vger.kernel.org
Fixes: cf5a8abc6560 ("riscv: misaligned: request misaligned exception from SBI")
Reported-by: Songsong Zhang <U2FsdGVkX1@gmail.com> # KVM
Link: https://lore.kernel.org/linux-riscv/38ce44c1-08cf-4e3f-8ade-20da224f529c@iscas.ac.cn/ [1]
Link: https://lore.kernel.org/linux-riscv/b3cfcdac-0337-4db0-a611-258f2868855f@iscas.ac.cn/ [2]
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260401-riscv-misaligned-dont-delegate-v2-1-5014a288c097@iscas.ac.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig                   |   22 ++++++++++++++++++++++
 arch/riscv/kernel/traps_misaligned.c |    2 +-
 2 files changed, 23 insertions(+), 1 deletion(-)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -925,6 +925,28 @@ config RISCV_VECTOR_MISALIGNED
 	help
 	  Enable detecting support for vector misaligned loads and stores.
 
+config RISCV_SBI_FWFT_DELEGATE_MISALIGNED
+	bool "Request firmware delegation of unaligned access exceptions"
+	depends on RISCV_SBI
+	depends on NONPORTABLE
+	help
+	  Use SBI FWFT to request delegation of load address misaligned and
+	  store address misaligned exceptions, if possible, and prefer Linux
+	  kernel emulation of these accesses to firmware emulation.
+
+	  Unfortunately, Linux's emulation is still incomplete. Namely, it
+	  currently does not handle vector instructions and KVM guest accesses.
+	  On platforms where these accesses would have been handled by firmware,
+	  enabling this causes unexpected kernel oopses, userspaces crashes and
+	  KVM guest crashes. If you are sure that these are not a problem for
+	  your platform, you can say Y here, which may improve performance.
+
+	  Saying N here will not worsen emulation support for unaligned accesses
+	  even in the case where the firmware also has incomplete support. It
+	  simply keeps the firmware's emulation enabled.
+
+	  If you don't know what to do here, say N.
+
 choice
 	prompt "Unaligned Accesses Support"
 	default RISCV_PROBE_UNALIGNED_ACCESS
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -584,7 +584,7 @@ static int cpu_online_check_unaligned_ac
 
 static bool misaligned_traps_delegated;
 
-#ifdef CONFIG_RISCV_SBI
+#if defined(CONFIG_RISCV_SBI_FWFT_DELEGATE_MISALIGNED)
 
 static int cpu_online_sbi_unaligned_setup(unsigned int cpu)
 {


