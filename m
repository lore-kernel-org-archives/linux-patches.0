Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F298B32E151;
	Fri, 17 Oct 2025 15:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713954; cv=none; b=Yp8u/8P+BcvrPfn2j1m3jrPHIxaqqlUI8NkJl7HiAoTEf9C306KEkWjRcGYk7wP5pJSqRwSk0xMwcNcreYcF8WbHeaHZbR0RoyGw8gbjG5x4H2gK1nvilN6C6t+qv1qIfyAuOp48GAI1rA91VfE0kjvHtZeEdgHusDMtu0zoMPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713954; c=relaxed/simple;
	bh=ltzVjiZtWAUGHX1nlh79TvLwtr+dielBBVVULPnLW8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9NPQhbiuBbSYOmQM5fxZRqEtqm/5Cx2tmPyYcrbpidvrNjIaIq3rTGJYK1zaZTHNY2LXxPYPniJjqDI4cGQGNyejykTD2ZlY5r/a2hX200pY+tb/XEARPMYsFQbd7Y99iUijmLd6dIQeUj3wGONBC7cIyDDxeM3us1APwvIrT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBXCyxMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBXCyxMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80490C4CEFE;
	Fri, 17 Oct 2025 15:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713953;
	bh=ltzVjiZtWAUGHX1nlh79TvLwtr+dielBBVVULPnLW8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBXCyxMxRUC/hcdwyn5o4TLLVxjQShUgHimrb6V8YaxW0zXznGMQD5m+1UDj6dlSl
	 ALj3O95zrExV3UToRZMZaNF4KuajzvxnHj2M0iC9exrl5A4v/ddPzeqEVc1SoGOgxu
	 HNaGrzs+4pBh6wlYHPbwXlo4io4cV87hoU5982hM=
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
Subject: [PATCH 6.6 177/201] arm64: mte: Do not flag the zero page as PG_mte_tagged
Date: Fri, 17 Oct 2025 16:53:58 +0200
Message-ID: <20251017145141.255016185@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |   10 +++++++---
 arch/arm64/kernel/mte.c        |    3 ++-
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2174,17 +2174,21 @@ static void bti_enable(const struct arm6
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
-	if (try_page_mte_tagging(ZERO_PAGE(0))) {
+	if (!cleared_zero_page) {
+		cleared_zero_page = true;
 		mte_clear_page_tags(lm_alias(empty_zero_page));
-		set_page_mte_tagged(ZERO_PAGE(0));
 	}
 
 	kasan_init_hw_tags_cpu();
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -428,7 +428,8 @@ static int __access_remote_tags(struct m
 			put_page(page);
 			break;
 		}
-		WARN_ON_ONCE(!page_mte_tagged(page));
+
+		WARN_ON_ONCE(!page_mte_tagged(page) && !is_zero_page(page));
 
 		/* limit access to the end of the page */
 		offset = offset_in_page(addr);


