Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55A1390613;
	Tue, 25 Aug 2026 13:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665860; cv=none; b=RfXncE1NiqaCFm+LGQkJEosEk7w+sWrkJs84lunAsP8ogqOhYqTeCk2UlPH/vZ0v0iZ8sLvTXlfFWIHHcKiuX92+L1gIYz0Em/7QH/depRwCK1Jtf1Te7pLNe73UTAcloKE0QgPJyZ8kMQEQlObFCZnR7h1CACNGw0I7u5XIo/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665860; c=relaxed/simple;
	bh=sXw20SU1oIRXEvZmqRs/dwLAEWBIaJm3sfgAdRMhclY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PPaOsXpXALdT2KUX4Uqq/t2B+66w6vY9593NQG/w46S40Yf/vHH1GG7inC7BFBftY0oDUG2MVI9CwNzKfxp5OPac0i1F4yiuz57ERD2prhw9gl7kIFBAJ8OuxaOIhG9VpB8qmok4EsDpn6HrReIO+khfCrSPlx3asxNkGE3IGM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yy9lp/ve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yy9lp/ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1E11F000E9;
	Tue, 25 Aug 2026 13:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665859;
	bh=9cxMhLTT2Za7cO1u4WaCJE5EYI1tkYQdDYEAe8WQwic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yy9lp/ve9BCPR0UEc1VNwiSEXbvxFO6d3Tve5+GkrKzK8aLQ9c7oVtVuBdMcsTUU+
	 aWthqoVnVaJDT4s75365XZRflXYOzpie2YOynx8Q5+lJOYaDmRmziYEnqdOIixiDS9
	 /EaQ/zFgMy1ZvJV6IQ3lX4svEEa3jbiYb9iNXXJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 66/87] HID: magicmouse: Prevent out-of-bounds (OOB) read during DOUBLE_REPORT_ID
Date: Tue, 25 Aug 2026 15:26:29 +0200
Message-ID: <20260825132544.406382916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -384,6 +384,10 @@ static int magicmouse_raw_event(struct h
 	struct input_dev *input = msc->input;
 	int x = 0, y = 0, ii, clicks = 0, npoints;
 
+	/* Protect against zero sized recursive calls from DOUBLE_REPORT_ID */
+	if (size < 1)
+		return 0;
+
 	switch (data[0]) {
 	case TRACKPAD_REPORT_ID:
 	case TRACKPAD2_BT_REPORT_ID:
@@ -484,6 +488,18 @@ static int magicmouse_raw_event(struct h
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


