Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B382C08D0;
	Sat, 12 Sep 2026 18:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239569; cv=none; b=IyaJuCHed0o9gByzDYZMvPbmJWENagw906UoKEJVGpZ/tk1+zmXM0nyw11+2/8mifrg2otmS+DB0QfSC/pSwOVRntv8NDVy+FJ9FbCIGhIzBYCkdoNflF6W36Y+1BS12tFSEEzE+CgGkGAPMBSeO7RExB2WGz/LgGPoeBfu49B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239569; c=relaxed/simple;
	bh=XUlLRsD2VgZHGZXUcQ6ZJefRyTlp4hCn8UXsyNjdirI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjYh+YR7De9jSCU4so0VqH25HTs4nnXHoER5RkkYCRHDYLocnpu3i0vf6f5DsGz0BPYMuPPqw5HtCkUPf/JB2t3etZKCzyVtlbTVC4ic0WFGAW+bNbOg6eMMXXGPN6zHqHzUDo7eBhiZJQn68RWBz3tVx1TE9xz9Qj+LWo4uKhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/GNgiVf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/GNgiVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594A71F000FF;
	Sat, 12 Sep 2026 18:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239568;
	bh=HXJzjqfj4l/dF5mNRFvWYdMtBd78VjB6uHv/QTITlZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/GNgiVfUnWZRN+tfAgdu8hRZM4NOu3vukCf5oG4AMpS0W8nFywtSpA/l/A62cQTl
	 xaQyme1ii0KCkl7P2/KLD/oNO3h5e+ldwPUtkWgez1Cq45i8vY+//l2FftEFpDDgRm
	 Tx5o6w6zlhAtjFPBH7qbgVeUsrz9AWmp3XdvUTec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9eebf5f6544c5e873858@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 674/935] HID: synchronize input before cleaning up a failed probe
Date: Sat, 12 Sep 2026 09:01:44 +0200
Message-ID: <20260912065542.301129416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fa9aea45d2c0b..07b4bda8e2c9c 100644
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



