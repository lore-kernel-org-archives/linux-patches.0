Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219E2428498;
	Sat, 12 Sep 2026 10:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209568; cv=none; b=AT9Dc6EfjbkrmXKZ8edgGQoisFLUgrnErFwN5Nhkjy3GWTdGuzA1AMQaxcCZ2FdFwp38owJAWGB33ZKevZ/9JRwTP5Pn+n3XAUAh2bfnu7nT4m+4TdgKiWxFWsWa0AuWCP11rBeULxSeLfLbRps0HkE/nr15mU1zRq6MVqLAxE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209568; c=relaxed/simple;
	bh=vWGz4o2Rd4i3G9hLMgdH2KK5DZ4JJ9KbAv7cUS+Q9CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSFX7tcLv4Wkt7SWzy7R7sanonIn4Hb5FXWUYplAkS9GYy1H4NAMAQmealiA5bWadu0QaK6UgwyqiZNvzfQAouf3Kj8uZGheSzK8oPEgmrTaM0/DC+OoVfRrHABuOZ8WXfXdkJTqXurwtqAjWgVDMFIC6sAP7cuiMSiMVYCoDas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gABWtxZr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gABWtxZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232FA1F00893;
	Sat, 12 Sep 2026 10:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209567;
	bh=sf2z3i2PiLNZ+R65aKbq1SY+RZas2JloNZ7lIVyJ1II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gABWtxZrOe49qUzEUSq/K1VuaG9E4rFCZ37BJ7YHrovvNsmWRvy8Zkj0nP+sgKqGn
	 1OXgF4Nj8vcBKKAXAtrkRTJgFmsPm2oZuXRk5bZ9JU+nVpTSwbhr5VlTGOlhjQwzbM
	 0FTCunrBKwM1doxWaCa9uK4WJvw3lvM9RltzngFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+75f3f9bff8c510602d36@syzkaller.appspotmail.com,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0847/1518] HID: steam: Reject short reads
Date: Sat, 12 Sep 2026 08:50:16 +0200
Message-ID: <20260912065642.605842570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



