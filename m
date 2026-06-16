Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004A838F930;
	Tue, 16 Jun 2026 17:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629884; cv=none; b=GkeLd7TqCs4V3HHahEsO+N3eIIv3I1ZpkaFtpsop414MxnV8UgEMpE0k5Fc/ZIolIRK9Ir6YY/Ui1jfIpdQbyBcKJOyHlDCkiGfK0Sjd3U+963HlYz/bWVrEKp3dR53j4z2X4u0+CdumD8eQ7mjoCqXbdfpieXSsMb+YPO79poI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629884; c=relaxed/simple;
	bh=yhpqLodPjvkYpFA9J/nSUYs1tvwqsAaFOh3APFaHUiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=el3Lg5lKQ6UcmqD2tad5rzizFTNxZ5/xdWB7lSBy1NPjoBVXW62yaMySC8Bd2oXw9bLQsTHTfd9jN/bcY+aJMwVtajtsPLHyc5fnZ4l+h8BgeYRp1O76pm0tBwPMYtChHdH3lD1F8lXKmqBuvNna3TSqtFZIAnp2AKB68KX1MQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ql+DPHq9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ql+DPHq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74E11F000E9;
	Tue, 16 Jun 2026 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629883;
	bh=MU5BVzlNZmMNyJnL+XlrmBr+Y0dzuGlS2IYh1COHGpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ql+DPHq9RzhESK+Ff5Z/psv84RFxJehHz4eyhPnpo5pYS0kA5PHor4hZYC2kPQRUu
	 lyMzIvNgVlRf+Z1NcJNbNRg6tv4g4l2r1L9RBMaxoqWw4G5Nam120Y7SrurTcoacTs
	 q4UEgkx0Nt7S9WEza+RhhpxatYkD7Cs+/c8kZJeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.6 369/452] driver core: reject devices with unregistered buses
Date: Tue, 16 Jun 2026 20:29:56 +0530
Message-ID: <20260616145136.425455872@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -503,10 +503,10 @@ static const struct attribute_group driv
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
@@ -515,6 +515,13 @@ int bus_add_device(struct device *dev)
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


