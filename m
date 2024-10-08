Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98681DF256;
	Tue,  8 Oct 2024 12:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391261; cv=none; b=DwuwovBP1f62usGdugzXv/7YAMAxBNgjL0lddiSVNzQNHop98vvzxXk7XzsSlvZc44GeG41JAafoaBMOQMYHOCoQ+kUw6V//5dIdtEMQT6o606whEgWH6HqHJFXfu7xQWanAcMzowTBjsdErF3WBtKrNkf7Q4WeWP+L9O3dO7fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391261; c=relaxed/simple;
	bh=PYtSoteJ/FKk/GwLl5MN3X4Lzb7gK92ySkLQLdbNr/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJRGhDyYvmQqZSyRpwg+9JxTexIeZRJbTwOSZWhKGYOYWO0SORlQjrDq/8seE1gFkxPJ09G8cJ9OvQmJe5VODApFaHWq4Yd5HrQcWJRg8GvixUS/0MajWhQwmlRycqGNJQbn5L5U+IYG5yZR3MpNo6688vwRA3Mllp9ahbIDkG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14cQJwR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14cQJwR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741F8C4CECD;
	Tue,  8 Oct 2024 12:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391260;
	bh=PYtSoteJ/FKk/GwLl5MN3X4Lzb7gK92ySkLQLdbNr/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14cQJwR+4QN8g6PFNJTtYUoMf6ceDeC/jsCMeSPmKVmsfNKm8fdiiby95Cx2v4Ehm
	 iWuAaWe03X4LVTImpmLIUFk8Mnf7/5GzZntTTSeJYCGpBMazJ1Gmw1oojmD4TJcRcg
	 AbINBTwLOgm5sxTxQl+3OzHsFdXKDMLqVRNEaHCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Foreman <derek.foreman@collabora.com>,
	Maxime Ripard <mripard@kernel.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 058/558] drm/connector: hdmi: Fix writing Dynamic Range Mastering infoframes
Date: Tue,  8 Oct 2024 14:01:28 +0200
Message-ID: <20241008115704.502491412@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek Foreman <derek.foreman@collabora.com>

[ Upstream commit f0fa69b5011a45394554fb8061d74fee4d7cd72c ]

The largest infoframe we create is the DRM (Dynamic Range Mastering)
infoframe which is 26 bytes + a 4 byte header, for a total of 30
bytes.

With HDMI_MAX_INFOFRAME_SIZE set to 29 bytes, as it is now, we
allocate too little space to pack a DRM infoframe in
write_device_infoframe(), leading to an ENOSPC return from
hdmi_infoframe_pack(), and never calling the connector's
write_infoframe() vfunc.

Instead of having HDMI_MAX_INFOFRAME_SIZE defined in two places,
replace HDMI_MAX_INFOFRAME_SIZE with HDMI_INFOFRAME_SIZE(MAX) and make
MAX 27 bytes - which is defined by the HDMI specification to be the
largest infoframe payload.

Fixes: f378b77227bc ("drm/connector: hdmi: Add Infoframes generation")
Fixes: c602e4959a0c ("drm/connector: hdmi: Create Infoframe DebugFS entries")

Signed-off-by: Derek Foreman <derek.foreman@collabora.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240827163918.48160-1-derek.foreman@collabora.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_hdmi_state_helper.c | 4 +---
 drivers/gpu/drm/drm_debugfs.c                   | 4 +---
 include/linux/hdmi.h                            | 9 +++++++++
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/display/drm_hdmi_state_helper.c b/drivers/gpu/drm/display/drm_hdmi_state_helper.c
index 7854820089ec6..feb7a3a759811 100644
--- a/drivers/gpu/drm/display/drm_hdmi_state_helper.c
+++ b/drivers/gpu/drm/display/drm_hdmi_state_helper.c
@@ -521,8 +521,6 @@ int drm_atomic_helper_connector_hdmi_check(struct drm_connector *connector,
 }
 EXPORT_SYMBOL(drm_atomic_helper_connector_hdmi_check);
 
-#define HDMI_MAX_INFOFRAME_SIZE		29
-
 static int clear_device_infoframe(struct drm_connector *connector,
 				  enum hdmi_infoframe_type type)
 {
@@ -563,7 +561,7 @@ static int write_device_infoframe(struct drm_connector *connector,
 {
 	const struct drm_connector_hdmi_funcs *funcs = connector->hdmi.funcs;
 	struct drm_device *dev = connector->dev;
-	u8 buffer[HDMI_MAX_INFOFRAME_SIZE];
+	u8 buffer[HDMI_INFOFRAME_SIZE(MAX)];
 	int ret;
 	int len;
 
diff --git a/drivers/gpu/drm/drm_debugfs.c b/drivers/gpu/drm/drm_debugfs.c
index 6b239a24f1dff..9d3e6dd68810e 100644
--- a/drivers/gpu/drm/drm_debugfs.c
+++ b/drivers/gpu/drm/drm_debugfs.c
@@ -520,8 +520,6 @@ static const struct file_operations drm_connector_fops = {
 	.write = connector_write
 };
 
-#define HDMI_MAX_INFOFRAME_SIZE		29
-
 static ssize_t
 audio_infoframe_read(struct file *filp, char __user *ubuf, size_t count, loff_t *ppos)
 {
@@ -579,7 +577,7 @@ static ssize_t _f##_read_infoframe(struct file *filp, \
 	struct drm_connector *connector; \
 	union hdmi_infoframe *frame; \
 	struct drm_device *dev; \
-	u8 buf[HDMI_MAX_INFOFRAME_SIZE]; \
+	u8 buf[HDMI_INFOFRAME_SIZE(MAX)]; \
 	ssize_t len = 0; \
 	\
 	connector = filp->private_data; \
diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
index 3bb87bf6bc658..455f855bc0848 100644
--- a/include/linux/hdmi.h
+++ b/include/linux/hdmi.h
@@ -59,6 +59,15 @@ enum hdmi_infoframe_type {
 #define HDMI_DRM_INFOFRAME_SIZE    26
 #define HDMI_VENDOR_INFOFRAME_SIZE  4
 
+/*
+ * HDMI 1.3a table 5-14 states that the largest InfoFrame_length is 27,
+ * not including the packet header or checksum byte. We include the
+ * checksum byte in HDMI_INFOFRAME_HEADER_SIZE, so this should allow
+ * HDMI_INFOFRAME_SIZE(MAX) to be the largest buffer we could ever need
+ * for any HDMI infoframe.
+ */
+#define HDMI_MAX_INFOFRAME_SIZE    27
+
 #define HDMI_INFOFRAME_SIZE(type)	\
 	(HDMI_INFOFRAME_HEADER_SIZE + HDMI_ ## type ## _INFOFRAME_SIZE)
 
-- 
2.43.0



