Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8BA31A55E;
	Sat, 12 Sep 2026 14:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224017; cv=none; b=DgKmH/jxAm3G91DXoXtsh9Ssg82BlTruzYsCQCUgnySlSOq11oZFuGPL8gZfNqaY0OxkQuWBsILDmAHxxkPm9Jefd46Y3Oii0QhxHV5AB72RRjKchqIgyxU/L8Gpld/Wh8S8tJuEcagrbq9sPJetxJeqf2wEbrK86MMsZfSJKXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224017; c=relaxed/simple;
	bh=7IuYY5uDpMysSHaOPkG90xvHFe90CX/LMSpefnddxzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXiWkYW3oQw2Jd+WfuVfevjh6E+C6/FundkVM73gMdyn1IzxY9UPNIEdhaTfE+aEIMgfO4xrrpuu9DwslaoQHIhg4RdG9pYK/ovozyz0+ZG5vhpEmsVLv7kIT5nnR1Y0uYEBpKzRxTejKEn8VMmTcuX78ca+OEcXCdtCp3aRBbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5F7OETL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5F7OETL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9341F000FF;
	Sat, 12 Sep 2026 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224015;
	bh=LevUyLnU0uYgwmXpzDkYZSNHgd1f1qSrBkZD/tV4imk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5F7OETLi7RMfyuegAW7sxPb5mVFgcfQDRMmFjWpNVDdQYKhnpmj2vPqIoP2D2Jkh
	 QLxzebAn58BZIkecdh6S7Grlh3xGySTQg5X1oYQHFmwZNMJl/oa1RpZ5LVN6lb4pCM
	 Ig1ASQjn9ag4DA9q73TQRr49Lx+7/uj6foT55idE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0863/1424] firmware: arm_scmi: Add multiple protocols registration support
Date: Sat, 12 Sep 2026 08:54:55 +0200
Message-ID: <20260912065626.644414099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 2858f6e5f06440d6b9e9c3f57bc68915344830a9 ]

Add the capability for a SCMI driver to register to the core SCMI stack
with multiple SCMI protocols. In such a case the SCMI driver probe
function will end up being called once for each registered protocol
which have been also found as implemented on the platform.

This is especially useful in testing scenarios.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20231221151129.325749-1-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 9f7cd6a62aa7 ("firmware: arm_scmi: Unrequest devices if driver registration fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 9ae7f5cbce7fe..3a3c3a3d6581e 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -134,6 +134,17 @@ static int scmi_protocol_device_request(const struct scmi_device_id *id_table)
 	return ret;
 }
 
+static int scmi_protocol_table_register(const struct scmi_device_id *id_table)
+{
+	int ret = 0;
+	const struct scmi_device_id *entry;
+
+	for (entry = id_table; entry->name && ret == 0; entry++)
+		ret = scmi_protocol_device_request(entry);
+
+	return ret;
+}
+
 /**
  * scmi_protocol_device_unrequest  - Helper to unrequest a device
  *
@@ -179,6 +190,15 @@ static void scmi_protocol_device_unrequest(const struct scmi_device_id *id_table
 	}
 }
 
+static void
+scmi_protocol_table_unregister(const struct scmi_device_id *id_table)
+{
+	const struct scmi_device_id *entry;
+
+	for (entry = id_table; entry->name; entry++)
+		scmi_protocol_device_unrequest(entry);
+}
+
 static const struct scmi_device_id *
 scmi_dev_match_id(struct scmi_device *scmi_dev, struct scmi_driver *scmi_drv)
 {
@@ -275,7 +295,7 @@ int scmi_driver_register(struct scmi_driver *driver, struct module *owner,
 	if (!driver->probe)
 		return -EINVAL;
 
-	retval = scmi_protocol_device_request(driver->id_table);
+	retval = scmi_protocol_table_register(driver->id_table);
 	if (retval)
 		return retval;
 
@@ -295,7 +315,7 @@ EXPORT_SYMBOL_GPL(scmi_driver_register);
 void scmi_driver_unregister(struct scmi_driver *driver)
 {
 	driver_unregister(&driver->driver);
-	scmi_protocol_device_unrequest(driver->id_table);
+	scmi_protocol_table_unregister(driver->id_table);
 }
 EXPORT_SYMBOL_GPL(scmi_driver_unregister);
 
-- 
2.53.0



