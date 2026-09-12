Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E723176EE;
	Sat, 12 Sep 2026 19:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242182; cv=none; b=NB3Db4+qlTiuCRW1ZGVUdcpfM3ssMAunhMtiNsB5qzk5Mii76kZUBNbows6tgShuFbQU3SuqasxKJIIcxKGnpYyP2bjSCkRcR6E1+GSe8/KiwPUXP1EmR9KzGDbPv7SRPiMDYG45npxMzygYcs1EzMuIn0iGfSGTYCaGU4kpZjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242182; c=relaxed/simple;
	bh=o5/Obr5WKG87PdrzG9zkQxVucbk1k6zwfP7wzNQyYCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cf5hB/1YjVWv2cgCvs3DGoIB5Moe92OW4/GXYZ2nb2Uqo2iG+sSi+g6xlnh9dDp+y0/YdTxfH/HHtFexUAMUA87RNk/+bhIAz2EdxE45yG4/S4xCVVhAdhB81bbG0vNrDvdrgPI4rCqz8mnqMsauxQ/3WxwS4kYzSpMO/mNNnLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elsZogqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elsZogqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D99E1F000FF;
	Sat, 12 Sep 2026 19:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242181;
	bh=+sA+mAndxk5kLXf/Y5rsfahxQo0GurJBcLsWFnEG7p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=elsZogqEVhpykjN1ddLxrX6GnSBr9MyD87usJR0uPeJrLHGaS5YLY/5tkHQNfdNAE
	 PuIqxJMEW1XEygFPrRh5QS1TN+K9fX7jNWgUnq4UHkEAUq+z2oDUT5Tt3/ic1NkFR8
	 lpQo8ckei0ZnpkA005DGJ9X9nX4TUILQ6ZTgUB2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Alexandre Courbot <acourbot@nvidia.com>,
	Lyude Paul <lyude@redhat.com>,
	Deborah Brouwer <deborah.brouwer@collabora.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.10 314/798] drm: fix race between partial drm_dev_register() failure and ioctl
Date: Sat, 12 Sep 2026 08:59:02 +0200
Message-ID: <20260912065524.355777859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit eb197f7d60f00d0f5b1b3505dfc86a7e36045a3e upstream.

If drm_dev_register() fails after registering a minor (e.g. render minor
registered, primary minor fails), userspace could have opened the first
minor and entered a drm_dev_enter() critical section. Since the
unplugged flag was never set, the ioctl proceeds while the error path
tears down device resources.

Fix this by introducing drm_dev_synchronize_unplug(), which sets the
unplugged flag and waits for the SRCU barrier, ensuring all in-flight
drm_dev_enter() critical sections complete before cleanup proceeds; call
it on the error path of drm_dev_register().

Fixes: bee330f3d672 ("drm: Use srcu to protect drm_device.unplugged")
Cc: stable@vger.kernel.org
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260620190648.2E9F61F000E9@smtp.kernel.org/
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Tested-by: Deborah Brouwer <deborah.brouwer@collabora.com>
Link: https://patch.msgid.link/20260628145406.2107056-17-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_drv.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -447,6 +447,22 @@ void drm_dev_exit(int idx)
 }
 EXPORT_SYMBOL(drm_dev_exit);
 
+/*
+ * Mark the device as unplugged and wait for any in-flight drm_dev_enter()
+ * critical sections to complete.
+ */
+static void drm_dev_synchronize_unplug(struct drm_device *dev)
+{
+	/*
+	 * After synchronizing any critical read section is guaranteed to see
+	 * the new value of ->unplugged, and any critical section which might
+	 * still have seen the old value of ->unplugged is guaranteed to have
+	 * finished.
+	 */
+	dev->unplugged = true;
+	synchronize_srcu(&drm_unplug_srcu);
+}
+
 /**
  * drm_dev_unplug - unplug a DRM device
  * @dev: DRM device
@@ -459,15 +475,7 @@ EXPORT_SYMBOL(drm_dev_exit);
  */
 void drm_dev_unplug(struct drm_device *dev)
 {
-	/*
-	 * After synchronizing any critical read section is guaranteed to see
-	 * the new value of ->unplugged, and any critical section which might
-	 * still have seen the old value of ->unplugged is guaranteed to have
-	 * finished.
-	 */
-	dev->unplugged = true;
-	synchronize_srcu(&drm_unplug_srcu);
-
+	drm_dev_synchronize_unplug(dev);
 	drm_dev_unregister(dev);
 }
 EXPORT_SYMBOL(drm_dev_unplug);
@@ -885,6 +893,7 @@ int drm_dev_register(struct drm_device *
 		goto err_minors;
 
 	dev->registered = true;
+	dev->unplugged = false;
 
 	if (dev->driver->load) {
 		ret = dev->driver->load(dev, flags);
@@ -912,6 +921,13 @@ err_unload:
 	if (dev->driver->unload)
 		dev->driver->unload(dev);
 err_minors:
+	/*
+	 * If a minor was registered before the failure, userspace could have
+	 * opened it and entered a drm_dev_enter() critical section. Ensure all
+	 * such sections complete before we clean up.
+	 */
+	drm_dev_synchronize_unplug(dev);
+
 	remove_compat_control_link(dev);
 	drm_minor_unregister(dev, DRM_MINOR_PRIMARY);
 	drm_minor_unregister(dev, DRM_MINOR_RENDER);


