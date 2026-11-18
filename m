Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054608;
	b=vk86mk0IVQWP2nBF6pPZ6VgmJtqWuIVNjzgDvlx66BeZAoYioGmnBy1jvsZ+7UFqHXMc
	 Rv01EvTaZLKcIz2GjBCVusaPu4wylpsaAgFqupOFf+qJe4mKSRW1G+o4ADSBiL+PyV0na
	 LQO6eW0SEgn/+qkPZyALMDF/PC543ZzEL//T3e+cBG74Au2Ym5R0a9knR2voY4u7Ygplc
	 VMml97VGKaLn/aqHMOEQ60aCyhB4HVzf0VODDJIb+rRlL51uz/T7RHuVyzigRoYyVV/3C
	 lLWeN++BgAG0zyoK2YSnZDJpekIwNBX5UitCOt7b9Ui+SFvd9Gu7Lx5hUC1zCpj9tRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0whBlp3XpnvltcDSVncdTfq/R/iO8EE9J9F4Ze8VGoA=;
	b=p3GVY+5G1BSXsw37KPyTbUf9IKEvcSyRNh6GM6sCYbOIR+AfMMxx0DPN2sXPL/vnIB/E
	 RUuWjXsPsq97Ukw1pmQr/fgiVFHJc4Nw/JbmojwlrUDkpkqk47Q3legIX2JhZukpyDwk4
	 3H3isJh9YFC97Qqqhyqc/PRbwKTXZkCJk0BCp8gpleQZ/fFf97li7innDT9fftYhAI7rG
	 vXSEShyyT74EPantB3uV3bpC+cD9UbKbF8PIvGhKQDSHD3sfTP2jS72d4rKd1f2D/119Q
	 XZ50yQMqgVhjE2jw1Ujfq5l32MJkgAAiSBLVbHOuR09vVlp1uJHRJgV+IQiftDLxssA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2afI3zKC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EA2606A320;
	Thu, 19 Nov 2026 02:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2afI3zKC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5467E1F000C4;
	Thu, 19 Nov 2026 02:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054607;
	bh=0whBlp3XpnvltcDSVncdTfq/R/iO8EE9J9F4Ze8VGoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2afI3zKCvhyuoc+cnvl46SSO5IxetpQ1SHs9996K2aCCdMc1sNjz/BxhrggRkOh/B
	 oBL+YliODaZu6NbZ6eQOBMtLS/qUEkr/qz2z4TUZOMr5hLl6KAqUqMVmMpstgkKrqg
	 ngmKudkekTWMnKdtaqEd2sQISM+9myCAX676sJtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yongji <xieyongji@bytedance.com>,
	"chenglong.ma" <longpareto@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Claude Code <noreply@anthropic.com>
Subject: [PATCH 5.15 1295/2214] vduse: fix VA/PA confusion in the coherent page fault path
Date: Wed, 18 Nov 2026 15:49:31 +0100
Message-ID: <20261118150103.341905936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced vm_flags_set() with a direct vma->vm_flags |= update because the helper is unavailable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/iova_domain.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_user/iova_domain.c
index 783319f160761..e7f1ed339b206 100644
--- a/drivers/vdpa/vdpa_user/iova_domain.c
+++ b/drivers/vdpa/vdpa_user/iova_domain.c
@@ -70,6 +70,10 @@ int vduse_domain_set_map(struct vduse_iova_domain *domain,
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
@@ -216,6 +220,7 @@ vduse_domain_get_coherent_page(struct vduse_iova_domain *domain, u64 iova)
 {
 	u64 start = iova & PAGE_MASK;
 	u64 last = start + PAGE_SIZE - 1;
+	struct vdpa_map_file *map_file;
 	struct vhost_iotlb_map *map;
 	struct page *page = NULL;
 
@@ -224,6 +229,10 @@ vduse_domain_get_coherent_page(struct vduse_iova_domain *domain, u64 iova)
 	if (!map)
 		goto out;
 
+	map_file = (struct vdpa_map_file *)map->opaque;
+	if (!map_file || map_file->file != domain->file)
+		goto out;
+
 	page = pfn_to_page((map->addr + iova - map->start) >> PAGE_SHIFT);
 	get_page(page);
 out:
@@ -461,7 +470,7 @@ static int vduse_domain_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct vduse_iova_domain *domain = file->private_data;
 
-	vma->vm_flags |= VM_DONTDUMP | VM_DONTEXPAND;
+	vma->vm_flags |= VM_IO | VM_DONTDUMP | VM_DONTEXPAND;
 	vma->vm_private_data = domain;
 	vma->vm_ops = &vduse_domain_mmap_ops;
 
-- 
2.53.0



