Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD5F34D3BD;
	Tue, 16 Dec 2025 11:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885381; cv=none; b=sOhaB/zIMaeh8koEgt0akx7PcfFQfStkGTVE5SLPLgBWLD06NoM5VbvjSObzZn3WKZKAPiO5tPWyobkvNNsfIRVSzSOlPOO9V+S9x7wE8M+8LGKnQQT+CJ80U3oPTu9v2Jtwm6inRCMlUCSaJRyxxGiYNDe5+dFscRzj/A7cT2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885381; c=relaxed/simple;
	bh=gfPaKI9UcrZpdHdoiMGr+FSPIBRzLxS2m7UyuOoswVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCAShpQ/6jze8ql3gBFkJspcNoj5ZBvlxQQN0z3pX/a78kI1UogogFObLqV+ziol2RC6oUEfFHDO61MN3uMWXGQ8ZKqBuxrbnn7uFAHuFeaH+W7nANqfc6VWEPRV3JhOKS/1wHHXjEdGzVef7vfJ0k76I/ekxf65Gr6Vod6jQvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ioh5vZfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ioh5vZfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FA5C4CEF1;
	Tue, 16 Dec 2025 11:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885380;
	bh=gfPaKI9UcrZpdHdoiMGr+FSPIBRzLxS2m7UyuOoswVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ioh5vZfYevHLZniy5ayyqC9uPUtR5o49k6VbSG+wofJTJua0kzYB39uEhzO8IoFai
	 +p4TPSiQeiyZT5agoUGdnS5muO0pruSH+SpL2sQso+1eC3eyvKQCtWBYyJCI18NOOg
	 d/sgqqCBf5B7nkPCBgq7yqIaKWV2+4TLacoytgd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 122/507] accel/ivpu: Remove skip of dma unmap for imported buffers
Date: Tue, 16 Dec 2025 12:09:23 +0100
Message-ID: <20251216111349.952689668@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



