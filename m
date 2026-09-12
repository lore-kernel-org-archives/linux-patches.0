Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F563446AD;
	Sat, 12 Sep 2026 12:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217052; cv=none; b=HKNP7UC+sN+cXpXfIOA8Dt1v7Br8bTlamqA1yvll6WGdNh5Wx9/nNR1GaFuMg+GYjRcTOrc3G6sOau8UixDBkOTqlRigqIk+wV4zTPGPgUyFxFor17xzvxvMJAPYSFvmu40ILUMtWQ6YYLQQvVhreCU7Y5fMj/DS4zYi0K9fCZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217052; c=relaxed/simple;
	bh=vvUvc91uKGfAda2ZJPY4XoAQPEYAVGcrek1eaZt87Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCQ0G18no5Ul9XMeTumqQJQH41pPzl+NFC/Yw0NzygtuITuRioMB9JuwxW71wH/889fXAcj4qUzq5mKGoD84fr1vY2SpP+hzxpZcK4ugl12jAP3Ywlkj5ojJ5hOkqoREc6rDupgocoxtpzt7/1NchSyJKY/fGeXs38PkW3+rIbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTfhQuLc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTfhQuLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D894E1F00893;
	Sat, 12 Sep 2026 12:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217050;
	bh=4BCiLNaLyY2vFyykUNg2iHEchfG5PEckNrPqo8sDXHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lTfhQuLcAP8lXjw83abv/E7fnwPOgi5gIKIwS+vGpbc4JwjoAy0ECPnosa4nuDMgN
	 e4S40fEZ5hQFl+k9l4BXr0DMRlFsHNuZUSj2E4OPP/DqXsrWpg7bIYn2qgj2R+lrCg
	 LlDYWk2umfc8k0dYIR1np4JCJIQm9UBUH921quuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9eebf5f6544c5e873858@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0862/1376] HID: synchronize input before cleaning up a failed probe
Date: Sat, 12 Sep 2026 08:54:48 +0200
Message-ID: <20260912065626.772031645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 5c33e1a0aef3c..df2e43b27388d 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2780,6 +2780,8 @@ static int __hid_device_probe(struct hid_device *hdev, struct hid_driver *hdrv)
 	 */
 
 	if (ret) {
+		if (hdev->io_started)
+			hid_device_io_stop(hdev);
 		devres_release_group(&hdev->dev, hdev->devres_group_id);
 		hid_close_report(hdev);
 		hdev->driver = NULL;
-- 
2.53.0



