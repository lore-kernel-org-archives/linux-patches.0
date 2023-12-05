Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF006FB0;
	Tue,  5 Dec 2023 03:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBMj4R+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91ED7C433C7;
	Tue,  5 Dec 2023 03:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747844;
	bh=auPS1porM2TiLvrtdrMJRjbnJizvYvV51HVfU5xQqME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBMj4R+TQvPcCqYlR/l5E0zC+o37Aj7GR32Sl5DKVsWIlrA9GzODTqme3wDZhSmEp
	 g9XLJrAVZtUj/BJI5/jw2jN7cqHxFF1FMA0Qe2MBuBa+zmAeIDyfbGVXMryqh0zAOt
	 cB0afBNDB845IPF/d0hiP7mL29v90kcAgfsgRqr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/94] HID: core: store the unique system identifier in hid_device
Date: Tue,  5 Dec 2023 12:16:37 +0900
Message-ID: <20231205031523.399996863@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8248cdc30e1d3..af1e1922e1ae0 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2437,10 +2437,12 @@ int hid_add_device(struct hid_device *hdev)
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
index 20266127cf666..3fc4241cffbe2 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -622,6 +622,8 @@ struct hid_device {							/* device report descriptor */
 	struct list_head debug_list;
 	spinlock_t  debug_list_lock;
 	wait_queue_head_t debug_wait;
+
+	unsigned int id;						/* system unique id */
 };
 
 #define to_hid_device(pdev) \
-- 
2.42.0



