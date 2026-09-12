Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0C137C118;
	Sat, 12 Sep 2026 09:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205324; cv=none; b=kqz7EEux8ZlfbtlckLNRtSudnDcolV7WvQj1I2hTfA3u7PUTStUJsJqC/InASP9h2kzkhTZ92Ozq1+0XEp34txB8Et1A+oPs4KbYp4gmDCukJHjjPqb/MsV6Kfr6zKCBIpcJfoLvzJbjL95v8IRHZ0zZsp6OTmKYjDn1J9tLUhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205324; c=relaxed/simple;
	bh=h1vEEkU1ecOrA6TeU18zHb6nRXukt5PVW6omXHMNtiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ih+RCqmI7R+B+I84pb6cNLW/O7LqhBu11HP0uixNHUxfyrq7B1H2qktcBt++xBrm44FMKcIVrTd3OZPFnwKynVyHdlzd8woEC1I6GNh3K6yjGPPihOtiD4vRJUpTRq4rMCuBsbjsFMswVy1e6hd2uWU2P4hSIi5fTmTpw7ncA6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRGj27na; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRGj27na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD621F000FF;
	Sat, 12 Sep 2026 09:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205322;
	bh=2WhYVqBH7ry40xLanmaNQcfqTdae/FcTG+Jl4SU+NlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HRGj27nalXK/OU5lNaFFMDkWmXRrTMdNRxx9pYD+JONPLCpUyt/VxIvq5seNFqK2P
	 jrckUZq6bDXBu32AmplPmc3A64KDdaUqo0RCYyPaQisra89ibokYxSJKPZizZkZjrq
	 NZBZW601CX8gTlsgu/adfBTGSC6HA0qxGjnwBI1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Riana Tauro <riana.tauro@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1795/1815] drm/xe/xe_ras: Add support to get error counter value
Date: Sat, 12 Sep 2026 08:59:05 +0200
Message-ID: <20260912065731.176036791@linuxfoundation.org>
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

From: Riana Tauro <riana.tauro@intel.com>

[ Upstream commit fe48a86980798ffc78c8713ec964877c8594610d ]

Add request/response structures and helper functions to query system
controller to get error counter value.

Reviewed-by: Raag Jadav <raag.jadav@intel.com>
Link: https://patch.msgid.link/20260618060633.2790109-10-riana.tauro@intel.com
Signed-off-by: Riana Tauro <riana.tauro@intel.com>
Stable-dep-of: a62212b35a21 ("drm/xe/sysctrl: Read mailbox phase bit from hardware")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_ras.c                   | 91 +++++++++++++++++++
 drivers/gpu/drm/xe/xe_ras.h                   |  3 +
 drivers/gpu/drm/xe/xe_ras_types.h             | 26 ++++++
 drivers/gpu/drm/xe/xe_sysctrl_mailbox.c       | 28 ++++++
 drivers/gpu/drm/xe/xe_sysctrl_mailbox.h       |  3 +
 drivers/gpu/drm/xe/xe_sysctrl_mailbox_types.h |  2 +
 6 files changed, 153 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_ras.c b/drivers/gpu/drm/xe/xe_ras.c
index 4cb16b419b0c6..96702234d7ece 100644
--- a/drivers/gpu/drm/xe/xe_ras.c
+++ b/drivers/gpu/drm/xe/xe_ras.c
@@ -4,11 +4,14 @@
  */
 
 #include "xe_device.h"
+#include "xe_pm.h"
 #include "xe_printk.h"
 #include "xe_ras.h"
 #include "xe_ras_types.h"
 #include "xe_sysctrl.h"
 #include "xe_sysctrl_event_types.h"
+#include "xe_sysctrl_mailbox.h"
+#include "xe_sysctrl_mailbox_types.h"
 
 /* Severity of detected errors  */
 enum xe_ras_severity {
@@ -50,6 +53,36 @@ static const char *const xe_ras_components[] = {
 };
 static_assert(ARRAY_SIZE(xe_ras_components) == XE_RAS_COMP_MAX);
 
+static u8 drm_to_xe_ras_severity(u8 severity)
+{
+	switch (severity) {
+	case DRM_XE_RAS_ERR_SEV_CORRECTABLE:
+		return XE_RAS_SEV_CORRECTABLE;
+	case DRM_XE_RAS_ERR_SEV_UNCORRECTABLE:
+		return XE_RAS_SEV_UNCORRECTABLE;
+	default:
+		return XE_RAS_SEV_NOT_SUPPORTED;
+	}
+}
+
+static u8 drm_to_xe_ras_component(u8 component)
+{
+	switch (component) {
+	case DRM_XE_RAS_ERR_COMP_CORE_COMPUTE:
+		return XE_RAS_COMP_CORE_COMPUTE;
+	case DRM_XE_RAS_ERR_COMP_SOC_INTERNAL:
+		return XE_RAS_COMP_SOC_INTERNAL;
+	case DRM_XE_RAS_ERR_COMP_DEVICE_MEMORY:
+		return XE_RAS_COMP_DEVICE_MEMORY;
+	case DRM_XE_RAS_ERR_COMP_PCIE:
+		return XE_RAS_COMP_PCIE;
+	case DRM_XE_RAS_ERR_COMP_FABRIC:
+		return XE_RAS_COMP_FABRIC;
+	default:
+		return XE_RAS_COMP_NOT_SUPPORTED;
+	}
+}
+
 static inline const char *sev_to_str(u8 severity)
 {
 	if (severity >= XE_RAS_SEV_MAX)
@@ -91,3 +124,61 @@ void xe_ras_counter_threshold_crossed(struct xe_device *xe,
 			comp_to_str(component), sev_to_str(severity));
 	}
 }
+
+static int get_counter(struct xe_device *xe, struct xe_ras_error_class *counter, u32 *value)
+{
+	struct xe_ras_get_counter_response response = {0};
+	struct xe_ras_get_counter_request request = {0};
+	struct xe_sysctrl_mailbox_command command = {0};
+	struct xe_ras_error_common *common;
+	size_t rlen;
+	int ret;
+
+	request.counter = *counter;
+
+	xe_sysctrl_create_command(&command, XE_SYSCTRL_GROUP_GFSP, XE_SYSCTRL_CMD_GET_COUNTER,
+				  &request, sizeof(request), &response, sizeof(response));
+
+	ret = xe_sysctrl_send_command(&xe->sc, &command, &rlen);
+	if (ret) {
+		xe_err(xe, "sysctrl: failed to get counter %d\n", ret);
+		return ret;
+	}
+
+	if (rlen != sizeof(response)) {
+		xe_err(xe, "sysctrl: unexpected get counter response length %zu (expected %zu)\n",
+		       rlen, sizeof(response));
+		return -EIO;
+	}
+
+	common = &response.counter.common;
+	*value = response.value;
+
+	xe_dbg(xe, "[RAS]: get counter %u for %s %s\n", *value, comp_to_str(common->component),
+	       sev_to_str(common->severity));
+
+	return 0;
+}
+
+/**
+ * xe_ras_get_counter() - Get error counter value
+ * @xe: Xe device instance
+ * @severity: Error severity to be queried (&enum drm_xe_ras_error_severity)
+ * @component: Error component to be queried (&enum drm_xe_ras_error_component)
+ * @value: Counter value
+ *
+ * This function retrieves the value of a specific error counter based on
+ * the error severity and component.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int xe_ras_get_counter(struct xe_device *xe, u8 severity, u8 component, u32 *value)
+{
+	struct xe_ras_error_class counter = {0};
+
+	counter.common.severity = drm_to_xe_ras_severity(severity);
+	counter.common.component = drm_to_xe_ras_component(component);
+
+	guard(xe_pm_runtime)(xe);
+	return get_counter(xe, &counter, value);
+}
diff --git a/drivers/gpu/drm/xe/xe_ras.h b/drivers/gpu/drm/xe/xe_ras.h
index ea90593b62dc1..e148debd5d418 100644
--- a/drivers/gpu/drm/xe/xe_ras.h
+++ b/drivers/gpu/drm/xe/xe_ras.h
@@ -6,10 +6,13 @@
 #ifndef _XE_RAS_H_
 #define _XE_RAS_H_
 
+#include <linux/types.h>
+
 struct xe_device;
 struct xe_sysctrl_event_response;
 
 void xe_ras_counter_threshold_crossed(struct xe_device *xe,
 				      struct xe_sysctrl_event_response *response);
+int xe_ras_get_counter(struct xe_device *xe, u8 severity, u8 component, u32 *value);
 
 #endif
diff --git a/drivers/gpu/drm/xe/xe_ras_types.h b/drivers/gpu/drm/xe/xe_ras_types.h
index 4e63c67f806a2..fdfebaeb5ed26 100644
--- a/drivers/gpu/drm/xe/xe_ras_types.h
+++ b/drivers/gpu/drm/xe/xe_ras_types.h
@@ -70,4 +70,30 @@ struct xe_ras_threshold_crossed {
 	struct xe_ras_error_class counters[XE_RAS_NUM_COUNTERS];
 } __packed;
 
+/**
+ * struct xe_ras_get_counter_request - Request structure for get counter
+ */
+struct xe_ras_get_counter_request {
+	/** @counter: Error counter to be queried */
+	struct xe_ras_error_class counter;
+	/** @reserved: Reserved for future use */
+	u32 reserved;
+} __packed;
+
+/**
+ * struct xe_ras_get_counter_response - Response structure for get counter
+ */
+struct xe_ras_get_counter_response {
+	/** @counter: Error counter that was queried */
+	struct xe_ras_error_class counter;
+	/** @value: Current counter value */
+	u32 value;
+	/** @timestamp: Timestamp when counter was last updated */
+	u64 timestamp;
+	/** @threshold: Threshold value for the counter */
+	u32 threshold;
+	/** @reserved: Reserved  */
+	u32 reserved[57];
+} __packed;
+
 #endif
diff --git a/drivers/gpu/drm/xe/xe_sysctrl_mailbox.c b/drivers/gpu/drm/xe/xe_sysctrl_mailbox.c
index 3caa9f15875f5..e13eebaac1d00 100644
--- a/drivers/gpu/drm/xe/xe_sysctrl_mailbox.c
+++ b/drivers/gpu/drm/xe/xe_sysctrl_mailbox.c
@@ -293,6 +293,34 @@ static int sysctrl_send_command(struct xe_sysctrl *sc,
 	return 0;
 }
 
+/**
+ * xe_sysctrl_create_command() - Create system controller command
+ * @command: Sysctrl command structure
+ * @group_id: Command group ID
+ * @cmd_id: Command ID
+ * @request: Pointer to request buffer (can be NULL)
+ * @request_len: Size of request buffer
+ * @response: Pointer to response buffer
+ * @response_len: Size of response buffer
+ *
+ * Helper function to create sysctrl command to be sent via %xe_sysctrl_send_command()
+ */
+void xe_sysctrl_create_command(struct xe_sysctrl_mailbox_command *command, u8 group_id, u8 cmd_id,
+			       void *request, size_t request_len, void *response,
+			       size_t response_len)
+{
+	struct xe_sysctrl_app_msg_hdr header = {0};
+
+	header.data = FIELD_PREP(APP_HDR_GROUP_ID_MASK, group_id) |
+		      FIELD_PREP(APP_HDR_COMMAND_MASK, cmd_id);
+
+	command->header = header;
+	command->data_in = request;
+	command->data_in_len = request_len;
+	command->data_out = response;
+	command->data_out_len = response_len;
+}
+
 /**
  * xe_sysctrl_mailbox_init - Initialize System Controller mailbox interface
  * @sc: System controller structure
diff --git a/drivers/gpu/drm/xe/xe_sysctrl_mailbox.h b/drivers/gpu/drm/xe/xe_sysctrl_mailbox.h
index f67e9234de482..fb434cc165b2a 100644
--- a/drivers/gpu/drm/xe/xe_sysctrl_mailbox.h
+++ b/drivers/gpu/drm/xe/xe_sysctrl_mailbox.h
@@ -23,6 +23,9 @@ struct xe_sysctrl_mailbox_command;
 #define XE_SYSCTRL_APP_HDR_VERSION(hdr) \
 	FIELD_GET(APP_HDR_VERSION_MASK, (hdr)->data)
 
+void xe_sysctrl_create_command(struct xe_sysctrl_mailbox_command *command, u8 group_id, u8 cmd_id,
+			       void *request, size_t request_len, void *response,
+			       size_t response_len);
 void xe_sysctrl_mailbox_init(struct xe_sysctrl *sc);
 int xe_sysctrl_send_command(struct xe_sysctrl *sc,
 			    struct xe_sysctrl_mailbox_command *cmd,
diff --git a/drivers/gpu/drm/xe/xe_sysctrl_mailbox_types.h b/drivers/gpu/drm/xe/xe_sysctrl_mailbox_types.h
index 84d7c647e7432..b315847cbf64f 100644
--- a/drivers/gpu/drm/xe/xe_sysctrl_mailbox_types.h
+++ b/drivers/gpu/drm/xe/xe_sysctrl_mailbox_types.h
@@ -22,9 +22,11 @@ enum xe_sysctrl_group {
 /**
  * enum xe_sysctrl_gfsp_cmd - Commands supported by GFSP group
  *
+ * @XE_SYSCTRL_CMD_GET_COUNTER: Get error counter value
  * @XE_SYSCTRL_CMD_GET_PENDING_EVENT: Retrieve pending event
  */
 enum xe_sysctrl_gfsp_cmd {
+	XE_SYSCTRL_CMD_GET_COUNTER		= 0x03,
 	XE_SYSCTRL_CMD_GET_PENDING_EVENT	= 0x07,
 };
 
-- 
2.53.0



