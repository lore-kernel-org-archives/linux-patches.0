Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A285946C4D6;
	Tue, 21 Jul 2026 18:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658392; cv=none; b=WkcLmAnlE10Gkk6cMy4KlXksTO4WjCEr3xRA86eshiX0ogFz05z2A6qw6+cC0+ZsyFln/I1lcsyX9TDEUvrl29HQ8A1Obo53VZT745L0bP/ky+tNhHGEk8o2A3yMpyZNaqThWGXw2dqxD0dKWyRFTg7A5BAl2DhRkbEkfkYjMsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658392; c=relaxed/simple;
	bh=K+AfhpWiplBfGR4pz0Y6mHvN1OSktoN/CVuTiv9THSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9/DonH3llUXyhA27xkD0oApEVNIGzGtCXOomB6G5rlZyU+88QxeVynohalIRbKIgI9sSZjvG4xXj3Yf0f/WEsu3gYXGAKK/GogeHaeFdO/xv/RieYHM+XBP9JJ2kpqjUJUwW1h9bh9xj+wIl5IjN+G84/SFtOxS9g3RlM6OXNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLcbKDaG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLcbKDaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058371F000E9;
	Tue, 21 Jul 2026 18:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658391;
	bh=hgffkBlb4PgHMRJILyAQj5STWUiCQjoj0bUbZoVu59c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLcbKDaGXLvFGpgTn+0Ca4wV2SNWqpUvMxaNV4m0u+6ntGSxGebVHcndno8+rN7D2
	 MNb515x2tELoV5Zd1RjnQHs1312jqqqYAKiL90cfUf7XA/aaBqdYaDpfcNlpRORb0g
	 Lwoh1SI3NsGGOoh8gr1ZxPsKQiPRP/UCY/Jj5Ugo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Qiang Ma <maqianga@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 1127/1611] LoongArch: KVM: Return full old CSR value from kvm_emu_xchg_csr()
Date: Tue, 21 Jul 2026 17:20:43 +0200
Message-ID: <20260721152540.771125678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
 


