Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11382E8893;
	Tue, 15 Jul 2025 13:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586999; cv=none; b=Shl8JVOGNyrpIP1x48gbqDRD6flY1xtdLEUwIQdzRgYo+PalUp1bdi9qKvvC44MFhzn9gfiplLusbZJak6Rb+VeicsLeb03WtHaLNy1FZPNMw+l9RebjPt697ZNWF+BJxXxlefscaFlORC5CGlb/mvL/O4DABPGAottaKRFJwOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586999; c=relaxed/simple;
	bh=60OKKbAlFVcInfm/FYRPWSsZiv5r7WaFRrNXgTTrVy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h+ax6JQjSl4xlGoRAVRxz4UqRcDpvDSaO+cMVPcKUYGfsybsw9UXrGb6/zZT25MCtRhDWcFsgJ6MbBHKaTQc/8M7yLx+Z+XKhEalpKT74JDRr69HDRiZK8rD1l8u4NIdZ2zQNYjcI/Od4nC2KQ27i+TbvAXxjRV9YsQMeIQoPRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0gu0K2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0gu0K2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654CFC4CEE3;
	Tue, 15 Jul 2025 13:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586999;
	bh=60OKKbAlFVcInfm/FYRPWSsZiv5r7WaFRrNXgTTrVy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0gu0K2+PsVWp93UZ5dvFoqjilt19EkW5ZuFEEddjKoZcmTn8OaVnglLVfaKMezee
	 7EbjUShD0Bdx0ddgfCwoYmg0BVi4uSNvaJ1VrejWNIzEZuBspEIACcqtORAxNnMR1r
	 yhuTPPM4KpCa+VAH7xkqmr6OX//W2+YUrP4Zks0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 6.15 087/192] drm/ttm: fix error handling in ttm_buffer_object_transfer
Date: Tue, 15 Jul 2025 15:13:02 +0200
Message-ID: <20250715130818.404167893@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 97e000acf2e20a86a50a0ec8c2739f0846f37509 upstream.

Unlocking the resv object was missing in the error path, additionally to
that we should move over the resource only after the fence slot was
reserved.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Fixes: c8d4c18bfbc4a ("dma-buf/drivers: make reserving a shared slot mandatory v4")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20250616130726.22863-3-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -254,6 +254,13 @@ static int ttm_buffer_object_transfer(st
 	ret = dma_resv_trylock(&fbo->base.base._resv);
 	WARN_ON(!ret);
 
+	ret = dma_resv_reserve_fences(&fbo->base.base._resv, 1);
+	if (ret) {
+		dma_resv_unlock(&fbo->base.base._resv);
+		kfree(fbo);
+		return ret;
+	}
+
 	if (fbo->base.resource) {
 		ttm_resource_set_bo(fbo->base.resource, &fbo->base);
 		bo->resource = NULL;
@@ -262,12 +269,6 @@ static int ttm_buffer_object_transfer(st
 		fbo->base.bulk_move = NULL;
 	}
 
-	ret = dma_resv_reserve_fences(&fbo->base.base._resv, 1);
-	if (ret) {
-		kfree(fbo);
-		return ret;
-	}
-
 	ttm_bo_get(bo);
 	fbo->bo = bo;
 


