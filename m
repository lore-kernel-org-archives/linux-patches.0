Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047428;
	b=xl7zPaX0/9CZ2st7B+aQWbaXSE/I6M46EDfNB2IE4FF/p3wxYHptBj/8aYfJ0F0WcXLH
	 Ni/zLeSwFryQXEN67/xnIFtMvCp6MQtGwaVrA/ifgWNqYmrFgInrx0tykVb003DYmkxGD
	 UeY3JVCJdrh4/JFSbJriohCyIkDI3h3B3buOLoTNAPbhwtz7pXPBDTos6auAsYVKJn5Tq
	 DqcVm27iVH/GvpwzkznlzRt+mW1T4HMbslvXMkTJwQEInEn1L9UbTjYM0fRmNF65KJ9uF
	 +95FgJoMBuck/hf8b3G/jmJok9Lzcc2hkLWC9yuEylHdAxslCpZ+QdFTcnP2bnv5Vkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KzMFmVfArJDgFe3+d5cIviGWYdfTTN68xlz57/LzsHc=;
	b=f01Fx6b4ZK3DLz3IOxWaRlk+zRHfvVYEHWk3iohIvC+l5IPM6gZO7AI2ZUPJ0SYZs0YB
	 5iXAQUwWHoKqx8BQJJNalgMMxACvSR+bFQDA6lkugbhyH3WxJlhsIhqgwD/fc9/wq4eo5
	 M8nh1rl6aJrbDC/x9hq/E6b5pzbb/u68w1Dyp0iM9YQqLYs28Yzx6XHME8QmmzlLPF9CW
	 63Wvcf8BYoZkzHTqugYFHPBcT2fjfhAR3kotC2yY2aU9iL4BvMlxCfs1cxeMzMBlzDG9L
	 3zEcApoT68rICHU3kCEina78A6ld8jPCOyqAwJdeugRacEn3jI8joWpyGrKxttsD5cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HH/xtKGk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4ED606A31C;
	Thu, 19 Nov 2026 00:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HH/xtKGk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F2A1F000C5;
	Thu, 19 Nov 2026 00:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047428;
	bh=KzMFmVfArJDgFe3+d5cIviGWYdfTTN68xlz57/LzsHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HH/xtKGkvSv3jkwJisqtcfGfpQuT+W2Pe9UClqcWCvoEAZ4k5MPehUl+wcHd9JrMB
	 HNLRHMuHl6Eg+GwYJBtfHOs3kLGkZN2uGYGFMcvnmFXeBIWmUOV66eC8Ibh3bHbC8D
	 cggqfJJecL7yq/isIsEwSRKIAeDU9tjabGbjr9mI=
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
Subject: [PATCH 6.1 1633/2857] mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
Date: Wed, 18 Nov 2026 15:44:27 +0100
Message-ID: <20261118150300.134766036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted VMA expansion to use the existing vma_adjust() path instead of vma_expand() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 9a53eeb2191f5..a13ad0e9c1f84 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1111,8 +1111,12 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 			 * expanding, so perform a simple expand for such vma.
 			 * Ideally the check for close op should be only done
 			 * when a vma would be actually removed due to a merge.
+			 *
+			 * Mixed mappings cannot be merged either, so they also
+			 * need to be expanded directly.
 			 */
-			if (!vma->vm_ops || !vma->vm_ops->close) {
+			if (!(vma->vm_flags & VM_MIXEDMAP) &&
+			    (!vma->vm_ops || !vma->vm_ops->close)) {
 				vma = vma_merge(mm, vma, extension_start, extension_end,
 					vma->vm_flags, vma->anon_vma, vma->vm_file,
 					extension_pgoff, vma_policy(vma),
-- 
2.53.0



