Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FA0392C34;
	Fri, 15 May 2026 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862124; cv=none; b=Lylp76BPk7L9k7A1fAsjJSHQKSsoV6wmGWKp1T02QtI1rY3ENy4EXNr5r8oUyruIFyDYGzEUH8LzJ89fjAeIgDdYtl3GC2vIF7tMjPkA1pntrPWSo/+oNygWY1E0P1saH08adL6cxTXznSwtQpGWlb63R7GWg8f6K4TwpEyStQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862124; c=relaxed/simple;
	bh=dAFsB51gLYMlmGco1mkqrinIy3pb/+wBmd3KgpT0F6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqCtr6rze/7VZ6fa/l3H8EUGTFNhiJodsNb1XP3+m6qmyUR2ZoNafYzAPaHE6JgJxcE17Q3HpiMPXXAKaztV3ZvBWgvrOTgkljTn9yZSPzK4C6HtYFW67xzLrHIesYQasojWnKL4QauA5YhkuhNCFMnZPHUjjp+Hz7nmNpRehvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LzhPhAkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LzhPhAkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B78C2BCB0;
	Fri, 15 May 2026 16:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862123;
	bh=dAFsB51gLYMlmGco1mkqrinIy3pb/+wBmd3KgpT0F6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzhPhAkLfteQB7yeYDxRvz7OvoB597STYQGmVLuG17VgjftxDSM7UJgIm6w0+PoAf
	 s6Lgtg21pB+O1mB9rEencA8Qq7viwdlWHLRkYC/D4793lcaPQD4zn3ELA7Yw6vDPc/
	 CZrB7NTegIDcxpxz+6pSOjknDvHlBLaABQVfr/bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mattheq Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18 118/188] drm/xe: Fix dma-buf attachment leak in xe_gem_prime_import()
Date: Fri, 15 May 2026 17:48:55 +0200
Message-ID: <20260515154659.891597079@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Shuicheng Lin <shuicheng.lin@intel.com>

commit 111ab678471bf1f90d078d5513bb086b70596c3c upstream.

When xe_dma_buf_init_obj() fails, the attachment from
dma_buf_dynamic_attach() is not detached. Add dma_buf_detach() before
returning the error. Note: we cannot use goto out_err here because
xe_dma_buf_init_obj() already frees bo on failure, and out_err would
double-free it.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.6
Reviewed-by: Mattheq Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260408175255.3402838-5-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit a828eb185aac41800df8eae4b60501ccc0dbbe51)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_dma_buf.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -347,12 +347,15 @@ struct drm_gem_object *xe_gem_prime_impo
 		goto out_err;
 	}
 
-	/* Errors here will take care of freeing the bo. */
+	/*
+	 * xe_dma_buf_init_obj() takes ownership of bo on both success
+	 * and failure, so we must not touch bo after this call.
+	 */
 	obj = xe_dma_buf_init_obj(dev, bo, dma_buf);
-	if (IS_ERR(obj))
+	if (IS_ERR(obj)) {
+		dma_buf_detach(dma_buf, attach);
 		return obj;
-
-
+	}
 	get_dma_buf(dma_buf);
 	obj->import_attach = attach;
 	return obj;


