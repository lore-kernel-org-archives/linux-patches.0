Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED6F47DD59;
	Sat, 12 Sep 2026 13:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219756; cv=none; b=EhP5hd+gzRPxz7FiJYAMDLsEy8Wnijr1gCEi2npfPEQiJ0yycSB86Lq9ts5oAimyUMYka+G0voYu0J22zW/MLRMzhHbdTm/mMo7pPT39uWvXQ14AYm1Y5GWqNte/yfMSUSqEwFPJmJ7wFJTJ6yhrklO+YyG5rXSq4aCwJ3mFFwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219756; c=relaxed/simple;
	bh=s7BRVsxlRe6UAbR8U7i961IgGKo13IUq1kii5GJ0NAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIz6/TneeguL6agS2IQ8GnzXt7RmSeMofc4/LwNm3SCSCYvhPN1rDO6tz/39yN5I8VSapcBgRqm+jCFzRra3u6fU88/nJltgR/um3beFf7LELfnG8agf7/3TgGfTFC0CtNo86cMYXKlinPyckO1UuostEERCCQgashwQDL+Cd9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zge5L4yk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zge5L4yk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1365B1F000FF;
	Sat, 12 Sep 2026 13:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219755;
	bh=gCl3fDKwnv3K1PmF26ubNe2QWmv/vtBg3k9FSiPQ3/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zge5L4yk54TFssJ4M0TwNwr+ogYQCkFzqYa3684Z8R6yZIgo8HqnKP4Cn44+61ir6
	 qlE8DmTZdtZnZboTBwXRPwcNqPsziemmZ8b0+Y0hZsKNXMMuXlVEK/HPA/d/8TvLj2
	 mcgW5qwmn/KdMbVK5gziO5E5dsIqyuWGySkdKzmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xingrui Li <baka9@bakabaka9.tech>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0039/1424] HID: sensor-hub: Fix out-of-bounds write in sensor_hub_get_feature
Date: Sat, 12 Sep 2026 08:41:11 +0200
Message-ID: <20260912065608.179198643@linuxfoundation.org>
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


