Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB3F411A09;
	Thu, 30 Jul 2026 14:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422831; cv=none; b=giMdKSDXmBZdo/RZdgwRWyBKTazz5YGPw9AtBLAQ5r1+Eu2ftOnjWN0lxUnrAI6ozQctrSVw1KrJlyEgDWYlKDnkBPtbh9QqwTcMPCDsAM6zccDBV5qDMHsOmz9pHNW1nXdSpP+V4jziUFx6i3G/C0XP4Qnm9z2IKfyOUn6UE0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422831; c=relaxed/simple;
	bh=E1+nx/5I2izLFjMHQscE6/U3a/nEwlCYsNJFMrm02ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzGQUTWkCMK/Vw+zYUH7w1v8km677naE2OQjcD1APsx+XjFT39MYcWR9LBseN62xYTIzagSZDq5m3hAGWqs/XvZjzB/B5zTbzq6fUQ4usYAEgVFfnaEnXqMRr9cZoRuBPu8PRiNg1htidG6lj773yQ4/ElT0p2sqfohkVVd8t6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFeDPHcx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFeDPHcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1312A1F000E9;
	Thu, 30 Jul 2026 14:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422830;
	bh=SpUeO1B6dcjLHYx5eAtQNbZWSxbyNxMqBgGXgqQtpSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFeDPHcxSufAnauCsXv7xVK7x6dLrc62BjReS2N2XNFP2okZawfOMoJ9l3BBfV7Ji
	 b/lH5AJHi3dxw9OfyJ4o1V3z3i2bKKcu4KgneobPSygBo5zfv09pbl9S5n5+Ud7oR6
	 Ldzsx6BBe8NVtlnBgnFSqnqffWVRBVcl3wvKtOeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoran Jiang <jianghaoran@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.1 571/744] LoongArch: Fix oops during single-step debugging
Date: Thu, 30 Jul 2026 16:14:04 +0200
Message-ID: <20260730141456.422203604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoran Jiang <jianghaoran@kylinos.cn>

commit 73555fdab5e1e4f24ca000c41a616b34edf4b55d upstream.

When entering KDB via a breakpoint and then performing single-step
debugging, an oops is triggered. Now during single-step debugging,
kdb_local() expects the reason to be KDB_REASON_SSTEP, but it is
actually KDB_REASON_OOPS. In kdb_stub(), when determining the reason,
the ex_vector for single-step should be 0, as already implemented on
other architectures such as arm64 and riscv.

Before the patch:
[112]kdb> ss

Entering kdb (current=0x900020009f520000, pid 10661) on
processor 112 Oops: (null)
due to oops @ 0x90000000005b57a4

Cc: stable@vger.kernel.org
Signed-off-by: Haoran Jiang <jianghaoran@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/kgdb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kernel/kgdb.c
+++ b/arch/loongarch/kernel/kgdb.c
@@ -252,7 +252,8 @@ static int kgdb_loongarch_notify(struct
 	if (atomic_read(&kgdb_active) != -1)
 		kgdb_nmicallback(smp_processor_id(), regs);
 
-	if (kgdb_handle_exception(args->trapnr, args->signr, cmd, regs))
+	if (kgdb_handle_exception(regs->csr_era == stepped_address ? 0 : args->trapnr,
+				  args->signr, cmd, regs))
 		return NOTIFY_DONE;
 
 	if (atomic_read(&kgdb_setting_breakpoint))


