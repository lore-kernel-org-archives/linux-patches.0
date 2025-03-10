Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844A6230D14;
	Mon, 10 Mar 2025 17:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626610; cv=none; b=RHZdhIEoBP5cY1EcBcU7dwOF4+WcJMUHyl2lAX1t+Mo54l5k3+D9m3kJNri+wRenWj55dONPwWUdobJXRuvfV9G/MMDa45wsRX0Fto3rZKfHGbqUasthg+qxP7EVh9xq8P9mBam1aSUMcHK5MYYImcsTlfUUt52IYHaRNK9SwwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626610; c=relaxed/simple;
	bh=DRvwuyo7cbHn7JzOePf43EY6FBWKNE3hjIho7+0cCHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eBzap8Utw6XZgFiPzogQ9ClryjbsyEMP8OrfjoCRNP60s17RootGlUgXvH/qMAKYVBw7WbOabalAK9CpyRS5/VxwjtHGVVK7IJR96Br8KBI87gRSv7iG1vGu/O2Ht5ueG+r8L6+TpxtBpE+pTBN8b0Bb+UdRcDK3Xr5jNGg3cGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qodfXue6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qodfXue6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07194C4CEE5;
	Mon, 10 Mar 2025 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626610;
	bh=DRvwuyo7cbHn7JzOePf43EY6FBWKNE3hjIho7+0cCHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qodfXue6s53GlBXigKBvsvMMcKfRyy03DithIz4du01C41D86JwSiNvANr7PhcPXD
	 pKNdlWfXX/SeI/u6I4yHDh4IJRLG8KvYEfsAljU2D9PpMa9pyEKPWsclJNWSdYWO63
	 gVZq7NF+iGOIrKh98syZAlyhB7DXFphMmdDxrKLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.13 052/207] drm/xe/vm: Validate userptr during gpu vma prefetching
Date: Mon, 10 Mar 2025 18:04:05 +0100
Message-ID: <20250310170449.838632804@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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


