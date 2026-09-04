Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8856B3815E1;
	Fri,  4 Sep 2026 05:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500144; cv=none; b=kKcydLpGHzvGEbOS/xKzpvWgwRO7hIlKQIXJQmzsdVz9mhUUwpH8mnpsPack0glMJf9f4bIUiqs1V45zmALFf2OLkP/q1BVJYZFhGj0XA8YU7UfWPp4zELvXTx1HwTfKIKIqb6h8XSaUbUczb5BqWnJLYF8dc6d5IiCIawhvXyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500144; c=relaxed/simple;
	bh=sy9dkNlP5XvX3q5zGvwPSFRqzmpSdH2NO767p2iXsjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpBSwu0IxFvnLwGFx9MyDXw7nFLav+swHJ2NGat3LGEuHfpWHwfNv8ri+1/spAKs8pW7QVpgO7T1lUpWTSwiN6x0ynpQbJPvc+kWYnvUt6CVadS17d6SJYAq7LoRN+wu+H7/9RBa1G7HFdkywr0BQQHv54UTElrNwPe95xFUOWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEX8ugMR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEX8ugMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37301F00A3D;
	Fri,  4 Sep 2026 05:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500143;
	bh=J2UBlDLAxPhJbntPv3O5f88tENWV+x3JHlfjUoIHA9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEX8ugMRKyd+S1gEnsZDryHMbshPoegUPN1SqGH2sJYH+8FuibC1Si9xmgfiimfgt
	 7skZR5Fb0WfmDyzyHZZsEZBU0C5Cc+83V8vSHV+s7ien+m/sQ+Zdzic6Q21J3dKt+E
	 19Q80+908pQf8qMNWkHA3oFPr0M21txHDbTx+CNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 665/713] i3c: master: Fix info leak and UAF in device unregister path
Date: Fri,  4 Sep 2026 07:00:33 +0200
Message-ID: <20260904045818.742661708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit d2c743efd2d1ee64e94324664808f623dd865872 upstream.

i3c_master_unregister_i3c_devs() clears i3cdev->dev->desc before
calling device_unregister().  During device_unregister(),
device_del() emits a KOBJ_REMOVE uevent and unbinds the driver while
the device descriptor is still expected to be valid.  As a result,
i3c_device_uevent() and a racing modalias_show() can observe a NULL
desc and fall back to an uninitialized stack struct i3c_device_info,
leaking kernel stack contents in the generated modalias.  Driver
.remove() callbacks may also encounter an unexpected NULL desc during
unbind.

Keep desc valid until device_unregister() has completed.  Since
device_unregister() drops the device reference and may free the device,
take an extra reference with get_device() before unregistering.  Clear
desc afterwards and release the extra reference with put_device().
This preserves the release-time invariant that desc must be NULL while
avoiding both the information leak and a potential use-after-free from
writing desc after the device has been released.

Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/linux-i3c/20260702190003.8BF741F000E9@smtp.kernel.org/
Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260723075747.34049-1-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2971,11 +2971,12 @@ static void i3c_master_unregister_i3c_de
 		if (!i3cdev->dev)
 			continue;
 
-		i3cdev->dev->desc = NULL;
-		if (device_is_registered(&i3cdev->dev->dev))
+		if (device_is_registered(&i3cdev->dev->dev)) {
+			get_device(&i3cdev->dev->dev);
 			device_unregister(&i3cdev->dev->dev);
-		else
-			put_device(&i3cdev->dev->dev);
+		}
+		i3cdev->dev->desc = NULL;
+		put_device(&i3cdev->dev->dev);
 		i3cdev->dev = NULL;
 	}
 }


