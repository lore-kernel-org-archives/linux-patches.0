Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F8924633C;
	Tue, 20 May 2025 14:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749708; cv=none; b=cQn8n6SsLsVkRVXWhDQripMF5BdeCYQRAXkPXSu6h26qQoymgitbwXTrBnApwhYxq8P9U91kwKCuqfwMIhnL63wdr28GToQzBYC+ECGOPxYYo0PYAO14z1YpwZIJejT10Pn6Lk00vWgs3HpDEOQWxr8g9wXbJoMfvoBSKnnxUIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749708; c=relaxed/simple;
	bh=6WZRxVvOFbgG7JkF5DeKRd2vrTVT4T+QwW2t2dVeTVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdt1Vu2djU6zfJJRkmWT3p+b6kBFRxB6JU2vIWxebNG7Sqi/CjCvaatrl0psFviVEdmiJzwUbzr18cRiKgzZFo92QCpjL2mA8xH6x3GYl7UuCH88lKzsDQe4fTZQf+rKzOffFcUOsSzAzHZVaB5GDeHfwOvZXwJiLlt0DYkw1zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFnJbKki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFnJbKki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020E9C4CEEA;
	Tue, 20 May 2025 14:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749708;
	bh=6WZRxVvOFbgG7JkF5DeKRd2vrTVT4T+QwW2t2dVeTVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFnJbKkiTtkEV84PpsEeEIy57S27VItHnXOv9A5O1aXfUw5WgXaEp5UnYlNeoBK1b
	 JKWGERtoaF5DVzx3q6TkM1ljCh7n0ZJHtmVPbJP9y+9gDvgAabQc7rYdRosHuN36XF
	 zl3niHeSapeFrzTm3HalEmfKIIBVQJXIoUlzGi90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luke Parkin <luke.parkin@arm.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/117] firmware: arm_scmi: Add support for debug metrics at the interface
Date: Tue, 20 May 2025 15:49:42 +0200
Message-ID: <20250520125804.666709413@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Luke Parkin <luke.parkin@arm.com>

[ Upstream commit 1b18d4295f9d1125bc7a799fc12924cd45fc04b1 ]

Since SCMI involves interaction with the entity(software, firmware and/or
hardware) providing services or features, it is quite useful to track
certain metrics(for pure debugging purposes) like how many messages were
sent or received, were there any failures, what kind of failures, ..etc.

Add a new optional config option for the above purpose and the initial
support for counting such key debug metrics.

Signed-off-by: Luke Parkin <luke.parkin@arm.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Message-Id: <20240805131013.587016-3-sudeep.holla@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: c23c03bf1faa ("firmware: arm_scmi: Fix timeout checks on polling path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/Kconfig  | 14 ++++++++++++++
 drivers/firmware/arm_scmi/common.h | 10 ++++++++++
 drivers/firmware/arm_scmi/driver.c |  2 ++
 3 files changed, 26 insertions(+)

diff --git a/drivers/firmware/arm_scmi/Kconfig b/drivers/firmware/arm_scmi/Kconfig
index ea0f5083ac47f..9a41c1c91f71a 100644
--- a/drivers/firmware/arm_scmi/Kconfig
+++ b/drivers/firmware/arm_scmi/Kconfig
@@ -55,6 +55,20 @@ config ARM_SCMI_RAW_MODE_SUPPORT_COEX
 	  operate normally, thing which could make an SCMI test suite using the
 	  SCMI Raw mode support unreliable. If unsure, say N.
 
+config ARM_SCMI_DEBUG_COUNTERS
+	bool "Enable SCMI communication debug metrics tracking"
+	select ARM_SCMI_NEED_DEBUGFS
+	depends on DEBUG_FS
+	default n
+	help
+	  Enables tracking of some key communication metrics for debug
+	  purposes. It may track metrics like how many messages were sent
+	  or received, were there any failures, what kind of failures, ..etc.
+
+	  Enable this option to create a new debugfs directory which contains
+	  such useful debug counters. This can be helpful for debugging and
+	  SCMI monitoring.
+
 config ARM_SCMI_HAVE_TRANSPORT
 	bool
 	help
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index e26a2856a0e3d..e3a9217f29d39 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -303,6 +303,16 @@ extern const struct scmi_desc scmi_optee_desc;
 
 void scmi_rx_callback(struct scmi_chan_info *cinfo, u32 msg_hdr, void *priv);
 
+enum debug_counters {
+	SCMI_DEBUG_COUNTERS_LAST
+};
+
+static inline void scmi_inc_count(atomic_t *arr, int stat)
+{
+	if (IS_ENABLED(CONFIG_ARM_SCMI_DEBUG_COUNTERS))
+		atomic_inc(&arr[stat]);
+}
+
 enum scmi_bad_msg {
 	MSG_UNEXPECTED = -1,
 	MSG_INVALID = -2,
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index f66a16d3671f1..3bc41a9920294 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -108,12 +108,14 @@ struct scmi_protocol_instance {
  * @name: Name of this SCMI instance
  * @type: Type of this SCMI instance
  * @is_atomic: Flag to state if the transport of this instance is atomic
+ * @counters: An array of atomic_c's used for tracking statistics (if enabled)
  */
 struct scmi_debug_info {
 	struct dentry *top_dentry;
 	const char *name;
 	const char *type;
 	bool is_atomic;
+	atomic_t counters[SCMI_DEBUG_COUNTERS_LAST];
 };
 
 /**
-- 
2.39.5



