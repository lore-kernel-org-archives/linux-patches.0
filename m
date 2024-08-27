Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC871BD514;
	Tue, 27 Aug 2024 15:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771499; cv=none; b=ffz/c/3He45mTClP2JgOBM4bBcYeGY8Pw68cVeKCKwKJhZ2CXxwYRUfpkEX/F2jTReOAS04vqWH/oNMjjy9Lft9oiTwW4+ph7KXq/ZiNFMjN9WP3CiLGDFDojqIHsbzDsmhTyEPpTXHJR6TOHdHYKo4z705YdjR/HdnVGvCJ9aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771499; c=relaxed/simple;
	bh=pcT0INRNCBJEwOtSG0VT0SZtKbs6ztEm0dLGMI0tmfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTOaQfrF7tj7wF9kuzo+h7HvIhf7U3P3LAAqvF3+L26J3lpmUs6TvjC290xUxiyMIcqnrMvarZKqfGiYFlrOtWsu+XllcNzJ1Nw5nYWPvyiFYy1WM+NSyykdWXJ4e5oai9uXCMvTO0Qm39EbFG+IdFTZYfeyzQZufqBAp/6jSVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRUFZ0Hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRUFZ0Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B45C4DDED;
	Tue, 27 Aug 2024 15:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771499;
	bh=pcT0INRNCBJEwOtSG0VT0SZtKbs6ztEm0dLGMI0tmfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRUFZ0HvA1XbGF4FjTZ7lHyMnP9MGnh/Glbq7D3OYceqb89xqn8nKvR6LKC3xxFUP
	 NUYDAtnP+DhGT9hBMLoPYqFTRJfTp4+r5CKubT5VCxubAeZG9uNowMoItUAj0WwB+N
	 pPT4BNDAk5lB/d0tyOnIyee9MlR3KxHkKNW9E4y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 207/273] drm/xe/mmio: move mmio_fini over to devm
Date: Tue, 27 Aug 2024 16:38:51 +0200
Message-ID: <20240827143841.287561172@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit a0b834c8957a7d2848face008a12382a0ad11ffc ]

Not valid to touch mmio once the device is removed, so make sure we
unmap on removal and not just when driver instance goes away. Also set
the mmio pointers to NULL to hopefully catch such issues more easily.

Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240522102143.128069-32-matthew.auld@intel.com
Stable-dep-of: 15939ca77d44 ("drm/xe: Fix tile fini sequence")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_mmio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_mmio.c b/drivers/gpu/drm/xe/xe_mmio.c
index 334637511e750..2ebb2f0d6874e 100644
--- a/drivers/gpu/drm/xe/xe_mmio.c
+++ b/drivers/gpu/drm/xe/xe_mmio.c
@@ -386,13 +386,16 @@ void xe_mmio_probe_tiles(struct xe_device *xe)
 	}
 }
 
-static void mmio_fini(struct drm_device *drm, void *arg)
+static void mmio_fini(void *arg)
 {
 	struct xe_device *xe = arg;
 
 	pci_iounmap(to_pci_dev(xe->drm.dev), xe->mmio.regs);
 	if (xe->mem.vram.mapping)
 		iounmap(xe->mem.vram.mapping);
+
+	xe->mem.vram.mapping = NULL;
+	xe->mmio.regs = NULL;
 }
 
 int xe_mmio_init(struct xe_device *xe)
@@ -417,7 +420,7 @@ int xe_mmio_init(struct xe_device *xe)
 	root_tile->mmio.size = SZ_16M;
 	root_tile->mmio.regs = xe->mmio.regs;
 
-	return drmm_add_action_or_reset(&xe->drm, mmio_fini, xe);
+	return devm_add_action_or_reset(xe->drm.dev, mmio_fini, xe);
 }
 
 u8 xe_mmio_read8(struct xe_gt *gt, struct xe_reg reg)
-- 
2.43.0



