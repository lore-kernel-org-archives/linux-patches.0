Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D087A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC50C433D2;
	Tue, 10 Jan 2023 18:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374535;
	bh=6JRh4Rr8it+Lgp23VAcoc3J/lQz+PsMAP7iqcnh/ZPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTcBkyt+8/JcwnCC1GFKmG1FfTQVRq3pD2cQtgFfSNMm1niNZ485ZCQD4hkkqcK7K
	 hmmGxvBqggs+7wzFiDNv7Zx+/eo76mc0xZ8374j/owpWcg0YZxvU8hAqqAta8NMtZY
	 WioclYV8fsDmDioJhQsxWVdg9IjZbCtz8pDHYpEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Wang <wangrong68@huawei.com>,
	Nanyong Sun <sunnanyong@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Cindy Lu <lulu@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/159] vdpa/vp_vdpa: fix kfree a wrong pointer in vp_vdpa_remove
Date: Tue, 10 Jan 2023 19:03:17 +0100
Message-Id: <20230110180019.869301403@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rong Wang <wangrong68@huawei.com>

[ Upstream commit ed843d6ed7310a27cf7c8ee0a82a482eed0cb4a6 ]

In vp_vdpa_remove(), the code kfree(&vp_vdpa_mgtdev->mgtdev.id_table) uses
a reference of pointer as the argument of kfree, which is the wrong pointer
and then may hit crash like this:

Unable to handle kernel paging request at virtual address 00ffff003363e30c
Internal error: Oops: 96000004 [#1] SMP
Call trace:
 rb_next+0x20/0x5c
 ext4_readdir+0x494/0x5c4 [ext4]
 iterate_dir+0x168/0x1b4
 __se_sys_getdents64+0x68/0x170
 __arm64_sys_getdents64+0x24/0x30
 el0_svc_common.constprop.0+0x7c/0x1bc
 do_el0_svc+0x2c/0x94
 el0_svc+0x20/0x30
 el0_sync_handler+0xb0/0xb4
 el0_sync+0x160/0x180
Code: 54000220 f9400441 b4000161 aa0103e0 (f9400821)
SMP: stopping secondary CPUs
Starting crashdump kernel...

Fixes: ffbda8e9df10 ("vdpa/vp_vdpa : add vdpa tool support in vp_vdpa")
Signed-off-by: Rong Wang <wangrong68@huawei.com>
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Message-Id: <20221207120813.2837529-1-sunnanyong@huawei.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Cindy Lu <lulu@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/virtio_pci/vp_vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index d448db0c4de3..8fe267ca3e76 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -647,7 +647,7 @@ static void vp_vdpa_remove(struct pci_dev *pdev)
 	mdev = vp_vdpa_mgtdev->mdev;
 	vp_modern_remove(mdev);
 	vdpa_mgmtdev_unregister(&vp_vdpa_mgtdev->mgtdev);
-	kfree(&vp_vdpa_mgtdev->mgtdev.id_table);
+	kfree(vp_vdpa_mgtdev->mgtdev.id_table);
 	kfree(mdev);
 	kfree(vp_vdpa_mgtdev);
 }
-- 
2.35.1



