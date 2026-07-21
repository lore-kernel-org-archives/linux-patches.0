Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BD438399A;
	Tue, 21 Jul 2026 17:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654034; cv=none; b=X61DCdvWPzbdYybnRaoWUS8TV0y95cYHOYvD6XEUokBOSxu55hWlztac+1fatSbkygeidX4HcqhI9a2G1WcbYVVbZ21NDB2+b3u8kwLazC2pvpIvsbKfFqvRmGLFm/9RahdFWFcBrVFcQGDd9QHxxzfLnXjkxBeIbMSYv9pf3qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654034; c=relaxed/simple;
	bh=dLmeNg+xnGRmqkRSwE1VP598pUeaBe9gttY3+B6Zmb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEjvMEpZtz25pMBRYqZn9F/UhG29nAYJhhIB12Zy3Q4eus2LxPeiHofMybyEDLnq2OhPViN7+hOXk7l/oADSHFwAiggPuRcwzSnehDBgDcmZBZtPZ3Fmm+4Tf9x8O1fJAoZPeU0gODjtfNM6nGPeXJTfAfhpNPSCNAjqKkN4APo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdAOYhpv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdAOYhpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494651F000E9;
	Tue, 21 Jul 2026 17:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654033;
	bh=wOWpdgy9CRTAPs4zOnh/dA6GyoMOCylWTefIbxft7iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdAOYhpvuzZonHcOT6rn108jDnHjg3dp/mkhk7W6lB/8PW1SaY9VAvJk1p8kAyfWo
	 pK96LzVBB+Hmwe+LoApcw/DsDLmCOnoQ18kwbj4uNKCclrMexyOCT2oZ03bsro3e5h
	 P4r/5z40d2hApogfQS1F4RKYz90Z0LvWI5dNwze4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Qiang Ma <maqianga@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.1 1551/2077] LoongArch: KVM: Return full old CSR value from kvm_emu_xchg_csr()
Date: Tue, 21 Jul 2026 17:20:24 +0200
Message-ID: <20260721152629.358581551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Qiang Ma <maqianga@uniontech.com>

commit ebd50de14f1a06b7e0206083904bcc62b9ba65be upstream.

The LoongArch CSRXCHG instruction returns the full old CSR value in rd
after applying the masked update. kvm_emu_xchg_csr() currently masks
the saved value before returning it to the guest, so rd receives only
the bits selected by the write mask.

That breaks the architectural behavior and makes a zero mask return 0
instead of the previous CSR value. So, keep the masked CSR update, but
return the unmodified old CSR value.

Cc: stable@vger.kernel.org
Fixes: da50f5a693ff ("LoongArch: KVM: Implement handle csr exception")
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/exit.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -103,7 +103,6 @@ static unsigned long kvm_emu_xchg_csr(st
 		old = kvm_read_sw_gcsr(csr, csrid);
 		val = (old & ~csr_mask) | (val & csr_mask);
 		kvm_write_sw_gcsr(csr, csrid, val);
-		old = old & csr_mask;
 	} else
 		pr_warn_once("Unsupported csrxchg 0x%x with pc %lx\n", csrid, vcpu->arch.pc);
 


