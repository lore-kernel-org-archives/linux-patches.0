Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81BE407CEF;
	Thu, 30 Jul 2026 16:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427756; cv=none; b=oT0N2HdxCmKWfDJcbQM+iDWvmKqtNS5rxWDXP6OfI2HDgRzCQb00pN2E35Ciii8E8GXPiBk60bdh3snnTW95izXqNN0jJY6nyewG+NlKneOjpm5FQCBEnrODL8pWrYY0ek8eQdJGG/W+9fm+Yf9XdobgwUTIUKGUNkjEVIwb3aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427756; c=relaxed/simple;
	bh=7bIbvMcrrHH0pMUY13j/P9ZXLJSwwpEnQ/n6452QW80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N78hoKXPpxppNhNK3XxMRiKvFkPC9jEtzLkM4/RLVUvHtSLW/Df2xwSHz1TjwlwHy7DXoDz60vql2jexv8rLdvdIT4BmFXDnO3H8LucE5bsURx2y4rek4CGdrKETDcQ4KhxibUVf/DnP41pU3PyUg+YDTfmZjU0rW6g8TfI/120=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IN9ZR2nJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IN9ZR2nJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A691F000E9;
	Thu, 30 Jul 2026 16:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427755;
	bh=TjMv2ufwSVUMDjZi346+VBit/ph8Vbl4aUHg8gkE5iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IN9ZR2nJgX6yeGvDF36i2oylLeWfj3p4hMM8dX0I4haw8ITYu9yQNcvVrpONtJx12
	 JsH6PrKZZWS9MO+BuBoP0i5devF+43RE6YrmbnIl3lVtxApq1f+s75h/P5Sfco5YZH
	 dBonFHKzmHb3MI5MRPDpigOg9UdROq+cBC1JNrWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoran Jiang <jianghaoran@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 283/484] LoongArch: Fix oops during single-step debugging
Date: Thu, 30 Jul 2026 16:13:00 +0200
Message-ID: <20260730141429.639020433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


