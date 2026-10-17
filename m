Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF71C3939A4;
	Sat, 17 Oct 2026 18:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260105; cv=none; b=cdLDBayBB/wRAmdXsYBy5TRZMsdEkEwwqVIbLnaK73pJ2pWigTHub1XdoZ9YBG6I1sD1a/kY7BuZT7HVctBTY3Y5eEG58MXMl6JS30KVKKNrLHK85zx/1Vf3n7KwWc1LxjSaN2SCMvhg8CEy5UDRB/d6lmLRSPD/CzIAbJKTfW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260105; c=relaxed/simple;
	bh=QuaEmnKEERwsv9M3ecQBnKneWQN1YRZDvsVPGmptvq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrADudr0HFMWvMKjwnKLOcwR9FyrlDEtNKgWvSevvYAoRu6zsw4Z08NIlh+mJXMnMSZXbDOrmBu5fbnMxn/0g//5FNQIwJ1njH5nW9TvNPAHDV2tlr/rhQT+gq8pMWU4MOY9lGOP250uy911vFh1S3NLm65E1be6SL0+2IAnLVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pg3af/xE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pg3af/xE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C25F1F000C4;
	Sat, 17 Oct 2026 18:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260104;
	bh=W5dfDjEVEr51Yy1m2vX+JzFRY1dl2XBXOBaoEtQlkBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pg3af/xEwzLgggoCP1qGDN5fM9SF9N7SPM4IJnK2OUqlKcFxU7bxWUIp/WuJX3+T8
	 bwvvzYw0T873NXEZPihGnnGstRko5GcopMgARQi712CCXSvjvIph3w3NPGHk2fcpBm
	 08Kja65IEL33sz7aSmo8FvV7ZSZQ3Od4VvUrfVQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+75f3f9bff8c510602d36@syzkaller.appspotmail.com,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1435/1674] HID: steam: Reject short reads
Date: Sat, 17 Oct 2026 18:01:47 +0200
Message-ID: <20261017160508.016434806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 drivers/hid/hid-steam.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 61e8070bed3f8..9086bef42be56 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -323,6 +323,13 @@ static int steam_recv_report(struct steam_device *steam,
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
@@ -345,10 +352,31 @@ static int steam_recv_report(struct steam_device *steam,
 	ret = hid_hw_raw_request(steam->hdev, 0x00,
 			buf, hid_report_len(r) + 1,
 			HID_FEATURE_REPORT, HID_REQ_GET_REPORT);
-	if (ret > 0)
-		memcpy(data, buf + 1, min(size, ret - 1));
+	if (ret > 0) {
+		/* Remove the report ID from the return buffer */
+		ret--;
+		size = min(size, ret);
+		memcpy(data, buf + 1, size);
+	}
 	kfree(buf);
-	return ret;
+
+	if (ret < 0)
+		hid_err(steam->hdev, "%s: error %d\n", __func__, ret);
+	else
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



