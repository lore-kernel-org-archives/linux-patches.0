Received: from n169-113.mail.139.com (n169-113.mail.139.com [120.232.169.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D142386568
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 08:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774340107; cv=none; b=ESAREljV/aPuaMsDJE5epSU6vJn8xp8+WIAND04aV84n+FrC4/LyIgss0e1hb/ALKx7Y212IPlUeCfn9AHQZY56plfgACIsgG/D5XFfYCGoflpZaO9l0whOKfHZqR8RuC84NXxZ23RetMbBAW273N3UVrwxNcL9IVP2i98OndSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774340107; c=relaxed/simple;
	bh=hUB7/MzUgAL2vani/wBQcq2t+8aTEbfZENnogD0sWnc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u2yGHnS1Lf5wAiuJ4kp+e9pW82ukrireXG/ZLaOfbm02LeY72uUNG4L2zNTOD+6h1rzFSgBwmfo7ULYsS/tD9zAPPtYDWBbVg8If6PokzZSUB1icer+BAPOcY5/YdlMqF2dWvZFJAeqFQew3y9W81RPAyo4C8W1Pd4D2WxKPPBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=pMvgKfk+; arc=none smtp.client-ip=120.232.169.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="pMvgKfk+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=pMvgKfk+ArApyejaDiHwNi8qR7OFArHVpdoMg3BB+MiKaaIf7dbt1yj+QW1aV3II3Yk2HAI+vfIqI
	 DT9bEk5KrNSgJ4HaEqcrhIJMutO25oQktioTobnE8EyJ6PXG5AqcPMlmQXfPo8cIiFRfe8NygkpkDH
	 kfo83gSxQskLYZE0=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-28-12033 (RichMail) with SMTP id 2f0169c247ee7e2-02814;
	Tue, 24 Mar 2026 16:14:40 +0800 (CST)
X-RM-TRANSID:2f0169c247ee7e2-02814
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	davidgow@google.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	rafael@kernel.org,
	tom.leiming@gmail.com,
	mripard@kernel.org
Subject: [PATCH 5.15.y] drivers: base: Free devm resources when unregistering a device
Date: Tue, 24 Mar 2026 16:14:38 +0800
Message-Id: <20260324081438.1182050-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 drivers/base/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4fc62624a95e..683a7c461451 100644
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
-- 
2.34.1


