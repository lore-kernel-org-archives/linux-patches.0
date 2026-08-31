Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE752542813;
	Mon, 31 Aug 2026 13:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183962; cv=none; b=lm+0nWxPscL6VH9Wona+RYgarLHZ60nW/kipq3Qy9yN1e0qmHzc0aR0aqJEdSsQeyIimCp2KXa2X3FZzs4HsJ+mqdg2QIEd6z17VIo+YFjjYo0FOhnHTGZL0IgwAXvwDhihAGuN8Kmi/rt8YgDaChShF7rNuBfUBnViogXKLeUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183962; c=relaxed/simple;
	bh=7BpGfKca3NYpnGSo7IWpSMvTN8UNyPTH2WqEXaZbGGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lnmhwMVRivmdUYxFKrYEsCaqjGI/qWqO/n0YnmFT+FNB4iHjlJqcvcEYttpW4H8/kKeqVebfzxO+sHy8bieq5Ow5+NLNyxj9dilqiIRkB6IGoU4Ip9Gn9hij10SA9GI9UdNI4t9neK7vGP6fIe4ieP6lYXdFxY59nOY9RJsSJAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEfn+8Vi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEfn+8Vi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21ED51F00A3D;
	Mon, 31 Aug 2026 13:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183959;
	bh=xvwVtcfnqgdX5D0SXtgSnEeY6yCu23bt3+lc5v1meMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eEfn+8Vid3rMbIwmRWcbhgW4CNV744Hk3slIWVEWU+36ecZEYzDSMBJvK0UX98abK
	 wzSeoMP+En+v1/x1yXLiFBthYpUzgnog8iRnzZ9bJMdH1I1Zau1PJI41yGHndKrO9R
	 3xPtecDaesraB67VoSw0fovtT9kyEAZzokl9zaTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jose=20Villase=C3=B1or=20Montfort?= <pepemontfort@gmail.com>,
	Alec Hall <signshop.alec@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 24/83] HID: magicmouse: prevent unbounded recursion in magicmouse_raw_event()
Date: Mon, 31 Aug 2026 15:34:00 +0200
Message-ID: <20260831133400.501540318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Villaseñor Montfort <pepemontfort@gmail.com>

[ Upstream commit db8d634128d2ba88d79c0b601e983ebe14bb0519 ]

magicmouse_raw_event() handles DOUBLE_REPORT_ID (0xf7) packets, which pack
two touch reports into one, by splitting the packet and calling itself on
each half. The only guard against runaway recursion is a "size < 1" check,
which stops zero-sized calls but does not bound the recursion depth.

A malicious HID device that matches this driver can send a report starting
with DOUBLE_REPORT_ID and filled with the sequence [0xf7, 0x00]. Each level
consumes two bytes and recurses on the remainder, so an incoming report of
up to HID_MAX_BUFFER_SIZE (16 KiB) drives roughly 8000 nested calls. That
easily exhausts the 16 KiB kernel stack, leading to a stack overflow: a
panic with CONFIG_VMAP_STACK, or memory corruption without it.

A double report only ever wraps two normal reports; it is never
legitimately nested. Refuse to re-enter the DOUBLE_REPORT_ID case from a
recursive call so the recursion depth is bounded to two, while all valid
packets keep being parsed exactly as before.

Fixes: a462230e16ac ("HID: magicmouse: enable Magic Trackpad support")
Link: https://lore.kernel.org/linux-input/20260706181347.700DB1F00A3F@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Jose Villaseñor Montfort <pepemontfort@gmail.com>
Reviewed-by: Alec Hall <signshop.alec@gmail.com>
Tested-by: Alec Hall <signshop.alec@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-magicmouse.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -383,8 +383,8 @@ static void magicmouse_emit_touch(struct
 	}
 }
 
-static int magicmouse_raw_event(struct hid_device *hdev,
-		struct hid_report *report, u8 *data, int size)
+static int __magicmouse_raw_event(struct hid_device *hdev,
+		struct hid_report *report, u8 *data, int size, bool nested)
 {
 	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
 	struct input_dev *input = msc->input;
@@ -495,6 +495,15 @@ static int magicmouse_raw_event(struct h
 		 * packet.
 		 */
 
+		/*
+		 * A double report only ever wraps two normal reports, so it is
+		 * never nested. Refuse to recurse a second time; otherwise a
+		 * malicious device could chain DOUBLE_REPORT_ID packets to drive
+		 * unbounded recursion and overflow the kernel stack.
+		 */
+		if (nested)
+			return 0;
+
 		/* Ensure that we have at least 2 elements (report type and size) */
 		if (size < 2)
 			return 0;
@@ -506,9 +515,9 @@ static int magicmouse_raw_event(struct h
 			return 0;
 		}
 
-		magicmouse_raw_event(hdev, report, data + 2, data[1]);
-		magicmouse_raw_event(hdev, report, data + 2 + data[1],
-			size - 2 - data[1]);
+		__magicmouse_raw_event(hdev, report, data + 2, data[1], true);
+		__magicmouse_raw_event(hdev, report, data + 2 + data[1],
+			size - 2 - data[1], true);
 		return 0;
 	default:
 		return 0;
@@ -534,6 +543,12 @@ static int magicmouse_raw_event(struct h
 	return 1;
 }
 
+static int magicmouse_raw_event(struct hid_device *hdev,
+		struct hid_report *report, u8 *data, int size)
+{
+	return __magicmouse_raw_event(hdev, report, data, size, false);
+}
+
 static int magicmouse_event(struct hid_device *hdev, struct hid_field *field,
 		struct hid_usage *usage, __s32 value)
 {


