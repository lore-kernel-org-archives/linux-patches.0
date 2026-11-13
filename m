Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585605;
	b=4lPwX213vQtbEzAPfSH3ry7yHirkW2sr25ePa+RAHuTyxm/B2SbSJRsqZEuXwqQHDIxp
	 8CC7mJ2ol4dO/tezsZ0lLKZtdWYk+050kyzbdyjllJ/iS0yeFCHEl/N5DQJLQ0ZDbYZDN
	 wo1bGm2CiLDtKNHyFNLo4bbjed0/0b1rmPO+FDNqo6xfV2rt1OfkbxAv7/Q0ucySD2pdQ
	 VRhB5JaglhcsvxKH+a5gXZDwRMi7UX45XHhe3ugmGbhmlbmmtfmrTqE/iZZ5k2HseTm5A
	 xGkneWrzPyXj2o/uq+lXVR9dzpYlPnLgi5px6Df5S9/52hV5iNqoJcTDoYCEWTj10ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WLyc1gB/R7YVbdL2AvdXI+l+0JGLA00bVySoVRx3v/4=;
	b=Y/97JTp9lNXgi1tkNkEfr9f4L6aQmBWuL9iJL+KFe8BQtYd4IeXqhzS83xCLzyEMFImM
	 t3WfViyOoyKJffvh8yaivDNrJE6cBfpRskUFiUaLfbz0h6P1Gk3TS5WSCAC796XjZXIIk
	 139XK6Hmq3PP1FLdEbnVQZOtUbTCUivW9rRzSD9J5EhJkb3ZzZdc8wKV6ALfilRGd6Gap
	 Lf4sh61et3j2lm54KcIaYhXymUGuO3Gq0A1XPPfDeqxKsY0gvTeKofdgEsCWZp6aXgScN
	 k98GGuLI4xntWDO1FcC9TlsUEjFR6rJ30qlW0H2yYJL58wXdXSv8pRGguCuP+XLbhZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AAZEWcWA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3072606A33B;
	Fri, 13 Nov 2026 16:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AAZEWcWA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EF71F000C4;
	Fri, 13 Nov 2026 16:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585605;
	bh=WLyc1gB/R7YVbdL2AvdXI+l+0JGLA00bVySoVRx3v/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AAZEWcWALN7qbGqpKpHDQNeWFZORQU8nNTsD4+jEE9X0//POoFwngXS7TjdEjc/2j
	 bIAMGfurYPU/+tvnUQATnvOh8nUuuAaGopTP9a6JExhBwr+/9fwB1CS1aDiT636G9W
	 RFhy3+6kCb99W0szluu9uLOvzo09e3Tv6ue53qMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Pedro Falcato <pfalcato@suse.de>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	SJ Park <sj@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Colin Cross <ccross@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 229/507] mm/vma: write lock source VMA before duplicating it in __split_vma()
Date: Fri, 13 Nov 2026 10:48:53 -0500
Message-ID: <20261113153802.259564893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 769417e410dd19b2a438c6addb61b194b7a4c387 ]

__split_vma() duplicates the source VMA before taking its VMA write lock,
and until the VMA is write-locked, a concurrent thread might set
VMA_MAYBE_GUARD_BIT, resulting in the duplication missing the flag.

If this happens, then fork may fail to duplicate guard markers and, if a
file-backed mapping, THP collapse may also discard the markers.

Resolve this by taking the VMA write lock before vm_area_dup() and, since
all callers of vm_area_dup() now hold the VMA write lock, assert that this
is the case there, and add a comment to explain why it's needed.

[ljs@kernel.org: add VMA write assert in vm_area_dup(), commit message touchup]
Link: https://lore.kernel.org/20261023-fix-vma-atomic-v1-2-8ff4fae1fc85@kernel.org
Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: SJ Park <sj@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Colin Cross <ccross@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vma.c      | 2 +-
 mm/vma_init.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/vma.c b/mm/vma.c
index 3d63f73e723b9..e2ce21afe44a6 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -557,6 +557,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 			return err;
 	}
 
+	vma_start_write(vma);
 	new = vm_area_dup(vma);
 	if (!new)
 		return -ENOMEM;
@@ -587,7 +588,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
-	vma_start_write(vma);
 	vma_start_write(new);
 
 	init_vma_prep(&vp, vma);
diff --git a/mm/vma_init.c b/mm/vma_init.c
index baa7e82f47e3f..d661f229a734f 100644
--- a/mm/vma_init.c
+++ b/mm/vma_init.c
@@ -127,6 +127,9 @@ struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig)
 {
 	struct vm_area_struct *new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 
+	/* Must hold a write lock to stabilise atomic VMA flags. */
+	vma_assert_write_locked(orig);
+
 	if (!new)
 		return NULL;
 
-- 
2.53.0



