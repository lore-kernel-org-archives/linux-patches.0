Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B472210C2;
	Thu, 12 Dec 2024 15:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016577; cv=none; b=oodLNFki1EglPZ8i378aX3HC1NyFExTYaojAg2tW4MiE1/zGT1iwT5Rgpka4P+dBzAOEF21bBlaIFk75yyIrNASe5T+cig7dywPC4SwZo/k3KPcspFJ1GU8t8+tVYA2L5q/bNJe0hPOHYZfgYzp4igUXNT8srR7e/qchas0Kc2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016577; c=relaxed/simple;
	bh=LOCehs3NyBNX6D4TFTf28/f2e5fJ8mUEiXbIYlx4p/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5oXbq8lzSfQ4q34UnLrW2Sl/1ZjJuEfgRZ4tOj3a2IPhsF5B7LcsBBCVHrhfygiEGdm27xVD8/HISTgXKd2xyIE4KmNmVYGv04VjAfrkh0/Fox9nOADmmbyH68UEbU3fZnBJR/+oXzl2F3szafA7uwF3ZxESxpaWEeCSmxO3oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWjMNMwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWjMNMwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E81EC4CECE;
	Thu, 12 Dec 2024 15:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016577;
	bh=LOCehs3NyBNX6D4TFTf28/f2e5fJ8mUEiXbIYlx4p/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWjMNMwaKjJFUdinkLsfH3oWu6xl6JyC/djUt1g1MhzibrD+PIwBIV5T+N2lP3SJI
	 wVH3UQpVFKsL9i8VuO+LBXSY8JAAtUY+a7BVN+1oamiC9WQ2755/W81v3/Hv8ZmAPN
	 PmMIjwjvhBdzTTHXibzzCIbHHSBpSadrLyLw8flc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Hutterer <peter.hutterer@who-t.net>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/466] HID: add per device quirk to force bind to hid-generic
Date: Thu, 12 Dec 2024 15:56:47 +0100
Message-ID: <20241212144316.185369784@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

[ Upstream commit 645c224ac5f6e0013931c342ea707b398d24d410 ]

We already have the possibility to force not binding to hid-generic and
rely on a dedicated driver, but we couldn't do the other way around.

This is useful for BPF programs where we are fixing the report descriptor
and the events, but want to avoid a specialized driver to come after BPF
which would unwind everything that is done there.

Reviewed-by: Peter Hutterer <peter.hutterer@who-t.net>
Link: https://patch.msgid.link/20241001-hid-bpf-hid-generic-v3-8-2ef1019468df@kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c    | 5 +++--
 drivers/hid/hid-generic.c | 3 +++
 include/linux/hid.h       | 2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 582fd234eec78..935ccc38d1295 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2674,9 +2674,10 @@ static bool hid_check_device_match(struct hid_device *hdev,
 	/*
 	 * hid-generic implements .match(), so we must be dealing with a
 	 * different HID driver here, and can simply check if
-	 * hid_ignore_special_drivers is set or not.
+	 * hid_ignore_special_drivers or HID_QUIRK_IGNORE_SPECIAL_DRIVER
+	 * are set or not.
 	 */
-	return !hid_ignore_special_drivers;
+	return !hid_ignore_special_drivers && !(hdev->quirks & HID_QUIRK_IGNORE_SPECIAL_DRIVER);
 }
 
 static int __hid_device_probe(struct hid_device *hdev, struct hid_driver *hdrv)
diff --git a/drivers/hid/hid-generic.c b/drivers/hid/hid-generic.c
index d2439399fb357..9e04c6d0fcc87 100644
--- a/drivers/hid/hid-generic.c
+++ b/drivers/hid/hid-generic.c
@@ -40,6 +40,9 @@ static bool hid_generic_match(struct hid_device *hdev,
 	if (ignore_special_driver)
 		return true;
 
+	if (hdev->quirks & HID_QUIRK_IGNORE_SPECIAL_DRIVER)
+		return true;
+
 	if (hdev->quirks & HID_QUIRK_HAVE_SPECIAL_DRIVER)
 		return false;
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 121d5b8bc8675..a7d60a1c72a09 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -359,6 +359,7 @@ struct hid_item {
  * | @HID_QUIRK_NO_OUTPUT_REPORTS_ON_INTR_EP:
  * | @HID_QUIRK_HAVE_SPECIAL_DRIVER:
  * | @HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE:
+ * | @HID_QUIRK_IGNORE_SPECIAL_DRIVER
  * | @HID_QUIRK_FULLSPEED_INTERVAL:
  * | @HID_QUIRK_NO_INIT_REPORTS:
  * | @HID_QUIRK_NO_IGNORE:
@@ -384,6 +385,7 @@ struct hid_item {
 #define HID_QUIRK_HAVE_SPECIAL_DRIVER		BIT(19)
 #define HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE	BIT(20)
 #define HID_QUIRK_NOINVERT			BIT(21)
+#define HID_QUIRK_IGNORE_SPECIAL_DRIVER		BIT(22)
 #define HID_QUIRK_FULLSPEED_INTERVAL		BIT(28)
 #define HID_QUIRK_NO_INIT_REPORTS		BIT(29)
 #define HID_QUIRK_NO_IGNORE			BIT(30)
-- 
2.43.0



