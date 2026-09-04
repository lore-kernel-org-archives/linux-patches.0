Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EF634A77D;
	Fri,  4 Sep 2026 05:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499090; cv=none; b=kvu9xy5o0rv38qcTi+Vh7YGvBK5evQi8jcpR9pBnlR2IMvm7M4dXBHzPuAZwWofv+CJrW+/+jrSe/DaP3J/LASuSwc1uHDm9aTl5uxW+2VVLsCXrC63Lp79il2j6+QdssdPZ76SAYBcrEeZpMdVEYpyYHLdpYXgfa5uKq3KRs7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499090; c=relaxed/simple;
	bh=EAEUGU+AtTPi6Lgnjfl2Z1eFJ81amTqOOah6EtLsbtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=febqicE1t0aaq9ebRhwtpdUCGyhPdZbxfws0ecoqNDnxZg4rc/Kf+u+vHX7R7rQ6L5QYJnwhGROmOfM1/+g2MUycinSkpK828LV80G//7VJNLexpuZE2xJlt8vez+yBg0LlisDIgQAu8BJODQvyzZDSHVB6cpfcbbK51S2BJ2KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxlZxV6O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxlZxV6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAD21F00A3D;
	Fri,  4 Sep 2026 05:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499089;
	bh=+CryiEzCVv0wHDospS/4EVAFdDrWbZrVu5JCl4vvNoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vxlZxV6OhwcFRig57SQARiyJ+HHwo0j/CSZ+21Ja12GxD3wocEkjsfqgUr0LjSJXD
	 /CFMOpgXXXmYGkCGUhAyEC69cuBWqQyH1/+tUUw02cTjiaIe/GRIRBlUeebekwGtzj
	 BiWoVkca/nqdlio/R2VyHExmDlzKnYEuPPeyplI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>
Subject: [PATCH 7.2 293/713] accel/rocket: fix NULL dereference and integer overflow in rocket_job_push()
Date: Fri,  4 Sep 2026 06:54:21 +0200
Message-ID: <20260904045810.409308207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit a85402bff218f2b8f0d806e46c16c2f3d49cdda7 upstream.

rocket_job_push() allocates a temporary array to hold all input and
output GEM object pointers:

    bos = kvmalloc_array(job->in_bo_count + job->out_bo_count,
                         sizeof(void *), GFP_KERNEL);
    memcpy(bos, job->in_bos, job->in_bo_count * sizeof(void *));
    memcpy(&bos[job->in_bo_count], job->out_bos, ...);

Two bugs exist:

1. Missing NULL check: if kvmalloc_array() fails, bos is NULL and
   the subsequent memcpy() dereferences it, causing a kernel NULL
   pointer dereference.

2. Integer overflow: in_bo_count and out_bo_count are both u32, set
   directly from userspace-supplied in_bo_handle_count and
   out_bo_handle_count with no prior validation. Their sum is computed
   in u32 arithmetic and can wrap to a smaller value, causing the
   allocation count passed to kvmalloc_array() to be smaller than
   intended. Subsequent uses still operate on the original counts when
   copying and locking objects, which may lead to out-of-bounds accesses
   on the temporary array.

Fix by using check_add_overflow() to detect count overflow before the
allocation, and adding a NULL check on the allocation result.

Fixes: 0810d5ad88a1 ("accel/rocket: Add job submission IOCTL")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://lore.kernel.org/r/20260524155716.90955-1-meatuni001@gmail.com
Signed-off-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/rocket/rocket_job.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/accel/rocket/rocket_job.c
+++ b/drivers/accel/rocket/rocket_job.c
@@ -8,6 +8,7 @@
 #include <drm/drm_gem.h>
 #include <drm/rocket_accel.h>
 #include <linux/interrupt.h>
+#include <linux/overflow.h>
 #include <linux/iommu.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
@@ -188,14 +189,19 @@ static int rocket_job_push(struct rocket
 	struct rocket_device *rdev = job->rdev;
 	struct drm_gem_object **bos;
 	struct ww_acquire_ctx acquire_ctx;
+	u32 bo_count;
 	int ret = 0;
 
-	bos = kvmalloc_array(job->in_bo_count + job->out_bo_count, sizeof(void *),
-			     GFP_KERNEL);
+	if (check_add_overflow(job->in_bo_count, job->out_bo_count, &bo_count))
+		return -EINVAL;
+
+	bos = kvmalloc_array(bo_count, sizeof(*bos), GFP_KERNEL);
+	if (!bos)
+		return -ENOMEM;
 	memcpy(bos, job->in_bos, job->in_bo_count * sizeof(void *));
 	memcpy(&bos[job->in_bo_count], job->out_bos, job->out_bo_count * sizeof(void *));
 
-	ret = drm_gem_lock_reservations(bos, job->in_bo_count + job->out_bo_count, &acquire_ctx);
+	ret = drm_gem_lock_reservations(bos, bo_count, &acquire_ctx);
 	if (ret)
 		goto err;
 
@@ -220,7 +226,7 @@ static int rocket_job_push(struct rocket
 	rocket_attach_object_fences(job->out_bos, job->out_bo_count, job->inference_done_fence);
 
 err_unlock:
-	drm_gem_unlock_reservations(bos, job->in_bo_count + job->out_bo_count, &acquire_ctx);
+	drm_gem_unlock_reservations(bos, bo_count, &acquire_ctx);
 err:
 	kvfree(bos);
 


