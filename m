Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C84364059;
	Sat, 12 Sep 2026 08:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201702; cv=none; b=bhoctsE3XFI3NMLnZWHrAFs+QTNLichiBvvQKnj5FthkCKO7uSVQHaN8wekiHJPAe14j3GrIZHTEuk4JZ3gy9LU4sAc2K/ljf4Wm7DLZm7tESg8EYiFb0c7CmzxWiD9F1F/Q5EBGalOor2EMGh2JDlBWGUTG6jrZImApe7HZkVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201702; c=relaxed/simple;
	bh=nlxiQe3eiE0UOEpcuBdT8WcdeSR7mVXXBgVnLVmSHXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrmIuCXLaUsKG8INrwARBQ+nDA4I2EvdZJTdJCJ1vzBkjQbUlHoF6BopRHYs7UK00H0Vx2TZoLDnLBmD1fi8diFvXFSBF1LwoyvVwAncVuUE450Uzo7hhiRj9ajn7DJUEoosl53CsGpjza2fEhXNYlm4kMpCE8kFeJ9tjszb640=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvVtxIp1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvVtxIp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FE31F000FF;
	Sat, 12 Sep 2026 08:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201701;
	bh=A9ACAwbTrCtt10kDPfDtpd8ZFNuR3KCi+zaAeBzy3aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TvVtxIp1inqKXk9TuKFCTNbzJ8tw8qu12QtFIroyCudxg4Ua8hyPIvhf/X9lxZKpY
	 9RkeldLlgVUcx2I7SJeffFo2ZP6pbSM4W8GJgL3qTAzk5SqMHMTrCbWp1+sL9+95Ss
	 43hmFimvoo4xKC33fwA216hhCM43Tws+NfqGNkvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9eebf5f6544c5e873858@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1008/1815] HID: synchronize input before cleaning up a failed probe
Date: Sat, 12 Sep 2026 08:45:58 +0200
Message-ID: <20260912065712.672136316@linuxfoundation.org>
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
index 5add6c9f2807a..14a06ab435a23 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2856,6 +2856,8 @@ static int __hid_device_probe(struct hid_device *hdev, struct hid_driver *hdrv)
 	 */
 
 	if (ret) {
+		if (hdev->io_started)
+			hid_device_io_stop(hdev);
 		devres_release_group(&hdev->dev, hdev->devres_group_id);
 		hid_close_report(hdev);
 		hdev->driver = NULL;
-- 
2.53.0



