Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27EC1DE8AD;
	Mon,  9 Feb 2026 14:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647550; cv=none; b=j4mybQ852QhuEdQlWT8aqAMdnZ2xON1TvjvdOTqPDEalHnt6QyhDCG3qHZ/vyOg7cbE6TNS56IFJD/IaYRvENd2LQXNbWYOFJq2ItgYXu1JwgVZpzH3I051u8v4tHz+gdvchj6eTFyzYw9065ECJLGpGxzOCbru2fcsM8aS8IB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647550; c=relaxed/simple;
	bh=J5iEPcKk3I0zpgdGEeM1/ZR4zS+STCC2iK1wYmvM3nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DH6Mj+0A1tSoMSlB0IrcBOe8qdNnQVdkfz1x7i3S5t1ep0hwAFKOIG9ruZ33hzW67QS+nw1depHJqB2L9kZ1Zv3vovKSH15A7VmgtkruABbpgso8gkRgZAChVxgHRUN8/wOj88306H+XwZRVVXzJoZR9NoPuGx7WUsiTp5esC3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSQpZ17U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSQpZ17U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75D0C116C6;
	Mon,  9 Feb 2026 14:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647550;
	bh=J5iEPcKk3I0zpgdGEeM1/ZR4zS+STCC2iK1wYmvM3nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSQpZ17U/ja+w8KpG5uVfDERa2OKCz9GYCxhR31nlnw5vgHN+MrbCgr+sF5Ry6JWq
	 x9GrdXbMvEo3mMF5NWsf3SlV2yF1einjTA+9XmotDSCRFDIXAyvbH+ji6uedH3zxa1
	 lyMhBrgyq+UM257L7/6l58mXpKCSH3jFm2md9ESw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 134/175] hwmon: (acpi_power_meter) Fix deadlocks related to acpi_power_meter_notify()
Date: Mon,  9 Feb 2026 15:23:27 +0100
Message-ID: <20260209142325.330634333@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 615901b57b7ef8eb655f71358f7e956e42bcd16b ]

The acpi_power_meter driver's .notify() callback function,
acpi_power_meter_notify(), calls hwmon_device_unregister() under a lock
that is also acquired by callbacks in sysfs attributes of the device
being unregistered which is prone to deadlocks between sysfs access and
device removal.

Address this by moving the hwmon device removal in
acpi_power_meter_notify() outside the lock in question, but notice
that doing it alone is not sufficient because two concurrent
METER_NOTIFY_CONFIG notifications may be attempting to remove the
same device at the same time.  To prevent that from happening, add a
new lock serializing the execution of the switch () statement in
acpi_power_meter_notify().  For simplicity, it is a static mutex
which should not be a problem from the performance perspective.

The new lock also allows the hwmon_device_register_with_info()
in acpi_power_meter_notify() to be called outside the inner lock
because it prevents the other notifications handled by that function
from manipulating the "resource" object while the hwmon device based
on it is being registered.  The sending of ACPI netlink messages from
acpi_power_meter_notify() is serialized by the new lock too which
generally helps to ensure that the order of handling firmware
notifications is the same as the order of sending netlink messages
related to them.

In addition, notice that hwmon_device_register_with_info() may fail
in which case resource->hwmon_dev will become an error pointer,
so add checks to avoid attempting to unregister the hwmon device
pointer to by it in that case to acpi_power_meter_notify() and
acpi_power_meter_remove().

Fixes: 16746ce8adfe ("hwmon: (acpi_power_meter) Replace the deprecated hwmon_device_register")
Closes: https://lore.kernel.org/linux-hwmon/CAK8fFZ58fidGUCHi5WFX0uoTPzveUUDzT=k=AAm4yWo3bAuCFg@mail.gmail.com/
Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/acpi_power_meter.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
index 29ccdc2fb7ff8..de408df0c4d78 100644
--- a/drivers/hwmon/acpi_power_meter.c
+++ b/drivers/hwmon/acpi_power_meter.c
@@ -47,6 +47,8 @@
 static int cap_in_hardware;
 static bool force_cap_on;
 
+static DEFINE_MUTEX(acpi_notify_lock);
+
 static int can_cap_in_hardware(void)
 {
 	return force_cap_on || cap_in_hardware;
@@ -823,18 +825,26 @@ static void acpi_power_meter_notify(struct acpi_device *device, u32 event)
 
 	resource = acpi_driver_data(device);
 
+	guard(mutex)(&acpi_notify_lock);
+
 	switch (event) {
 	case METER_NOTIFY_CONFIG:
+		if (!IS_ERR(resource->hwmon_dev))
+			hwmon_device_unregister(resource->hwmon_dev);
+
 		mutex_lock(&resource->lock);
+
 		free_capabilities(resource);
 		remove_domain_devices(resource);
-		hwmon_device_unregister(resource->hwmon_dev);
 		res = read_capabilities(resource);
 		if (res)
 			dev_err_once(&device->dev, "read capabilities failed.\n");
 		res = read_domain_devices(resource);
 		if (res && res != -ENODEV)
 			dev_err_once(&device->dev, "read domain devices failed.\n");
+
+		mutex_unlock(&resource->lock);
+
 		resource->hwmon_dev =
 			hwmon_device_register_with_info(&device->dev,
 							ACPI_POWER_METER_NAME,
@@ -843,7 +853,7 @@ static void acpi_power_meter_notify(struct acpi_device *device, u32 event)
 							power_extra_groups);
 		if (IS_ERR(resource->hwmon_dev))
 			dev_err_once(&device->dev, "register hwmon device failed.\n");
-		mutex_unlock(&resource->lock);
+
 		break;
 	case METER_NOTIFY_TRIP:
 		sysfs_notify(&device->dev.kobj, NULL, POWER_AVERAGE_NAME);
@@ -953,7 +963,8 @@ static void acpi_power_meter_remove(struct acpi_device *device)
 		return;
 
 	resource = acpi_driver_data(device);
-	hwmon_device_unregister(resource->hwmon_dev);
+	if (!IS_ERR(resource->hwmon_dev))
+		hwmon_device_unregister(resource->hwmon_dev);
 
 	remove_domain_devices(resource);
 	free_capabilities(resource);
-- 
2.51.0



