Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5252939E16B;
	Sat, 17 Oct 2026 16:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253778; cv=none; b=k3QlKLOHLBAk75zz8Q3dLbxPNUbhf+Ii2xfeQe7O81iYNnPg3sHToUax/+W5KqSaEHnPDESoYPIAyxgfXfcExH0LTnS4ZLg0sNTsEjixuc7Gfvr/IYCETuauzRP9kCCWiKb1URRySS5ybDoaoAYAE0M2KljeGYnudYM7cVonb+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253778; c=relaxed/simple;
	bh=KoxdW7JuXNA+kPKpEebDZYiN9azpCqqc9aHckjM3ovE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kA9SD3cBKT7asPpLThFx5Rs6JiFp3f8jHNvVhzPT2Y43nn+og6ZmGkvNM4CfMMMhDmR9Q5lJFtFbE9i3+7kRmJDf1X8L9S9VzDWMWLeIdRJ/zkr0RlaU+uLJ7g57cVtR/4gFFu4kBJChrACB/npvyM2cU5OTfic/9zhlSZqidKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvTzI346; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvTzI346"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994C81F000C4;
	Sat, 17 Oct 2026 16:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253776;
	bh=SDYKU/VdN010gSZm1agCm4rJFLyC49DCl/HyGh2K79U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvTzI346afSjmfqunZ+nopqQY4EGUxiKcmhdMkrGeF7lU2dyg+dyDuUE38sAoKmCF
	 a+/qG6Np9Rm13/WC5WgzfMJMijPgbMPvHlbnnG9DOdDY1u3oI3ppj7FLIN9+c6Ouj2
	 kM1/6BuTUFPNKFcjD9aU91lK7x8AhyzO3oDBPz7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/869] HID: core: Mitigate potential OOB by removing bogus memset()
Date: Sat, 17 Oct 2026 17:51:10 +0200
Message-ID: <20261017160042.921016090@linuxfoundation.org>
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

From: Lee Jones <lee@kernel.org>

[ Upstream commit 0a3fe972a7cb1404f693d6f1711f32bc1d244b1c ]

The memset() in hid_report_raw_event() has the good intention of
clearing out bogus data by zeroing the area from the end of the incoming
data string to the assumed end of the buffer.  However, as we have
previously seen, doing so can easily result in OOB reads and writes in
the subsequent thread of execution.

The current suggestion from one of the HID maintainers is to remove the
memset() and simply return if the incoming event buffer size is not
large enough to fill the associated report.

Suggested-by Benjamin Tissoires <bentiss@kernel.org>

Signed-off-by: Lee Jones <lee@kernel.org>
[bentiss: changed the return value]
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index bf9cd8c7e4c5c..52eda362bb1a1 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2061,9 +2061,9 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
 	}
 
 	if (csize < rsize) {
-		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
-			csize, rsize);
-		memset(cdata + csize, 0, rsize - csize);
+		hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %d)\n",
+				     report->id, rsize, csize);
+		return -EINVAL;
 	}
 
 	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_report_event)
-- 
2.53.0



