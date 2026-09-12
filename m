Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225C229D288;
	Sat, 12 Sep 2026 19:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242946; cv=none; b=IeJT3rB5UFmBJpS1cD79n92T/1mJH2nK0T8APY6OpHYgkd0zS4aiAMNwsmDBewlnHjrOuDBL+2ymlBRy70wiwRhgX2Z5xXCNEM3dNCG6xYun4YU6SGwBF8D6QKp3Ix8eYajJB+UgzbcypJ5RPzMxWiTIH9p28In6NJW16XSUhAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242946; c=relaxed/simple;
	bh=De46YE2dBm3oubU75ZpwpNgsQigiu91vj1gki0oYukw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8Uw7e4O6VOOU+FHDng8ie7/S1PhAzG6ieFtIJPkwJnu+Pe/UOQSWT40cTbJImAEsEmBd/SCdiiS1CfQ+1kkjSSa8TrOBVXmFVjArxA1/JcMnmMhhuynMJoA9pP8BdsGC8Jeb4ZzqXd0bFWEZGsGVmUkPXvFIZu4cFxwOfb+Li0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKYUyGz9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKYUyGz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D23A1F000FF;
	Sat, 12 Sep 2026 19:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242944;
	bh=EEAukrTvKyqpAJv98ozNBsAtSGK15YwHau3jgb1jYeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xKYUyGz9sWv9b9hHJcIWrerwGVO69erWmS3W+CYLC7knTRxJYiuI9X9XhxLuVIMOz
	 Eag7MLj6u6bhZyUkMKS6fZ80MkrZNnAgGQsYBaIFTyleiMFKeEZscfNhIFpvOfnQCW
	 SLV7V8h2xBZU1Z7T1q1IygmL0XjriW5B9UzN/PDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9eebf5f6544c5e873858@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 582/798] HID: synchronize input before cleaning up a failed probe
Date: Sat, 12 Sep 2026 09:03:30 +0200
Message-ID: <20260912065530.467981606@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 207853d46f7ef2e28042344a1468da8754c3ddbf ]

hid_device_io_start() allows reports to run concurrently with probe. If
the probe subsequently fails, __hid_device_probe() releases driver
resources and clears hdev->driver without first excluding those report
callbacks.

For example, a report may enter hidraw_report_event() while the failure
path frees the associated hidraw object, leading to a use-after-free when
the report takes the object's list lock.

Stop input before performing failed-probe cleanup. This reacquires
driver_input_lock and waits for any report callback already in progress.

Fixes: c849a6143bec ("HID: Separate struct hid_device's driver_lock into two locks.")
Reported-by: syzbot+9eebf5f6544c5e873858@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9eebf5f6544c5e873858
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 68d1b9bfb6441..4b704d98b019f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2368,6 +2368,8 @@ static int __hid_device_probe(struct hid_device *hdev, struct hid_driver *hdrv)
 	 */
 
 	if (ret) {
+		if (hdev->io_started)
+			hid_device_io_stop(hdev);
 		devres_release_group(&hdev->dev, hdev->devres_group_id);
 		hid_close_report(hdev);
 		hdev->driver = NULL;
-- 
2.53.0



