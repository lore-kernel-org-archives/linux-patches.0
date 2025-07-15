Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23391A23AF;
	Tue, 15 Jul 2025 13:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585535; cv=none; b=mxA0E1b/yF7v/+BTdtN319U2KYX6F59d3itk1GEOkjKaCS8j8ITaquOSqVWjWe3dNrFpEEuxVcKsIciyH+pqrGjYd7vR6FqlTuDn5UiUVhaF2iFN3ZwV2abHw0XxzVz+WnoXkAtD9ibCS3myy4KKpcnX/v+GmULavopfXzyd+mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585535; c=relaxed/simple;
	bh=ZrcEaCdMhXbVwMg9beEU/RkPJqoHSuNSxVkuTOWhxOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TSQeA6ainZlD9Nx76DKTqt/wXtmQfcbKq54Z1o5ZwTLiVtRbuxch0CPas3w93+469cN4ZYueg4tKhJC9aMnoYX7Fo4PL8Wk+mzNbpQO4uWCR9XnJvnFuQQve+xS+lysvwe8bA6XlI8lwr2mEVpVzr1aHYg7tdFDL3Xj/P6vDS9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwEEhLI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwEEhLI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445F2C4CEE3;
	Tue, 15 Jul 2025 13:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585534;
	bh=ZrcEaCdMhXbVwMg9beEU/RkPJqoHSuNSxVkuTOWhxOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwEEhLI1jVUs3D0Q9bAs4EqgeCGwg8kCumdY6hsQPLDyvGQTnPEmiGZhnpiYWAG/7
	 z9XoXx3EusXUOuCb4G9AJPNp8UiYTHPcOnhfSO0V7g7DLyTTYBTVIP5vdCS1vIhV9d
	 iW7mwxRc2FjMmTM9wOBfLfyxja8s3XTJmki0Iytg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 6.12 076/163] drm/ttm: fix error handling in ttm_buffer_object_transfer
Date: Tue, 15 Jul 2025 15:12:24 +0200
Message-ID: <20250715130811.785166911@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


