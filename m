Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3141509BC;
	Tue, 20 Feb 2024 21:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464777; cv=none; b=GggpOk6I6C9P4fsgDLxsH7UHxEfiu3KcXIODsWJHphBA731En0K1IDKdFJdcMkeHALB/BTL0b2+WuGPb/gVyBY9NixIb5+SXQzDc+0MtopfrTw0rGZjtIsYdBRidbqB7Gl8wRVYOwSa6jIYXdJbYuMQUA+j0CRGJ/Y0W8h2851I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464777; c=relaxed/simple;
	bh=QM3qE/cRLtwWse3Lj3dGiWoMenGnW5AlitFLXrqbRNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTgFpEribttqdVV83fo35tlIaLkpYvloHhlSTLQG6PihZncvjo2F6rDjd2QvXqN8biTSGiJDrGcogYkBiiAonBqwV+Ennw4NWb1GOj1qI2P4/3yXmd+YGr1OoRMegGqIH3lp+p0lxUdBIvvPAr0eKIRP7iiZEZBWt3sLJymdtK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/jfLev9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/jfLev9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FB4C433F1;
	Tue, 20 Feb 2024 21:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464777;
	bh=QM3qE/cRLtwWse3Lj3dGiWoMenGnW5AlitFLXrqbRNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/jfLev9/e/HLSPDjpJK7UaWarvuDNMi8C7V4pa5P6qdrLNmY1QDJ3hJ4YPTlw6sj
	 V0IKSeRIRUDqmAnw5yGnK3xnxbuZitxg2Vf5e5+dCfdxGvXD4PDLd3XmP9I0reLX00
	 Ms6BClHi8FxsjAuOFX2Y3yS+Kq26qsROamWoVQ7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenyu Zhang <zhenyzha@redhat.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Sebastian Ott <sebott@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 6.7 134/309] drm/virtio: Set segment size for virtio_gpu device
Date: Tue, 20 Feb 2024 21:54:53 +0100
Message-ID: <20240220205637.334502108@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ott <sebott@redhat.com>

commit 9c64e749cebd9c2d3d55261530a98bcccb83b950 upstream.

Set the segment size of the virtio_gpu device to the value
used by the drm helpers when allocating sg lists to fix the
following complaint from DMA_API debug code:

DMA-API: virtio-pci 0000:07:00.0: mapping sg segment longer than
device claims to support [len=262144] [max=65536]

Cc: stable@vger.kernel.org
Tested-by: Zhenyu Zhang <zhenyzha@redhat.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/7258a4cc-da16-5c34-a042-2a23ee396d56@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/virtio/virtgpu_drv.c
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.c
@@ -94,6 +94,7 @@ static int virtio_gpu_probe(struct virti
 			goto err_free;
 	}
 
+	dma_set_max_seg_size(dev->dev, dma_max_mapping_size(dev->dev) ?: UINT_MAX);
 	ret = virtio_gpu_init(vdev, dev);
 	if (ret)
 		goto err_free;


