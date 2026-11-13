Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591162;
	b=Aglrx9SExcIxaboD3chEmYy0yqQ2eyEtGfBIFhDgn2E4k3RIOVL9gjA65LLCHJCXo6NR
	 8YRWQFV93cEqF3IY/l6AN+tmjrYQruHKOhh22kwMHKDnofpELdoQV2oG2xmwSPumV0mMP
	 fkSTSliOUhtiV13rFgwmUqOzaljKi2CPx6SMfwHVnQH9KM4xb0mYua/uCM7b9qCPqeQg/
	 VAmJWxHlSVcsUD5nwnYyA8iwxXP28gfc3xn5uR9Au4r90uNJ4qm7Av9sVx7ON6z8vDNu/
	 b66wOL9dF7zAQ5uyoabDM+nkrW72zwwFHgGPkrrppQ8qfTV6UmTLBepfb3Jfm3xqJzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uDAVgZs0/HgdgWwAMB6rGFub/PYpCsUVelCFooXxAMA=;
	b=npLy7j1bAXaIzUrVUaSbzDmvwBX85mBsCYAaB54Qh1jGbC6JgpXFBYrZlMDZSWnpSHVk
	 yiJc/izIAOCkLyEv4heU721MYtlOEW/qBt0MSyq2XSb9TIcbct1marsj+i6e3ciQfG/pN
	 mSeX9vvhiRO3+fep9iLfQSGz2Et1OoYg9BnjI7a731xXdyr96JlZPBgj5/fkCgY9XP0kj
	 3reigq+SVtyxbVVyoI3LmMe+8E3gJOPiyBgz9sWdj+RwzmePXX9hGZhDM9ff6znPSNR/h
	 gZKriyEoJ+phBzHChYSBtenuKERnI0fAKUoyEQSS7AI9/3ucG+q413F1KbcocVEHNhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3i9hNEh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB94606C08A;
	Fri, 13 Nov 2026 17:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3i9hNEh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3951F000C6;
	Fri, 13 Nov 2026 17:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591162;
	bh=uDAVgZs0/HgdgWwAMB6rGFub/PYpCsUVelCFooXxAMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3i9hNEhkEBYRAqn5lJmPj3YhAg9455Q4vxjLoIdTFMxONCgjcit3yv3MEif5jdNC
	 XF6/NbXA1aW6WZLeQFq8nNt0QDEfRKh9UyGDWJuf4HS4e36+8o2JVqzTrh/VhGlDMI
	 UEo+53V76AgnSAnFREW13koiLi/K/Gj7PQHOA++U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yongji <xieyongji@bytedance.com>,
	"chenglong.ma" <longpareto@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Claude Code <noreply@anthropic.com>
Subject: [PATCH 6.12 305/670] vduse: fix VA/PA confusion in the coherent page fault path
Date: Fri, 13 Nov 2026 10:47:49 -0500
Message-ID: <20261113153822.250951664@linuxfoundation.org>
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

From: chenglong.ma <longpareto@gmail.com>

[ Upstream commit bb2e6f166547838fd7c320b01c90918b736f76e2 ]

vduse_domain_get_coherent_page() assumes that iotlb entries above
bounce_size were installed by vduse_domain_alloc_coherent(), so it
treats map->addr as a physical address. But vduse registers with
use_va = true, and when the device is bound to vhost_vdpa,
vhost_vdpa_va_map() stores a userspace virtual address in map->addr,
which vduse_domain_set_map() then copies into the same iotlb. A
process holding the domain file descriptor across a rebind can
therefore fault in an arbitrary physical page with read/write
access, ignoring the entry permissions.

Additionally, since the domain file mmap lacks VM_IO, the domain
file itself can be mapped and passed to vhost_vdpa_va_map(),
producing self-referential entries that bypass the coherent path
check.

To fix, only translate entries whose backing file is the domain
file itself in vduse_domain_get_coherent_page(), reject such
entries in vduse_domain_set_map() since only external mappings
should be imported, and set VM_IO on the domain file mmap so
vhost_vdpa_va_map() refuses to map it in the first place.

Fixes: 8c773d53fb7b ("vduse: Implement an MMU-based software IOTLB")
Cc: Xie Yongji <xieyongji@bytedance.com>
Cc: stable@vger.kernel.org
Reported-by: chenglong.ma <longpareto@gmail.com>
Signed-off-by: chenglong.ma <longpareto@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Co-Authored-By: Claude Code <noreply@anthropic.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/iova_domain.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_user/iova_domain.c
index e8b837df328f0..b8b2eb44410da 100644
--- a/drivers/vdpa/vdpa_user/iova_domain.c
+++ b/drivers/vdpa/vdpa_user/iova_domain.c
@@ -76,6 +76,10 @@ int vduse_domain_set_map(struct vduse_iova_domain *domain,
 	for (map = vhost_iotlb_itree_first(iotlb, start, last); map;
 	     map = vhost_iotlb_itree_next(map, start, last)) {
 		map_file = (struct vdpa_map_file *)map->opaque;
+		if (!map_file || map_file->file == domain->file) {
+			ret = -EINVAL;
+			goto err;
+		}
 		ret = vduse_iotlb_add_range(domain, map->start, map->last,
 					    map->addr, map->perm,
 					    map_file->file,
@@ -226,6 +230,7 @@ vduse_domain_get_coherent_page(struct vduse_iova_domain *domain, u64 iova)
 {
 	u64 start = iova & PAGE_MASK;
 	u64 last = start + PAGE_SIZE - 1;
+	struct vdpa_map_file *map_file;
 	struct vhost_iotlb_map *map;
 	struct page *page = NULL;
 
@@ -234,6 +239,10 @@ vduse_domain_get_coherent_page(struct vduse_iova_domain *domain, u64 iova)
 	if (!map)
 		goto out;
 
+	map_file = (struct vdpa_map_file *)map->opaque;
+	if (!map_file || map_file->file != domain->file)
+		goto out;
+
 	page = pfn_to_page((map->addr + iova - map->start) >> PAGE_SHIFT);
 	get_page(page);
 out:
@@ -579,7 +588,7 @@ static int vduse_domain_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct vduse_iova_domain *domain = file->private_data;
 
-	vm_flags_set(vma, VM_DONTDUMP | VM_DONTEXPAND);
+	vm_flags_set(vma, VM_IO | VM_DONTDUMP | VM_DONTEXPAND);
 	vma->vm_private_data = domain;
 	vma->vm_ops = &vduse_domain_mmap_ops;
 
-- 
2.53.0



