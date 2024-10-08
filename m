Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341931DE4D7;
	Tue,  8 Oct 2024 12:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391561; cv=none; b=U/3083iYUcVMUG2FCv7gp5S0ecAuzt+Uv93q25DgzPIA0MCw2dPRbxl1GzZnUk8ZvFylQH4zd7ShuPghMZDB7PlntZE5KPrBnimXiNIOJ35WoJXH2fk6/fp/Qgx12mpJHXO2sFBN2ZGVJAvdrF2GS8BHnK31VtY5COZyHKMggJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391561; c=relaxed/simple;
	bh=A+j27AFGrJrXj1HkWJdD+4jhgPQZjQZnLa4WhO/4wDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XZb+nI0myNB9IWp3SQqA4qdXKGYULAIlZ2NNdcBQj/R3kisUGGjoD9oWwBH2GKqF2EhQIrtvXUt71YgJXEjbEXMd4UREZWpvZuaGeM4feVlqTdsgzei99RiaYjGLYJFKO7Zh8IpHnYe7otnYWb8kYg9BdvSeipPb3z9dfk1St/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffjPh/dj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffjPh/dj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5053AC4CEC7;
	Tue,  8 Oct 2024 12:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391560;
	bh=A+j27AFGrJrXj1HkWJdD+4jhgPQZjQZnLa4WhO/4wDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffjPh/djrSwgAr7QcbR/YjLf27og6+VLDcMhLHXCTbG4du6PcEEgg6hIFUAGqg4yT
	 iWSfcsLLc+SflQorx7j5wdbdlbxG3qscqlGlCAKu0m4YmAKU2UMm+ofS5Rg/Y44O9D
	 wUP9nieBpLmByRgakCu/EailjKLGcMvJws9e2++s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Jan=20H . =20Sch=C3=B6nherr?=" <jschoenh@amazon.de>,
	Fares Mehanna <faresx@amazon.de>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 153/558] arm64: trans_pgd: mark PTEs entries as valid to avoid dead kexec()
Date: Tue,  8 Oct 2024 14:03:03 +0200
Message-ID: <20241008115708.382672121@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fares Mehanna <faresx@amazon.de>

[ Upstream commit 7eced90b202d63cdc1b9b11b1353adb1389830f9 ]

The reasons for PTEs in the kernel direct map to be marked invalid are not
limited to kfence / debug pagealloc machinery. In particular,
memfd_secret() also steals pages with set_direct_map_invalid_noflush().

When building the transitional page tables for kexec from the current
kernel's page tables, those pages need to become regular writable pages,
otherwise, if the relocation places kexec segments over such pages, a fault
will occur during kexec, leading to host going dark during kexec.

This patch addresses the kexec issue by marking any PTE as valid if it is
not none. While this fixes the kexec crash, it does not address the
security concern that if processes owning secret memory are not terminated
before kexec, the secret content will be mapped in the new kernel without
being scrubbed.

Suggested-by: Jan H. Schönherr <jschoenh@amazon.de>
Signed-off-by: Fares Mehanna <faresx@amazon.de>
Link: https://lore.kernel.org/r/20240902163309.97113-1-faresx@amazon.de
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/trans_pgd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
index 5139a28130c08..0f7b484cb2ff2 100644
--- a/arch/arm64/mm/trans_pgd.c
+++ b/arch/arm64/mm/trans_pgd.c
@@ -42,14 +42,16 @@ static void _copy_pte(pte_t *dst_ptep, pte_t *src_ptep, unsigned long addr)
 		 * the temporary mappings we use during restore.
 		 */
 		__set_pte(dst_ptep, pte_mkwrite_novma(pte));
-	} else if ((debug_pagealloc_enabled() ||
-		   is_kfence_address((void *)addr)) && !pte_none(pte)) {
+	} else if (!pte_none(pte)) {
 		/*
 		 * debug_pagealloc will removed the PTE_VALID bit if
 		 * the page isn't in use by the resume kernel. It may have
 		 * been in use by the original kernel, in which case we need
 		 * to put it back in our copy to do the restore.
 		 *
+		 * Other cases include kfence / vmalloc / memfd_secret which
+		 * may call `set_direct_map_invalid_noflush()`.
+		 *
 		 * Before marking this entry valid, check the pfn should
 		 * be mapped.
 		 */
-- 
2.43.0



