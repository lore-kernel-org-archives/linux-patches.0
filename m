Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A3338758E;
	Thu, 23 Apr 2026 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776945346; cv=none; b=cJ3gg+ZoHOpCinixjW3gYSE3eWj89xPcohbUJlg+Bu6d8yzhqu6R45gE3CmlNxvfusQ7RjjELTgAFIcn3Pgm/Q0S1Gt8T1Px47zA0BAF9xHOsPevJIHBN15SO+3MvhcSk5EUnNIbTdBjkEeB8LGp+rHESTw5RrSIx+mf9i5VAUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776945346; c=relaxed/simple;
	bh=cdsOCklTT/PxvPeGALZZPuklO2JZGvHdJXiPUOI0vqs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=YZppfbM68YR9bWhMqzG7eQuGKvRHTjgYeAmkEEEbEh03JDwEwrXVpDJ6nmdvYSAN1Yj8lqKZcbSTxym7Ophm55Q04S5KXokgL3alD84z9b0UAKc257l3F0UJ8OcPzeg3avDqxa7DpalTUQ/XJbXfut/uccy1Y8q/zCJpA3QSM+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jc0DwMDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jc0DwMDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E7AC2BCB4;
	Thu, 23 Apr 2026 11:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776945346;
	bh=cdsOCklTT/PxvPeGALZZPuklO2JZGvHdJXiPUOI0vqs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=jc0DwMDUs10jSqXZJZXzEKsycVRD6N4W3OUQKWzhX8yxRRC7NgyL07S5/Eenk+oea
	 W55BmkGq4tZP6Tw3TbUPyCYp1SUaZDzmaWh08itU20bjAJo0N1TnpqXjqHeAYAdmeW
	 gwuOgzE42AQhLpHK1ekVTMvGeaagY/ApKSxxoTVw=
Subject: Patch "drivers: base: Free devm resources when unregistering a device" has been added to the 5.15-stable tree
To: 1468888505@139.com,davidgow@google.com,gregkh@linuxfoundation.org,mripard@kernel.org,patches@lists.linux.dev,rafael@kernel.org,tom.leiming@gmail.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 23 Apr 2026 13:55:28 +0200
In-Reply-To: <20260324081438.1182050-1-1468888505@139.com>
Message-ID: <2026042328-distance-bok-09db@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    drivers: base: Free devm resources when unregistering a device

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     drivers-base-free-devm-resources-when-unregistering-a-device.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 1468888505@139.com Tue Mar 24 09:14:43 2026
From: Li hongliang <1468888505@139.com>
Date: Tue, 24 Mar 2026 16:14:38 +0800
Subject: drivers: base: Free devm resources when unregistering a device
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, davidgow@google.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, rafael@kernel.org, tom.leiming@gmail.com, mripard@kernel.org
Message-ID: <20260324081438.1182050-1-1468888505@139.com>

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


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-5.15/drivers-base-free-devm-resources-when-unregistering-a-device.patch
queue-5.15/nf_tables-nft_dynset-fix-possible-stateful-expressio.patch
queue-5.15/wifi-mac80211-always-free-skb-on-ieee80211_tx_prepar.patch
queue-5.15/ipv6-add-null-checks-for-idev-in-srv6-paths.patch
