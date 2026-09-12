Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F6923BD03;
	Sat, 12 Sep 2026 14:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224548; cv=none; b=Xd3Hs2YBiDex9jp2hEyzihjSCTf41atSC7R+pU7F4AXZ34cNlFgHakNwjbgQuBwkKnG2rIJX8ugessbr9vUeUDM5qyh+o4M7ORPfVLVlkmkQ6c6EL5uj8EDaOH6YJfR0VqGL9Wai7CeDNeEn+Z1tCMOof+AZfA4+YpYqmP18YJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224548; c=relaxed/simple;
	bh=fS7MHwLOUL3XI40lrgs1BZW59c2T5uTvW4jwCE9FxKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qC3FFIzJDD5Cg/AgXHKW4IjBPJ7NkW7XUM74slffVvkTgsM6IsbsGzsky2OKLFNtY0rzMSfecjZrK9ctzZqGUpdqkMXe+hP/xooHgwBfsiHMnP8wIDfFrRjq2MYRMlcGHg+RWrMqY+mNwhUiPfd+DgK4y3DuCuo5lV/TiAy63zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YB4JekAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YB4JekAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F821F000FF;
	Sat, 12 Sep 2026 14:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224546;
	bh=+QNUNMLnR3MYf9Gy2ivF1mRzYJicnO+RQ3mejoSttbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YB4JekANr9CAF32emp1bUmolSq4ZtlDyuBMbA/if1+bKTG3YPAYihDG2GeH6L9e/x
	 J24LieDuxG0DUQhgXZfheQJKIJKia8LEscRF2yvloDr9FeW7DpKurjr/wj1gKwvgA4
	 NfR+zJum71QQjV1245XDM4eYFUV/nuCcOFNC+ftU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9eebf5f6544c5e873858@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1016/1424] HID: synchronize input before cleaning up a failed probe
Date: Sat, 12 Sep 2026 08:57:28 +0200
Message-ID: <20260912065630.064843978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 241dfec35d1c0..446ed394dc488 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2701,6 +2701,8 @@ static int __hid_device_probe(struct hid_device *hdev, struct hid_driver *hdrv)
 	 */
 
 	if (ret) {
+		if (hdev->io_started)
+			hid_device_io_stop(hdev);
 		devres_release_group(&hdev->dev, hdev->devres_group_id);
 		hid_close_report(hdev);
 		hdev->driver = NULL;
-- 
2.53.0



