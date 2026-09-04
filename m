Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132F9358378;
	Fri,  4 Sep 2026 06:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502016; cv=none; b=n0tVykPuMxLlmy4aqf6bxwWh48XBTfmFXTqiC5zSYyLqtoDjoNm+zPYU+HStrrzWciEUOmd4TU3UcPkKqA9UvzPujcXkxcmSwE7XQVmkB34/9CHTVVOVl63YQ9B2LscAZkI3v3z2NxhZ5j0LLzYEwq8N6r+dBlAL4w+gNmezzyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502016; c=relaxed/simple;
	bh=rUxgUfIXJ94bZo8ERMWk6ioOexb3GYEIb9Y8XOtW7Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGva+hHCP+OM2886AT52jcEt+r4tIKrJUS2Aq9Kc81q4Qj+u9NW9rmqv7TvOKJmyW4QqC2CJjrJKdpf8zz6tgBZcQ2XdBXkCcnKPVMBd3pW7fSKx/8xoWuVqF1CLE8iU/wx5CCkmTAm5j2THAujP7XLqQoe5raqHOFwIzC8GTBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Icu7vQpn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Icu7vQpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A791F00A3D;
	Fri,  4 Sep 2026 06:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502014;
	bh=UlxPjuwd165kD/ji0a/hg3PGDzO2P/zbu9WttEshYoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Icu7vQpnkLGOjCqgSh5/ZuE53Gn9b9kYzq/Vic8zkqT4WQQKzPOi5uaL5fstDGv/n
	 NnbF02Gz/v6HsqEJtqv3VPur2vAWDQ7lxQmCkS/EMTziP2s4v3OQh6YKQWbEKu6GOF
	 Px2PhKyF7Nj5Th1ekdzKCIbAupChARfOQTuyrcjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xingrui Li <baka9@bakabaka9.tech>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 059/403] HID: sensor-hub: Fix out-of-bounds write in sensor_hub_get_feature
Date: Fri,  4 Sep 2026 06:57:42 +0200
Message-ID: <20260904045736.174410193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingrui Li <baka9@bakabaka9.tech>

commit c92693f3ed099401d0383ef35ca1fe1e6ba033de upstream.

sensor_hub_get_feature() clamps its return value to the caller's buffer
size, but the copy loop still copies field->report_size / 8 bytes for
each report value. A malicious HID descriptor can advertise a large
feature field size while an IIO caller supplies a small stack buffer,
such as a single s32, causing an out-of-bounds write.

HID core stores parsed report values in __s32 slots and clamps extracted
values to 32 bits. Reject feature fields that require more than one slot
per value, guard the total byte count calculation, and clamp each
per-value copy to the remaining caller buffer.

Fixes: 5459ada2b3cd69 ("HID: sensor-hub: Fix packing of result buffer for feature report")
Cc: stable@kernel.org
Assisted-by: OpenAI:GPT-5.5-Cyber
Signed-off-by: Xingrui Li <baka9@bakabaka9.tech>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-sensor-hub.c |   44 +++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -239,12 +239,17 @@ int sensor_hub_get_feature(struct hid_se
 			   u32 field_index, int buffer_size, void *buffer)
 {
 	struct hid_report *report;
+	struct hid_field *field;
 	struct sensor_hub_data *data = hid_get_drvdata(hsdev->hdev);
-	int report_size;
+	size_t field_size;
+	size_t report_size;
+	size_t copied = 0;
+	size_t to_copy;
 	int ret = 0;
-	u8 *val_ptr;
-	int buffer_index = 0;
-	int i;
+	unsigned int i;
+
+	if (!buffer || buffer_size <= 0)
+		return -EINVAL;
 
 	memset(buffer, 0, buffer_size);
 
@@ -258,26 +263,29 @@ int sensor_hub_get_feature(struct hid_se
 	hid_hw_request(hsdev->hdev, report, HID_REQ_GET_REPORT);
 	hid_hw_wait(hsdev->hdev);
 
+	field = report->field[field_index];
+
 	/* calculate number of bytes required to read this field */
-	report_size = DIV_ROUND_UP(report->field[field_index]->report_size,
-				   8) *
-				   report->field[field_index]->report_count;
-	if (!report_size) {
+	field_size = DIV_ROUND_UP(field->report_size, 8);
+	/* HID core stores each parsed report value in a __s32 slot. */
+	if (!field_size || field_size > sizeof(field->value[0])) {
+		ret = -EINVAL;
+		goto done_proc;
+	}
+	if (field->report_count > SIZE_MAX / field_size) {
 		ret = -EINVAL;
 		goto done_proc;
 	}
-	ret = min(report_size, buffer_size);
 
-	val_ptr = (u8 *)report->field[field_index]->value;
-	for (i = 0; i < report->field[field_index]->report_count; ++i) {
-		if (buffer_index >= ret)
-			break;
-
-		memcpy(&((u8 *)buffer)[buffer_index], val_ptr,
-		       report->field[field_index]->report_size / 8);
-		val_ptr += sizeof(__s32);
-		buffer_index += (report->field[field_index]->report_size / 8);
+	report_size = field_size * field->report_count;
+	report_size = min_t(size_t, report_size, buffer_size);
+
+	for (i = 0; i < field->report_count && copied < report_size; ++i) {
+		to_copy = min(field_size, report_size - copied);
+		memcpy(&((u8 *)buffer)[copied], &field->value[i], to_copy);
+		copied += to_copy;
 	}
+	ret = copied;
 
 done_proc:
 	mutex_unlock(&data->mutex);


