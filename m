Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1940B4F392A;
	Thu, 17 Sep 2026 15:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659873; cv=none; b=CyLBPBhXDGsJ11lonan2fYoe1toClzpAWt5VgRKanUWqebllWvNlzbfQle0wVID/r/JkHdBDDZ23kooSY0t3CiuyemFPN7mhun/AOUWfoMAR9kfHG8IgCpiePFFJAdaZbxU7qgBRl21ElRVhpnmbEibJKdQxtGMmuRlS38UR3zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659873; c=relaxed/simple;
	bh=tAqeEG9HRodJeoAH2QKyGAGNU4Gp7fNzGHnQ67ddtKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C75kvrl+IEMCABukRANCRBFuK1HZAHwotK1RcB+Y3E8ED3iam1focY2tzMpnuTCub6AnzvGE/4Grogu/K4fX/rArLo/ZZtcEovOxcXLrAyPHQr89/M+6L/pvvow6OLPrZzUOQ/sA23OzfivAavxKetTOpyGRlXLkrjcMgnCozFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uscQVJmw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uscQVJmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D811F000FF;
	Thu, 17 Sep 2026 15:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659865;
	bh=M/zYrJaaEPwR8flaPbV+lHlgZEaEsJ2dpplz/A8Cue4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uscQVJmwy6uRzvKOUJBnio74gcPlyQf2RoGwk+DLfqXbNm8B/htQfThrTcXX7x0me
	 QbN3HLg0JZAnK8OcGk1NYsD94M90ebtK/REw4MzLKhikMFx3YGhXLaBOl2qoycatn4
	 aw7CZFHkxBYYFzGLPPsjOjwMkJS58zb3iasAjfIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Linmao Li <lilinmao@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 399/733] hwmon: (corsair-cpro) Create debugfs entries after hwmon registration
Date: Thu, 17 Sep 2026 16:11:47 +0100
Message-ID: <20260917151401.673822695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 508baf1713f32f287bfb4f85d759403ec8ba35a3 ]

ccp_debugfs_init() registers debugfs files whose private data is the devm
allocated ccp.  It runs before hwmon_device_register_with_info(), so when
that registration fails, ccp_probe() returns with the files still in
place.  The HID core then frees ccp, and ccp_remove() is not called for a
failed probe, so nothing removes them later either.  Reading one of the
files dereferences the freed pointer.

Create the debugfs entries only after the hwmon device has been
registered, so no failing path can leave them behind.

The two version queries stay where they are.  They send USB commands
without holding ccp->mutex, which is only safe as long as nothing else
can call send_usb_cmd(); once the hwmon device is registered its
callbacks can do so concurrently.  Only the debugfs creation moves, and
it is told which queries succeeded.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-hwmon/20260708031612.BD7E61F000E9@smtp.kernel.org/
Suggested-by: Guenter Roeck <linux@roeck-us.net>
Fixes: 5997eb60f896 ("hwmon: (corsair-cpro) Add firmware and bootloader information")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260831014509.3352442-1-lilinmao@kylinos.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index 8354a002f4c5e..56de0fe0f544c 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -566,21 +566,18 @@ static int bootloader_show(struct seq_file *seqf, void *unused)
 }
 DEFINE_SHOW_ATTRIBUTE(bootloader);
 
-static void ccp_debugfs_init(struct ccp_device *ccp)
+static void ccp_debugfs_init(struct ccp_device *ccp, bool fw_valid, bool bl_valid)
 {
 	char name[32];
-	int ret;
 
 	scnprintf(name, sizeof(name), "corsaircpro-%s", dev_name(&ccp->hdev->dev));
 	ccp->debugfs = debugfs_create_dir(name, NULL);
 
-	ret = get_fw_version(ccp);
-	if (!ret)
+	if (fw_valid)
 		debugfs_create_file("firmware_version", 0444,
 				    ccp->debugfs, ccp, &firmware_fops);
 
-	ret = get_bl_version(ccp);
-	if (!ret)
+	if (bl_valid)
 		debugfs_create_file("bootloader_version", 0444,
 				    ccp->debugfs, ccp, &bootloader_fops);
 }
@@ -588,6 +585,7 @@ static void ccp_debugfs_init(struct ccp_device *ccp)
 static int ccp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	struct ccp_device *ccp;
+	bool fw_valid, bl_valid;
 	int ret;
 
 	ccp = devm_kzalloc(&hdev->dev, sizeof(*ccp), GFP_KERNEL);
@@ -632,7 +630,13 @@ static int ccp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (ret)
 		goto out_hw_close;
 
-	ccp_debugfs_init(ccp);
+	/*
+	 * Query the versions before registering the hwmon device: they send
+	 * USB commands without holding ccp->mutex, which is only safe while
+	 * nothing else can call send_usb_cmd().
+	 */
+	fw_valid = !get_fw_version(ccp);
+	bl_valid = !get_bl_version(ccp);
 
 	ccp->hwmon_dev = hwmon_device_register_with_info(&hdev->dev, "corsaircpro",
 							 ccp, &ccp_chip_info, NULL);
@@ -641,6 +645,8 @@ static int ccp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto out_hw_close;
 	}
 
+	ccp_debugfs_init(ccp, fw_valid, bl_valid);
+
 	return 0;
 
 out_hw_close:
-- 
2.53.0



