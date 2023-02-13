Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856C48F58
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0815EC433D2;
	Mon, 13 Feb 2023 14:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300225;
	bh=UQRvJN2wi/x7Jxw7mkAWrK8rQQz6vlysSPL99h9+hrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrbi5J8xBb3zJ9Lc+QLokK3pWr74gfc+TOHtipYsg/bfqyam+aNr7tnmNUfYyPEjP
	 6j2oUmnIFcwVvcbEDKfpBq1Rfqb8oNhos7oeqj859ogWIk3Z8bcoNgi6Bnnto/OWsc
	 TS97sXVfFd8t2ydn973H3jrI6OI8Khc/mOLF/vo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 112/114] drm/i915: Move fd_install after last use of fence
Date: Mon, 13 Feb 2023 15:49:07 +0100
Message-Id: <20230213144748.021478384@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Clark <robdclark@chromium.org>

commit 251e8c5b1b1fadcc387a8e618c7437d330bdac3e upstream.

Because eb_composite_fence_create() drops the fence_array reference
after creation of the sync_file, only the sync_file holds a ref to the
fence.  But fd_install() makes that reference visable to userspace, so
it must be the last thing we do with the fence.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Fixes: 00dae4d3d35d ("drm/i915: Implement SINGLE_TIMELINE with a syncobj (v4)")
Cc: <stable@vger.kernel.org> # v5.15+
[tursulin: Added stable tag.]
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230203164937.4035503-1-robdclark@gmail.com
(cherry picked from commit 960dafa30455450d318756a9896a02727f2639e0)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -3478,6 +3478,13 @@ err_request:
 				   eb.composite_fence :
 				   &eb.requests[0]->fence);
 
+	if (unlikely(eb.gem_context->syncobj)) {
+		drm_syncobj_replace_fence(eb.gem_context->syncobj,
+					  eb.composite_fence ?
+					  eb.composite_fence :
+					  &eb.requests[0]->fence);
+	}
+
 	if (out_fence) {
 		if (err == 0) {
 			fd_install(out_fence_fd, out_fence->file);
@@ -3489,13 +3496,6 @@ err_request:
 		}
 	}
 
-	if (unlikely(eb.gem_context->syncobj)) {
-		drm_syncobj_replace_fence(eb.gem_context->syncobj,
-					  eb.composite_fence ?
-					  eb.composite_fence :
-					  &eb.requests[0]->fence);
-	}
-
 	if (!out_fence && eb.composite_fence)
 		dma_fence_put(eb.composite_fence);
 


