Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425022356A4;
	Mon, 10 Mar 2025 17:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627472; cv=none; b=gO6ALI/DfTKupsIvFRs1X2w/u+dvQhhXBbLj6o4XdTBrf5iwIptaVr92hyk/O7cMopZJaHmSER70zCd29xoESwSx5sZ8m5xnIpI0Jd1WdpRaDZV1QKcaVJxZ2AKdcpDo7qqyKKON83Wt4RO+o1I3MNGcG8LfwKmuH6i/ww2szqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627472; c=relaxed/simple;
	bh=lDQQNjCjzWhz8VfaeJNtHewQPj3Cb7e2CjBPd1mDr0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=beCTTqrekzTpqO1zx4kGdRaFcb8laytIDITC1N46gkIB+9krxJoRNBolCci0FPEuamAU9P+eYBZNnCviZwheG51uH9ic3xS938B4wQ3nHxgYSpaqHY2w01DOr92J+LjI+0o7Ykt/bBa00AnYFZLFG3eRWUByK4FM+h530J0PscU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zb+6Xurs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zb+6Xurs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0071C4CEE5;
	Mon, 10 Mar 2025 17:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627472;
	bh=lDQQNjCjzWhz8VfaeJNtHewQPj3Cb7e2CjBPd1mDr0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zb+6XursFHax3L3iWvtYWcKDUoQNLPucHfp/qvIuQ98iTqSUhWgb4iwf6RvvNStBO
	 hvrf/AJBH3jINRYZUblE06cCxpjTrXvzhqfcsAsVfv1f8R5ZhCb/08CwU6JHxNGJu6
	 LG6CZ99aNiCFo7KoONMY+QGI7wleRogQPJSemeUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 113/269] drm/xe/vm: Validate userptr during gpu vma prefetching
Date: Mon, 10 Mar 2025 18:04:26 +0100
Message-ID: <20250310170502.223905350@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit e775e2a060d99180edc5366fb9f4299d0f07b66c upstream.

If a userptr vma subject to prefetching was already invalidated
or invalidated during the prefetch operation, the operation would
repeatedly return -EAGAIN which would typically cause an infinite
loop.

Validate the userptr to ensure this doesn't happen.

v2:
- Don't fallthrough from UNMAP to PREFETCH (Matthew Brost)

Fixes: 5bd24e78829a ("drm/xe/vm: Subclass userptr vmas")
Fixes: 617eebb9c480 ("drm/xe: Fix array of binds")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.9+
Suggested-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250228073058.59510-2-thomas.hellstrom@linux.intel.com
(cherry picked from commit 03c346d4d0d85d210d549d43c8cfb3dfb7f20e0a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vm.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -2284,8 +2284,17 @@ static int vm_bind_ioctl_ops_parse(struc
 			break;
 		}
 		case DRM_GPUVA_OP_UNMAP:
+			xe_vma_ops_incr_pt_update_ops(vops, op->tile_mask);
+			break;
 		case DRM_GPUVA_OP_PREFETCH:
-			/* FIXME: Need to skip some prefetch ops */
+			vma = gpuva_to_vma(op->base.prefetch.va);
+
+			if (xe_vma_is_userptr(vma)) {
+				err = xe_vma_userptr_pin_pages(to_userptr_vma(vma));
+				if (err)
+					return err;
+			}
+
 			xe_vma_ops_incr_pt_update_ops(vops, op->tile_mask);
 			break;
 		default:


