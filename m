Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD78336888;
	Tue, 21 Jul 2026 17:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653596; cv=none; b=FzG7CQxPstDNSmgZT8qBdm4ypzhYG1iZObTw6CO/UCBRp2Ulim4Yc/0gc+tRKCanb0YAe4dG2JavFg1J1L6BVOz+jgTgIlgGY9xlEPkJqZvaz710ID+XnCBMv431hOxA6sXdh9sd85zOeeSeyqnyfz0E8lacOe1/qPOZzMKt6DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653596; c=relaxed/simple;
	bh=lmaXqgQhhrtjx6EU//0OCaBkhFR5CGie70fVMr9Uh+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHpeMoyJNUZ7G5cJS+10EPMKfNBKbj8cfJAENKi/zBhaqvOkJsLKyd8gqJftkCvMQY2Jqz1cytessqs0nnRP1hPgcf+gwgE/bytqgEoRLKzCVjWtgSNRPgx/6wE3JqURB9Cdf2iyESvTYiWvM7toVLnK+Xd4Zfqllfjsrh0zzz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUd3ZXvG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUd3ZXvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAFF1F000E9;
	Tue, 21 Jul 2026 17:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653594;
	bh=i1jTGdDIqQHobgI+Yal0UNn5lRNtR6bXAaPefQf3OfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUd3ZXvGUX+xIbBYw1coqxheBB3ItoNaNxQd7Zar9vWVxjx/KtDAvpLuSFAQNKtEj
	 Ogxk7Nn5VcmNMUUvohlKyqS0xiMtrnKCzjy+mySHMhByoHki9cI4ZvOq5nWmlQL/pT
	 otMxoIKSDsKqtSqUjjC0dktCtDh2X4SFoKMhVl6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1343/2077] drm/panthor: Fix theoretical IOMEM access in suspended state
Date: Tue, 21 Jul 2026 17:16:56 +0200
Message-ID: <20260721152624.493999232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit fe4c05a59018964bac7923338706371fff3c09ef ]

In theory, our hardirq handler can be called while the device (and
thus the panthor_irq) is suspended, because the IRQ line is shared.
In practice though, in all the designs we've seen, the line is only
shared within the GPU, and because sub-component suspend state is
consistent (all-suspended or all-resumed), we shouldn't end up with
an interrupt triggered while we're suspended.

Fix the problem anyway, if nothing else, for our sanity.

Fixes: 0b2d86670a84 ("drm/panthor: Rework panthor_irq::suspended into panthor_irq::state")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260625-panthor-signal-from-irq-v4-0-3d2908912afa@collabora.com?part=1
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260625-panthor-misc-fixes-v1-5-b67ed973fea6@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_device.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_device.h b/drivers/gpu/drm/panthor/panthor_device.h
index dea0ff7def6caa..724b4aeaf23e16 100644
--- a/drivers/gpu/drm/panthor/panthor_device.h
+++ b/drivers/gpu/drm/panthor/panthor_device.h
@@ -439,9 +439,6 @@ static irqreturn_t panthor_ ## __name ## _irq_raw_handler(int irq, void *data)
 	struct panthor_irq *pirq = data;							\
 	enum panthor_irq_state old_state;							\
 												\
-	if (!gpu_read(pirq->iomem, INT_STAT))							\
-		return IRQ_NONE;								\
-												\
 	guard(spinlock_irqsave)(&pirq->mask_lock);						\
 	old_state = atomic_cmpxchg(&pirq->state,						\
 				   PANTHOR_IRQ_STATE_ACTIVE,					\
@@ -449,6 +446,13 @@ static irqreturn_t panthor_ ## __name ## _irq_raw_handler(int irq, void *data)
 	if (old_state != PANTHOR_IRQ_STATE_ACTIVE)						\
 		return IRQ_NONE;								\
 												\
+	if (!gpu_read(pirq->iomem, INT_STAT)) {							\
+		atomic_cmpxchg(&pirq->state,							\
+			       PANTHOR_IRQ_STATE_PROCESSING,					\
+			       PANTHOR_IRQ_STATE_ACTIVE);					\
+		return IRQ_NONE;								\
+	}											\
+												\
 	gpu_write(pirq->iomem, INT_MASK, 0);							\
 	return IRQ_WAKE_THREAD;									\
 }												\
-- 
2.53.0



