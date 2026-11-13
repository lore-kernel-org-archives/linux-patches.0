Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591605;
	b=VpcN66QHWKxhtJPMPyInwIIgH4Ppr/4Nx+qiYTAneCrTT22mXqZURpzOVE9ku72UUZUz
	 lxxdRG2zqXyekmBSorhGAfNcgVYt8fGsEfCdd66i5x2Of19RhZ5W4rAhuCU3Oamv+TZfU
	 imiByLLhKwWApVvO4feoMovEgH/tYlW6hHhN407/cGJxE71DX0j26s23PZnEsjo/nxKVK
	 OtWKG1wSFelkJRs9XbkcYWCH1Ib8ixp0snszKNT958Prbhv9uWN/GFKKR21gsOJAhJixu
	 Tf2j9oK4j6aq/RJu57VdUCbgwFrI4yHv+0fvoAwp1uIniOZobk8mVEEpjTum33Asy3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BAF0wOrsVHmY8iZcmD7RronTrrvVb0jsp5zO/mrLX8Y=;
	b=botEmNeobV4+Z722eYKKK08SNAwUFm9my6C85iGDEYLUpCKSu/KWI60CD8aZGBiIuDbi
	 BHds8VTG5BhLX220QnkRjnCfqQOqlkEY65ixh72V9iZ8YDaX/KqFG+YbsA95v3f7eyo8i
	 04wp1ioC2rlJ3Qu9DlyV4XCVJDmiLEZi5wW0qauhq+vCHgUuAU38x0j2hyfDcsGSMd0GD
	 dkpu+qXh5UC74zBX48gY6fMcOMMO6gfHel4sHqkUQKkiSmFliOtloF/Sfc97q22wYOo9A
	 aEFLArtvJ0iIcYwbouihmvPiOWyzhlk7X1Bs9w2dZabee9fJQUZDXvELI5TYGvBLniQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ope2Y5v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B698A606B452;
	Fri, 13 Nov 2026 17:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ope2Y5v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB781F000C4;
	Fri, 13 Nov 2026 17:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591605;
	bh=BAF0wOrsVHmY8iZcmD7RronTrrvVb0jsp5zO/mrLX8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ope2Y5vB+dJK1cMbCyg+Tj4fL48Jo2vYr+BOoywWlsgO6rSwGAjIqiunqt20/+Vo
	 dq8S66L6maJ2y49HhEkgf/bzoy6m42eTEu/jBwvH2n9PKswHgZuBqcZyIgdcMArug3
	 5i9zeH5x1WkMHGk5YX01bvlN9VP2e3acf6AB4P/o=
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
Subject: [PATCH 6.12 646/670] mm/vma: avoid broken uffd merge on mremap
Date: Fri, 13 Nov 2026 10:53:30 -0500
Message-ID: <20261113153833.696946559@linuxfoundation.org>
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
[ sashal: moved the merge guard into copy_vma() because vma_merge_copied_range() is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vma.c                         | 5 ++++-
 tools/testing/vma/vma_internal.h | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/vma.c b/mm/vma.c
index 66b0472b7d8a6..85660d67b7942 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1694,7 +1694,10 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 		faulted_in_anon_vma = true;
 	}
 
-	new_vma = vma_merge_new_range(&vmg);
+	/* If not registered for remap, uffd context will be cleared. */
+	new_vma = NULL;
+	if (!vma_has_uffd_without_event_remap(vma))
+		new_vma = vma_merge_new_range(&vmg);
 
 	if (new_vma) {
 		/*
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 0a95dbb0346fb..213e40afa8ee3 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -605,6 +605,8 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 	return true;
 }
 
+#define vma_has_uffd_without_event_remap(vma) false
+
 static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
 				    struct anon_vma_name *anon_name2)
 {
-- 
2.53.0



