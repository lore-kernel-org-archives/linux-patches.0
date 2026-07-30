Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EB83B0598;
	Thu, 30 Jul 2026 15:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424667; cv=none; b=F2JE8CZYAC1S4+JZFPW/53bnY2scB3tT+4/zD7mIEmkR0rGzEerF9bf5GVuQ8Jfzbh/NXKtZnWIqnmx5qTtreGWQ0IXFRzhPEzUhZtPzaJOOW+GaGdmUhhJWOz42B/Pns+leLUjx55JS1tPM+vmK2FrHirZdnVpwEIcSeAbJtAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424667; c=relaxed/simple;
	bh=IRUjcKFgsy+7mFlR0tEE3py6addTl5hvCGR59Uenwrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vo4nVB6BjyOLe4gkZEyysl/AELMib1WGU9ReVgkiXTyqS8fDL9AIZGnLWK3Ws7sn34Vb5+u7L3YnFaenzx5M1dxywKysJeJT7eSFwzNbhtrCFcXbTfhQ5h3mHF0lnLWfxRr931RYSP+DqipXjibwhydTrUp9eme9YQWc6i6SRBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBrPSl08; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBrPSl08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BE81F000E9;
	Thu, 30 Jul 2026 15:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424666;
	bh=oZoLLFbfEGNVCFItNjeon3fvz61uKtZpO50C4RhkEIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBrPSl08OeC3+sD2Dxwtzc2dgsyIVfna+idAWoUpCsWtRLLAuKxbttZ+WNtCaA6T8
	 Kvv72ScQMYQWVhb0lzVK2GjZ2psZzn8y8+PM0sjzU7mMsoj2EcP+BL8AE15OdgH6Vs
	 dY5w56A0L00nKWFHFT9Gu14tdHCDOyovQgV1Pl9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoran Jiang <jianghaoran@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 474/675] LoongArch: Fix oops during single-step debugging
Date: Thu, 30 Jul 2026 16:13:24 +0200
Message-ID: <20260730141455.202351096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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


