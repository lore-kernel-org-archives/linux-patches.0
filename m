Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591593;
	b=awE7IXZifpHLmxqMaYqQO0o6n1tyaqJXgY1InVNQzfFp7mqW0P02Usj8lMU1F8YReknW
	 2RvMdqhQVd+CPutnUNSuPQK+dYp3Q1io16XRyLPghmIB/R5MDZqhFcaYRWRRrDQpe1GQA
	 gCwSUgxrva4r7fUNYqz5iodPKqHGvNpwxYQsrqCx37SrHpp1g7IaYjJ6hucdkn3UWzi2b
	 2rO1xYotvHkJyve5l4vGZyZm9PJoVvkK2lDAJ+2wRDHNpqcQUJks/UJLGpSSnfebZEkHD
	 lMYYrK0fqltt7I/OGZCf501Md+wjkIOwpxIzJI5UW8MoCplNpKbn5CyhgLEHePOk/OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nq6snGx41+RD7HrT82Ia1Ay0NEe4Fm4S4OsYKsBLOJU=;
	b=cUBFLWIsVBvPyVNdXDHfn9laR+sBK/p75Ec/2V28tball4jtG/taCkHrg3/4YIAsJPWk
	 VLPi+AQx98ehfO/dG/xgWoMpizi26Z8Qxw6FpEaurY/SQxv8FvHHxF5VXm21zvXe5xXXx
	 5OKtAC3XrQa5eijGA1aruC299sZn3Zva/SZVoSS6w9/rP6u9LKmSg/Dz5eeaOBY2c/R13
	 j3fm7wqCMLC2VDfctHxJQtpX36vxr+xBC9RbAk3ba/UYCAsVGDlNsGIciSQFZvk45dLTj
	 L/O0A4Ka+m7xXqr5g8aLV+PNioxwGZ2zAaPJ2QOXg1bboCMDCZsBQSHz292/aQFM+Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YGP2covO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47005606B444;
	Fri, 13 Nov 2026 17:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YGP2covO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1BF1F000C4;
	Fri, 13 Nov 2026 17:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591593;
	bh=Nq6snGx41+RD7HrT82Ia1Ay0NEe4Fm4S4OsYKsBLOJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YGP2covOAFN3fv2h04kLk/oKg7cicvhXK439QRVXAb++siauYrsphVLwWM2UoKDIP
	 /y5055gOQ460yHpujWW5zWrDoqmraLAi3xii1R6ffipthCvx1FhIO1+XRl9dF5SUcp
	 qSDCCAoSyPWq/J0BXrnpq/A/FUGoDTvSOduzKUuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brian Geffon <bgeffon@google.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 637/670] mm/mremap: correctly uncharge accountable VMAs in error path
Date: Fri, 13 Nov 2026 10:53:21 -0500
Message-ID: <20261113153833.389422336@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 65e722a74df992719676ead85a9e93fb2b5a0983 ]

The mremap error path is a fragile and unwieldy beast - it reverses the
page table move then updates vma_remap_struct state to swap VMA, length and
address between old and new VMAs in copy_vma_and_data().

If the mremap() operation didn't specify MREMAP_DONTUNMAP then its caller,
move_vma(), invokes unmap_source_vma(), which unmaps the new VMA rather
than the old one.

For accountable VMAs when MREMAP_DONTUNMAP is not specified,
unmap_source_vma() unsets VMA_ACCOUNT_BIT during this unmap in order that
only the delta of a VMA expansion is charged (performed by
vrm_calc_charge() earlier).

Therefore nothing uncharges the expanded VMA size, and there is a permanent
leak in global Committed_AS.

Resolve the issue by uncharging when MREMAP_DONTUNMAP is not specified.

Link: https://lore.kernel.org/20261019-other-mremap-charge-leak-v1-1-d94477fe6545@kernel.org
Fixes: fdbef6149135 ("mm/mremap: don't account pages in vma_to_resize()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: <stable@vger.kernel.org>
[ sashal: replaced vrm_uncharge() with a VM_ACCOUNT-guarded vm_unacct_memory(to_account >> PAGE_SHIFT) call in move_vma() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/mremap.c b/mm/mremap.c
index 8b507e228a274..d4666f1ab5939 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -782,6 +782,21 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		 */
 		move_page_tables(new_vma, new_addr, vma, old_addr, moved_len,
 				 true, false);
+
+		/*
+		 * When the error path completes, the new VMA will be
+		 * unmapped rather than the old one.
+		 *
+		 * When an accountable move is being performed, this unmapping
+		 * will not uncharge any expansion, so do that now.
+		 *
+		 * A move is accountable if the VMA is accountable and
+		 * MREMAP_DONTUNMAP is not specified, so only do so if the
+		 * latter is true.
+		 */
+		if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP))
+			vm_unacct_memory(to_account >> PAGE_SHIFT);
+
 		vma = new_vma;
 		old_len = new_len;
 		old_addr = new_addr;
-- 
2.53.0



