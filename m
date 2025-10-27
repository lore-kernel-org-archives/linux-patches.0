Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DE83128D0;
	Mon, 27 Oct 2025 18:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591528; cv=none; b=ec5kPtDYc1o1NRPyDMThxGiRIM7Ep/IfCLA68idcsxtHHvzerwh0qSshzKM8sbSvsuAlBhSD/irN1yN4P3wBQyX7Aqt1BzVc8z/SHzLt78DbPPfCeZ7qxoe70eoi2rjaNIa5YUqq9bK0ZA7Y552nc8AdRY2VA3lm5qpTF3nVZAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591528; c=relaxed/simple;
	bh=I5I5YaRmWTjLmeQxd13+0Y12xwZnOSASXPI7D5CipD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFgGwZWvdRD2/2MUDG3vkpixz9/7Vo2LdpvzAAErhy4RYswR4YsCDeNJYbBz/AnuAd1vGqk8sggZSneMvH3HgkNwyLsHtYaBZf7VD86feMEioAvfNZY6ER4v/GnRgp8mG5Q6eXFk5Okzuaa7lABUtDdqVAo70oWocwz1JzjNlQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQ38RQgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQ38RQgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83ACC4CEF1;
	Mon, 27 Oct 2025 18:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591528;
	bh=I5I5YaRmWTjLmeQxd13+0Y12xwZnOSASXPI7D5CipD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQ38RQgDf3tvrNjyD6pv6J5XBnZe7+2JzttNDFzfQnIoqKnb+uXK3728iGltWdelG
	 nei9XFQdPx14QRFybkCxDc2XGBt8uy6+ilRp5i8dknzU3jV7Lu6yXAgn4viGiutqrT
	 PEpiAAheHmaxQXEVg3VMkEiBSx24VLO3Z95qm5mg=
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
Subject: [PATCH 5.10 193/332] arm64: mte: Do not flag the zero page as PG_mte_tagged
Date: Mon, 27 Oct 2025 19:34:06 +0100
Message-ID: <20251027183529.787921724@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ replaced is_zero_page() with is_zero_pfn(page_to_pfn()) and folio APIs with page APIs ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |   10 ++++++++--
 arch/arm64/kernel/mte.c        |    3 ++-
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1768,12 +1768,18 @@ static void bti_enable(const struct arm6
 #ifdef CONFIG_ARM64_MTE
 static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 {
+	static bool cleared_zero_page = false;
+
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
 }
 #endif /* CONFIG_ARM64_MTE */
 
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -247,7 +247,8 @@ static int __access_remote_tags(struct m
 			put_page(page);
 			break;
 		}
-		WARN_ON_ONCE(!test_bit(PG_mte_tagged, &page->flags));
+		WARN_ON_ONCE(!test_bit(PG_mte_tagged, &page->flags) &&
+			     !is_zero_pfn(page_to_pfn(page)));
 
 		/* limit access to the end of the page */
 		offset = offset_in_page(addr);


