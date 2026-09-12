Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5826A1F1534;
	Sat, 12 Sep 2026 08:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201524; cv=none; b=U2oiOr/G4Qmy7uNqiqCRwZ4jevuO8arzh0U9dSnNbmPO80a/b20oO4M9CEu3XKGsT4XAzat37YtkpC/K4/EcIhRpGr7mbOLvN09epaXd2rysOFf36WJt6A5atiXgSwH3fHHoOJhasnWEx56zKCqFD1lM3rTMsVJTgHqdGwwiIqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201524; c=relaxed/simple;
	bh=iCdzkPkgLi0aQyhi53yKTWbhy7bH1Hg/dFZQEAlSlyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5r0F9WYAHkhbzV/VSRrON2DlJPUfM+nwSDXvcE8qL/hL0NV4J/Ob+61W22p3hS8yEXvGdnEg0qUoozf6jNBMBaMQLpzAqE2s/uioa3lJvhr3SuhkRvn8XzGdyhtHwWcxFYQ+unqsJdWbFDlN+OM3iNMJ2q3gmb5ovm/X2cNkpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1h/mzLd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1h/mzLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB14C1F000FF;
	Sat, 12 Sep 2026 08:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201523;
	bh=djQZOr5MHo59E8fOYWdBztF/0RbL+vjbpMMINlp2BkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M1h/mzLdPawCCDsNIDGfXsDxEMky8SsjDcoim2bdSv9KitYsUBzQsCQTycoOwsT+O
	 UQi/DfcNG+K79tpQxRwMuwz00qj1/vobNosddPFoYLHB/sV6nkkJKVewohEjfxYKau
	 qs3iE7swc1Bej0yrekUmUhIsXbTntlWG9Holj7bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+75f3f9bff8c510602d36@syzkaller.appspotmail.com,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1014/1815] HID: steam: Reject short reads
Date: Sat, 12 Sep 2026 08:46:04 +0200
Message-ID: <20260912065712.814799058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 33ff7b49c38b39b1f3d27db508ac0720fb25c08a ]

Steam Controller FEATURE reports encode the size of the message in the
message itself. Previously we were trusting that the size reported matched
the size we actually read, leading to a potential issue with short reads.
Instead, we should actually verify the length of the read.

Fixes: c164d6abf384 ("HID: add driver for Valve Steam Controller")
Reported-by: syzbot+75f3f9bff8c510602d36@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=75f3f9bff8c510602d36

Signed-off-by: Vicki Pfau <vi@endrift.com>
Link: https://syzkaller.appspot.com/bug?extid=75f3f9bff8c510602d36
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 3383a62646f9e..80d2eabc930ec 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -356,6 +356,13 @@ static int steam_recv_report(struct steam_device *steam,
 	u8 *buf;
 	int ret;
 
+	/*
+	 * All reports start with a two byte header.
+	 * We must read at least two bytes to get a sensible output.
+	 */
+	if (size < 2)
+		return -EINVAL;
+
 	r = steam->hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[0];
 	if (!r) {
 		hid_err(steam->hdev, "No HID_FEATURE_REPORT submitted -  nothing to read\n");
@@ -379,16 +386,30 @@ static int steam_recv_report(struct steam_device *steam,
 			buf, hid_report_len(r) + 1,
 			HID_FEATURE_REPORT, HID_REQ_GET_REPORT);
 	if (ret > 0) {
-		ret = min(size, ret - 1);
-		memcpy(data, buf + 1, ret);
+		/* Remove the report ID from the return buffer */
+		ret--;
+		size = min(size, ret);
+		memcpy(data, buf + 1, size);
 	}
 	kfree(buf);
 
 	if (ret < 0)
 		hid_err(steam->hdev, "%s: error %d\n", __func__, ret);
 	else
-		hid_dbg(steam->hdev, "Received report %*ph\n", ret, data);
-	return ret;
+		hid_dbg(steam->hdev, "Received report %*ph\n", size, data);
+	if (ret < 0)
+		return ret;
+
+	if (ret < 2) {
+		hid_err(steam->hdev, "%s: reply too short\n", __func__);
+		return -EPROTO;
+	}
+	if (ret < data[1] + 2) {
+		hid_err(steam->hdev, "%s: expected %u bytes, read %i\n",
+				__func__, data[1] + 2, ret);
+		return -EPROTO;
+	}
+	return size;
 }
 
 static int steam_send_report(struct steam_device *steam,
-- 
2.53.0



