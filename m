Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204872E716A;
	Fri, 17 Oct 2025 15:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716667; cv=none; b=jGoKwLKCEHQCxlk68kkS5a45NH+pUdQ/Oq2iP1iBYxETDfFROAgtUt2/JI0CMwTGEChfcvdrNn7+YJf8yiVGU5Kf2vziVOgfK7oh/o7HVurLcU/pWI0XidOp8yiEcFZlHsRPOczU9W3qe3cbLSIrUDfa4cZntl4+2QwwB7lTmwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716667; c=relaxed/simple;
	bh=jXv28jACPLnRd9v6WMM9i0gaEED/o9aZyFfA53cXwoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5xw9dgW51pCQEGlQ0+ImbXGXTiyfttB1zggrJi1zuLZLtfD8QVNp+aUGg5W93/Y3R6/K/PBNVAp4ZsFsm9e5U17M0M9KaWd/9JWD0lZaeRLCW5UfxOSEVQRNl880JZhF5P1z+u9oUkxooc9dSfSdBjvJeUz8s31t+n7aZSsaBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJpganeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJpganeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D659C4CEFE;
	Fri, 17 Oct 2025 15:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716667;
	bh=jXv28jACPLnRd9v6WMM9i0gaEED/o9aZyFfA53cXwoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJpganeovK2Ojt6ey+Y1vzSHVoWLgqpObph7r3XRGJ7VfoMdQhdp0ygKqk8OU9N7b
	 RSQtmPyYQKzEEOQSPDJtRjKTop9BsVoBkz/yPBmpWsELYhj/cH4R4h65wk1Wt4jRoU
	 ARLVOvRFDwVsPmrI9tGIRwxQ8APC5sJfafKj7FRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Gergely Kovacs <Gergely.Kovacs2@arm.com>,
	Will Deacon <will@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/276] arm64: mte: Do not flag the zero page as PG_mte_tagged
Date: Fri, 17 Oct 2025 16:56:02 +0200
Message-ID: <20251017145152.306567785@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

[ Upstream commit f620d66af3165838bfa845dcf9f5f9b4089bf508 ]

Commit 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to the
zero page") attempted to fix ptrace() reading of tags from the zero page
by marking it as PG_mte_tagged during cpu_enable_mte(). The same commit
also changed the ptrace() tag access permission check to the VM_MTE vma
flag while turning the page flag test into a WARN_ON_ONCE().

Attempting to set the PG_mte_tagged flag early with
CONFIG_DEFERRED_STRUCT_PAGE_INIT enabled may either hang (after commit
d77e59a8fccd "arm64: mte: Lock a page for MTE tag initialisation") or
have the flags cleared later during page_alloc_init_late(). In addition,
pages_identical() -> memcmp_pages() will reject any comparison with the
zero page as it is marked as tagged.

Partially revert the above commit to avoid setting PG_mte_tagged on the
zero page. Update the __access_remote_tags() warning on untagged pages
to ignore the zero page since it is known to have the tags initialised.

Note that all user mapping of the zero page are marked as pte_special().
The arm64 set_pte_at() will not call mte_sync_tags() on such pages, so
PG_mte_tagged will remain cleared.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero page")
Reported-by: Gergely Kovacs <Gergely.Kovacs2@arm.com>
Cc: stable@vger.kernel.org # 5.10.x
Cc: Will Deacon <will@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
Acked-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Will Deacon <will@kernel.org>
[ replaced page_mte_tagged() and is_zero_page() with test_bit() and is_zero_pfn() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |   10 ++++++++--
 arch/arm64/kernel/mte.c        |    3 ++-
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1948,16 +1948,22 @@ static void bti_enable(const struct arm6
 #ifdef CONFIG_ARM64_MTE
 static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 {
+	static bool cleared_zero_page = false;
+
 	sysreg_clear_set(sctlr_el1, 0, SCTLR_ELx_ATA | SCTLR_EL1_ATA0);
 
 	mte_cpu_setup();
 
 	/*
 	 * Clear the tags in the zero page. This needs to be done via the
-	 * linear map which has the Tagged attribute.
+	 * linear map which has the Tagged attribute. Since this page is
+	 * always mapped as pte_special(), set_pte_at() will not attempt to
+	 * clear the tags or set PG_mte_tagged.
 	 */
-	if (!test_and_set_bit(PG_mte_tagged, &ZERO_PAGE(0)->flags))
+	if (!cleared_zero_page) {
+		cleared_zero_page = true;
 		mte_clear_page_tags(lm_alias(empty_zero_page));
+	}
 
 	kasan_init_hw_tags_cpu();
 }
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -370,7 +370,8 @@ static int __access_remote_tags(struct m
 			put_page(page);
 			break;
 		}
-		WARN_ON_ONCE(!test_bit(PG_mte_tagged, &page->flags));
+		WARN_ON_ONCE(!test_bit(PG_mte_tagged, &page->flags) &&
+			     !is_zero_pfn(page_to_pfn(page)));
 
 		/* limit access to the end of the page */
 		offset = offset_in_page(addr);


