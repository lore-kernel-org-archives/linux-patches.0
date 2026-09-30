Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83711516148;
	Wed, 30 Sep 2026 16:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787597; cv=none; b=WM88Ak6sHLD8c09HoNmB3duU030NS8TP4AIqSYu6pxQQVeM60/SzTkDACzeeMlph5Oi/SjybEqlecqXSwgd42bpM5Bg7Ui9ihJ2D/IB0nmknAGCzFOAWB6GY6Qdhnmpr31S4nsq0XttGToA2h5WBKLe62u2999zY5GvW1XRJRzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787597; c=relaxed/simple;
	bh=W2cPOiExeKXonWIGni85PZ6NonAFdpbtCJg8ZxiMtmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I2IELZEzU9nkgX7deWV5eljTwYIGUcCn8+fE48Yf3IufeQaP8GBEmk17j6WHTdjt6IKkjjXMphThSBcFZOHKiA18c5a1dAVvY7wcDaH6TBoX/fnQZ9blTFXESk9D9u4PYviIC3wr/Nj/v6EINIcEPweAskOW+zK2DrMBQfOzhRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVOI7/zl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVOI7/zl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC111F00898;
	Wed, 30 Sep 2026 16:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787596;
	bh=G0DPIORuH3ErQMHG8yNgx80mKD3X6/p1YwWx6WCiBUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVOI7/zlRiyl7XWx8QrhsI77HOwB4MNIcHYhecniGU31B7R76MwAxuh36Jw+K1Txi
	 ENv252nmBeo8VcWa3ckaqbTI0w5YqDfvC2X8dNjj3Q6Ku122fghQ6l9hFY5JNLgQ8/
	 LLg2uh+fD13P2vBUInqtjK2uRudC8XE1VN5AY0lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 285/457] drm/amdgpu/userq: fix double jiffies conversion in hang detect timeout
Date: Wed, 30 Sep 2026 17:26:30 +0200
Message-ID: <20260930152352.184579540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

commit cd195f1616b2bb5fb7765465326c4d5d64a620a0 upstream.

Function amdgpu_userq_start_hang_detect_work() calls msecs_to_jiffies()
on adev->gfx_timeout/compute_timeout/sdma_timeout before arming
hang_detect_work. These timeout values already hold jiffies values from
amdgpu_device_get_job_timeout_settings() at device init.

This silently shrinks the real hang-detect deadline to (2 * HZ) ms
instead of the intended timeout. e.g. 500ms instead of the 2000ms
default on a CONFIG_HZ=250 kernel, only coincidentally correct at
HZ=1000. The shortened window is easily exceeded by ordinary
fence-completion latency, causing hang_detect_work to fire and
trigger a per-queue or full GPU reset for queues that are not
actually hung.

Pass the jiffies value directly to queue_delayed_work() instead of
converting it a second time.

Fixes: fc3336be9c62 ("drm/amd/amdgpu: Add independent hang detect work for user queue fence")
Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 13d44ca033cb74756c2aef0ade54a75cdf2f6271)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -167,27 +167,27 @@ static void amdgpu_userq_hang_detect_wor
 void amdgpu_userq_start_hang_detect_work(struct amdgpu_usermode_queue *queue)
 {
 	struct amdgpu_device *adev;
-	unsigned long timeout_ms;
+	unsigned long timeout_jiffies;
 
 	adev = queue->userq_mgr->adev;
 	/* Determine timeout based on queue type */
 	switch (queue->queue_type) {
 	case AMDGPU_RING_TYPE_GFX:
-		timeout_ms = adev->gfx_timeout;
+		timeout_jiffies = adev->gfx_timeout;
 		break;
 	case AMDGPU_RING_TYPE_COMPUTE:
-		timeout_ms = adev->compute_timeout;
+		timeout_jiffies = adev->compute_timeout;
 		break;
 	case AMDGPU_RING_TYPE_SDMA:
-		timeout_ms = adev->sdma_timeout;
+		timeout_jiffies = adev->sdma_timeout;
 		break;
 	default:
-		timeout_ms = adev->gfx_timeout;
+		timeout_jiffies = adev->gfx_timeout;
 		break;
 	}
 
 	queue_delayed_work(adev->reset_domain->wq, &queue->hang_detect_work,
-			   msecs_to_jiffies(timeout_ms));
+			   timeout_jiffies);
 }
 
 void amdgpu_userq_process_fence_irq(struct amdgpu_device *adev, u32 doorbell)


