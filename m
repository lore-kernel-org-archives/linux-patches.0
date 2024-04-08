Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65496D1A9;
	Mon,  8 Apr 2024 13:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582469; cv=none; b=EiD2ulG+k6wvzuYf+1CL3eRkC6BnB29zxNF4zWFMbqCb4c+4vAV1VZ76C0Dq/35ICLixM8O97e2AbqiwKnEwPogvAl35HLynNNy9Zdf0AFou32zvgfm8hxQcCSst6WQ5uEIoD27mmTwXOlTtQcp7Pw1uy+mS8O17qAQsgtl7ySg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582469; c=relaxed/simple;
	bh=Ig/z5ONIMgROIKpYmo22P+xm/KhXugXkM65oZhvPgqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iT8yBGvGBJp9w4+MieIr5TzJTd+Ej51YSrq1nGc9sKf2u2x+VJ1HAdjzJLWHcsOUOvU11ml5xLJ5jpq+TkmtyCYT0sVIwF4uFQlVGPn8TB1ZmhrHfO1jZ24oy3iWB5JFM1iRpmBCMd6DWrOMOxt29vJfaraFeYyQoyIO7Ccx5Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lh96z1uL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lh96z1uL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D43FC433F1;
	Mon,  8 Apr 2024 13:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582468;
	bh=Ig/z5ONIMgROIKpYmo22P+xm/KhXugXkM65oZhvPgqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lh96z1uLToaBqEF3rMRqT814yvfeE7qnJKSfeBgZo28T3VTnrWIvNf5pGkgzLhq1n
	 jCkfumtx5guBlp28xn/JMA4fAUVI7RSF5PLZ0lUOyJjm5AncV4S8B0P92xOOlIHkq2
	 ELSTjbP20QZxzisO5tljNcw8iulYyqD8j3WQR29I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Krister Johansen <kjlx@templeofstupid.com>
Subject: [PATCH 5.15 148/690] KVM: arm64: Work out supported block level at compile time
Date: Mon,  8 Apr 2024 14:50:14 +0200
Message-ID: <20240408125404.877751397@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oliver.upton@linux.dev>

commit 3b5c082bbfa20d9a57924edd655bbe63fe98ab06 upstream.

Work out the minimum page table level where KVM supports block mappings
at compile time. While at it, rewrite the comment around supported block
mappings to directly describe what KVM supports instead of phrasing in
terms of what it does not.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221007234151.461779-2-oliver.upton@linux.dev
Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_pgtable.h |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -13,6 +13,18 @@
 
 #define KVM_PGTABLE_MAX_LEVELS		4U
 
+/*
+ * The largest supported block sizes for KVM (no 52-bit PA support):
+ *  - 4K (level 1):	1GB
+ *  - 16K (level 2):	32MB
+ *  - 64K (level 2):	512MB
+ */
+#ifdef CONFIG_ARM64_4K_PAGES
+#define KVM_PGTABLE_MIN_BLOCK_LEVEL	1U
+#else
+#define KVM_PGTABLE_MIN_BLOCK_LEVEL	2U
+#endif
+
 static inline u64 kvm_get_parange(u64 mmfr0)
 {
 	u64 parange = cpuid_feature_extract_unsigned_field(mmfr0,
@@ -58,11 +70,7 @@ static inline u64 kvm_granule_size(u32 l
 
 static inline bool kvm_level_supports_block_mapping(u32 level)
 {
-	/*
-	 * Reject invalid block mappings and don't bother with 4TB mappings for
-	 * 52-bit PAs.
-	 */
-	return !(level == 0 || (PAGE_SIZE != SZ_4K && level == 1));
+	return level >= KVM_PGTABLE_MIN_BLOCK_LEVEL;
 }
 
 /**


