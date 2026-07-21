Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394D337B40C;
	Tue, 21 Jul 2026 17:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653540; cv=none; b=Z8IryJKFpqhvhLlqkm+AM12yc4DEDof6ruXPicQMmzAU/X9FBNuajnzA1p2MQhvUm5ABg9QUbU1AE4cJwIzJ3TBc83h0ec9Upjv1Pq2PsDI/JJjTiGn74VkifLFneEpEuNfjWW5Ve8FZ/2yyOpx5jFBIFulvdMNrisPVIN2BvSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653540; c=relaxed/simple;
	bh=87OHqYH770OpBmz0xytzDeApQS4GHKRZB4gEMFDH0a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBSZxnWAeNcDAp5ERPZhYPJ8xrD36CJAI4ZpKzejd3d/s60w3sJaqyeJoSRoLGX+SCBRsllFfsl8Lx6pyF+D7S1KmvSUa080+gnlOhxloiZJKncWdbECAL4hdSLKPJwamvTJ04ifmgjgG/8f0bsQcq8KEnzU4lrHjvO9q0nSvao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLF5erB8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLF5erB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E75E1F000E9;
	Tue, 21 Jul 2026 17:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653539;
	bh=uirF5pB1Beqyh3dvn2nFKLBeP61GiXIh59VkPTyJmus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLF5erB8Z0OMdzB8YAj6Ryx7R2BQSYorvljwPRnxwCDpL0MslY5997EBG61RGud2Y
	 +foAhzzT5okRTyklY43OQyBMe8HAASiLWpYj9x3vP87l3Tp8KWla8UbSxwa1vLVJ+C
	 ImmGs4mnBlGmOtClnYfDTPc8QEv87UhSg51Gaxrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1338/2077] drm/panthor: Keep the reset work disabled until everything is initialized
Date: Tue, 21 Jul 2026 17:16:51 +0200
Message-ID: <20260721152624.376764833@linuxfoundation.org>
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

[ Upstream commit 1b8d771fb214e1f783d66caf13d35d7eda39a643 ]

The reset work will sub-component reset helpers, which might not be
ready if the reset happens during initialization, leading to NULL
pointer dereferences or worse.

Avoid that by keeping the reset work disabled while we're initializing
those sub-components.

Fixes: 5fe909cae118 ("drm/panthor: Add the device logical block")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260625-panthor-signal-from-irq-v5-0-8836a74e0ef9@collabora.com?part=4
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260625-panthor-misc-fixes-v1-2-b67ed973fea6@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/panthor/panthor_device.c
index 54fbb1aa07c52e..55fbb201e89f0a 100644
--- a/drivers/gpu/drm/panthor/panthor_device.c
+++ b/drivers/gpu/drm/panthor/panthor_device.c
@@ -231,6 +231,7 @@ int panthor_device_init(struct panthor_device *ptdev)
 	*dummy_page_virt = 1;
 
 	INIT_WORK(&ptdev->reset.work, panthor_device_reset_work);
+	disable_work(&ptdev->reset.work);
 	ptdev->reset.wq = alloc_ordered_workqueue("panthor-reset-wq", 0);
 	if (!ptdev->reset.wq)
 		return -ENOMEM;
@@ -305,6 +306,9 @@ int panthor_device_init(struct panthor_device *ptdev)
 
 	panthor_gem_init(ptdev);
 
+	/* Now that everything is initialized, we can enable the reset work. */
+	enable_work(&ptdev->reset.work);
+
 	/* ~3 frames */
 	pm_runtime_set_autosuspend_delay(ptdev->base.dev, 50);
 	pm_runtime_use_autosuspend(ptdev->base.dev);
-- 
2.53.0



