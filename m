Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590373;
	b=TBx+e8gKXIUMWxpTQ6VPARgze3lM/fapWUkaKn72AV6bCbQ0Ff2Mq/F+uYTPawv7jufA
	 7PHNfRxWPnD8SDerenTch4cP7OYxgmaYwffCpynmiz4u+/RKJSxncm7OziBHb2jwCi4lO
	 BmMtGKPBp//4IvvF1Irqm59hsxhirDPxwGjllE/NBrthHNrLlJHPEdtciwWRqd7g4vFnz
	 S2QEOgLwv0cZWQuE+wR4E6HomfQKii2lOHv9CNBvFfWIEgmbov3ZYd5DVapxT1iH2i98F
	 z4Scn+hihgSNH3lIXtgxxWoNjiZJpNr0zTBsh9Bpfn49kIqJLeFjsdghe7KmhPmsOOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Up0LQw2/oKqw3hHCSTWZPD8Bg42Hyj4ze9Id71dOAxI=;
	b=hWbZWCObGLf+wSCOrW271XOCz1vG00uqoZIpz7fQScQ9EfXyOms5S5fC9pqLxtQBukPV
	 kx68S8VmD71M+GSYADD1E84CC46/SPrUTFEY3wyZEiN1+YLpWR2jFyVI/F1Tj7Ir+5TzF
	 qKN0qPYSyZwxsyl0c9nby10uzBeROr5FCUgjmdWepK3KAzclRDfmwskdLE5TLLg2H/tDx
	 kYCqv5AR3Bt0JyNCfvxJyClSX4SzP60A3KBn8Qxgjrozs1VRg0SrKdUhX/p39+OiZ7ro3
	 sDAbNa8xsdm5gkF/XfkG/zkcO+j/o0uwQTdk/+2vkIEaExYkRp/Ao8LM8o5C3KHQEWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uM7Fodmh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F44606B340;
	Fri, 13 Nov 2026 17:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uM7Fodmh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325811F000C4;
	Fri, 13 Nov 2026 17:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590373;
	bh=Up0LQw2/oKqw3hHCSTWZPD8Bg42Hyj4ze9Id71dOAxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uM7FodmhJ9NEVbZZBOEMgq3ufb5H2d/6xCLc4IrA95ncvHSTZybBjeq5fnkd0fEf0
	 ytdw3jbS/+Cf6cklCykmmv+lReyGZ1g++6FF+NI0NMmN6wPRtuuhwqvFjv0mw6AGsh
	 X+5qMrjUAMbtWjbIAGHUZp5i5bUjNPdQTwa5aNDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yongji <xieyongji@bytedance.com>,
	"chenglong.ma" <longpareto@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Claude Code <noreply@anthropic.com>
Subject: [PATCH 6.18 346/686] vduse: fix VA/PA confusion in the coherent page fault path
Date: Fri, 13 Nov 2026 10:47:59 -0500
Message-ID: <20261113153832.651052914@linuxfoundation.org>
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



