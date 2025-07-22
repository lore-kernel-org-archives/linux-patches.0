Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC4478F51;
	Tue, 22 Jul 2025 13:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192672; cv=none; b=AYdDVPpMbPiPNVGlMUpUP/4Vwe2lUaSooOhOBOfZE3W03zAeihKv+EOp4cfk5WslWiCL6yiM8NbXY/DMThoVd23sPHZxnOpqJV+vL7E6tgpo6DMg8+e2FMwgnBpX7w9jhEF0R6o8T5qGyRTesycZSDk0/YnRWME9GrX0ql9zoPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192672; c=relaxed/simple;
	bh=b3LUxPHEAVYscKFhwwK7KgShwqqHGT2/Pr/iyyAfvwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baYNeUCyQfZsX+H/swosSySyMV9nlHQ18ecdJXk/VXDFqWLbDC357h+vXvHtgpYZU1cNlCemCoQDhs8f/WSodzPs4qqWuXoPNkOzJBiwjrEg1SsCrtZYbhCMkOdpn+I3KOsT5Fno+XKZbNQMYX1xGlqVhJy4qBChBPlETs+WUhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2QVfOpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2QVfOpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7177CC4CEEB;
	Tue, 22 Jul 2025 13:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192671;
	bh=b3LUxPHEAVYscKFhwwK7KgShwqqHGT2/Pr/iyyAfvwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2QVfOpw6x2XmmNJ5EKWD4i/eDd6s/pT1fedoeAVluXA4QmiXzWVzhiaiaT0JYxxp
	 PQciYJ1UFEV4KPFByKGWXUpHlRpouwEJxyFkFqXEsRsVxe9RZH4rPvUkJ0XIBnebB0
	 AF5UmjrYEG7RhjNFPIBWpRcvrb+sLIOL75HetZHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+8258d5439c49d4c35f43@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 023/158] HID: core: ensure __hid_request reserves the report ID as the first byte
Date: Tue, 22 Jul 2025 15:43:27 +0200
Message-ID: <20250722134341.603341924@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1966,7 +1966,7 @@ static struct hid_report *hid_get_report
 int __hid_request(struct hid_device *hid, struct hid_report *report,
 		enum hid_class_request reqtype)
 {
-	char *buf;
+	char *buf, *data_buf;
 	int ret;
 	u32 len;
 
@@ -1974,10 +1974,17 @@ int __hid_request(struct hid_device *hid
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


