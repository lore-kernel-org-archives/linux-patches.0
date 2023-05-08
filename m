Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC01125B3
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BD0C433EF;
	Mon,  8 May 2023 10:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541094;
	bh=SSfty5k5frekUJIoyYf4pgyqGQ8iyw42iJoT+FBngcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9HnDbC5hfhF1Eff2uKq0LQBmML2SSF/qJ2xmAT3M+0jUvpZfU37qzzNN8olj+Juy
	 La90D5tjRKpWGUHstjENVloeNEv71S/p9BDJQ2N/rS32izB3PNG3bVV2aJLgk8qLRB
	 S4hM6X365XT5FKOPh84BYFVMhzjJ+DnpuRy0QZ24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cindy Lu <lulu@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.1 589/611] vhost_vdpa: fix unmap process in no-batch mode
Date: Mon,  8 May 2023 11:47:11 +0200
Message-Id: <20230508094441.053633775@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cindy Lu <lulu@redhat.com>

commit c82729e06644f4e087f5ff0f91b8fb15e03b8890 upstream.

While using the vdpa device with vIOMMU enabled
in the guest VM, when the vdpa device bind to vfio-pci and run testpmd
then system will fail to unmap.
The test process is
Load guest VM --> attach to virtio driver--> bind to vfio-pci driver
So the mapping process is
1)batched mode map to normal MR
2)batched mode unmapped the normal MR
3)unmapped all the memory
4)mapped to iommu MR

This error happened in step 3). The iotlb was freed in step 2)
and the function vhost_vdpa_process_iotlb_msg will return fail
Which causes failure.

To fix this, we will not remove the AS while the iotlb->nmaps is 0.
This will free in the vhost_vdpa_clean

Cc: stable@vger.kernel.org
Fixes: aaca8373c4b1 ("vhost-vdpa: support ASID based IOTLB API")
Signed-off-by: Cindy Lu <lulu@redhat.com>
Message-Id: <20230420151734.860168-1-lulu@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vdpa.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -819,11 +819,7 @@ static void vhost_vdpa_unmap(struct vhos
 		if (!v->in_batch)
 			ops->set_map(vdpa, asid, iotlb);
 	}
-	/* If we are in the middle of batch processing, delay the free
-	 * of AS until BATCH_END.
-	 */
-	if (!v->in_batch && !iotlb->nmaps)
-		vhost_vdpa_remove_as(v, asid);
+
 }
 
 static int vhost_vdpa_va_map(struct vhost_vdpa *v,
@@ -1080,8 +1076,6 @@ static int vhost_vdpa_process_iotlb_msg(
 		if (v->in_batch && ops->set_map)
 			ops->set_map(vdpa, asid, iotlb);
 		v->in_batch = false;
-		if (!iotlb->nmaps)
-			vhost_vdpa_remove_as(v, asid);
 		break;
 	default:
 		r = -EINVAL;


