Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047620;
	b=rF9Qsgz4T6QY9ZtOBsIOpNLsXciEUfJG4wKDpRUqbyAGim9f2gDEGPYllOUF7JnlKYjm
	 Nj6psbxfZxNWk1agsmuSF5L6uKRzpWGsy+LhxGhwvxreHBH0V3C+GbH1tcYToe1ETVBxl
	 HYQMlYsnr/1yff2S2xbmIW68ahTwcayGbSZTRXerTnMiQP1bzQknmXT6TH/PELx+TSuQU
	 9fjr2zPS17gdUB1dx7wq4ODsa/qXfkx3VsE/nzZoP4SCkTSuQ6cqZXF7ecmcgpQqcRIvj
	 RiZqdps3VJYbI5SfIiyTmBOFaSGVNhmurvsGamcPYoT6CdgMo41tlj5mnwM5ToyUwiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZgdDsVbo21A3BHd7z9l+2PTq5Pi3IaoP7J+hNIszNzY=;
	b=bJUohmPN1AYInMZmBb3LvJa85kaLFJ1Bj3FOjd1HPf9jjh8CTWEAaP8tff+zUAVyZNp5
	 VGupoFvAqoemlvu+L5LTNnTuRwjJtqdeoW91K6mfeS+DrWiYuSgA5NvphYVmwZ3Ob7oPb
	 1rx50Rsjl8nNYF1+1mWc/W8/7Zzdf4NWeBoTxboW5zaZsQ8PpGBr2oFqgd9pF5/yyX8r3
	 hvI6vysO3bYb1AQLwhy9LQ+PkydKEAgvwAcKT8RG7HVaXdCD3Q0Iez47DU1fAFffH44++
	 fIj/rK0+wsG1FRaGvsBygahbFod7U/lOs8Z82vzyS5mUJUuSlfC+bumLEv9eJHugSvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRwWzpPL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EF8606A320;
	Thu, 19 Nov 2026 00:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRwWzpPL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F56A1F000C4;
	Thu, 19 Nov 2026 00:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047619;
	bh=ZgdDsVbo21A3BHd7z9l+2PTq5Pi3IaoP7J+hNIszNzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gRwWzpPLKu2hoaAuwgKPSDxY1kfXqwffPZ9vWHihgSXe0K0VFbsrJIDsEfYun/QwS
	 tNDNlzSDkoZSC0ym39zCu/Gqkl+0I25vzlGDCZi8sl9THlt71Of/qIouo3Rr7MNwgf
	 1tmC9NNraBIFaSrCy+k+b9FQ+/tVkJvEh60eCfJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yongji <xieyongji@bytedance.com>,
	"chenglong.ma" <longpareto@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Claude Code <noreply@anthropic.com>
Subject: [PATCH 6.1 1703/2857] vduse: fix VA/PA confusion in the coherent page fault path
Date: Wed, 18 Nov 2026 15:45:37 +0100
Message-ID: <20261118150302.651271907@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced vm_flags_set() with a direct vma->vm_flags |= update because the helper is unavailable ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/iova_domain.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_user/iova_domain.c
index e60a2b4065af9..a0c6835019a63 100644
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
@@ -222,6 +226,7 @@ vduse_domain_get_coherent_page(struct vduse_iova_domain *domain, u64 iova)
 {
 	u64 start = iova & PAGE_MASK;
 	u64 last = start + PAGE_SIZE - 1;
+	struct vdpa_map_file *map_file;
 	struct vhost_iotlb_map *map;
 	struct page *page = NULL;
 
@@ -230,6 +235,10 @@ vduse_domain_get_coherent_page(struct vduse_iova_domain *domain, u64 iova)
 	if (!map)
 		goto out;
 
+	map_file = (struct vdpa_map_file *)map->opaque;
+	if (!map_file || map_file->file != domain->file)
+		goto out;
+
 	page = pfn_to_page((map->addr + iova - map->start) >> PAGE_SHIFT);
 	get_page(page);
 out:
@@ -565,7 +574,7 @@ static int vduse_domain_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct vduse_iova_domain *domain = file->private_data;
 
-	vma->vm_flags |= VM_DONTDUMP | VM_DONTEXPAND;
+	vma->vm_flags |= VM_IO | VM_DONTDUMP | VM_DONTEXPAND;
 	vma->vm_private_data = domain;
 	vma->vm_ops = &vduse_domain_mmap_ops;
 
-- 
2.53.0



