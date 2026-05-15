Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8805A33B6E8;
	Fri, 15 May 2026 16:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862126; cv=none; b=JbvS6Xwe/0Qd2AHl3EDkVzPyhhuuBY6VBJy+Mh0FwgNToIDsdlfMH2hfaELyzyffvW3bcq5oBdjC7WZW3Yhs+vSKUeWZfL85YM1WdOvGCSRbfU9Ui6wsrkAZwp0KTEB+pSYpPi3WNnXWuGOj49W028/ptzVrBs4qRj3itpE/5YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862126; c=relaxed/simple;
	bh=k7q4EDaaLndEOnbJpBPCxJhZt0Tly1YOWkoD7EqzCuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXjN0yJEcLB9AU2TwE3eMfkogYmoZRoSLToF3rTGy9vflUzrBEN7sRv1kUtjBqma62h9YC/nkcXPkLrifhom6ih681lY7oxNcs3U+OqhkISslGT+5B3buw8u0LsZsHl0Nefq/b6ZRRgF3ZTT5CDkr7fy2DB+jni1bvVguRIgNB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4VXiZN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4VXiZN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A03C2BCB0;
	Fri, 15 May 2026 16:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862126;
	bh=k7q4EDaaLndEOnbJpBPCxJhZt0Tly1YOWkoD7EqzCuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4VXiZN9Tus1HBeh5JmTlJyHS+g2etDMMtSZKBFLAhqQb/u4o9XQBm40SAH5wVvfa
	 /0q6r3ErOOA3pp4c4rAnbO6zhIMqeQE76XQmI6yQhIeHCdbCbOHYTMa0a/vL7/52ff
	 mvm99EsNWg3PNpHvzSNMavBzVqgZVOvG8TFupgWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18 119/188] drm/xe/bo: Fix bo leak on unaligned size validation in xe_bo_init_locked()
Date: Fri, 15 May 2026 17:48:56 +0200
Message-ID: <20260515154659.913087014@linuxfoundation.org>
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

commit 09a8f3c1c11977a6e10c167f26dd298790b31c32 upstream.

When type is ttm_bo_type_device and aligned_size != size, the function
returns an error without freeing a caller-provided bo, violating the
documented contract that bo is freed on failure.

Add xe_bo_free(bo) before returning the error.

Fixes: 4e03b584143e ("drm/xe/uapi: Reject bo creation of unaligned size")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.6
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260408175255.3402838-2-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit 601c2aa087b6f21014300a3f107a08ee4dde7bdf)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -2134,8 +2134,10 @@ struct xe_bo *xe_bo_init_locked(struct x
 		alignment = SZ_4K >> PAGE_SHIFT;
 	}
 
-	if (type == ttm_bo_type_device && aligned_size != size)
+	if (type == ttm_bo_type_device && aligned_size != size) {
+		xe_bo_free(bo);
 		return ERR_PTR(-EINVAL);
+	}
 
 	if (!bo) {
 		bo = xe_bo_alloc();


