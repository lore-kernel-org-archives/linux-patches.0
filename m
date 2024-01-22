Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622FB2B9CD;
	Tue, 23 Jan 2024 00:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969461; cv=none; b=rE+Vw0mACKGa7jz2NsJbNpxi2LEcR4Y0Wb9B1V7E6Hua7pgLaRGUCH/XukPGjWeDhohCKF986AMeEgKi9KPBt6BU/IeOnXockgKUS4ZEjg8akOvFoaFKKuMBA9MAzXK4sGQKwfnnh3CwNgpjDHMxHMLy4IZF5JKc0vPW6nhPnd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969461; c=relaxed/simple;
	bh=q57nwhDl4Eq7hVWjl0bH/fXzvY0OV+LbRQ5KntqlZx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dasxfp+tyR3EgCCfAzUevqMWg9e0Sg0fkvfShz6lHu5XI5u1PAuR6PcHDYi3jnfzo2tDknygchYNAbAH5mE7cSi9jQPsW3v3fyI2pdsAaAevH44eNgI6Erx3RjQsfPU32pNahW0p4Vn4pEmwUrSCWI1IitNmCvOPRoJ/T9i0E8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMSuea4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMSuea4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01178C43399;
	Tue, 23 Jan 2024 00:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969461;
	bh=q57nwhDl4Eq7hVWjl0bH/fXzvY0OV+LbRQ5KntqlZx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMSuea4cLsLDDE3Qp+KpjL1KCOtUzedqsKNceYSWbUemBB2yy7ayi7oqinZoR1Sv3
	 rcAQxQhiszk9bO+DgbgtuwIFvY63Xrzyc6P6aIB4xU5olaFrMzO/Up7CVVQuCqXRt9
	 4g+lFKt9g43zPDaP/uoIP9c4pDRw9ehsUBeRz+8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luben Tuikov <ltuikov89@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 260/641] drm/sched: Fix bounds limiting when given a malformed entity
Date: Mon, 22 Jan 2024 15:52:44 -0800
Message-ID: <20240122235826.076344776@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luben Tuikov <ltuikov89@gmail.com>

[ Upstream commit 2bbe6ab2be53858507f11f99f856846d04765ae3 ]

If we're given a malformed entity in drm_sched_entity_init()--shouldn't
happen, but we verify--with out-of-bounds priority value, we set it to an
allowed value. Fix the expression which sets this limit.

Signed-off-by: Luben Tuikov <ltuikov89@gmail.com>
Fixes: 56e449603f0ac5 ("drm/sched: Convert the GPU scheduler to variable number of run-queues")
Link: https://patchwork.freedesktop.org/patch/msgid/20231123122422.167832-2-ltuikov89@gmail.com
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/dbb91dbe-ef77-4d79-aaf9-2adb171c1d7a@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index 409e4256f6e7..0a7a7e4ad8d1 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -81,12 +81,15 @@ int drm_sched_entity_init(struct drm_sched_entity *entity,
 		 */
 		pr_warn("%s: called with uninitialized scheduler\n", __func__);
 	} else if (num_sched_list) {
-		/* The "priority" of an entity cannot exceed the number
-		 * of run-queues of a scheduler.
+		/* The "priority" of an entity cannot exceed the number of run-queues of a
+		 * scheduler. Protect against num_rqs being 0, by converting to signed.
 		 */
-		if (entity->priority >= sched_list[0]->num_rqs)
-			entity->priority = max_t(u32, sched_list[0]->num_rqs,
-						 DRM_SCHED_PRIORITY_MIN);
+		if (entity->priority >= sched_list[0]->num_rqs) {
+			drm_err(sched_list[0], "entity with out-of-bounds priority:%u num_rqs:%u\n",
+				entity->priority, sched_list[0]->num_rqs);
+			entity->priority = max_t(s32, (s32) sched_list[0]->num_rqs - 1,
+						 (s32) DRM_SCHED_PRIORITY_MIN);
+		}
 		entity->rq = sched_list[0]->sched_rq[entity->priority];
 	}
 
-- 
2.43.0



