Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4703879E3;
	Tue,  5 Dec 2023 03:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/ZQlT0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E4EC433C7;
	Tue,  5 Dec 2023 03:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746782;
	bh=vjbYDlYL5MrYze1Oh2NadVd4uxO8CDSB4eKRy7qTFuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/ZQlT0iW3qa1fTnXWSgVVuwAgEDOPSzKS204Cnpmrw5kB4Agwi2GwcIzG3WQSBC/
	 9RhOBY3wEePZEHVTc09PDz8iDir5I2IeVB+5ZR6d9/tK4TZzmVaLjUumzv+fUQB0Kn
	 m0TL2HZ6w8a2EN3PQL/nLhb/Io/PLxVdkYHIBZOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/71] HID: core: store the unique system identifier in hid_device
Date: Tue,  5 Dec 2023 12:16:04 +0900
Message-ID: <20231205031518.244565961@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

[ Upstream commit 1e839143d674603b0bbbc4c513bca35404967dbc ]

This unique identifier is currently used only for ensuring uniqueness in
sysfs. However, this could be handful for userspace to refer to a specific
hid_device by this id.

2 use cases are in my mind: LEDs (and their naming convention), and
HID-BPF.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20220902132938.2409206-9-benjamin.tissoires@redhat.com
Stable-dep-of: fc43e9c857b7 ("HID: fix HID device resource race between HID core and debugging support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 4 +++-
 include/linux/hid.h    | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index c8d687f795caa..99eb26bcb1dd3 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2259,10 +2259,12 @@ int hid_add_device(struct hid_device *hdev)
 			hid_warn(hdev, "bad device descriptor (%d)\n", ret);
 	}
 
+	hdev->id = atomic_inc_return(&id);
+
 	/* XXX hack, any other cleaner solution after the driver core
 	 * is converted to allow more than 20 bytes as the device name? */
 	dev_set_name(&hdev->dev, "%04X:%04X:%04X.%04X", hdev->bus,
-		     hdev->vendor, hdev->product, atomic_inc_return(&id));
+		     hdev->vendor, hdev->product, hdev->id);
 
 	hid_debug_register(hdev, dev_name(&hdev->dev));
 	ret = device_add(&hdev->dev);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 79c6c3b4e0044..10b41b2b20857 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -625,6 +625,8 @@ struct hid_device {							/* device report descriptor */
 	struct list_head debug_list;
 	spinlock_t  debug_list_lock;
 	wait_queue_head_t debug_wait;
+
+	unsigned int id;						/* system unique id */
 };
 
 #define to_hid_device(pdev) \
-- 
2.42.0



