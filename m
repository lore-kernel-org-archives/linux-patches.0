Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038832;
	b=gY6jpRyAadydqCXF7eJEPf/JXHzWwZL6NFYxAagqrwVJnd4UGOMFvXFEIlcayH9YQSWx
	 x7QTb0cocIwUzp4BUDHxvxcruuj8X2qJzr8o7mCRzR1e0eyR2AJDf428lc9bX7d23gctJ
	 RMvX1Qt5hRyPlTsY5h2tuq8U4QwqqztQYr5gYYU9Qjdxc5EAJ0l1Taiut4UVbBsQPey7S
	 LBokI5x5sPDYtxwFLDglJ+Qm7b9cDfdx81IIjv7UjmsJuw0V45pplJE2pt21urdCH3snB
	 uL0Q+jX7+4bIxc3CN4+C8LNXGuHYdpT2sBwwk6HJNhhijY/FX2vRKwFB9VsCukuEA9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JRKXE+ozSocNbb70bm970fi+6myXEEFRicWvESl5C+c=;
	b=0quUEJwuOimAyBI0Tc11j4hYYrNXSBnIWzM/z8pg9J7wSPPBAqTeh1WXiZXVd/J2Sta4
	 ZojLZd1LYHPAJ1a/lcXC87yMbaZxD2aNJr+zw8xAyrOiuWWC5k8h8k//vW3g3QYeFC7ug
	 Z+9YekbnwWEqYdbjdyjXqbmpJ3namoLrrGQ7KSnLzZgmsSboc+VImc6xRS3vHSAotjvtV
	 /iA7T9LVKRY8o8sxq3RR97CJ1NyrNgemk2QSATjCyhCPQDg0UcPO05dGewNIHOHD23YeZ
	 Na556Zjd3e6eLtFZvswHxn2DhRBtcW0aX8/x9VoNhS4KJYunDvvmlBvwqHOSeYocjGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VMttFV33;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C4C606A31C;
	Wed, 18 Nov 2026 21:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VMttFV33
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961B71F000C4;
	Wed, 18 Nov 2026 21:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038832;
	bh=JRKXE+ozSocNbb70bm970fi+6myXEEFRicWvESl5C+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VMttFV33KGqbDgDb2Hm8D1ADbtz7a6UvM3Cbwr0fSOfJupnTo9cWSSHOSfc3oKwHZ
	 71Kch//lfeJ8VjUrVAjF/VcXBwpR5cebMTViYJIoRqN9TYsJYkMKuD2rkat5CuWzNy
	 QC5f+p4GL5tlUtNv/iGx4JpRnuzNQ62lgoRuMqpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Jann Horn <jannh@google.com>,
	=?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1884/3318] mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
Date: Wed, 18 Nov 2026 15:41:46 +0100
Message-ID: <20261118150418.512114004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 8146c6478224d8f6395c6b08a19c344a56d79867 ]

Commit ca3d76b0aa80 ("mm: add merging after mremap resize") combined
merging with expansion of mremap()'d VMAs, however it also unintentionally
disallowed the expansion of unmergeable VMAs.

Previously it was possible to expand a mixed mapping which mremap() had
already ensured was a legal expansion.

This is clearly seen in the mremap() logic, as it checks
vma_is_fixed_mapping() to determine legality of an expansion rather than
vma_can_merge().

Additionally, copy_vma() allows for a failed merge to result in a new VMA
being instantiated if MREMAP_MAYMOVE is specified.

However, this is not attempted, as a failure in vma_merge_extend() is
assumed to be an -ENOMEM failure.

Since vma_merge_extend() is used exclusively by mremap() to perform a merge
and/or expansion, resolve the issue by invoking vma_expand() for
unmergeable VMAs there.

Explicitly assert that the VMA is both non-fixed and a mixed mapping.
This provides double insurance against broken changes in future.

Note that khugepaged_enter_vma() (which vma_merge_new_range() runs) is
redundant in this case, as a mixed mapping is not subject to khugepaged.

Also update the VMA userland tests to add a required predicate.

Link: https://lore.kernel.org/20261023-vma-expansion-fix-v1-1-6142baf1f46b@kernel.org
Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Luiz Capitulino <luizcap@redhat.com>
Closes: https://lore.kernel.org/all/20261023023106.515365-1-luizcap@redhat.com/
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: <stable@vger.kernel.org>
[ sashal: Adapted vma_merge_extend() changes to the inline mremap() implementation using the older vma_expand() interface. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 26d3cb46f6ec1..ea57f3095076b 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1133,10 +1133,21 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 			 * the next vma if it becomes adjacent to the expanded
 			 * vma and  otherwise compatible.
 			 */
-			vma = vma_merge(&vmi, mm, vma, extension_start,
-				extension_end, vma->vm_flags, vma->anon_vma,
-				vma->vm_file, extension_pgoff, vma_policy(vma),
-				vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+			if (!(vma->vm_flags & (VM_PFNMAP | VM_DONTEXPAND |
+					      VM_MIXEDMAP))) {
+				vma = vma_merge(&vmi, mm, vma, extension_start,
+					extension_end, vma->vm_flags, vma->anon_vma,
+					vma->vm_file, extension_pgoff, vma_policy(vma),
+					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+			} else {
+				/* Mixed mappings are permitted to be expanded, not merged. */
+				VM_WARN_ON_ONCE(vma->vm_flags & (VM_PFNMAP | VM_DONTEXPAND));
+				VM_WARN_ON_ONCE(!(vma->vm_flags & VM_MIXEDMAP));
+				vma_prev(&vmi); /* Reposition to start of VMA. */
+				if (vma_expand(&vmi, vma, vma->vm_start,
+					       extension_end, vma->vm_pgoff, NULL))
+					vma = NULL;
+			}
 			if (!vma) {
 				vm_unacct_memory(pages);
 				ret = -ENOMEM;
-- 
2.53.0



