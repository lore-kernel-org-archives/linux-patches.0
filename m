Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F5C1D2784;
	Wed,  6 Nov 2024 12:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896182; cv=none; b=iJ231RQ7BGZV9YI+XCgddKTHLqsX+Jtt8Yo1df5ywmvQDf7NUt6v1CvMhhUFTPVE3VSmMmSr6HVfCx9+kqwdba+bA0YWIr1QXbuM4iFjX4CUEbYYTkaQu/KX50kJbSg9grTx4A4gkJKq1QYlf9USF2d5z0a8FN0xKMVTQ5WTj4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896182; c=relaxed/simple;
	bh=z1tMfdkQlQg5diGvVOtNqqAm2v6jj1OK/IZUtlot1ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvf9qNPymmyvnju2H/RAqh1CLwFMY/9wY+kxg9Og66D4a8TB7eFJJoo5qoRLOENtPXlCn9XO0eng6tup5NWwvjOnjX2bnPNhcYgbeS/tAlJHl8UEzZLHx5WM/JdwWr+VXxuLkk9l0v40y6bZ7DadnqLGPHUJYB0qUk763ozpuKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ne+vXP/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ne+vXP/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C50C4CECD;
	Wed,  6 Nov 2024 12:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896182;
	bh=z1tMfdkQlQg5diGvVOtNqqAm2v6jj1OK/IZUtlot1ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ne+vXP/0xMQb7IUrUxrvEvG5MnljlKlmX5Z6SGXbUSIHqBk9Ocr1yQIwBU3/3qVaX
	 auVVejhL1+ERMcTtxN9TejTNktuH3KrSanhuEXmowPXkjGl7QhpUGHZj5Qa3NxYNtC
	 ke9uLqAXYLU+UiBIFPZN+0Pym20FY3lcMVUNP/48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 081/245] drm/panthor: Report group as timedout when we fail to properly suspend
Date: Wed,  6 Nov 2024 13:02:14 +0100
Message-ID: <20241106120321.198463198@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 4700fd3e050da8302e60ebd4850d008250fa7204 ]

If we don't do that, the group is considered usable by userspace, but
all further GROUP_SUBMIT will fail with -EINVAL.

Changes in v3:
- Add R-bs

Changes in v2:
- New patch

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241029152912.270346-3-boris.brezillon@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 9b64c61caab64..e9234488dc2b4 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -589,10 +589,11 @@ struct panthor_group {
 	 * @timedout: True when a timeout occurred on any of the queues owned by
 	 * this group.
 	 *
-	 * Timeouts can be reported by drm_sched or by the FW. In any case, any
-	 * timeout situation is unrecoverable, and the group becomes useless.
-	 * We simply wait for all references to be dropped so we can release the
-	 * group object.
+	 * Timeouts can be reported by drm_sched or by the FW. If a reset is required,
+	 * and the group can't be suspended, this also leads to a timeout. In any case,
+	 * any timeout situation is unrecoverable, and the group becomes useless. We
+	 * simply wait for all references to be dropped so we can release the group
+	 * object.
 	 */
 	bool timedout;
 
@@ -2640,6 +2641,12 @@ void panthor_sched_suspend(struct panthor_device *ptdev)
 		csgs_upd_ctx_init(&upd_ctx);
 		while (slot_mask) {
 			u32 csg_id = ffs(slot_mask) - 1;
+			struct panthor_csg_slot *csg_slot = &sched->csg_slots[csg_id];
+
+			/* We consider group suspension failures as fatal and flag the
+			 * group as unusable by setting timedout=true.
+			 */
+			csg_slot->group->timedout = true;
 
 			csgs_upd_ctx_queue_reqs(ptdev, &upd_ctx, csg_id,
 						CSG_STATE_TERMINATE,
-- 
2.43.0



