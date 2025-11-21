Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38A61F03D7;
	Fri, 21 Nov 2025 13:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731846; cv=none; b=ha3LXsWU/suPGwBf+HaXs+K3NAvrV/VXe/c6Isk9KOYIH94KCUMW8PQRAItLUN7bTpqLSOOvrKoYK90d6UYh6VXVLjNr73JzaBiwkng30rqWH9grX8xogwET5bq72HzdA7PSsNbHT28scp6JZhW0WsvNMUSjzcBP3/25O93T47Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731846; c=relaxed/simple;
	bh=fx3QwFdjPNtp+4iQvGrrO5nC5aJMVUAzsgiVQpuK6lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIVQWQYeT5c0obiXWZRIux9mQvJSNbBxymlKWTTz8ewB5jcECdBIUkkdN3fWCl21DsTNo+GzJlTBmyuWbYf5i0MQ5DzWqsn4SlMgzJZpj2hoziYoPN89luCMdAAblaR1frpKh6hWGp34jFvkL7qGweRW5u5aqZjjp95JxnSB8Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9WD7PZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9WD7PZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDCDC4CEF1;
	Fri, 21 Nov 2025 13:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731846;
	bh=fx3QwFdjPNtp+4iQvGrrO5nC5aJMVUAzsgiVQpuK6lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9WD7PZzKu4K7btFUWHMwe7Yu0Xs/v3Vma+4DYPt+fC9S9KktlzNRagbMbORMZrnl
	 UDM7vN8YjwT6K1dweynlTb6wG1Ti8oGOM5pz/PYrIpJb2MkTMKinomDaOtAyu9W8zs
	 k4ldtDdltlYaWdNTHIpZlNMN0b69NhEAq1Lm5AkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Ichikawa <masami256@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/185] HID: hid-ntrig: Prevent memory leak in ntrig_report_version()
Date: Fri, 21 Nov 2025 14:12:09 +0100
Message-ID: <20251121130147.554088249@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Masami Ichikawa <masami256@gmail.com>

[ Upstream commit 53f731f5bba0cf03b751ccceb98b82fadc9ccd1e ]

Use a scope-based cleanup helper for the buffer allocated with kmalloc()
in ntrig_report_version() to simplify the cleanup logic and prevent
memory leaks (specifically the !hid_is_usb()-case one).

[jkosina@suse.com: elaborate on the actual existing leak]
Fixes: 185c926283da ("HID: hid-ntrig: fix unable to handle page fault in ntrig_report_version()")
Signed-off-by: Masami Ichikawa <masami256@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ntrig.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 0f76e241e0afb..a7f10c45f62bd 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -142,13 +142,13 @@ static void ntrig_report_version(struct hid_device *hdev)
 	int ret;
 	char buf[20];
 	struct usb_device *usb_dev = hid_to_usb_dev(hdev);
-	unsigned char *data = kmalloc(8, GFP_KERNEL);
+	unsigned char *data __free(kfree) = kmalloc(8, GFP_KERNEL);
 
 	if (!hid_is_usb(hdev))
 		return;
 
 	if (!data)
-		goto err_free;
+		return;
 
 	ret = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
 			      USB_REQ_CLEAR_FEATURE,
@@ -163,9 +163,6 @@ static void ntrig_report_version(struct hid_device *hdev)
 		hid_info(hdev, "Firmware version: %s (%02x%02x %02x%02x)\n",
 			 buf, data[2], data[3], data[4], data[5]);
 	}
-
-err_free:
-	kfree(data);
 }
 
 static ssize_t show_phys_width(struct device *dev,
-- 
2.51.0



