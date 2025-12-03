Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8057340281;
	Wed,  3 Dec 2025 16:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780009; cv=none; b=JLElio4jXCUY36DhsFyaSCpajJIh+nDHG1zyJbiuAn2Bk2B2xPBCV7BccFiqRs2IBUeFG+EUzI6k3TNhLoiAzQNA9XwIH9tr/Ux3CWc8Deo8v8zFuTbymbe18OnKihWXmuGn/imAG0UtJpP/4oSezVJR0HYyIEWk81e3GFaZ/94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780009; c=relaxed/simple;
	bh=0sGo2/6zxVNemXFgw0lrLioWDMM76U320BuO5CaV+ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwcVyy/QONUYiPMJhrjMYYp7CzVTNLSNSxTXWeY9AjN6rNEIU+u6m/aLnN9pkD78kPwMuX0ePBSo5k/Pho89VOyn60NAr713zzlyHr9Fxmin2sgwiBzeHF5ByWMzYaC0WhkXIFj6gjewRk3kq9yzuqqb/zdOidfs8/E0VCrsiLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aTLG90s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aTLG90s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1383BC4CEF5;
	Wed,  3 Dec 2025 16:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780009;
	bh=0sGo2/6zxVNemXFgw0lrLioWDMM76U320BuO5CaV+ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2aTLG90sE0dNwOyrJ2GWwyBeYugt4TQGzJpkWhguW2cxZXnvBx2PdPW6H/WseNh8u
	 H25WNT3sn/KnBZONt3Fu9CRfgv30bCMjCxOnykDX1On+FhRDQ/MsFS0VYf37jpHLAb
	 usfkhksnyc7GogMgw1+2bDsubDd1yton1dT4H/l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Ichikawa <masami256@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 395/568] HID: hid-ntrig: Prevent memory leak in ntrig_report_version()
Date: Wed,  3 Dec 2025 16:26:37 +0100
Message-ID: <20251203152455.158994181@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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



