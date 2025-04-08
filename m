Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D37F26F44E;
	Tue,  8 Apr 2025 12:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114867; cv=none; b=FlqKhB8nXubWlYa9wEk5OwOHZ79v5xidtaMoKnAe8GqJG+9mzy7y8hm7dofCj4Xxrz9wFSS1dtVeRPMHvfJ668DfG7aIxElvJ25uO/eLjgqiiTvOhs0y+URcEXcGQgHPcVcD3owmqZmFmtD6oiY31uvBRQnIte7nf1XRtjhXN5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114867; c=relaxed/simple;
	bh=62KOWy11ZJyWo8hu1tAIGMBb8fAoO6SfhqnJ+fNzvU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSjcby/ceWU+bbPWRAPP8YMXvtG0LFG79FkVeNWezjN5tmQEGHFayyj4tJmpPb1jD1KLy5AUujsnYGsjQ0f80boLxFWIT8blMQ3pxmZ77CG8ZHliI318TDJI2alK7M7UlXbbe4rra36Sff2oh2S6nfN/k6j+YkOFzulDSX+JR6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ty1WedO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ty1WedO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507B6C4CEE7;
	Tue,  8 Apr 2025 12:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114866;
	bh=62KOWy11ZJyWo8hu1tAIGMBb8fAoO6SfhqnJ+fNzvU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ty1WedO3JGK9H6d5SW7I1sstTcU3eB0/T69d2c5SMCgdjLPjqDK7gANpSU1ecLxn3
	 o/Z7HhjD0HvKVnH5ZAoY0ZmkmFYWmZvAQIQ10ejKEmk43+//zmCQ8I5axNS7fe1YQk
	 cMGkLck2+VvW1PsjbkoRJeOmMH10lgCeWLUlTyyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 265/499] staging: vchiq_arm: Stop kthreads if vchiq cdev register fails
Date: Tue,  8 Apr 2025 12:47:57 +0200
Message-ID: <20250408104857.828345141@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit cfb320d990919836b49bd090c6c232c6c4d90b41 ]

In case the vchiq character device cannot be registered during probe,
all kthreads needs to be stopped to avoid resource leaks.

Fixes: 863a756aaf49 ("staging: vc04_services: vchiq_core: Stop kthreads on vchiq module unload")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20250309125014.37166-4-wahrenst@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../interface/vchiq_arm/vchiq_arm.c           | 25 ++++++++++++-------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index d3b7d1227d7d6..0c7ea2d0ee85e 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -308,6 +308,20 @@ static struct vchiq_arm_state *vchiq_platform_get_arm_state(struct vchiq_state *
 	return (struct vchiq_arm_state *)state->platform_state;
 }
 
+static void
+vchiq_platform_uninit(struct vchiq_drv_mgmt *mgmt)
+{
+	struct vchiq_arm_state *arm_state;
+
+	kthread_stop(mgmt->state.sync_thread);
+	kthread_stop(mgmt->state.recycle_thread);
+	kthread_stop(mgmt->state.slot_handler_thread);
+
+	arm_state = vchiq_platform_get_arm_state(&mgmt->state);
+	if (!IS_ERR_OR_NULL(arm_state->ka_thread))
+		kthread_stop(arm_state->ka_thread);
+}
+
 void vchiq_dump_platform_state(struct seq_file *f)
 {
 	seq_puts(f, "  Platform: 2835 (VC master)\n");
@@ -1396,6 +1410,7 @@ static int vchiq_probe(struct platform_device *pdev)
 	ret = vchiq_register_chrdev(&pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "arm: Failed to initialize vchiq cdev\n");
+		vchiq_platform_uninit(mgmt);
 		return ret;
 	}
 
@@ -1410,20 +1425,12 @@ static int vchiq_probe(struct platform_device *pdev)
 static void vchiq_remove(struct platform_device *pdev)
 {
 	struct vchiq_drv_mgmt *mgmt = dev_get_drvdata(&pdev->dev);
-	struct vchiq_arm_state *arm_state;
 
 	vchiq_device_unregister(bcm2835_audio);
 	vchiq_device_unregister(bcm2835_camera);
 	vchiq_debugfs_deinit();
 	vchiq_deregister_chrdev();
-
-	kthread_stop(mgmt->state.sync_thread);
-	kthread_stop(mgmt->state.recycle_thread);
-	kthread_stop(mgmt->state.slot_handler_thread);
-
-	arm_state = vchiq_platform_get_arm_state(&mgmt->state);
-	if (!IS_ERR_OR_NULL(arm_state->ka_thread))
-		kthread_stop(arm_state->ka_thread);
+	vchiq_platform_uninit(mgmt);
 }
 
 static struct platform_driver vchiq_driver = {
-- 
2.39.5



