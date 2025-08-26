Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C94922370D;
	Tue, 26 Aug 2025 14:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218481; cv=none; b=tcrf3PDajestxuL5Pg4NB1m8UBldNml/hLeBdSGUUftSy1/5V+4HY6f8V7YDTbjALzMpqFhC7tR9tXfIQzEPi2/NJ44d7p44pZYr3tbSNQwMNFhCZssU+50Lsg+LzulQRM1+I7TBhgFJ7rE2y+Kfo9OJIXTteIlkvmzCUvIgcug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218481; c=relaxed/simple;
	bh=YugG7wZhCZF9ipKlyyLTVEJtBrG1npLnMkjTlmU7TSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUec7wuJIPTJOFm3JzLgerRQ+MBfefWl1f1jB/V3CWh3eI/pps4IJjWqNK6Hw5t43PyTnXIGt8xOUdND3FPdhmdeBguO2jwXDixkd2yNmUS/Ta7rKcXC8u2H8pxTZsj87uzzakW+FjmyJ5kc/xk6JGBaeHXZZ+abksTH6w6TniI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsKbEPIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsKbEPIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C526BC4CEF1;
	Tue, 26 Aug 2025 14:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218481;
	bh=YugG7wZhCZF9ipKlyyLTVEJtBrG1npLnMkjTlmU7TSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsKbEPIWD1UouMjy62MywNgg5VL2b9tplbytCulAvQ8Jbw/aLal0q3DArKkCDpWfr
	 HRhqsip3vMGTVI0qTWRwJ6thXi8rO+B5qYGPWDHDFngQKrmyhEztYUdrS1YcNQXJH0
	 YdTK0mEqV+pw4BHS0nAQMZJIypU2W5j+5DtsZ6xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+8258d5439c49d4c35f43@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.4 009/403] HID: core: ensure __hid_request reserves the report ID as the first byte
Date: Tue, 26 Aug 2025 13:05:35 +0200
Message-ID: <20250826110905.902489501@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

commit 0d0777ccaa2d46609d05b66ba0096802a2746193 upstream.

The low level transport driver expects the first byte to be the report
ID, even when the report ID is not use (in which case they just shift
the buffer).

However, __hid_request() whas not offsetting the buffer it used by one
in this case, meaning that the raw_request() callback emitted by the
transport driver would be stripped of the first byte.

Note: this changes the API for uhid devices when a request is made
through hid_hw_request. However, several considerations makes me think
this is fine:
- every request to a HID device made through hid_hw_request() would see
  that change, but every request made through hid_hw_raw_request()
  already has the new behaviour. So that means that the users are
  already facing situations where they might have or not the first byte
  being the null report ID when it is 0. We are making things more
  straightforward in the end.
- uhid is mainly used for BLE devices
- uhid is also used for testing, but I don't see that change a big issue
- for BLE devices, we can check which kernel module is calling
  hid_hw_request()
- and in those modules, we can check which are using a Bluetooth device
- and then we can check if the command is used with a report ID or not.
- surprise: none of the kernel module are using a report ID 0
- and finally, bluez, in its function set_report()[0], does the same
  shift if the report ID is 0 and the given buffer has a size > 0.

[0] https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/profiles/input/hog-lib.c#n879

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Closes: https://lore.kernel.org/linux-input/c75433e0-9b47-4072-bbe8-b1d14ea97b13@rowland.harvard.edu/
Reported-by: syzbot+8258d5439c49d4c35f43@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8258d5439c49d4c35f43
Tested-by: syzbot+8258d5439c49d4c35f43@syzkaller.appspotmail.com
Fixes: 4fa5a7f76cc7 ("HID: core: implement generic .request()")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250710-report-size-null-v2-2-ccf922b7c4e5@kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1723,7 +1723,7 @@ static struct hid_report *hid_get_report
 int __hid_request(struct hid_device *hid, struct hid_report *report,
 		int reqtype)
 {
-	char *buf;
+	char *buf, *data_buf;
 	int ret;
 	u32 len;
 
@@ -1731,10 +1731,17 @@ int __hid_request(struct hid_device *hid
 	if (!buf)
 		return -ENOMEM;
 
+	data_buf = buf;
 	len = hid_report_len(report);
 
+	if (report->id == 0) {
+		/* reserve the first byte for the report ID */
+		data_buf++;
+		len++;
+	}
+
 	if (reqtype == HID_REQ_SET_REPORT)
-		hid_output_report(report, buf);
+		hid_output_report(report, data_buf);
 
 	ret = hid->ll_driver->raw_request(hid, report->id, buf, len,
 					  report->type, reqtype);


