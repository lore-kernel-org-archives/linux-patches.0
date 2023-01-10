Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27284A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67403C433D2;
	Tue, 10 Jan 2023 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374525;
	bh=W8VJ1W+khlaCFUy2flCJ7ZF7VXVhqpIwtC6XSejzBls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELjNPGl7VDPygeNyUNSMP22pvM9w3zZ3wgbmTmL5tfHRW4Qq9LZGmxldBB+vswDEp
	 TI6CSA993u51k1WviY77TqYUskMMQq8uitPCkhlplScNoBtFjXKOx9h+HPyaUntN+2
	 G3g+97iRDAtr8/Jn2MJiaIT0Uk64bZWn+xZUcPFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/159] vhost-vdpa: fix an iotlb memory leak
Date: Tue, 10 Jan 2023 19:03:14 +0100
Message-Id: <20230110180019.775515282@linuxfoundation.org>
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

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit c070c1912a83432530cbb4271d5b9b11fa36b67a ]

Before commit 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
we called vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1) during
release to free all the resources allocated when processing user IOTLB
messages through vhost_vdpa_process_iotlb_update().
That commit changed the handling of IOTLB a bit, and we accidentally
removed some code called during the release.

We partially fixed this with commit 037d4305569a ("vhost-vdpa: call
vhost_vdpa_cleanup during the release") but a potential memory leak is
still there as showed by kmemleak if the application does not send
VHOST_IOTLB_INVALIDATE or crashes:

  unreferenced object 0xffff888007fbaa30 (size 16):
    comm "blkio-bench", pid 914, jiffies 4294993521 (age 885.500s)
    hex dump (first 16 bytes):
      40 73 41 07 80 88 ff ff 00 00 00 00 00 00 00 00  @sA.............
    backtrace:
      [<0000000087736d2a>] kmem_cache_alloc_trace+0x142/0x1c0
      [<0000000060740f50>] vhost_vdpa_process_iotlb_msg+0x68c/0x901 [vhost_vdpa]
      [<0000000083e8e205>] vhost_chr_write_iter+0xc0/0x4a0 [vhost]
      [<000000008f2f414a>] vhost_vdpa_chr_write_iter+0x18/0x20 [vhost_vdpa]
      [<00000000de1cd4a0>] vfs_write+0x216/0x4b0
      [<00000000a2850200>] ksys_write+0x71/0xf0
      [<00000000de8e720b>] __x64_sys_write+0x19/0x20
      [<0000000018b12cbb>] do_syscall_64+0x3f/0x90
      [<00000000986ec465>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Let's fix this calling vhost_vdpa_iotlb_unmap() on the whole range in
vhost_vdpa_remove_as(). We move that call before vhost_dev_cleanup()
since we need a valid v->vdev.mm in vhost_vdpa_pa_unmap().
vhost_iotlb_reset() call can be removed, since vhost_vdpa_iotlb_unmap()
on the whole range removes all the entries.

The kmemleak log reported was observed with a vDPA device that has `use_va`
set to true (e.g. VDUSE). This patch has been tested with both types of
devices.

Fixes: 037d4305569a ("vhost-vdpa: call vhost_vdpa_cleanup during the release")
Fixes: 3d5698793897 ("vhost-vdpa: introduce asid based IOTLB")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Message-Id: <20221109154213.146789-1-sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 166044642fd5..b08e07fc7d1f 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -65,6 +65,10 @@ static DEFINE_IDA(vhost_vdpa_ida);
 
 static dev_t vhost_vdpa_major;
 
+static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
+				   struct vhost_iotlb *iotlb,
+				   u64 start, u64 last);
+
 static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
 {
 	struct vhost_vdpa_as *as = container_of(iotlb, struct
@@ -135,7 +139,7 @@ static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
 		return -EINVAL;
 
 	hlist_del(&as->hash_link);
-	vhost_iotlb_reset(&as->iotlb);
+	vhost_vdpa_iotlb_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
 	kfree(as);
 
 	return 0;
@@ -1162,14 +1166,14 @@ static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
 	struct vhost_vdpa_as *as;
 	u32 asid;
 
-	vhost_dev_cleanup(&v->vdev);
-	kfree(v->vdev.vqs);
-
 	for (asid = 0; asid < v->vdpa->nas; asid++) {
 		as = asid_to_as(v, asid);
 		if (as)
 			vhost_vdpa_remove_as(v, asid);
 	}
+
+	vhost_dev_cleanup(&v->vdev);
+	kfree(v->vdev.vqs);
 }
 
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
-- 
2.35.1



