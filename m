Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F246400981;
	Tue, 21 Jul 2026 17:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654180; cv=none; b=sD4HAt5xXDSkQUf2x8iQcLKrUossT0EmBMHQ72PWgUy/l29JulVqIIPC5nnqywEoMUf+qDpjE0lr9abvhE2oArz0GPPlPMbQhrsxqypM2R7PVIp1o8Slm4Lc1PKMZnV9UTRUrwtEWKNdnkyCNlTSyq2y3g4jAQ3fHw1ZE5/QRA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654180; c=relaxed/simple;
	bh=xvgOK0P6pw4PY5Q0Cngd6ytkeJfiaEw5Uxq07W5ySmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaGBfOoJQXTVpJhxsCROn5S9JpwvRvbpQLWHobqxLY5MvZ8vmy3Psl30iAwRtKoigSRhGYx1g0DjERRrUQAYoG5nGapNNtw/bKjmDsB9daafcfwCyacxs4RsNr9zZ5E8gGxikErXYPUsjJpauYpkv3+4HMSq5UPYXxOARqveMCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYvJILUV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYvJILUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008071F000E9;
	Tue, 21 Jul 2026 17:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654179;
	bh=BVBd/PKTUbtUFUfiOhE2bu8q3UTXlAfVM/ulQizSjLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QYvJILUVgrHEpjvutbtA7vgSlZHtOyDEPMsuTASJCu16bSWeikYzAbomNi0rHAYew
	 mt41A2nN9dW4hfx3VY+TLPI96/8QM00rViptEUHAS1mt7LngCdUoGJ3WtQLKRUI2oT
	 RJ/D16cPzcFXNXbN68p05mKN4GLR4vqV5JYNT3SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.1 1570/2077] KVM: arm64: account pKVM reclaim against the VM mm
Date: Tue, 21 Jul 2026 17:20:43 +0200
Message-ID: <20260721152629.810795501@linuxfoundation.org>
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

From: Bradley Morgan <include@grrlz.net>

commit d098bb75d14fde2f12155f1a95ec0168160867ce upstream.

Protected guest faults charge long term pins to the VM's mm. Teardown
can run later from file release, where current->mm may be unrelated.

Drop the charge from kvm->mm instead.

Fixes: 4e6e03f9eadd ("KVM: arm64: Hook up reclaim hypercall to pkvm_pgtable_stage2_destroy()")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260621213155.6019-1-include@grrlz.net
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 053e4f733e4b..428723b1b0f5 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -352,7 +352,7 @@ static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64
 		page = pfn_to_page(mapping->pfn);
 		WARN_ON_ONCE(mapping->nr_pages != 1);
 		unpin_user_pages_dirty_lock(&page, 1, true);
-		account_locked_vm(current->mm, 1, false);
+		account_locked_vm(kvm->mm, 1, false);
 		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
 		kfree(mapping);
 	}
-- 
2.55.0



