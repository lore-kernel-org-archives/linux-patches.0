Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29443128CD;
	Wed,  3 Dec 2025 16:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778192; cv=none; b=X+BavzQwzo6HowMeZcJFYZlmgUrcd8MJMZCV/sXF6u0PMBiISAgheXOLGWao2GJm1QuuMah5lygXtX+DwmoyGA8Zr/thg5vyQuST9w2TBFVn86UlnOzjQA3wEOpKlmhejWHqQkAqLqT4ixCRU2fAiqwFhT2/x6CFfn2O0Gs+XKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778192; c=relaxed/simple;
	bh=/y+AoJmZ8OjDO7u42wVf2pS5NBzWVPTVHAszknKU4Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QN8T6D5j12nHPJfPykvWvV2je+0X6YJM6Jg9BFOLu6cq+1M0XP9+HxtvvGaPm020R0HB4nYGMgOSh9vad/5RJMCHZT88D1frTgX7K7PIXMZDNI/X3OW9amNR6xkE8yjup/UCiwZw1P+mhgPVVFWOn80taWepacn+zgyBHEZC7Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHu71UdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHu71UdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5FCC4CEF5;
	Wed,  3 Dec 2025 16:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778192;
	bh=/y+AoJmZ8OjDO7u42wVf2pS5NBzWVPTVHAszknKU4Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHu71UdYh3eBLCMYq2hy1yooHYGsypsUjIkbqCWBOs7JTbQTkLfqzsos6AgrIu+re
	 td5nJPUOZWcg8XmlsvYS7E5SSN97/3rINHsM9zPrLh4znm5QXZDuszPJr4zcDQvWo+
	 DkMlSxx+tEzO7Y2TcgZI3DOMbuCTRe+6pTfELZU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Ichikawa <masami256@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 270/392] HID: hid-ntrig: Prevent memory leak in ntrig_report_version()
Date: Wed,  3 Dec 2025 16:27:00 +0100
Message-ID: <20251203152424.099885032@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a1128c5315fff..3c41f6841f775 100644
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



