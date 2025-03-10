Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A9B1B3927;
	Mon, 10 Mar 2025 17:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627353; cv=none; b=iPfbEJlK+TQkIsV/GitnwwcRcB4Yk6odmft6nC9I6uKaR6w6SNBbysKqNGCEwBYoiOPYpEtSmJGs4TpNXm1qjmC2v0buaNlH1G9MdfpRx55Ma5gjJLc/qgJG6+ew21/0242tlnY0ievq/U3zS0kGVzviUMYfQlnjvYxcjCOj0bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627353; c=relaxed/simple;
	bh=X8/KWrhptfUpD6eyo3sxQeT5LQXDdqy5E8xL6+d3fIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukDbwqQDBd0Oyrv9ncZonDvNzYJeKq7/FA+f+j6BE21TUDgJSUF4kLauSYl4pDQ8QJj63dt3yonR/lsrKYtyGBvFWhrmXiNrg3+fAsKzU/uWjSccIi2+9l9Jo8oBttL1MmWwDimOm59ESckd9TSvIHR0XUsJQ1by01gXXaVHLJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQdvyl7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQdvyl7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEF5C4CEE5;
	Mon, 10 Mar 2025 17:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627353;
	bh=X8/KWrhptfUpD6eyo3sxQeT5LQXDdqy5E8xL6+d3fIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQdvyl7omH9f6w2+zBiwrGpq5Z5489rheb21HUHdBnaxhNeP0a7X+odT1VUHQ3114
	 bdVDWiMnQZ6PNnic7VKpx/GtYZHkLhIpKEar8NUfutVP5YtK2PRsIXPxiGYRxXJhu7
	 4SLUp8hKxNHwxTa0awT8+VOyUBjr/NOFje4h4cVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan King <brendan.king@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 6.12 100/269] drm/imagination: only init job done fences once
Date: Mon, 10 Mar 2025 18:04:13 +0100
Message-ID: <20250310170501.697847804@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brendan King <Brendan.King@imgtec.com>

commit 68c3de7f707e8a70e0a6d8087cf0fe4a3d5dbfb0 upstream.

Ensure job done fences are only initialised once.

This fixes a memory manager not clean warning from drm_mm_takedown
on module unload.

Cc: stable@vger.kernel.org
Fixes: eaf01ee5ba28 ("drm/imagination: Implement job submission and scheduling")
Signed-off-by: Brendan King <brendan.king@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250226-init-done-fences-once-v2-1-c1b2f556b329@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_queue.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/imagination/pvr_queue.c
+++ b/drivers/gpu/drm/imagination/pvr_queue.c
@@ -313,8 +313,9 @@ pvr_queue_cccb_fence_init(struct dma_fen
 static void
 pvr_queue_job_fence_init(struct dma_fence *fence, struct pvr_queue *queue)
 {
-	pvr_queue_fence_init(fence, queue, &pvr_queue_job_fence_ops,
-			     &queue->job_fence_ctx);
+	if (!fence->ops)
+		pvr_queue_fence_init(fence, queue, &pvr_queue_job_fence_ops,
+				     &queue->job_fence_ctx);
 }
 
 /**


