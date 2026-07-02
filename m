Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863201C695;
	Thu,  2 Jul 2026 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011555; cv=none; b=PklfSbGTkpNZugW7JAehegbM/so6wyTxaXi//jrHnkpQmy+acJkJb2NAsAfcUJ8Xtj9SpPho8NJ+37w8u+uJvs7Ul3J6ho51H/kUkWqiqET2y0iGufPlr18Qx/GlpMegE2Sh2VQ2IBVK/D4KzFLHkuBN1rgwYKW3VlSYAETI9sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011555; c=relaxed/simple;
	bh=ab26taX6JC4MkkulgRt6YRJbgujEIPT7foXmt9J4fDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2beNzFJ8wCLFERgsE66gkjTDfXk3BWklUM0h2iH7h4Z78oo7HAn6NPHyKGgLGu9opFjfYD8BR8ZKihEY9CJKLIM067OOVugIFKblCriLmzxegyzgtaKR7CpRRwCUtSBPhaFtXTFzviHXUoms8zwkW/Nn3PDk0ygDL49fGW/pZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtYdgzrt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtYdgzrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5C11F00A3A;
	Thu,  2 Jul 2026 16:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011554;
	bh=I5x7UkVU60jV8YU4hDtOSJDlIZ49t15r1IARjsMYkls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PtYdgzrtDy0DhlspIKjNXn3reNQ3+dXRqXOvIxIHD7d7YGTCYGW0VlzakJ8c2bWR4
	 GEemL4sQ7+/F4LlfBIaNza5knbYAVTL2DyVB4H4pdn2peVjeJpxsBZygawprkDON/9
	 PFZ4jtnLjg2gwYb043asqIEF4qQVwRvrrKh/TfRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.1 042/120] KVM: arm64: Omit tag sync on stage-2 mappings of the zero page
Date: Thu,  2 Jul 2026 18:20:38 +0200
Message-ID: <20260702155113.831892061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit 2986a625740599fe6e7635b0586fed2a95bcd1f7 upstream.

Commit

   f620d66af316 ("arm64: mte: Do not flag the zero page as PG_mte_tagged")

removed the PG_mte_tagged flag from the zero page, but missed a KVM code
path that may set this flag on the zero page when it is used in a
stage-2 CoW mapping of anonymous memory.

So disregard the zero page explicitly in sanitise_mte_tags().

Fixes: f620d66af316 ("arm64: mte: Do not flag the zero page as PG_mte_tagged")
Cc: stable@vger.kernel.org # 5.10.x
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/mmu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1479,6 +1479,11 @@ static void sanitise_mte_tags(struct kvm
 	if (!kvm_has_mte(kvm))
 		return;
 
+	if (is_zero_pfn(pfn)) {
+		WARN_ON_ONCE(nr_pages != 1);
+		return;
+	}
+
 	if (folio_test_hugetlb(folio)) {
 		/* Hugetlb has MTE flags set on head page only */
 		if (folio_try_hugetlb_mte_tagging(folio)) {


