Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030521ACEDD;
	Wed,  5 Mar 2025 18:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198213; cv=none; b=OIY35xaLPjeoSsly/x8xnJfdDciQrcaXvSpYxy0JOekiPlqz3YkxjHA8ORj3w65n7uPfh3OYOSMLsYIkWuFZPel9MQNkwI5OEIks3dgNmEQQJew4Oh3RZ5J6yz0ojmHbXzhAIDWuae8SmaAA8f4LPZAIk6tGZLVW7hSyKeXqI8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198213; c=relaxed/simple;
	bh=+ckOm8lPpyRKtaAnjkp4Wo1EO+2/lBtv15cVmEOokGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+4RcNgZmWsRgi3KED8zz30MMUYLG84sXf6kih1gUoTqiwzf9FUj4wVEh3e0Uqj/7z/ZIC43FFNqQmvvtKacREDY7HH2OYO4FoXW8ToPOUsYUfNdTx2voFFH9e9VcPe0PkNSWJ2lL2o2N5YEYj4aCRv9C2W87o+4f0WMbR5RHRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIA3D+W2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIA3D+W2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3891C4CEE0;
	Wed,  5 Mar 2025 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198212;
	bh=+ckOm8lPpyRKtaAnjkp4Wo1EO+2/lBtv15cVmEOokGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIA3D+W2FeD4HDJ98BVU575EAsgb8z0NiX5Q5iUwJFiy/n/7Fxf82Mf7X7MtxgqGT
	 Ihftsx3urmytNxjUaCOzS+NaD07QA1t/C7utlqwzQchkgBYo1Z4mXIlcJ1PTooZ+lD
	 TOIA2fzxUQfiTvvHj7kewR+VVAxCkgJB5kURdz98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Capitulino <luizcap@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 102/150] arm64/mm: Fix Boot panic on Ampere Altra
Date: Wed,  5 Mar 2025 18:48:51 +0100
Message-ID: <20250305174507.910890721@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: Ryan Roberts <ryan.roberts@arm.com>

commit 2b1283e1ea9b5e0b06f075f79391a51d9f70749b upstream.

When the range of present physical memory is sufficiently small enough
and the reserved address space for the linear map is sufficiently large
enough, The linear map base address is randomized in
arm64_memblock_init().

Prior to commit 62cffa496aac ("arm64/mm: Override PARange for !LPA2 and
use it consistently"), we decided if the sizes were suitable with the
help of the raw mmfr0.parange. But the commit changed this to use the
sanitized version instead. But the function runs before the register has
been sanitized so this returns 0, interpreted as a parange of 32 bits.
Some fun wrapping occurs and the logic concludes that there is enough
room to randomize the linear map base address, when really there isn't.
So the top of the linear map ends up outside the reserved address space.

Since the PA range cannot be overridden in the first place, restore the
mmfr0 reading logic to its state prior to 62cffa496aac, where the raw
register value is used.

Reported-by: Luiz Capitulino <luizcap@redhat.com>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Closes: https://lore.kernel.org/all/a3d9acbe-07c2-43b6-9ba9-a7585f770e83@redhat.com/
Fixes: 62cffa496aac ("arm64/mm: Override PARange for !LPA2 and use it consistently")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Link: https://lore.kernel.org/r/20250225114638.2038006-1-ryan.roberts@arm.com
Cc: stable@vger.kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/init.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -278,12 +278,7 @@ void __init arm64_memblock_init(void)
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
 		extern u16 memstart_offset_seed;
-
-		/*
-		 * Use the sanitised version of id_aa64mmfr0_el1 so that linear
-		 * map randomization can be enabled by shrinking the IPA space.
-		 */
-		u64 mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+		u64 mmfr0 = read_cpuid(ID_AA64MMFR0_EL1);
 		int parange = cpuid_feature_extract_unsigned_field(
 					mmfr0, ID_AA64MMFR0_EL1_PARANGE_SHIFT);
 		s64 range = linear_region_size -


