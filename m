Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45E636AB6B;
	Sat, 17 Oct 2026 16:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255095; cv=none; b=ZYzm9wK8OOcpSE0M4LcIsStBqIlK5nhIT/6vOtkbIXQDRp/ZUoKvLMJJmeq2bwx9Fcorva/7aYUg3FGAD0pxWbGHVl3wdskO1LOmDkIpEPpKxFLg44N/ITe3GhMvqIEOtdk31OerLBN3z+4g9SyzF9oUABBIenafpmL7yD4ucWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255095; c=relaxed/simple;
	bh=V9WGJ7+bTSoAMwRQ5f8B1via7X8VnKFQZwL7vz2D+7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzWAqE8BEJ+J/o4nWAExtJNfC4Bnx5/d+IzJ+YaIzeh1GcKdUJgrFiqnRQN3DiJp+2bB6ISFBCpLBCrPldSaPjX7uV7/eULf4Y0qxr1hQsN/5d6jjZoHAL4Y20OMkPFkUIkUk5ic646T0RclXfa29UaK+kcbYygWZtuKMJarFaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cogkqvRJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cogkqvRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CB91F000C4;
	Sat, 17 Oct 2026 16:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255093;
	bh=D+UKx5JcWlUedkvE4IQ2ueghuDGho8aTbD7qS/BHcv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cogkqvRJl+9T0RvJgS+fsW5Iew+pi27COzCjnOKdu3IhiHNmMgotfci523xSaeVh6
	 j76hEGdpg9r1xHa5vMRBJ2QAS8iBv56XR4r8fGrXnTWXjAPWvD89OrRKNFAI7gGTNs
	 nVsbv+DVfJ04C/OxpsKQukP7JYKe1oWLiNUYIGjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+75f3f9bff8c510602d36@syzkaller.appspotmail.com,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 664/869] HID: steam: Reject short reads
Date: Sat, 17 Oct 2026 17:58:25 +0200
Message-ID: <20261017160054.018651238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/hid/hid-steam.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 0f826acfbf275..4283219275a3d 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -324,6 +324,13 @@ static int steam_recv_report(struct steam_device *steam,
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
@@ -346,10 +353,30 @@ static int steam_recv_report(struct steam_device *steam,
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
+	if (ret < 0) {
+		hid_err(steam->hdev, "%s: error %d\n", __func__, ret);
+		return ret;
+	}
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
+	hid_dbg(steam->hdev, "Received report %*ph\n", size, data);
+	return size;
 }
 
 static int steam_send_report(struct steam_device *steam,
-- 
2.53.0



