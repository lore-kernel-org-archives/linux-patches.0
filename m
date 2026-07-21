Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9A7402444;
	Tue, 21 Jul 2026 18:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657442; cv=none; b=MorjWwmKz1V3aVuZSE+wX3qA/WZ0y+zS/d8kUEB2sD3Gb96I5m+2RCFXgDn/reVK4QIxnDzHxHrzPVkxPu9ug2OHN/8TEuOFLf6yGY8lSNuWZX/vRH1dJ2V31gjNH2aGxpcZOgLLAG8Is936o7VfMJH8WUDuviMsIlGONP42O9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657442; c=relaxed/simple;
	bh=5sgLBenbm0Fit07fQe9m/R4+pnl5CGoK6D4P3sXPM5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qinbArMdpEeyL2hMmK54ZavVUd3zN3CHSWhlvefQyDRVup/c0YQ3fvJFmEh5Ed+JESmw0WiykoKLQ+FGLvL4on9VbWIFxlAwBzn0V0r4fb9SxdUrMtfdJ3dnysFKiQ8wMQGjnuhAXIpq/ef/QM+1j7IwgwcmQTuOztNOvpMe3tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFFUfoOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFFUfoOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270031F000E9;
	Tue, 21 Jul 2026 18:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657441;
	bh=khjvEd3Ur8fw5W4Sze0w/qzGmwbK9K8KqXVb9LzlK64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mFFUfoOBzdv/qcybjc3smc1ssahcNrmQGwfMJrZabkVpTckenga+1IOwy2Ob+qet0
	 Ty4fsAL1KZIcsZz5h+7OiHf08UzNWTow6ynox6jbZztz+WYqlF6W+/LIufKlyYU+uM
	 SYllZWTVu+tjC528+HcuYswiAYUUJg9KllO6klzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0766/1611] accel/ivpu: fix HWS command queue leak on registration failure
Date: Tue, 21 Jul 2026 17:14:42 +0200
Message-ID: <20260721152532.610055601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@linux.intel.com>

[ Upstream commit e7ab91e2bf01b024691d6ce488546533943e7a6b ]

A command queue is considered valid and usable by the driver only when
it has a doorbell ID assigned (db_id != 0), meaning both the FW cmdq
creation and doorbell registration completed successfully.

However, when either ivpu_register_db() or set_context_sched_properties()
fails after ivpu_hws_cmdq_init() has already created the cmdq in FW,
the command queue is left registered in FW while the driver treats it as
uninitialized (db_id remains 0). On the next submission attempt the
driver tries to register the same cmdq again, which fails because FW
already has an entry for it.

Fix by calling ivpu_jsm_hws_destroy_cmdq() on error paths to properly
unwind FW state and allow subsequent registration attempts to succeed.

Fixes: 465a3914b254 ("accel/ivpu: Add API for command queue create/destroy/submit")
Reviewed-by: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260611055140.948684-1-karol.wachowski@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_job.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_job.c b/drivers/accel/ivpu/ivpu_job.c
index 1e4caf5726474d..dcae72a79e72c7 100644
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -195,9 +195,9 @@ static int ivpu_hws_cmdq_init(struct ivpu_file_priv *file_priv, struct ivpu_cmdq
 	ret = ivpu_jsm_hws_set_context_sched_properties(vdev, file_priv->ctx.id, cmdq->id,
 							priority);
 	if (ret)
-		return ret;
+		ivpu_jsm_hws_destroy_cmdq(vdev, file_priv->ctx.id, cmdq->id);
 
-	return 0;
+	return ret;
 }
 
 static int ivpu_register_db(struct ivpu_file_priv *file_priv, struct ivpu_cmdq *cmdq)
@@ -255,10 +255,10 @@ static int ivpu_cmdq_register(struct ivpu_file_priv *file_priv, struct ivpu_cmdq
 	}
 
 	ret = ivpu_register_db(file_priv, cmdq);
-	if (ret)
-		return ret;
+	if (ret && vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW)
+		ivpu_jsm_hws_destroy_cmdq(vdev, file_priv->ctx.id, cmdq->id);
 
-	return 0;
+	return ret;
 }
 
 static int ivpu_cmdq_unregister(struct ivpu_file_priv *file_priv, struct ivpu_cmdq *cmdq)
-- 
2.53.0



