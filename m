Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB6C248F6A;
	Tue, 11 Nov 2025 01:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823273; cv=none; b=uZyhKimimkyfVhbiGjGsn6mt0necMuNMY05SuT1WJXNjDVGn0argZQZEsWpqoKqZV+fX2wDhW2epo1D/iNR485JuvfXPeaWa5xpRwF77aIY5K7dQtlLGwjScJB4cYkiiuijuclvnWLbPkcMv8iLSl/4bnPvNYm8oMg2pMKSY0So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823273; c=relaxed/simple;
	bh=7NRFMsbPybHXfY26HZQ9QyVI53gzGG/igNOeut4qlrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EDRvzubYxI+AeKmWvaIepDZ0VNDt1GWiAEl8o7SfKLh4sLxUFuqq7gO4uyqRZmqzervLwlRUdpYgui9Am/quLvk6DvFC2tSAQ9nm5jseX1iyicaicMBDFBAc+rBg9RerC70gjVrQCRqmLebc/Zcw2hU0zhR29wfLxbr7rG8wwnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5omNOjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5omNOjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDF9C4CEFB;
	Tue, 11 Nov 2025 01:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823273;
	bh=7NRFMsbPybHXfY26HZQ9QyVI53gzGG/igNOeut4qlrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5omNOjK+eixkw0UDZTGjPtHGWATydEbHhm9QjHRRzQgebyC7mY2I7JSpeu+5ogkL
	 OSfbP17GcA25cHM+7dwwNlkavQd+4tm9BNWkTIWK1sZbhJqEO4RTQBwY3VmnKzRRRz
	 x6alsepf0knemxXbRP/XqnazMBEAbbV3OJslreXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 266/849] drm/amdgpu: add to custom amdgpu_drm_release drm_dev_enter/exit
Date: Tue, 11 Nov 2025 09:37:16 +0900
Message-ID: <20251111004542.863776332@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

[ Upstream commit c31f486bc8dd6f481adcb9cca4a6e1837b8cf127 ]

User queues are disabled before GEM objects are released
(protecting against user app crashes).
No races with PCI hot-unplug (because drm_dev_enter prevents cleanup
if iewdevice is being removed).

Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index c1792e9ab126d..5e81ff3ffdc3f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2937,11 +2937,14 @@ static int amdgpu_drm_release(struct inode *inode, struct file *filp)
 {
 	struct drm_file *file_priv = filp->private_data;
 	struct amdgpu_fpriv *fpriv = file_priv->driver_priv;
+	struct drm_device *dev = file_priv->minor->dev;
+	int idx;
 
-	if (fpriv) {
+	if (fpriv && drm_dev_enter(dev, &idx)) {
 		fpriv->evf_mgr.fd_closing = true;
 		amdgpu_eviction_fence_destroy(&fpriv->evf_mgr);
 		amdgpu_userq_mgr_fini(&fpriv->userq_mgr);
+		drm_dev_exit(idx);
 	}
 
 	return drm_release(inode, filp);
-- 
2.51.0



