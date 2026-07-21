Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B268C472F99;
	Tue, 21 Jul 2026 19:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663506; cv=none; b=Cqp6S18DuhySmVjr4sr7GdSDfywgYUmDuCzZK/qy8BH4IVtpJ4G27Pl/zqwXoCn5mLf0um/Yd2+zRCT4h4L5tTwVHeFNlbuWA2bck90TmkkYioEEnzlSk6m7HlYnQll3Wgm9TevsU6bhr2ungbl0KlQXHQNNkWo7fi2W8Fl/JyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663506; c=relaxed/simple;
	bh=d/SqbfbE6rnai7jeFFyu/GmX3S65UJV4u7iQB9PmDh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKcDjpvYxurfpmkuaFTr4izjkSvexQUHJ2wvHA75BijUnoOrCuT1IvZPXgl+8y5hJLFpniqEL6SarKXXP58EP2sgWn1DLe1vuonX6pkh5ngwlxNXkGfw/M2Lrx+v3GqBDz1I7LLQnfsxWrq+iuproqghf6APUJWvn4pmtyt6S8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FP3OMem/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FP3OMem/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238241F00A3A;
	Tue, 21 Jul 2026 19:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663501;
	bh=nAkfgsgFyt7EgVjckrSUEbWomhZYNtJlKHSB2m1qqwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FP3OMem/p3sNeruXSGMSLE/iwNnuF4EPcIwMHi4IP1JijQd1FXSIJfRV65IfAeFZg
	 gF6RCK3AMZqM9dYPe4HPApdRxv1GuRC6yu0y8/BY67HoMgDKQUEhagvzFmkU9JN/8Q
	 JaMOIaSVcqZ4t88buXxWrPnwo6ZgrVodXK7WkYDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Qiang Ma <maqianga@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 0830/1276] LoongArch: KVM: Return full old CSR value from kvm_emu_xchg_csr()
Date: Tue, 21 Jul 2026 17:21:13 +0200
Message-ID: <20260721152504.634855074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


