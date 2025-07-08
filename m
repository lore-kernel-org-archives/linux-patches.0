Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87192E5412;
	Tue,  8 Jul 2025 17:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994045; cv=none; b=L35yZJZrHzs6kiHvzTpuNJYeizy/M2s8H4Ko16WWHWZp5o2K6cxCroXekcRNmRhHN7mdvh1R6VudrC1tsV6b/F0GHDpWzEbCSS4Ueak+q6mBFmXuiXvrvmNR63Qql1wMLyJo2NvvGLq8tQONLy2JPwWWWBR7jKWTJ3NInuttZ7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994045; c=relaxed/simple;
	bh=x6jzcryHhfbhIQw0BdUb/g0XNDJpWc3NJfM8d1YwMe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kq9KbnK0/jWr7VoOMKCrcJLm390eGTcIL1ZWsZA4p65Epd/tw8N/+b7DzBRIn1udTR6KqJ2OQAMZ1ZDKbPZaqqsA/a62yiEAPIF8NXT0iH48/klEKmRgIgoU6PdByGT0q9UngOhwkLxaVKUSEswDMVukW4/KUZfwu7QZJZBBpeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irEQYeZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irEQYeZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A66C4CEED;
	Tue,  8 Jul 2025 17:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994045;
	bh=x6jzcryHhfbhIQw0BdUb/g0XNDJpWc3NJfM8d1YwMe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irEQYeZqcW6cSwI/iPAsB1SVYmVW9fywiI38MKEVjizPDTHGO+dAy5YU1hSBEXRjC
	 7Oa0T6+c2b0sjH02p9tiOQscpG5yq6U+VKy6qLRuc7YBKgsXGT3DqO+MTuFU4w/eJn
	 +IwURRq877uj63ZkIx88BvNJ0s2C/ALpdomLqvu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 077/160] HID: wacom: fix memory leak on kobject creation failure
Date: Tue,  8 Jul 2025 18:21:54 +0200
Message-ID: <20250708162233.676901775@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Qasim Ijaz <qasdev00@gmail.com>

commit 5ae416c5b1e2e816aee7b3fc8347adf70afabb4c upstream.

During wacom_initialize_remotes() a fifo buffer is allocated
with kfifo_alloc() and later a cleanup action is registered
during devm_add_action_or_reset() to clean it up.

However if the code fails to create a kobject and register it
with sysfs the code simply returns -ENOMEM before the cleanup
action is registered leading to a memory leak.

Fix this by ensuring the fifo is freed when the kobject creation
and registration process fails.

Fixes: 83e6b40e2de6 ("HID: wacom: EKR: have the wacom resources dynamically allocated")
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2020,8 +2020,10 @@ static int wacom_initialize_remotes(stru
 
 	remote->remote_dir = kobject_create_and_add("wacom_remote",
 						    &wacom->hdev->dev.kobj);
-	if (!remote->remote_dir)
+	if (!remote->remote_dir) {
+		kfifo_free(&remote->remote_fifo);
 		return -ENOMEM;
+	}
 
 	error = sysfs_create_files(remote->remote_dir, remote_unpair_attrs);
 


