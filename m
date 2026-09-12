Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECDC19D8BC;
	Sat, 12 Sep 2026 10:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209534; cv=none; b=ZiOOaktyLCbAEFle/c2NeZQw4baCSciWFNc2VHAN/oHxW+uxoC96aXYfCNMITmE73dp4mOkrzg2tVp9OfpabJ7lEtn3w8MzBdNENPbo4NezI/QpKCTMgsFtRiJNasMta8XkgeBNPHrBdYZDbUP6Q5LbdFxpH/gmvPnbrEIziAww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209534; c=relaxed/simple;
	bh=oA9XjsFxcRsVHP/b1R8YMFH1FFhvnzo/EwVsVmUel2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=albLY28Ynxx+xYWwMRVNi26UTvCMiJQd9RO/0UfkWj4x+8KqiKMXhCxPlJ/kvdMJ3FC7dzpnNqwi+lRVMRVyN85pL2b0uaHaGmdv+zEpt4F1AxBNiN/k1xzeqW6FbUof/e33sjStaGTmRqAtAr4yHbgDzAPoO0PYKsiOYYc7zdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yk/PGq2N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yk/PGq2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572601F000FF;
	Sat, 12 Sep 2026 10:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209533;
	bh=2vG5KAw2tAMDKh6w+qdthU9wvFujvVN9W7s13GHm36A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yk/PGq2Np7FLsBglJ5mpNS+OASIuW/1b6bnEexxvjVrzT9ReTzSRKXDjCE04nFIF/
	 ksj3iaVGU2l5X44DTW6XnpxONdmza8j12FjPI+1mtviWuk1RRZ+vQsaqesxbrw1ply
	 TPBPEi/0ZHE3EK0vhIczgaM7aiuTB0gC1Okvw/1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9eebf5f6544c5e873858@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0841/1518] HID: synchronize input before cleaning up a failed probe
Date: Sat, 12 Sep 2026 08:50:10 +0200
Message-ID: <20260912065642.465042764@linuxfoundation.org>
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
index 55990d17c5669..78adb5a48a612 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2852,6 +2852,8 @@ static int __hid_device_probe(struct hid_device *hdev, struct hid_driver *hdrv)
 	 */
 
 	if (ret) {
+		if (hdev->io_started)
+			hid_device_io_stop(hdev);
 		devres_release_group(&hdev->dev, hdev->devres_group_id);
 		hid_close_report(hdev);
 		hdev->driver = NULL;
-- 
2.53.0



