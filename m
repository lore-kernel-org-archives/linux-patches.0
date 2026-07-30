Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE01441638;
	Thu, 30 Jul 2026 15:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425064; cv=none; b=VLHydc3UIVaY5EKSgrMHb5kuTzZYZV0KNdtcZIf/r2SuHE+UqaAOn5kguGWXaMIw8I8BZE/2RXJ31RokLkZcU43AtjwwMGsSCcXu1NrZFGfaN0oHZgyTAEhyD3MgZVVvctjq8ANbcKW99IzHksJBdZuRcEf87qMu70QRxp8dm6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425064; c=relaxed/simple;
	bh=U0ditIpyonczpRcNZp8tDm+H5hFxBGdy4TxTjMo3724=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hvWLXXbW0TBovUY/p1kRbaOUZEaZmvgJbFxMVXMb/ZMVpBeyyBMOux6Fe1T0N424I0eHChL0S7MYjjus+FdgCyTDBJNL8xLSNoOgfK2M0Veu/1uZyOEv7m4g2Fl0ya/hE1wNi6A8oizEt0OU0Gq184cCnpcoyhXIvqGRaJuC0qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIXF3J1d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIXF3J1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F7B1F000E9;
	Thu, 30 Jul 2026 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425063;
	bh=23cFoe4sR+XYh5C730X98W+VocDHVdoCP2fccNkBVWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIXF3J1dy9j6nrPvX5soq8+H2MES5FC/d6JfoMjGWEEzYDWpMi8002kO2TsQItnZg
	 uM1VC40G3DicYnu8YphazaSH5DtXzzZZwGLnRfaXxfxfZmNpE4wKNC10+sIWe2BnqY
	 SNOyu7nvL9a2fNlrWOGv937LXEmNhOHcBYMs7/S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 614/675] vduse: take out allocations from vduse_dev_alloc_coherent
Date: Thu, 30 Jul 2026 16:15:44 +0200
Message-ID: <20260730141458.166826574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugenio Pérez <eperezma@redhat.com>

[ Upstream commit 489d76520612abf9a4ede4344349105406c91a73 ]

The function vduse_dev_alloc_coherent will be called under rwlock in
next patches.  Make it out of the lock to avoid increasing its fail
rate.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20260119143306.1818855-10-eperezma@redhat.com>
Stable-dep-of: 9c1523803445 ("VDUSE: avoid leaking information to userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_user/iova_domain.c |    3 ---
 drivers/vdpa/vdpa_user/vduse_dev.c   |    1 +
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/vdpa/vdpa_user/iova_domain.c
+++ b/drivers/vdpa/vdpa_user/iova_domain.c
@@ -526,7 +526,6 @@ void vduse_domain_free_coherent(struct v
 	struct iova_domain *iovad = &domain->consistent_iovad;
 	struct vhost_iotlb_map *map;
 	struct vdpa_map_file *map_file;
-	phys_addr_t pa;
 
 	spin_lock(&domain->iotlb_lock);
 	map = vhost_iotlb_itree_first(domain->iotlb, (u64)dma_addr,
@@ -538,12 +537,10 @@ void vduse_domain_free_coherent(struct v
 	map_file = (struct vdpa_map_file *)map->opaque;
 	fput(map_file->file);
 	kfree(map_file);
-	pa = map->addr;
 	vhost_iotlb_map_free(domain->iotlb, map);
 	spin_unlock(&domain->iotlb_lock);
 
 	vduse_domain_free_iova(iovad, dma_addr, size);
-	free_pages_exact(phys_to_virt(pa), size);
 }
 
 static vm_fault_t vduse_domain_mmap_fault(struct vm_fault *vmf)
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -961,6 +961,7 @@ static void vduse_dev_free_coherent(unio
 	domain = vdev->domain;
 
 	vduse_domain_free_coherent(domain, size, dma_addr, attrs);
+	free_pages_exact(vaddr, size);
 }
 
 static bool vduse_dev_need_sync(union virtio_map token, dma_addr_t dma_addr)


