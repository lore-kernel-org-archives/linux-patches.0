Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772002594BD;
	Sat, 12 Sep 2026 16:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229386; cv=none; b=m9DymivpuBDzEC52PS0owmODxLOj6WJaTdIiBN4YEcglsUMNDxoLfxhRzW9TwHHyQQg//XoadDe3dzzdfu9HeOsNiCWp/zjY/rLHEwzI6Qhgnfj9fwpYB997PyXOECPwyhshBDNEFTcnFcRntM9EmQCPeZe3GYwpPIZo8BRKXNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229386; c=relaxed/simple;
	bh=70DWQqErwAu5XM+zag8ZgPFJgVPEbLMiVgQvQC6csgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJ1Yercagb2gTZdvRXDb+PZg5rIND/25cIspzlpn9IU/WtIRQTu/KlO8DDecZ7vyNt0t8IkgdvYRyS/YTYUtKNJKQvNa2ASC0THEzNAxWEI0CqW7XgpS3x/uXQTZC28PcnCFKGG+r8AIUj+vuQjoM5v7awmVY7a349jgbpGB/v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSnBdJMr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSnBdJMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092C51F00893;
	Sat, 12 Sep 2026 16:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229385;
	bh=8RKLBURy5svWPWfu0jqBQCcqtbRRkb/AFUwoUt6WYFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kSnBdJMr4N1sT+5BoIMGEH9bEtJ95stk6hUavfh8ZoYCTiHYDaWPb29YY1LBvPEQ6
	 Ra2+68niLAYCJzMwWX1wYEhg5MMzGILcnrUypw8UwY4F8HgpT1j2k5kKAFOWBXNdky
	 LjgqDreEHQtugl/94apQ0eVBZXQ5XmD1VBJbE/So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Mandlik <mmandlik@google.com>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0579/1191] Bluetooth: btusb: Add btusb devcoredump support
Date: Sat, 12 Sep 2026 08:55:07 +0200
Message-ID: <20260912065601.250211997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Manish Mandlik <mmandlik@google.com>

[ Upstream commit 4f9c1a089623ac606e79a7886646939e0e2f89bf ]

This patch implements the btusb driver side .coredump() callback to
trigger a devcoredump via sysfs.

Signed-off-by: Manish Mandlik <mmandlik@google.com>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: ef8154d8b52d ("usb: fix UAF when probe runs concurrent to dyn ID removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 909e27bf0995f..f5785495eb2c3 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4415,6 +4415,17 @@ static int btusb_resume(struct usb_interface *intf)
 }
 #endif
 
+#ifdef CONFIG_DEV_COREDUMP
+static void btusb_coredump(struct device *dev)
+{
+	struct btusb_data *data = dev_get_drvdata(dev);
+	struct hci_dev *hdev = data->hdev;
+
+	if (hdev->dump.coredump)
+		hdev->dump.coredump(hdev);
+}
+#endif
+
 static struct usb_driver btusb_driver = {
 	.name		= "btusb",
 	.probe		= btusb_probe,
@@ -4426,6 +4437,14 @@ static struct usb_driver btusb_driver = {
 	.id_table	= btusb_table,
 	.supports_autosuspend = 1,
 	.disable_hub_initiated_lpm = 1,
+
+#ifdef CONFIG_DEV_COREDUMP
+	.drvwrap = {
+		.driver = {
+			.coredump = btusb_coredump,
+		},
+	},
+#endif
 };
 
 module_usb_driver(btusb_driver);
-- 
2.53.0



