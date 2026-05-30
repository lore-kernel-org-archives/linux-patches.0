Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540CF351C2F;
	Sat, 30 May 2026 17:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163233; cv=none; b=pQkUxkuKXw7HX51Z25SG88UvVr/ca5ddZbufP0l592ykOcAQ8eJUldLTvwU2rMFmyVqf6MO/dXSkUEthpt3br5f8byMntMd77AzHtantj/sY8BxZsutd3It3s7tIKCDlrOSLwAXcIC2V+vaRmox6ptNZBy6uegsrbVrzMkMW6sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163233; c=relaxed/simple;
	bh=cqWysi9PUvfJvAV5JHAn9ZkDGDe6RC4jAtPL5b6tDPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTo7X/zFr6Qdds2iCq7xq+km2zbC2P3f8pf+wMs2IM48RHjE3xuYb8d5bHYwtlTj4UqDviFq6MUkuz34P99powb3pFhpi+1kAzsEYFAaRW71mzy2cHHZAW6gU9gGEPV9lUaByGJV+uCiVNL/6Qh+vuEDav63hZVV/6Q9yaqsASI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjwB8lri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjwB8lri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967071F00893;
	Sat, 30 May 2026 17:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163232;
	bh=/tqtTCOoK2p4T1fpLHz2U9aNjEptVfNQcVplYRzCDeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjwB8lriRUbyarfMLtNwFTVyzhV9ydNgT0pBV3k7aJWL9+Bpgq4B5alik3Op1muwB
	 apuXBm10rWuIgr+0OQ0thHmj3IjPxl/9nVsF1sgYfuREST2RurAvD6fTbLr3DHOKqO
	 yJESdzfxB8PqIUAsJQtLFwg1ZRl2S4u6yKyy+u3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Maxime Ripard <mripard@kernel.org>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 5.15 163/776] drivers: base: Free devm resources when unregistering a device
Date: Sat, 30 May 2026 17:57:57 +0200
Message-ID: <20260530160244.704150318@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <davidgow@google.com>

[ Upstream commit 699fb50d99039a50e7494de644f96c889279aca3 ]

In the current code, devres_release_all() only gets called if the device
has a bus and has been probed.

This leads to issues when using bus-less or driver-less devices where
the device might never get freed if a managed resource holds a reference
to the device. This is happening in the DRM framework for example.

We should thus call devres_release_all() in the device_del() function to
make sure that the device-managed actions are properly executed when the
device is unregistered, even if it has neither a bus nor a driver.

This is effectively the same change than commit 2f8d16a996da ("devres:
release resources on device_del()") that got reverted by commit
a525a3ddeaca ("driver core: free devres in device_release") over
memory leaks concerns.

This patch effectively combines the two commits mentioned above to
release the resources both on device_del() and device_release() and get
the best of both worlds.

Fixes: a525a3ddeaca ("driver core: free devres in device_release")
Signed-off-by: David Gow <davidgow@google.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/r/20230720-kunit-devm-inconsistencies-test-v3-3-6aa7e074f373@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3604,9 +3604,21 @@ void device_del(struct device *dev)
 	device_remove_properties(dev);
 	device_links_purge(dev);
 
+	/*
+	 * If a device does not have a driver attached, we need to clean
+	 * up any managed resources. We do this in device_release(), but
+	 * it's never called (and we leak the device) if a managed
+	 * resource holds a reference to the device. So release all
+	 * managed resources here, like we do in driver_detach(). We
+	 * still need to do so again in device_release() in case someone
+	 * adds a new resource after this point, though.
+	 */
+	devres_release_all(dev);
+
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_REMOVED_DEVICE, dev);
+
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	glue_dir = get_glue_dir(dev);
 	kobject_del(&dev->kobj);


