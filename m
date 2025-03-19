Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502E21F872A;
	Wed, 19 Mar 2025 14:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394975; cv=none; b=j0HsTKM7NvymDKcX3NI2lZlRKfv6MzcxI5y158FuYpHNjaCV9LZeBwAJkrFDRjIzOWkJjmcNpT3RFlZcL/mHWa5jJIcL8uNXpcQpZRYgMU8wJWKAGY+Y7qVtwoN8oe7eCH3u6Tk2MDhMAkAxj/JyvDw8gFn9a9p8brfBRV/GejA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394975; c=relaxed/simple;
	bh=A4JuUUsWpdrLeDliUlfF1J2OAn7TP14ejV9At+cQNCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGtgbUhksAGrd1YaG1EcK54E6vqOJaoabVg7K6AOeyzeyK00sEQCMCCuGkibSQ+B8v84BEZNq9bCtRS6bqAOTQUeUJwwHta7Pb1R3h6iyM4Dq0r6fDkJfZygTWpAyqm1cqwxDQ+RbplVVloSC7vL0XMROms15IwEaEuvM0ZcwzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kYK2g/VH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kYK2g/VH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DC0C4CEE8;
	Wed, 19 Mar 2025 14:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394975;
	bh=A4JuUUsWpdrLeDliUlfF1J2OAn7TP14ejV9At+cQNCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYK2g/VHPDj+bq8V+2sc5sZbEMS4jIJgRfdixWcapE21rpUT5ARTERlHevuLz41xG
	 mMsUpRFv3clXTxQNW4xrkZn2rkgUuXDKuu5dspZ4wpInhwlTntWbS7Ohfor63Kg/yp
	 mEt/6CGvsCScp+5qhTLVVVT+gNom+hq40ryld1/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 212/241] drm/xe: cancel pending job timer before freeing scheduler
Date: Wed, 19 Mar 2025 07:31:22 -0700
Message-ID: <20250319143032.998317154@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit 12c2f962fe71f390951d9242725bc7e608f55927 ]

The async call to __guc_exec_queue_fini_async frees the scheduler
while a submission may time out and restart. To prevent this race
condition, the pending job timer should be canceled before freeing
the scheduler.

V3(MattB):
 - Adjust position of cancel pending job
 - Remove gitlab issue# from commit message
V2(MattB):
 - Cancel pending jobs before scheduler finish

Fixes: a20c75dba192 ("drm/xe: Call __guc_exec_queue_fini_async direct for KERNEL exec_queues")
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250225045754.600905-1-tejas.upadhyay@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit 18fbd567e75f9b97b699b2ab4f1fa76b7cf268f6)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 10c7988418d8 ("drm/xe: Release guc ids before cancelling work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 6f4a9812b4f4a..fe17e9ba86725 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1238,6 +1238,8 @@ static void __guc_exec_queue_fini_async(struct work_struct *w)
 
 	if (xe_exec_queue_is_lr(q))
 		cancel_work_sync(&ge->lr_tdr);
+	/* Confirm no work left behind accessing device structures */
+	cancel_delayed_work_sync(&ge->sched.base.work_tdr);
 	release_guc_id(guc, q);
 	xe_sched_entity_fini(&ge->entity);
 	xe_sched_fini(&ge->sched);
-- 
2.39.5



