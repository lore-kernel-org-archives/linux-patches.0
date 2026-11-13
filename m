Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590770;
	b=AGpKh+fRWZlXZ7EOwbBGoShUAYwatZSEovsHYqwowSdW8qro+ZvuZ3L7piiWrxonfhQK
	 tCE2Tyn4XkOnwSu1TcnA7nqrW4PXz0snLmBPPut89pRrjJyZzEuqyyeOVjafQuyIsO+FV
	 jr4QTIdMKrMlrk8se1GYGa4TCIxp3v/Nt1miDzJElWuBaCt+KiK9q88aDhUzikVZbvkNs
	 /uP7NZK6NSfuKA7ZRbvYnVVLKEEymgaaXogoyKOEFCbxDGqCmoYqe4BZRVu3ind/+u6Mh
	 wwUkS9xzwA8daDF+EaZTrByK7cNW0cAK9XkVF8+EbVgD0um+7fbMtpd0BBfPWxxs0Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WNNeI7WaxSBdWrXeMOPv+3AXTzUAIcwnZ8obxAFwmGA=;
	b=zYx7/rdjzKHbs0I+LCd5TXfhvOHOVjJXi40kh4f9YExRsMh4YwEQoZ160DXHrO09Eu+H
	 qmQUvDjsLdFiqW8+VhsPsRtC81HdcKnaybqm87Nykvs/NV0UeH6BdQ+rGCWNIMJ67MuF3
	 HBwyzxyJGGwAkSCruIHDNaEoTB/YaaNHQQYaTwkj/0bnj+7bMQzJzdrYCFe2Itg1NrNqy
	 zPpP0QjE5Rp0C1hFUTOvH+AwQJ84PVSfCJtcliWjlHSfXTPQOMF3aALJcSPWR6j6pkt8q
	 DDpODe9RbZJWQ3BrQwunGuqO2xNB+ybuJk+dzffoig4vkLFKd1oY5nzYn2n3dVieXbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJpDZ5dO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5872607C343;
	Fri, 13 Nov 2026 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJpDZ5dO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8067E1F000C5;
	Fri, 13 Nov 2026 17:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590769;
	bh=WNNeI7WaxSBdWrXeMOPv+3AXTzUAIcwnZ8obxAFwmGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJpDZ5dOfU/6cot4izMgnDksinoobhtTGBaAMe3/3ZOZbd1+rxMjrD3K/2vwrqUBA
	 yxZdzcZ34alK/alDp6cdlqhGWMLIq8wSGW9E10qUfe7EinTfgpCA4G/cu4w940DBsg
	 3XiHBP9VaGyT0+7bLIfuK/qQdIISMtsEvLzg7LEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	shaos <shawnq1@163.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@linux.vnet.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 667/686] mm/vma: avoid broken uffd merge on mremap
Date: Fri, 13 Nov 2026 10:53:20 -0500
Message-ID: <20261113153844.295151389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 68cb098eadda190783f8f8bdf9fe764df59f7d32 ]

Userfaultfd often causes unexpected interactions within mm, and does so at
the intersection of uffd, mremap() and VMA merging.

When an mremap of a VMA occurs, copy_vma_and_data() calls
mremap_userfaultfd_prep() to notify uffd of this.

However, mremap_userfaultfd_prep() simply drops the UFFD context for the
VMA if the user did not register it for remap, i.e. didn't specify the
UFFD_FEATURE_EVENT_REMAP flag.

This is OK for the VMA itself, as upon page table move, move_ptes() clears
UFFD page table flags, using vma_has_uffd_without_event_remap() to
determine whether to do so.

However, this doesn't account for merging with adjacent VMAs, whose page
tables won't have received this treatment, and thus latent UFFD markers
will be left around.

Worse, it'll break UFFD for any VMAs it is merged with. This is very
surprising behaviour for a user, who will then simply not receive UFFD
events for VMAs they ought to.

Resolve the issue by explicitly checking for this case via
vma_has_uffd_without_event_remap() in vma_merge_copied_range(), the merge
function explicitly designated for mremap() operations.

Also update the userland VMA tests accordingly.

Link: https://lore.kernel.org/20261020-uffd-remap-fix-v1-1-0f34fc181f0a@kernel.org
Fixes: 3cfd22be0ad6 ("userfaultfd: clear flag if remap event not enabled")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: shaos <shawnq1@163.com>
Closes: https://lore.kernel.org/all/20261020110748.959870-1-shawnq1@163.com/
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: replaced the inline test stub with a constant-false macro in the existing test harness header ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vma.c                         | 5 +++++
 tools/testing/vma/vma_internal.h | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index 3710cb70ca682..0d4f344956642 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1145,6 +1145,11 @@ static struct vm_area_struct *vma_merge_copied_range(struct vma_merge_struct *vm
 
 	vmg->copied_from = vmg->middle;
 	vmg->middle = NULL;
+
+	/* If not registered for remap, uffd context will be cleared. */
+	if (vma_has_uffd_without_event_remap(vmg->copied_from))
+		return NULL;
+
 	return vma_merge_new_range(vmg);
 }
 
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index f64064ee48587..b736528815bd8 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -802,6 +802,8 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 	return true;
 }
 
+#define vma_has_uffd_without_event_remap(vma) false
+
 static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
 				    struct anon_vma_name *anon_name2)
 {
-- 
2.53.0



