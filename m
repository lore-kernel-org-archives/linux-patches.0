Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25F4390990;
	Sat, 12 Sep 2026 19:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242954; cv=none; b=Se+H5v+BGdu7dXsF871LjorUtuNnNX+4i/SlyvgqNBAWMDTE1jmFKTJ5/w2wWoM51d8znNkrpDUgIvH3BddsblU3cHIhkUXAa0+DBrBoOKCtw5eNpbgganU92Xnh5Qw5DegfWeCBuvnkvk+v7TaH36tro8TuWKu60ramTKEwkQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242954; c=relaxed/simple;
	bh=UMRjgytA2EcxCOLnaludV59MTm8KuVadvnQ5xuVfGBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Shjmr9K7L5DyTP32b2U8JP2Uc0MjiA/rqMG0c8AkNCOsZ6eoyksz72Hn+N9b/FR8YVhhuZ1J0bRGZa7Iw88WcplGF+LCIiB0cDV98XsIUnR8EpNf4vJnRt9/mbTZVPCHmfhvAt4aHT7kBd3ZzCATo3yhxNpTDmyYxv8oUHnFOfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5YtySnF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5YtySnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF93B1F000FF;
	Sat, 12 Sep 2026 19:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242953;
	bh=eI2eHbLtF31A+ei2WG9QyWY7k89gmmscExdfL/81eFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5YtySnF8gVi5ShCll7AK7vejZ3UGZh0JUnh9W7KWEdSxz32T3T1F11qvBYnfvRu3
	 NJB5gzASkDzHOeC7aAsWizDFodr/jJKhKs8t3cNJJRsWiQWEGwOrrJ43sviqeEuluK
	 qJ1cI/hFZV13ZpmjMFI4HTyP4MD4n2HYMLRsKCeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiancheng Huang <jchuang@seu.edu.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 585/798] HID: lg4ff: validate report length before fixed offsets
Date: Sat, 12 Sep 2026 09:03:33 +0200
Message-ID: <20260912065530.533115292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiancheng Huang <jchuang@seu.edu.cn>

[ Upstream commit be00988cce4ed44db1e61231d0ab71a64bab44cd ]

lg4ff_raw_event() rewrites fixed report offsets when combined pedals are
enabled. It currently assumes that each product report contains every
source and destination byte used by the rewrite.

Return without rewriting a short report before each product-specific
access. Apply the same bound to the computed offset path.

Fixes: c832f86effbc ("HID: hid-logitech: Add combined pedal support Logitech wheels")
Signed-off-by: Jiancheng Huang <jchuang@seu.edu.cn>
Assisted-by: Codex:gpt-5.6-luna
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-lg4ff.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index e3fcf1353fb3b..71f168eff29b1 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -336,6 +336,8 @@ int lg4ff_raw_event(struct hid_device *hdev, struct hid_report *report,
 	if (entry->wdata.combine) {
 		switch (entry->wdata.product_id) {
 		case USB_DEVICE_ID_LOGITECH_WHEEL:
+			if (size < 7)
+				return 0;
 			rd[5] = rd[3];
 			rd[6] = 0x7F;
 			return 1;
@@ -343,10 +345,14 @@ int lg4ff_raw_event(struct hid_device *hdev, struct hid_report *report,
 		case USB_DEVICE_ID_LOGITECH_WINGMAN_FFG:
 		case USB_DEVICE_ID_LOGITECH_MOMO_WHEEL:
 		case USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2:
+			if (size < 6)
+				return 0;
 			rd[4] = rd[3];
 			rd[5] = 0x7F;
 			return 1;
 		case USB_DEVICE_ID_LOGITECH_DFP_WHEEL:
+			if (size < 7)
+				return 0;
 			rd[5] = rd[4];
 			rd[6] = 0x7F;
 			return 1;
@@ -366,6 +372,8 @@ int lg4ff_raw_event(struct hid_device *hdev, struct hid_report *report,
 		}
 
 		/* Compute a combined axis when wheel does not supply it */
+		if (size <= offset + 1)
+			return 0;
 		rd[offset] = (0xFF + rd[offset] - rd[offset+1]) >> 1;
 		rd[offset+1] = 0x7F;
 		return 1;
-- 
2.53.0



