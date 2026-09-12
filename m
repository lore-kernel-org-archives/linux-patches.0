Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4E32E88A4;
	Sat, 12 Sep 2026 07:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198515; cv=none; b=kiCbeMdYqZlIxLt7Dw24mapvKkAPAy1fhDPFjJosiPg1zPi/8dpcu5dzG1TMCjND/cGy3+qF3CXIF+NeTkn8rzvvS7UiFsuBZdnPtbfRI0RIXCyE9jK7Vxvc0IbhsdzEWAzNCOtnJHlpVeZXj90HvRmzLNupY56qp1Uu9YdXhbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198515; c=relaxed/simple;
	bh=X5zOrl1gbQDYPiOuZJlTbiKtTIYixCIoOb+k0iC86Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNYSQ+t6sHwU54GcQWu76i01jAKWry7GfOtibmk11uosN1/lmVQxRa7Tvb+WmH4bWO/WVRiOwO+xUHTGyInY3rziB4yO4dVsvhHUHDYShYVEmqjU15/dUCpYTT6v95ztoPkjgD3+gY03CoemBiHYANcvhudfjXjpOzunM+vldlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N6WP/AXI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6WP/AXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26851F00893;
	Sat, 12 Sep 2026 07:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198514;
	bh=Rb8To4q+yJyW+AGpVbU1k+nakkbXjCRA5im9YxUvnsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6WP/AXIbtN+aVPIfBV3ZRqPAQYZo0aqJ7IEwYXT/TtyuktgfSw+Capt7+OecK0Y0
	 JSt4mOhareSqght7oyld3L4GUa2Hg6T9hdH0E4Yf3Um/ndHHvK9U1NMPFXa/i8iHha
	 H0WHz1NQyZgvH8VI9XKwoz7kPxcGvFLJf9JJ31jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0395/1815] firmware: arm_scmi: Quiesce notifications before teardown
Date: Sat, 12 Sep 2026 08:35:45 +0200
Message-ID: <20260912065658.168979487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 8e49055d0d495c9c07575ad8e111d9eaf0efb13f ]

scmi_notification_exit() clears and releases the notification instance,
but transport callbacks can still deliver incoming notifications until
the TX/RX channels are freed. During remove, an RX interrupt in that
window can enter scmi_notify() while notification state is being torn
down and then dereference freed memory. The same ordering exists on the
probe error path after notification initialization.

The notification late-init worker has a separate lifetime issue: protocol
event registration queues ni->init_work on the system workqueue, so
destroying ni->notify_wq does not drain that work. If the devres group is
released while init_work is still pending or running, the late-init worker
can dereference the freed notification instance.

Quiesce the notification core before TX/RX channels are torn down, then
clean up the channels before releasing the notification core resources.
Use disable_work_sync() so future late-init queueing is rejected and any
already queued or running late-init work has completed before channel
teardown starts.

Fixes: 1e7cbfaa66d3 ("firmware: arm_scmi: Free mailbox channels if probe fails")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-3-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 13 +++++++------
 drivers/firmware/arm_scmi/notify.c | 21 +++++++++++++++++++++
 drivers/firmware/arm_scmi/notify.h |  1 +
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 52aff3aded4c5..ec373595f9557 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -3325,7 +3325,7 @@ static int scmi_probe(struct platform_device *pdev)
 			dev_err(dev, "%s", err_str);
 			return 0;
 		}
-		goto notification_exit;
+		goto raw_mode_cleanup;
 	}
 
 	mutex_lock(&scmi_list_mutex);
@@ -3367,17 +3367,18 @@ static int scmi_probe(struct platform_device *pdev)
 
 	return 0;
 
-notification_exit:
+raw_mode_cleanup:
 	if (IS_ENABLED(CONFIG_ARM_SCMI_RAW_MODE_SUPPORT))
 		scmi_raw_mode_cleanup(info->raw);
-	scmi_notification_exit(&info->handle);
 clear_dev_req_notifier:
 	blocking_notifier_chain_unregister(&scmi_requested_devices_nh,
 					   &info->dev_req_nb);
 clear_bus_notifier:
 	bus_unregister_notifier(&scmi_bus_type, &info->bus_nb);
 clear_txrx_setup:
+	scmi_notification_quiesce(&info->handle);
 	scmi_cleanup_txrx_channels(info);
+	scmi_notification_exit(&info->handle);
 clear_ida:
 	ida_free(&scmi_id, info->id);
 
@@ -3404,6 +3405,9 @@ static void scmi_remove(struct platform_device *pdev)
 	blocking_notifier_chain_unregister(&scmi_requested_devices_nh,
 					   &info->dev_req_nb);
 
+	/* Stop transport callbacks before tearing down notifications. */
+	scmi_notification_quiesce(&info->handle);
+	scmi_cleanup_txrx_channels(info);
 	scmi_notification_exit(&info->handle);
 
 	mutex_lock(&info->protocols_mtx);
@@ -3416,9 +3420,6 @@ static void scmi_remove(struct platform_device *pdev)
 
 	bus_unregister_notifier(&scmi_bus_type, &info->bus_nb);
 
-	/* Safe to free channels since no more users */
-	scmi_cleanup_txrx_channels(info);
-
 	ida_free(&scmi_id, info->id);
 }
 
diff --git a/drivers/firmware/arm_scmi/notify.c b/drivers/firmware/arm_scmi/notify.c
index 0a192cf2deab6..dfe2aa89c5004 100644
--- a/drivers/firmware/arm_scmi/notify.c
+++ b/drivers/firmware/arm_scmi/notify.c
@@ -1706,6 +1706,25 @@ int scmi_notification_init(struct scmi_handle *handle)
 	return -ENOMEM;
 }
 
+/**
+ * scmi_notification_quiesce()  - Stop notification late initialization
+ * @handle: The handle identifying the platform instance to quiesce
+ *
+ * Prevent new late-init work from being queued and wait for any already queued
+ * or running late-init work to complete before transport channels are torn
+ * down.
+ */
+void scmi_notification_quiesce(struct scmi_handle *handle)
+{
+	struct scmi_notify_instance *ni;
+
+	ni = scmi_notification_instance_data_get(handle);
+	if (!ni)
+		return;
+
+	disable_work_sync(&ni->init_work);
+}
+
 /**
  * scmi_notification_exit()  - Shutdown and clean Notification core
  * @handle: The handle identifying the platform instance to shutdown
@@ -1717,6 +1736,8 @@ void scmi_notification_exit(struct scmi_handle *handle)
 	ni = scmi_notification_instance_data_get(handle);
 	if (!ni)
 		return;
+
+	scmi_notification_quiesce(handle);
 	scmi_notification_instance_data_set(handle, NULL);
 
 	/* Destroy while letting pending work complete */
diff --git a/drivers/firmware/arm_scmi/notify.h b/drivers/firmware/arm_scmi/notify.h
index 76758a736cf47..f18f98c5ab3ba 100644
--- a/drivers/firmware/arm_scmi/notify.h
+++ b/drivers/firmware/arm_scmi/notify.h
@@ -82,6 +82,7 @@ struct scmi_protocol_events {
 };
 
 int scmi_notification_init(struct scmi_handle *handle);
+void scmi_notification_quiesce(struct scmi_handle *handle);
 void scmi_notification_exit(struct scmi_handle *handle);
 int scmi_register_protocol_events(const struct scmi_handle *handle, u8 proto_id,
 				  const struct scmi_protocol_handle *ph,
-- 
2.53.0



