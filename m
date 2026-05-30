Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492FE17555;
	Sat, 30 May 2026 18:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165537; cv=none; b=IO5SDEBBZMZNr45J671Uq4OoTiB0MN/lI3w/cWoG+kSH99lObZghgc5mv8HN3nxiZJxNkRbsKQn+YqzMl0fO5p5O1gDXVolJneM3TBu3iF498wCBm0uopmyUx/5o+pvMeewR5pZzXB0qtClhl3xes0ai4vpEzGAFe8sZ4J6AyZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165537; c=relaxed/simple;
	bh=Ai8fGm55tmAfYcKSzyc1GkB6hJYlywJcpK2CW59HM4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWcGx7PxX576uVlWIkUX5pdJCERc9HcM0tWXfBpoXkK+PKCUrYUze58EjCaoLfHpFFSnTZpAlWR2m7DEqiub7GPdAyCbUAp0KMpQ9JhzGq20ey3Nh1T4IPO9WpnsVgyZZj+UXkkZkzCeZhu8LpTQnZpqnTd6KGW2sS2zMyFRZD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFnYptaU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFnYptaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D47C1F00893;
	Sat, 30 May 2026 18:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165536;
	bh=zr4YgApaixHpZF8yNSkTEsJHMqIf0fIvFIYl0fKdBtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFnYptaUMUCbFWXqqOGZlXhUauM6B9i/a7A55wRJd4DlKTP5DOyuHrXzAb5XtYz4P
	 Uf6m7ynrli9PDdksB/dpNtK7Edyq2MwJRxqhpLdx/zpAxmUr2r+vvlfgD138WIA/In
	 THVzqKQCX6z8xGqx2IkQ9o+FguWyWJwdLRoWgRfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>
Subject: [PATCH 5.10 108/589] drivers: base: Free devm resources when unregistering a device
Date: Sat, 30 May 2026 17:59:49 +0200
Message-ID: <20260530160227.588161102@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3195,6 +3195,17 @@ void device_del(struct device *dev)
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


