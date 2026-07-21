Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90CF256C84;
	Tue, 21 Jul 2026 15:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649414; cv=none; b=JTnfG1ZufJxceciToEIocgWYXJoNcJOA1/CUcUHnW2utfLRCUNQRlQGYZwiY0oyzCkGuXTJ8icBvJwhIYGkZiiPd1/ocRIdShITfbAW9X0qmSYv+GAY0eNlrYw/HJU3p0/d2GUNasqVyTuLecmCFWtSkBe/LItgEfLQS9JAQ/xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649414; c=relaxed/simple;
	bh=eIVg3mheZg8mW+U7xvsxbovmogUHUv7Rkf/mDmzaZHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3/mHMEN4X0bcIgVoq/hDiA40MuYmZ4H0/dWqQMOZAUYRRG/7TpC8FdImkWz9WCCYrbYVsHDhS12SIMvw+9sDV8XZds3nmg9f6Q5InLKL1ZRGCkW9np46PMAm9FtqfMjqQc49hqGE7sVEwwV1VKtBHH77eU85wJRa2Y3w1k5XMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPSx1VCf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPSx1VCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F85B1F00A3D;
	Tue, 21 Jul 2026 15:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649413;
	bh=HJay47GhelGTuN8mIo0cZQXybVQMYKNy0O7av5q/UrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPSx1VCfu9k0t2sPey73iGCXuq4Ce77x7IhTCenqqWM7g1w3BPlhkmwoaBS3I1SPW
	 FCSPaY1AUcryw3W0p06yZ6PqLCzHuGCGafLPq7fbdfOdnJQ/qx2O0z0jQuuU0MGUSk
	 opQi2OatH2FYLqGtoOpfgWObXlTR0r22/KF4uYAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Soni <Ankit.Soni@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0569/2077] iommufd: Take dma_resv lock before dma_buf_unpin() in release path
Date: Tue, 21 Jul 2026 17:04:02 +0200
Message-ID: <20260721152606.230162824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Soni <Ankit.Soni@amd.com>

[ Upstream commit e745cd2c749e557c14a15ac931761c3f58c24489 ]

dma_buf_unpin() requires the caller to hold the exporter's dma_resv
lock:

  void dma_buf_unpin(struct dma_buf_attachment *attach)
  {
          ...
          dma_resv_assert_held(dmabuf->resv);
          ...
  }

iopt_release_pages() calls dma_buf_unpin() without taking that lock,
so every iommufd_ioas_destroy()/iommufd_ioas_unmap() that releases
the last reference on a DMABUF-backed iopt_pages triggers a WARN.
This was hit while running tools/testing/selftests/iommu/iommufd:

  WARNING: drivers/dma-buf/dma-buf.c:1137 at dma_buf_unpin+0x62/0x70
  RIP: 0010:dma_buf_unpin+0x62/0x70
  Call Trace:
   <TASK>
   dma_buf_unpin+0x62/0x70
   iopt_release_pages+0xe4/0x190
   iopt_unmap_iova_range+0x1c7/0x290
   iopt_unmap_all+0x1a/0x30
   iommufd_ioas_destroy+0x1d/0x50
   iommufd_fops_release+0x93/0x150
   __fput+0xfc/0x2c0
   __x64_sys_close+0x3d/0x80
   do_syscall_64+0x65/0x180
   </TASK>

Take the dma_resv lock around dma_buf_unpin() in iopt_release_pages(),
matching the iopt_map_dmabuf() convention. dma_buf_detach() acquires the
reservation lock internally, so it must remain outside the locked region.

Fixes: 8c5f9645c389 ("iommufd: Add dma_buf_pin()")
Link: https://patch.msgid.link/r/20260526111034.4079-1-Ankit.Soni@amd.com
Reported-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/pages.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 9bdb2945afe1eb..7b64002e54b9a2 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1663,7 +1663,9 @@ void iopt_release_pages(struct kref *kref)
 	if (iopt_is_dmabuf(pages) && pages->dmabuf.attach) {
 		struct dma_buf *dmabuf = pages->dmabuf.attach->dmabuf;
 
+		dma_resv_lock(dmabuf->resv, NULL);
 		dma_buf_unpin(pages->dmabuf.attach);
+		dma_resv_unlock(dmabuf->resv);
 		dma_buf_detach(dmabuf, pages->dmabuf.attach);
 		dma_buf_put(dmabuf);
 		WARN_ON(!list_empty(&pages->dmabuf.tracker));
-- 
2.53.0



