Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6CA43B6F3;
	Wed, 30 Sep 2026 19:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797035; cv=none; b=jAPAfxKUH5AczgdaYqOqM7uaHx3bApBts5awOD9BGL23SJulTwmHqVX48gWf3GwOKZsJpP6V1SkE1NKlSQrjjbwrIeft277kQ6bKMS9uUEqUCoiRqlIiEDHMDEB6X5/A9fU7RdjPDtYFZul4E4MSL0wcCEcVfretRjZqAJpwyiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797035; c=relaxed/simple;
	bh=6v6m1o2LEX5dkmziSbQIaZ65OQgsrjd7OJAz+aIk4jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjtCGeAQiG9NLOsCICubOfJuEjpD77Lkg9JtZwuy44ojhY6j4g8sQDn1oLEsIBGGv1pa4OOm9aPyblcYmgnp63aCYxJviiTrTAEuO1B8pi0IJeVYh6gIWKf7+sjKW81fHbtlXo8pstM19VYOMKNMKOphjm8rFL87ft4FNW0K5KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzk5BtXV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzk5BtXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECFF1F000FF;
	Wed, 30 Sep 2026 19:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797034;
	bh=Q138i+Ay7NOfy/Ku/8sDbW+XowKOuzsabIJIK+i0fVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzk5BtXV5hiHDBWqEE5A0kWC/zgk1KXoIC939kQRKMnvsO0FjkHt4NrtAGDkOv1Ik
	 K9FtLZYvrz8IXi7QykjIk3xdGZop0uITV+I8FXGIausS+Gq4IMJBFPTRUlrAhzHhCk
	 UHmbbm6KvvzjpBuSGly/bcvHAyt37UyVYvZ4gr/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <killertofu@gmail.com>,
	Wei Jie Law <98lawweijie@gmail.com>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 1123/1193] HID: wacom: fix OOB read in wacom_wac_pen_serial_enforce()
Date: Wed, 30 Sep 2026 17:30:07 +0200
Message-ID: <20260930152459.186122628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Wei Jie LAW <98lawweijie@gmail.com>

commit 9aa237cf66495b2426ddde8532e9b08a0ed83aaa upstream.

The 'wacom_wac_pen_serial_enforce()' function may calculate and pass an
invalid offset to hid_field_extract(), resulting in memory reads at
incorrect addresses -- possibly beyond the end of the report.  If a
field in the HID descriptor lists more usages than its Report Count
actually reserves space for, the function's inner 'j' will walk past
the end of the field:

	for (i = 0; i < report->maxfield; i++) {
		for (j = 0; j < report->field[i]->maxusage; j++) {
			...
			value = hid_field_extract(hdev, raw_data + 1,
						  offset + j * size, size);

A descriptor listing 12288 usages against Report Count 1 has the loop
extract the usage at index 12287 from bit offset 98296 -- about 12 KB
past a 2-byte received report.  The value is stored in
wacom_wac->serial[0] and can reach userspace as an MSC_SERIAL event,
making this an information disclosure.

Clamp the loop to field->report_count, the number of value slots the
report holds.  Value slots past the last declared usage are still
scanned; they reuse that usage (HID 1.11, 6.2.2.8).

Verified on v6.12.105 with a UHID reproducer: a 2-byte report from
such a descriptor trips KASAN before the patch and not after it.

Fixes: 83417206427b ("HID: wacom: Queue events with missing type/serial data for later processing")
Suggested-by: Jason Gerecke <killertofu@gmail.com>
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Assisted-by: GLM:glm-5.3
Signed-off-by: Wei Jie Law <98lawweijie@gmail.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -97,8 +97,9 @@ static int wacom_wac_pen_serial_enforce(
 
 	/* Queue events which have invalid tool type or serial number */
 	for (i = 0; i < report->maxfield; i++) {
-		for (j = 0; j < report->field[i]->maxusage; j++) {
-			struct hid_field *field = report->field[i];
+		struct hid_field *field = report->field[i];
+
+		for (j = 0; j < field->report_count; j++) {
 			struct hid_usage *usage = &field->usage[j];
 			unsigned int equivalent_usage = wacom_equivalent_usage(usage->hid);
 			unsigned int offset;


