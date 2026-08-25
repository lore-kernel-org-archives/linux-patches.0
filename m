Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B583409265;
	Tue, 25 Aug 2026 13:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666050; cv=none; b=Idjkdz2zZ+WDGA16h31DVWONvG8kd6QkoWTt9LAK2CpuibByrBUzmlsu1TVTOf9fk5EX+o1GTg0QNgcU1mlkh0wQO0hsX+vD7Ur48j9Zo5W8ZDtRZHotw7imewP3gf3BFsSB/GgLfrsCx686KJsezUHga/yoekV4YKsSaJSsk/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666050; c=relaxed/simple;
	bh=Noc2aCUCI/4BZYXqv3+sEwGlJFRAdSIZnnEZxMTmKU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pr5V/NmmNdszVTwNPiV+C4nUejodXh9z8UkiHLm7vr4NBb+7FpFW6z7EXstTEewH/D3EvzJgCgnGDlw5yuA/ZZC6E3WsCd4v1d9SpOqe8ZMQdrXcfLe53kLrWmWyHh3+9SHoP5mY5MQzvLxb1V1WwusVN4NQ8GJvQSRb27hEMOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ly1P8gpA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ly1P8gpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2E81F000E9;
	Tue, 25 Aug 2026 13:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666048;
	bh=x3ldmSOiT/TZvuVYFQeLE1JcV/JFJ+6GYrLJPGURFD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ly1P8gpAv7D+AiYzFDi6Y+zqRd8n8FQBithehcYilUqd6w8079tXZoxs4U86ORQ+G
	 AWuwvhOCAgMtBmDJAxNMmkYXRZLGea1lCl7JFccpiyoqT9cEy2pxcuaF5AOMx99G8h
	 EMFae14VxCZqh/BIwNXcZnfCcSLTsVyuDxigVzgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 67/79] HID: core: fix OOB read of field->usage in hid_set_field()
Date: Tue, 25 Aug 2026 15:26:47 +0200
Message-ID: <20260825132544.298610774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baul Lee <baul.lee@xbow.com>

commit a13cdb19fcb223ed41bdab3bab42b98dba87e90b upstream.

hid_set_field() hands field->usage + offset to hid_dump_input() before
the guard that bounds offset:

	hid_dump_input(field->report->device, field->usage + offset, value);

	if (offset >= field->report_count) {
		hid_err(...);
		return -1;
	}

Under CONFIG_DEBUG_FS hid_dump_input() dereferences that pointer, with
buf = hid_resolv_usage(usage->hid, NULL).  The usage[] array is
allocated inline with the hid_field in hid_register_field() and holds
field->maxusage entries, so an offset past it reads off the end of the
kvzalloc()ed allocation and into a neighbouring object.  Had the guard
run first, offset < report_count <= maxusage would already have confined
the pointer to the array.

A caller supplies such an offset today.  picolcd_fb_send_tile()
validates only report->maxfield before issuing
hid_set_field(report->field[0], 11 + i, ...) for i = 0..31, so its
offsets are fixed at 11..42 and are never checked against the bound
field.  When the device registers that field with fewer usages, the
framebuffer deferred-io work drives the read on every tile.  KASAN
reports a 4-byte slab-out-of-bounds read in hid_dump_input() below
hid_set_field(), and the same boot logs "offset (1) exceeds
report_count (1)" from the guard that runs only afterwards.

Move the hid_dump_input() call below the guard.  Because
field->maxusage >= field->report_count, the guard then establishes that
field->usage + offset lies inside the array before it is dereferenced,
for every caller and without changing behaviour on the valid path.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1910,13 +1910,14 @@ int hid_set_field(struct hid_field *fiel
 
 	size = field->report_size;
 
-	hid_dump_input(field->report->device, field->usage + offset, value);
-
 	if (offset >= field->report_count) {
 		hid_err(field->report->device, "offset (%d) exceeds report_count (%d)\n",
 				offset, field->report_count);
 		return -1;
 	}
+
+	hid_dump_input(field->report->device, field->usage + offset, value);
+
 	if (field->logical_minimum < 0) {
 		if (value != snto32(s32ton(value, size), size)) {
 			hid_err(field->report->device, "value %d is out of range\n", value);


