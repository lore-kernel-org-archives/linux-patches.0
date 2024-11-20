Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A971C7B63;
	Wed, 20 Nov 2024 13:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107602; cv=none; b=CQT1Cuei6V73yHJfs7ow+SadfXaI14Q1dX5JcQWcXHGyGXy/gRCSaj6OMrbdTrIjCR+WXELejWBvtTRe7VYCnn5jMdQYEBUSTSD4ml5d5Jkho/8Im4gGUNj+eQi+rRGVp+2JMM/aswxMBFZ0KaUgU+GPcF7wZTVBXXViiJxU6KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107602; c=relaxed/simple;
	bh=kz9sCQU/kM2LWfqM/B3IyK0DRU9yaTX4AQcXcDEP+Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlNFKUCbtMrJFKHZ1zjUSUQdy35ZvawGF5zX/pmULFvtM9TIs8PiW/QB+gA6JVxLtgvtKwBscHZZf8qLxdh8B4EQXF2lebCpNh8+tq6meQmFmAoxknnRjXJGphSDaO14Gh1h/Vt1whGgGhB9evTXSv2NBw7eu5r2Ugv9LL1esBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfMNah1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfMNah1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E3DC4CECD;
	Wed, 20 Nov 2024 13:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107602;
	bh=kz9sCQU/kM2LWfqM/B3IyK0DRU9yaTX4AQcXcDEP+Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfMNah1MDkwCIY3B9pUwb0Sgad8JVLX0LhSTbEWfz75rgUBBGV4C0+JVeMaN8bHTV
	 5B8+8yai1Be2gTBcwXV1TdNKttXauPLbSAWdX5hrq/PfjxD9GxuYEYhZpaEg3MrTez
	 WGyIaJKSJyhSeqcZ58Tu20SThNBv054H/xjLcwE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.6 52/82] nouveau: fw: sync dma after setup is called.
Date: Wed, 20 Nov 2024 13:57:02 +0100
Message-ID: <20241120125630.781619507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 21ec425eaf2cb7c0371f7683f81ad7d9679b6eb5 upstream.

When this code moved to non-coherent allocator the sync was put too
early for some firmwares which called the setup function, move the
sync down after the setup function.

Reported-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Tested-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Fixes: 9b340aeb26d5 ("nouveau/firmware: use dma non-coherent allocator")
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241114004603.3095485-1-airlied@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/falcon/fw.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/falcon/fw.c b/drivers/gpu/drm/nouveau/nvkm/falcon/fw.c
index a1c8545f1249..cac6d64ab67d 100644
--- a/drivers/gpu/drm/nouveau/nvkm/falcon/fw.c
+++ b/drivers/gpu/drm/nouveau/nvkm/falcon/fw.c
@@ -89,11 +89,6 @@ nvkm_falcon_fw_boot(struct nvkm_falcon_fw *fw, struct nvkm_subdev *user,
 		nvkm_falcon_fw_dtor_sigs(fw);
 	}
 
-	/* after last write to the img, sync dma mappings */
-	dma_sync_single_for_device(fw->fw.device->dev,
-				   fw->fw.phys,
-				   sg_dma_len(&fw->fw.mem.sgl),
-				   DMA_TO_DEVICE);
 
 	FLCNFW_DBG(fw, "resetting");
 	fw->func->reset(fw);
@@ -105,6 +100,12 @@ nvkm_falcon_fw_boot(struct nvkm_falcon_fw *fw, struct nvkm_subdev *user,
 			goto done;
 	}
 
+	/* after last write to the img, sync dma mappings */
+	dma_sync_single_for_device(fw->fw.device->dev,
+				   fw->fw.phys,
+				   sg_dma_len(&fw->fw.mem.sgl),
+				   DMA_TO_DEVICE);
+
 	ret = fw->func->load(fw);
 	if (ret)
 		goto done;
-- 
2.47.0



