Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547F9145345;
	Tue, 27 Feb 2024 14:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044250; cv=none; b=m/rTfyLWyVM3ij0kPX8Q8y0LXY0eU4zFV4QfpjSxhfl6CQ37z87n7u59TTQziO5o/rZSqNkMLWMEpqlX0pXOOvOJAen2CVan1ZLQmzVAjmBZcygSVdRfsh4NovS7niHr3VW2NZN2FkbUsnaV51WHlvQS4TojssVAUNXY55fbLnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044250; c=relaxed/simple;
	bh=jAwa4SHdGAmBM7kGG3+viUcMc8G6rIW+HJr2t8Wo87k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hy6AC0n3zLoMhpgtjq0RIQ5u/aQyG4USP+iduieFC89Hmoh3GRwed1LB4DiE+jmQTfsqmAnwESQbIxrMIntHZNfmd2T/Viub+I/55vGKbuwTEF6KRjzulC6P6WCSZJ8eSJoE3a7ZysFhDCpubPq4b+rnpjNrE5E6ON2CBeW0dwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6zJGnU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6zJGnU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53CDC433C7;
	Tue, 27 Feb 2024 14:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044250;
	bh=jAwa4SHdGAmBM7kGG3+viUcMc8G6rIW+HJr2t8Wo87k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6zJGnU8Ge0DcEgctwS+wzpUDwD5Wn1Jj0yvA4lZP80yuZ3mGs2bqhKwqQ+BODIyD
	 pbhQTdIlAz+VDQMSQ4GCUjGBp5SArCjlEpVd8IbPhzO/gkG09xErlnTp5GT6EPq64t
	 fyaS0YvP8yDKxPiQqPu9fdBegyfP5lz5wzG/+OPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Kurzinger <ekurzinger@nvidia.com>,
	Simon Ser <contact@emersion.fr>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/122] drm/syncobj: call drm_syncobj_fence_add_wait when WAIT_AVAILABLE flag is set
Date: Tue, 27 Feb 2024 14:27:58 +0100
Message-ID: <20240227131602.531018298@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erik Kurzinger <ekurzinger@nvidia.com>

[ Upstream commit 3c43177ffb54ea5be97505eb8e2690e99ac96bc9 ]

When waiting for a syncobj timeline point whose fence has not yet been
submitted with the WAIT_FOR_SUBMIT flag, a callback is registered using
drm_syncobj_fence_add_wait and the thread is put to sleep until the
timeout expires. If the fence is submitted before then,
drm_syncobj_add_point will wake up the sleeping thread immediately which
will proceed to wait for the fence to be signaled.

However, if the WAIT_AVAILABLE flag is used instead,
drm_syncobj_fence_add_wait won't get called, meaning the waiting thread
will always sleep for the full timeout duration, even if the fence gets
submitted earlier. If it turns out that the fence *has* been submitted
by the time it eventually wakes up, it will still indicate to userspace
that the wait completed successfully (it won't return -ETIME), but it
will have taken much longer than it should have.

To fix this, we must call drm_syncobj_fence_add_wait if *either* the
WAIT_FOR_SUBMIT flag or the WAIT_AVAILABLE flag is set. The only
difference being that with WAIT_FOR_SUBMIT we will also wait for the
fence to be signaled after it has been submitted while with
WAIT_AVAILABLE we will return immediately.

IGT test patch: https://lists.freedesktop.org/archives/igt-dev/2024-January/067537.html

v1 -> v2: adjust lockdep_assert_none_held_once condition

(cherry picked from commit 8c44ea81634a4a337df70a32621a5f3791be23df)

Fixes: 01d6c3578379 ("drm/syncobj: add support for timeline point wait v8")
Signed-off-by: Erik Kurzinger <ekurzinger@nvidia.com>
Signed-off-by: Simon Ser <contact@emersion.fr>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20240119163208.3723457-1-ekurzinger@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_syncobj.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
index 4c3c8f8da0215..6ce446cc88780 100644
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -960,7 +960,8 @@ static signed long drm_syncobj_array_wait_timeout(struct drm_syncobj **syncobjs,
 	uint64_t *points;
 	uint32_t signaled_count, i;
 
-	if (flags & DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT)
+	if (flags & (DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT |
+		     DRM_SYNCOBJ_WAIT_FLAGS_WAIT_AVAILABLE))
 		lockdep_assert_none_held_once();
 
 	points = kmalloc_array(count, sizeof(*points), GFP_KERNEL);
@@ -1029,7 +1030,8 @@ static signed long drm_syncobj_array_wait_timeout(struct drm_syncobj **syncobjs,
 	 * fallthough and try a 0 timeout wait!
 	 */
 
-	if (flags & DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT) {
+	if (flags & (DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT |
+		     DRM_SYNCOBJ_WAIT_FLAGS_WAIT_AVAILABLE)) {
 		for (i = 0; i < count; ++i)
 			drm_syncobj_fence_add_wait(syncobjs[i], &entries[i]);
 	}
-- 
2.43.0



