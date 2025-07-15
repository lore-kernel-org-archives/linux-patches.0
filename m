Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820B22E3380;
	Tue, 15 Jul 2025 13:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587261; cv=none; b=YSza3JFmHyMrxucTF5y8bu22cCG2Gn5WnoIwaPgshA5aTSpFw0RTdV5CicT15fIShxfCnv4JjC4c3s+2lYFKQi0kWvefffW3QuI1WVQlHD/0i3zMsxTd57qOG0VXaC6MF2cjoy2usplMyGW1Jplu769nb5p+T5QZ1fm1tCVzmtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587261; c=relaxed/simple;
	bh=/r7lgVVKrEFri0BEaUIqPCGSBBbk58Y+B3Ue3xGh1eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hqbF3s11q+4YpJNCe+ze5UnjggzmUXz9rO2ELrFIMDsTGbw53iSOCQ4hP6rqC73SZypc8KCK354Ufq5tFdBnQv3ssbSRM7xl5FZt4gJZiAo0QOP1Wlq54tPGgzjXyUGKmaKZQE7BQ40juhDH0XE1kxUizmGT+o7u5Qe9+eTuXyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sN1C53e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sN1C53e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E7DC4CEE3;
	Tue, 15 Jul 2025 13:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587261;
	bh=/r7lgVVKrEFri0BEaUIqPCGSBBbk58Y+B3Ue3xGh1eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0sN1C53eaDcDgthtVy29Q52A2Qjrc1+Pz0qxT0y1sN0fG+P1BHH9jUhpyPqSEgHnq
	 IhXclWsswxhfVNU/ySlOjo25PtzarzcNwZTkBuF4BVV6H2g8Vqz2i1B8m+1577nGaJ
	 RpavulGq47RN3aTuN7XgBLRX+e7X7EljE/NZl43k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 6.1 33/88] drm/ttm: fix error handling in ttm_buffer_object_transfer
Date: Tue, 15 Jul 2025 15:14:09 +0200
Message-ID: <20250715130755.850865503@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -244,6 +244,13 @@ static int ttm_buffer_object_transfer(st
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
@@ -252,12 +259,6 @@ static int ttm_buffer_object_transfer(st
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
 


