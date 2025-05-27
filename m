Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DCF2CCC0;
	Tue, 27 May 2025 16:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364570; cv=none; b=L8+nzE4Bb2Tgj97v0ubQMxTBgL17ZhDPYdnb6VyPNRxnAZLc8cU5GNxxAU0ms/xDFwzpR/3yFua2MKpLcijF8E+atpDdVIcow7aneLfCrlNk2bRsT6eer0VBMnkTF4jaaj1+0NQ1u/RReaSXFjUMJ0NFXG2WJc9aPH5X1yWZbQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364570; c=relaxed/simple;
	bh=2RklN/vSCzI1IokRK4hMSLUHYwdJGGnpTBTpmGt2g9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgOG6rxVFvVnRADNIUhKe9ip1o1SmHXfEgPPqfRHEYl8xkl37WdFSiejSCkOH5dAtGcZx1oEgQaQx1yQuoRB2po/Xr2NetaychhJrPcFtp/5PxKSo7AWTTBRfTlg7dwzNBfwsj2LlLMk39ysxUJ9CJWy/9m5SizBqKgepm5rZHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3gX7Kac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3gX7Kac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE82C4CEE9;
	Tue, 27 May 2025 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364570;
	bh=2RklN/vSCzI1IokRK4hMSLUHYwdJGGnpTBTpmGt2g9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3gX7KacCJR6RIsy+R3NJm6hv3u13hX40JXbOEGAunEAGN7wytWAeDjy2sh4lhh0V
	 VKLM2rBDqpiTg6QEjsagi3IzILvHxFIBRtKRtINBrVmucveRO3WJYe+cgMfoBG23BE
	 lpskv4S8/twIb4pc8lYRicP8ZJj6/sm/Y3S+VK7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/626] staging: vchiq_arm: Create keep-alive thread during probe
Date: Tue, 27 May 2025 18:19:51 +0200
Message-ID: <20250527162449.025227554@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 86bc8821700665ad3962f3ef0d93667f59cf7031 ]

Creating the keep-alive thread in vchiq_platform_init_state have
the following advantages:
- abort driver probe if kthread_create fails (more consistent behavior)
- make resource release process easier

Since vchiq_keepalive_thread_func is defined below
vchiq_platform_init_state, the latter must be moved.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20250309125014.37166-5-wahrenst@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../interface/vchiq_arm/vchiq_arm.c           | 69 +++++++++----------
 1 file changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 97787002080a1..1a9432646b70a 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -588,29 +588,6 @@ static int vchiq_platform_init(struct platform_device *pdev, struct vchiq_state
 	return 0;
 }
 
-int
-vchiq_platform_init_state(struct vchiq_state *state)
-{
-	struct vchiq_arm_state *platform_state;
-
-	platform_state = devm_kzalloc(state->dev, sizeof(*platform_state), GFP_KERNEL);
-	if (!platform_state)
-		return -ENOMEM;
-
-	rwlock_init(&platform_state->susp_res_lock);
-
-	init_completion(&platform_state->ka_evt);
-	atomic_set(&platform_state->ka_use_count, 0);
-	atomic_set(&platform_state->ka_use_ack_count, 0);
-	atomic_set(&platform_state->ka_release_count, 0);
-
-	platform_state->state = state;
-
-	state->platform_state = (struct opaque_platform_state *)platform_state;
-
-	return 0;
-}
-
 static struct vchiq_arm_state *vchiq_platform_get_arm_state(struct vchiq_state *state)
 {
 	return (struct vchiq_arm_state *)state->platform_state;
@@ -1358,6 +1335,39 @@ vchiq_keepalive_thread_func(void *v)
 	return 0;
 }
 
+int
+vchiq_platform_init_state(struct vchiq_state *state)
+{
+	struct vchiq_arm_state *platform_state;
+	char threadname[16];
+
+	platform_state = devm_kzalloc(state->dev, sizeof(*platform_state), GFP_KERNEL);
+	if (!platform_state)
+		return -ENOMEM;
+
+	snprintf(threadname, sizeof(threadname), "vchiq-keep/%d",
+		 state->id);
+	platform_state->ka_thread = kthread_create(&vchiq_keepalive_thread_func,
+						   (void *)state, threadname);
+	if (IS_ERR(platform_state->ka_thread)) {
+		dev_err(state->dev, "couldn't create thread %s\n", threadname);
+		return PTR_ERR(platform_state->ka_thread);
+	}
+
+	rwlock_init(&platform_state->susp_res_lock);
+
+	init_completion(&platform_state->ka_evt);
+	atomic_set(&platform_state->ka_use_count, 0);
+	atomic_set(&platform_state->ka_use_ack_count, 0);
+	atomic_set(&platform_state->ka_release_count, 0);
+
+	platform_state->state = state;
+
+	state->platform_state = (struct opaque_platform_state *)platform_state;
+
+	return 0;
+}
+
 int
 vchiq_use_internal(struct vchiq_state *state, struct vchiq_service *service,
 		   enum USE_TYPE_E use_type)
@@ -1678,7 +1688,6 @@ void vchiq_platform_conn_state_changed(struct vchiq_state *state,
 				       enum vchiq_connstate newstate)
 {
 	struct vchiq_arm_state *arm_state = vchiq_platform_get_arm_state(state);
-	char threadname[16];
 
 	dev_dbg(state->dev, "suspend: %d: %s->%s\n",
 		state->id, get_conn_state_name(oldstate), get_conn_state_name(newstate));
@@ -1693,17 +1702,7 @@ void vchiq_platform_conn_state_changed(struct vchiq_state *state,
 
 	arm_state->first_connect = 1;
 	write_unlock_bh(&arm_state->susp_res_lock);
-	snprintf(threadname, sizeof(threadname), "vchiq-keep/%d",
-		 state->id);
-	arm_state->ka_thread = kthread_create(&vchiq_keepalive_thread_func,
-					      (void *)state,
-					      threadname);
-	if (IS_ERR(arm_state->ka_thread)) {
-		dev_err(state->dev, "suspend: Couldn't create thread %s\n",
-			threadname);
-	} else {
-		wake_up_process(arm_state->ka_thread);
-	}
+	wake_up_process(arm_state->ka_thread);
 }
 
 static const struct of_device_id vchiq_of_match[] = {
-- 
2.39.5



