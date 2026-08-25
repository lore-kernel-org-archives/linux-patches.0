Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F59546EF87;
	Tue, 25 Aug 2026 13:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666263; cv=none; b=iXX7LPzLDz05twZ2/+1tFEmsLTNwtber6MnyfyKuxHGP5TYO3rLq9ExEFlBQFtJMonKj0VIiA0jY6m9Wz70z8kp3in1G5T0zJR4iBodK+OUMJPnWfmNTxjtu0iF/MOVaAaWAxp2RPrCSToUhPo1KY8qMdX8/0vWbkOwRktpHNRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666263; c=relaxed/simple;
	bh=uwOjTsg1Kphhs4kvLtm9DPxvreaM+LrmGm0jzpLsfoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dWuZOY8+z2M3wmJSc1KGLJB1aGtw1a20mLbZzmrKIkZwDnLmn827NUcsd8b1qHccF9je6aLXTYSWModMWclSVTvaCQA2ESQALtNxPNPqAYcCihFq2D+NKSKdKmZrzUTA6DlquVHrBA5tw23gGl68x5MMEiHIqhBagqRgJNibSNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6GoHg+1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6GoHg+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3599A1F000E9;
	Tue, 25 Aug 2026 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666261;
	bh=lIobMdm2KkqGoUayc7wWwgjf5Ei96Xgu1Tio9AziXPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6GoHg+1OQeN05/BXrnNzoVeniBuT0PtLm7uT1E9jqVdSKFjqY7sYM1Dy2YhLJr8K
	 +7mjFT7vZC2iTjQZxhMuScNAMPlCO0fTMApcreN2wJWgh89kv/0per6Q6CDC8P3ghh
	 AHunQztDrfsTTt6xP5ii/fp1ojWjQ9n8izFQjimA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 60/76] HID: magicmouse: Prevent out-of-bounds (OOB) read during DOUBLE_REPORT_ID
Date: Tue, 25 Aug 2026 15:26:53 +0200
Message-ID: <20260825132543.928736151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

commit d93ba918a185aca2594da63e92fdc5495b559c0f upstream.

It is currently possible for a malicious or misconfigured USB device to
cause an out-of-bounds (OOB) read when submitting reports using
DOUBLE_REPORT_ID by specifying a large report length and providing a
smaller one.

Let's prevent that by comparing the specified report length with the
actual size of the data read in from userspace.  If the actual data
length ends up being smaller than specified, we'll politely warn the
user and prevent any further processing.

Signed-off-by: Lee Jones <lee@kernel.org>
Reviewed-by: Günther Noack <gnoack@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-magicmouse.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -375,6 +375,10 @@ static int magicmouse_raw_event(struct h
 	struct input_dev *input = msc->input;
 	int x = 0, y = 0, ii, clicks = 0, npoints;
 
+	/* Protect against zero sized recursive calls from DOUBLE_REPORT_ID */
+	if (size < 1)
+		return 0;
+
 	switch (data[0]) {
 	case TRACKPAD_REPORT_ID:
 	case TRACKPAD2_BT_REPORT_ID:
@@ -475,6 +479,18 @@ static int magicmouse_raw_event(struct h
 		/* Sometimes the trackpad sends two touch reports in one
 		 * packet.
 		 */
+
+		/* Ensure that we have at least 2 elements (report type and size) */
+		if (size < 2)
+			return 0;
+
+		if (size < data[1] + 2) {
+			hid_warn(hdev,
+				 "received report length (%d) was smaller than specified (%d)",
+				 size, data[1] + 2);
+			return 0;
+		}
+
 		magicmouse_raw_event(hdev, report, data + 2, data[1]);
 		magicmouse_raw_event(hdev, report, data + 2 + data[1],
 			size - 2 - data[1]);


