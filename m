Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBC42BCF43;
	Tue, 11 Nov 2025 01:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823496; cv=none; b=sZrOITRFgYuyScqhzzmwtuZuaKk5HIVLXAKa4gW7dy+s/WtVJQQhcVXLp2aJol9GXkKUdJOcg5Kb2l3R2Dbgo95/qqqST2X8BMtMd9Y1bAXQC9s/XgfGfclXGrGDn+U01xhVTqIkPEwjsrTj2HMvpUSwO3D9tGrkx1WxJVz1SDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823496; c=relaxed/simple;
	bh=yeCx7fWe60Kd9SgGdWsIx/xpVHuLVF6/uS8vYV46SSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/ILVAdMc/D/NdmnFVW2PfU3pplS6D8Qo5HhaUHVQuaB9fYPEv2kozqL0FCnoKGtoNdI0lofqwHLq1uU9GB0jgTLf394vaQ5LzvnOdYQm9UWwOQ4ZwFTr9Oo5OZcAxbORa83koni8lFKuBVpg5LlICh7p31ymJ0iwMDl2HR9Q94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjxDEkhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjxDEkhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C15C116B1;
	Tue, 11 Nov 2025 01:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823496;
	bh=yeCx7fWe60Kd9SgGdWsIx/xpVHuLVF6/uS8vYV46SSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjxDEkhGKIlDcmyCdC3TfadZAE91h1tgMI9H4NZ/Eo4Gmi4hEWoeLqoJ4HT1zdDWb
	 PinoEovTwC7cLg7Y6wBQCor2Cyw86eR7ACqt8rqhC6/H7dK122D1cPojWueBJp2OHO
	 AtQ/m+kJPldp8LMYOo11SwidezEIbJwoS2RvNHOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Dennis Tsiang <dennis.tsiang@arm.com>,
	Karunika Choo <karunika.choo@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 311/849] drm/panthor: Serialize GPU cache flush operations
Date: Tue, 11 Nov 2025 09:38:01 +0900
Message-ID: <20251111004543.931565727@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karunika Choo <karunika.choo@arm.com>

[ Upstream commit e322a4844811b54477b7072eb40dc9e402a1725d ]

In certain scenarios, it is possible for multiple cache flushes to be
requested before the previous one completes. This patch introduces the
cache_flush_lock mutex to serialize these operations and ensure that
any requested cache flushes are completed instead of dropped.

Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Co-developed-by: Dennis Tsiang <dennis.tsiang@arm.com>
Signed-off-by: Dennis Tsiang <dennis.tsiang@arm.com>
Signed-off-by: Karunika Choo <karunika.choo@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250807162633.3666310-6-karunika.choo@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gpu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_gpu.c b/drivers/gpu/drm/panthor/panthor_gpu.c
index cb7a335e07d7c..030409371037b 100644
--- a/drivers/gpu/drm/panthor/panthor_gpu.c
+++ b/drivers/gpu/drm/panthor/panthor_gpu.c
@@ -35,6 +35,9 @@ struct panthor_gpu {
 
 	/** @reqs_acked: GPU request wait queue. */
 	wait_queue_head_t reqs_acked;
+
+	/** @cache_flush_lock: Lock to serialize cache flushes */
+	struct mutex cache_flush_lock;
 };
 
 /**
@@ -204,6 +207,7 @@ int panthor_gpu_init(struct panthor_device *ptdev)
 
 	spin_lock_init(&gpu->reqs_lock);
 	init_waitqueue_head(&gpu->reqs_acked);
+	mutex_init(&gpu->cache_flush_lock);
 	ptdev->gpu = gpu;
 	panthor_gpu_init_info(ptdev);
 
@@ -353,6 +357,9 @@ int panthor_gpu_flush_caches(struct panthor_device *ptdev,
 	bool timedout = false;
 	unsigned long flags;
 
+	/* Serialize cache flush operations. */
+	guard(mutex)(&ptdev->gpu->cache_flush_lock);
+
 	spin_lock_irqsave(&ptdev->gpu->reqs_lock, flags);
 	if (!drm_WARN_ON(&ptdev->base,
 			 ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED)) {
-- 
2.51.0



