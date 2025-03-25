Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332772571AB;
	Tue, 25 Mar 2025 12:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906019; cv=none; b=p/ojga2ykwcHObdTZyG8DrynHLHk02BrLzrDMd/kKqugGYnsW1uchi2ebogU48lqWPxZTBRFkpnFlL+llvkNZtVy1EmRNNlFptTBf68Ne0Y8czXAecwvhoB1AMgqQiR3G467relHGpR7KLMVf87iYE11gG0zP/u6X98jilg7WKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906019; c=relaxed/simple;
	bh=C664BOA0oq5Rf7LtYL7IDHtjgZwtwOEUhVUBKzIXows=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LloSWVepe3mkQUJish82nYMc61KoaJgRhFyJIhmUlXFgYZNSdC1KQhLs7L3Vwp99KCVNVHxSOooEoU4FjlRi8uCUhMz+8Sv66lRrKbG31Vr24A7nU21WxzNmvmUg3K1np5GUuQXDbUkbMLdUdNPuGaBTAUWRS0KopPJCY7X9J9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EibxTp5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EibxTp5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67860C4CEE4;
	Tue, 25 Mar 2025 12:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906018;
	bh=C664BOA0oq5Rf7LtYL7IDHtjgZwtwOEUhVUBKzIXows=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EibxTp5JmidQC8ww2+C27FR2gxKb7YWIgDlB7bUT/cdeWyxpN50Y43PfRKWp4gEpC
	 6caK5dy8WvLxDXdxy63bxdRrvvR34nntQxtoS1uY9IYvcylpll2xP/4N7REpfFDn2T
	 hZF3fNgi57eByEZvLLJcYYJEEHnovyg9Gz2pFV4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	intel-xe@lists.freedesktop.org,
	Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.13 061/119] drm/xe: Fix exporting xe buffers multiple times
Date: Tue, 25 Mar 2025 08:21:59 -0400
Message-ID: <20250325122150.614190714@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>

commit 50af7cab7520e46680cf4633bba6801443b75856 upstream.

The `struct ttm_resource->placement` contains TTM_PL_FLAG_* flags, but
it was incorrectly tested for XE_PL_* flags.
This caused xe_dma_buf_pin() to always fail when invoked for
the second time. Fix this by checking the `mem_type` field instead.

Fixes: 7764222d54b7 ("drm/xe: Disallow pinning dma-bufs in VRAM")
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: "Thomas Hellström" <thomas.hellstrom@linux.intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: intel-xe@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.8+
Signed-off-by: Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250218100353.2137964-1-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
(cherry picked from commit b96dabdba9b95f71ded50a1c094ee244408b2a8e)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.h      |    2 --
 drivers/gpu/drm/xe/xe_dma_buf.c |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/gpu/drm/xe/xe_bo.h
+++ b/drivers/gpu/drm/xe/xe_bo.h
@@ -318,7 +318,6 @@ static inline unsigned int xe_sg_segment
 	return round_down(max / 2, PAGE_SIZE);
 }
 
-#if IS_ENABLED(CONFIG_DRM_XE_KUNIT_TEST)
 /**
  * xe_bo_is_mem_type - Whether the bo currently resides in the given
  * TTM memory type
@@ -333,4 +332,3 @@ static inline bool xe_bo_is_mem_type(str
 	return bo->ttm.resource->mem_type == mem_type;
 }
 #endif
-#endif
--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -58,7 +58,7 @@ static int xe_dma_buf_pin(struct dma_buf
 	 * 1) Avoid pinning in a placement not accessible to some importers.
 	 * 2) Pinning in VRAM requires PIN accounting which is a to-do.
 	 */
-	if (xe_bo_is_pinned(bo) && bo->ttm.resource->placement != XE_PL_TT) {
+	if (xe_bo_is_pinned(bo) && !xe_bo_is_mem_type(bo, XE_PL_TT)) {
 		drm_dbg(&xe->drm, "Can't migrate pinned bo for dma-buf pin.\n");
 		return -EINVAL;
 	}


