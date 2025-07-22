Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCEB2BE045;
	Tue, 22 Jul 2025 13:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192638; cv=none; b=oeGhMMcrwQmRmhge5SnFWKkbd2bZg0wvEX4VawVnqOEZv7L3VvXXHfklThmqLCO28KCqiMRRXF6k2NLgGdfjj5b4lKatrum47fBQuzSbO9E3zLFgg5B8ZYOogYMWuV8OzP4goHG+SJutRIAfisDjbL96uZEMPOe+u2DNkUgonec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192638; c=relaxed/simple;
	bh=XqnkB3TFXcg3enwsn4uEU7neCVEA29n8wyphF/HK5JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k+BbOZpgkepPquO8u1ZYyGaTo9WuJ0mRhe7MEE8FAfRUbeeypmhOvW4Mqj7jJ5NuDk0PX9HjZHwUx0R3IEwaiA6WIXXCjJDBsoad12dqd+TU7of92Y4Z6wi1htRcNHHuUhcRsgsdpQdjJ/b/89kbVls0Q1FJE0IjHPP6qXIIpS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQ77Uqcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQ77Uqcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8A4C4CEEB;
	Tue, 22 Jul 2025 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192638;
	bh=XqnkB3TFXcg3enwsn4uEU7neCVEA29n8wyphF/HK5JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQ77Uqcd/b9uq99ZExs5NOUBBsjpg546G6CJenncMKL5tDxx8wdyyQFPaXXVjN6qi
	 bh8Jz9a5NsjLNx8jEduNbLGyaM2agv01mpWCX8P3qJRAX+XRIWPqVGdjoyOfwWak+Z
	 TTGYp5rrUhK+5fcoePDUTc5BeiR+M2X4shFAhFUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	stable@kernel.org,
	Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH 6.12 014/158] Revert "staging: vchiq_arm: Create keep-alive thread during probe"
Date: Tue, 22 Jul 2025 15:43:18 +0200
Message-ID: <20250722134341.266885073@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

commit 228af5a58524fba09ec4b7d184694db4f7fe96f5 upstream.

The commit 86bc88217006 ("staging: vchiq_arm: Create keep-alive thread
during probe") introduced a regression for certain configurations,
which doesn't have a VCHIQ user. This results in a unused and hanging
keep-alive thread:

  INFO: task vchiq-keep/0:85 blocked for more than 120 seconds.
        Not tainted 6.12.34-v8-+ #13
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:vchiq-keep/0    state:D stack:0 pid:85    tgid:85    ppid:2
  Call trace:
   __switch_to+0x188/0x230
   __schedule+0xa54/0xb28
   schedule+0x80/0x120
   schedule_preempt_disabled+0x30/0x50
   kthread+0xd4/0x1a0
   ret_from_fork+0x10/0x20

Fixes: 86bc88217006 ("staging: vchiq_arm: Create keep-alive thread during probe")
Reported-by: Maíra Canal <mcanal@igalia.com>
Closes: https://lore.kernel.org/linux-staging/ba35b960-a981-4671-9f7f-060da10feaa1@usp.br/
Cc: stable@kernel.org
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://lore.kernel.org/r/20250715161108.3411-3-wahrenst@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c |   69 +++++-----
 1 file changed, 35 insertions(+), 34 deletions(-)

--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -588,6 +588,29 @@ static int vchiq_platform_init(struct pl
 	return 0;
 }
 
+int
+vchiq_platform_init_state(struct vchiq_state *state)
+{
+	struct vchiq_arm_state *platform_state;
+
+	platform_state = devm_kzalloc(state->dev, sizeof(*platform_state), GFP_KERNEL);
+	if (!platform_state)
+		return -ENOMEM;
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
 static struct vchiq_arm_state *vchiq_platform_get_arm_state(struct vchiq_state *state)
 {
 	return (struct vchiq_arm_state *)state->platform_state;
@@ -1336,39 +1359,6 @@ exit:
 }
 
 int
-vchiq_platform_init_state(struct vchiq_state *state)
-{
-	struct vchiq_arm_state *platform_state;
-	char threadname[16];
-
-	platform_state = devm_kzalloc(state->dev, sizeof(*platform_state), GFP_KERNEL);
-	if (!platform_state)
-		return -ENOMEM;
-
-	snprintf(threadname, sizeof(threadname), "vchiq-keep/%d",
-		 state->id);
-	platform_state->ka_thread = kthread_create(&vchiq_keepalive_thread_func,
-						   (void *)state, threadname);
-	if (IS_ERR(platform_state->ka_thread)) {
-		dev_err(state->dev, "couldn't create thread %s\n", threadname);
-		return PTR_ERR(platform_state->ka_thread);
-	}
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
-int
 vchiq_use_internal(struct vchiq_state *state, struct vchiq_service *service,
 		   enum USE_TYPE_E use_type)
 {
@@ -1688,6 +1678,7 @@ void vchiq_platform_conn_state_changed(s
 				       enum vchiq_connstate newstate)
 {
 	struct vchiq_arm_state *arm_state = vchiq_platform_get_arm_state(state);
+	char threadname[16];
 
 	dev_dbg(state->dev, "suspend: %d: %s->%s\n",
 		state->id, get_conn_state_name(oldstate), get_conn_state_name(newstate));
@@ -1702,7 +1693,17 @@ void vchiq_platform_conn_state_changed(s
 
 	arm_state->first_connect = 1;
 	write_unlock_bh(&arm_state->susp_res_lock);
-	wake_up_process(arm_state->ka_thread);
+	snprintf(threadname, sizeof(threadname), "vchiq-keep/%d",
+		 state->id);
+	arm_state->ka_thread = kthread_create(&vchiq_keepalive_thread_func,
+					      (void *)state,
+					      threadname);
+	if (IS_ERR(arm_state->ka_thread)) {
+		dev_err(state->dev, "suspend: Couldn't create thread %s\n",
+			threadname);
+	} else {
+		wake_up_process(arm_state->ka_thread);
+	}
 }
 
 static const struct of_device_id vchiq_of_match[] = {


