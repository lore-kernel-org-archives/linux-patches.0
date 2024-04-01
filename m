Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED30546B9F;
	Mon,  1 Apr 2024 16:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989371; cv=none; b=NHCff7YfGHsDUQunE8E4VnDE/s1gXfRsABDRnJBDvTxhGHoUebLZX3A0XAFEmvTr02msjUsnqtc5IeOuyGJ4fsfI1ApjSqGlhEd6yh4fPfXEYjpQg1l1NVKxoqNHFDc5eKzlbfb3ZSN3v1G+z1cNYb2JKcIzyMso4xd9uGjtc28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989371; c=relaxed/simple;
	bh=fzAIMy9t3J0h7iX8Gx4+tqjfMbVKDxlfrluMly4pLTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hj2thl2FDgHXJu/LMCAQ0lhKUNSZjr1FqdCts5Xr+Q78d6/eLUJ8BJRXXKbpToZuUX1rk7mqvJ2t6Y8ROTSWUNJjqLXOEdFGm2wolwtuVhJHEAgpPgTrzB9LCe6ea2ciDMHYowRYePBjFXGQypHwR7RpvCOnB9BwzNBIJ4/6nwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqwEez8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqwEez8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C18C43399;
	Mon,  1 Apr 2024 16:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989370;
	bh=fzAIMy9t3J0h7iX8Gx4+tqjfMbVKDxlfrluMly4pLTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqwEez8vyi8jrco8lWIELQbBJsigalFAb5bVc8KOKNcrGOO0/a871WCeD7tomhHyZ
	 0vo4RzqOz+jnthA+j9vakF9d8gEOJ2VqWQhwK1YTXYkgpjEFljXdZQtCxg7yQq99nc
	 c5M5U+K/VMraupoJEzz20ZLa/wT8bY27WU/80+8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/396] remoteproc: virtio: Fix wdg cannot recovery remote processor
Date: Mon,  1 Apr 2024 17:40:57 +0200
Message-ID: <20240401152548.130454552@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Joakim Zhang <joakim.zhang@cixtech.com>

[ Upstream commit b327c72753d6a78de37aed6c35756f2ef62897ee ]

Recovery remote processor failed when wdg irq received:
[    0.842574] remoteproc remoteproc0: crash detected in cix-dsp-rproc: type watchdog
[    0.842750] remoteproc remoteproc0: handling crash #1 in cix-dsp-rproc
[    0.842824] remoteproc remoteproc0: recovering cix-dsp-rproc
[    0.843342] remoteproc remoteproc0: stopped remote processor cix-dsp-rproc
[    0.847901] rproc-virtio rproc-virtio.0.auto: Failed to associate buffer
[    0.847979] remoteproc remoteproc0: failed to probe subdevices for cix-dsp-rproc: -16

The reason is that dma coherent mem would not be released when
recovering the remote processor, due to rproc_virtio_remove()
would not be called, where the mem released. It will fail when
it try to allocate and associate buffer again.

Releasing reserved memory from rproc_virtio_dev_release(), instead of
rproc_virtio_remove().

Fixes: 1d7b61c06dc3 ("remoteproc: virtio: Create platform device for the remoteproc_virtio")
Signed-off-by: Joakim Zhang <joakim.zhang@cixtech.com>
Acked-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231217053659.3245745-1-joakim.zhang@cixtech.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_virtio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 83d76915a6ad6..25b66b113b695 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -351,6 +351,9 @@ static void rproc_virtio_dev_release(struct device *dev)
 
 	kfree(vdev);
 
+	of_reserved_mem_device_release(&rvdev->pdev->dev);
+	dma_release_coherent_memory(&rvdev->pdev->dev);
+
 	put_device(&rvdev->pdev->dev);
 }
 
@@ -584,9 +587,6 @@ static void rproc_virtio_remove(struct platform_device *pdev)
 	rproc_remove_subdev(rproc, &rvdev->subdev);
 	rproc_remove_rvdev(rvdev);
 
-	of_reserved_mem_device_release(&pdev->dev);
-	dma_release_coherent_memory(&pdev->dev);
-
 	put_device(&rproc->dev);
 }
 
-- 
2.43.0



