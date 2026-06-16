Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281883A16AC;
	Tue, 16 Jun 2026 16:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626345; cv=none; b=RiBftJIyYVNHx6k2vg7b4/hSiHiagtI/VxMcLPh4KoX4HCz2FU4aLLEPW8SNEFtwT1pQI8tEBkPDRbwXzvN+NB6OgLZrwoWN4l5jK8US7qBHjWLHORMvffNBC/0UIk1C385SknVKys2COwZreA8EZQqXJY8gZI9knfD57KaR7dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626345; c=relaxed/simple;
	bh=y3lYG6QuPjac/2r0bIgM6AK8PhVNJRl5wr6Wa326yiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0fSyJHqTalUr5vcXDQd/TJ/0es+y8pelpcnh4ri41bGnTxsHZC4YqHpyCf0cGzOCy4j65TAx7oxUkRJslGLyqz9NBWBS151ibwKcyQmX9j51WSlyLmG/z1pof99F4UjCMvADSYQ1L9wGryvQ6Ru6D6+rpMGsocgrrhh6cZBY2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWo+hODc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWo+hODc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E831F000E9;
	Tue, 16 Jun 2026 16:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626343;
	bh=JeQOFF3PaVD1aAwfp3GLZLmdibS93laU60a/K3ABp0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWo+hODc9/O6AZBDLL5kJxoDUG6E//ZakJ0yLPoLHMER29eEfo0DrKJedVzfuu6sF
	 KtOYicleXEphFl7ikEqojjeBf2vPVfj4lvp/hjTYTZmp0kYHVFxRr1yL+PPoaHhVwh
	 GGSl2TQIPnVvTDEthZF+H6jozmD1TUck2LKx5h8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 305/325] driver core: reject devices with unregistered buses
Date: Tue, 16 Jun 2026 20:31:41 +0530
Message-ID: <20260616145114.174073716@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 36f35b8df6972167102a1c3d4361e0afb6a84534 upstream.

Trying to register a device on a bus which has not yet been registered
used to trigger a NULL-pointer dereference, but since the const bus
structure rework registration instead succeeds without the device being
added to the bus.

This specifically means that the device will never bind to a driver and
that the bus sysfs attributes are not created (i.e. as if the device had
no bus).

Reject devices with unregistered buses to catch any callers that get
the ordering wrong and to handle bus registration failures more
gracefully.

Fixes: 5221b82d46f2 ("driver core: bus: bus_add/probe/remove_device() cleanups")
Cc: stable@vger.kernel.org	# 6.3
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260430091718.230228-1-johan@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/bus.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -506,10 +506,10 @@ static const struct attribute_group driv
  */
 int bus_add_device(struct device *dev)
 {
-	struct subsys_private *sp = bus_to_subsys(dev->bus);
+	struct subsys_private *sp;
 	int error;
 
-	if (!sp) {
+	if (!dev->bus) {
 		/*
 		 * This is a normal operation for many devices that do not
 		 * have a bus assigned to them, just say that all went
@@ -518,6 +518,13 @@ int bus_add_device(struct device *dev)
 		return 0;
 	}
 
+	sp = bus_to_subsys(dev->bus);
+	if (!sp) {
+		pr_err("%s: cannot add device '%s' to unregistered bus '%s'\n",
+		       __func__, dev_name(dev), dev->bus->name);
+		return -EINVAL;
+	}
+
 	/*
 	 * Reference in sp is now incremented and will be dropped when
 	 * the device is removed from the bus


