Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30D834DCF4;
	Fri, 21 Nov 2025 13:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733509; cv=none; b=gZBM/p3DpdfZXfkM+cAC+6yPz07n3tJ1rKKHHaNCnW9VFiWZQORiCk5T8bTQnbL5scY4XoUAMdyc8mb51KU/JppgLbOQniXsI6qXDakX83qHmqq7S5TVXp/rIztP0coaTtN6lol+10XoE80b8IXgWAZQ/X7ofj3xrl6nM7+Tb5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733509; c=relaxed/simple;
	bh=sSMMjJznBHII2kC2W7ui6GxoGn5mXWe0JeNQcvngI5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAzHUy+Xm/IuUWu2XUq08kkqkGFj8psnP39nVwordfU7rV0JVITWrRUgJ/odgyvzD6z5Rdt5SRquaaWJhE2I6w7IzTOKovHdSn6RoOGENdcfWLzKtAwUBSe5Z1oTpsf3bOqfcphQ6eOMpbc4CfiYwxTBesBB7CUXBuxDYQWrw1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdsLqZVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdsLqZVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F782C16AAE;
	Fri, 21 Nov 2025 13:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733509;
	bh=sSMMjJznBHII2kC2W7ui6GxoGn5mXWe0JeNQcvngI5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdsLqZVLBIlQJvUC2ZGoYceFNZMUNS40fB51bSieByQ8vwKxbx7Ce5XqDO5mVeWGv
	 h/+Rmx7Csc4/6iGoRo9kCuvHB60Gw3MXMWr1Dsft06YwBcJV3pEkFInhW1DKinR+SN
	 6XeSO/CtDMXWBHgptLwmWpDBhJCTHM9Xwi0PJ3Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Ichikawa <masami256@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 459/529] HID: hid-ntrig: Prevent memory leak in ntrig_report_version()
Date: Fri, 21 Nov 2025 14:12:38 +0100
Message-ID: <20251121130247.342454709@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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



