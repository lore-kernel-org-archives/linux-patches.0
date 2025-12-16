Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1159749C;
	Tue, 16 Dec 2025 12:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887159; cv=none; b=TfoFS11BY7h0f4Pun5w6QzH/dZgm/Cmu9TjKFDFaQcQK9k3fONccyoe3lakKeHMCL+nlQKEODsPOmTrBK4lRQiLYt7ZAqLk+tx42PXi/7SikFmjI/SraDoyIfFIHysuOy3hWCEOk+8obb3+oFqwlaxN0bCblbe+aWSkDOVMC0CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887159; c=relaxed/simple;
	bh=Xcbr6jb+vmiT6T4IME/r/KXT3PbxSFPfYftR5BHVCgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8Atg9tdRBJzljzCFi+LRfrYrX6nc2kKHrh+1ZIFTscT8qp8YB7siHQkvvL8le6IyAqPgnrilc5EykhBD8sWvyS5zPzfn/uTHo1yM3nTdpjO2uyz7kX6uHXJknEMinuMvFSR5DakdK0S8iFm1bYJAkqZNeVas9M9zAqjc8ACxSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XncIjZ2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XncIjZ2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DDEC4CEF1;
	Tue, 16 Dec 2025 12:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887158;
	bh=Xcbr6jb+vmiT6T4IME/r/KXT3PbxSFPfYftR5BHVCgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XncIjZ2VFX1IFUBquCCkqWBcteM+c21XJLq6+qxNuFaLwqo24CjmtwAS224EZT/8G
	 qNC782RikhsVNOxojoZNySkZpIHHoMmUe6OqswnktZzm+kC1yCmX/cWcCE2vuKAy25
	 Kz6ionXk41f9BwIr5gNt0OXXz9o/h5fognQ8jp0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 145/614] accel/ivpu: Remove skip of dma unmap for imported buffers
Date: Tue, 16 Dec 2025 12:08:32 +0100
Message-ID: <20251216111406.591462361@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Falkowski <maciej.falkowski@linux.intel.com>

[ Upstream commit c063c1bbee67391f12956d2ffdd5da00eb87ff79 ]

Rework of imported buffers introduced in the commit
e0c0891cd63b ("accel/ivpu: Rework bind/unbind of imported buffers")
switched the logic of imported buffers by dma mapping/unmapping
them just as the regular buffers.

The commit didn't include removal of skipping dma unmap of imported
buffers which results in them being mapped without unmapping.

Fixes: e0c0891cd63b ("accel/ivpu: Rework bind/unbind of imported buffers")
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Link: https://patch.msgid.link/20251027150933.2384538-1-maciej.falkowski@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_gem.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_gem.c b/drivers/accel/ivpu/ivpu_gem.c
index 1fca969df19dc..a38e41f9c7123 100644
--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -157,9 +157,6 @@ static void ivpu_bo_unbind_locked(struct ivpu_bo *bo)
 		bo->ctx = NULL;
 	}
 
-	if (drm_gem_is_imported(&bo->base.base))
-		return;
-
 	if (bo->base.sgt) {
 		if (bo->base.base.import_attach) {
 			dma_buf_unmap_attachment(bo->base.base.import_attach,
-- 
2.51.0



