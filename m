Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEC12EBDD6;
	Tue, 15 Jul 2025 13:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587676; cv=none; b=DzkY1FmnicvN7fyGiTHz2YGn7KRvksWYbOGVPLihDTCqngacAzpLT3+0g+Ksy/6VXpdiUI3Cr0FbJsFU/0WssyW5n8xc1Gwrg/wC7tL+GZrTlwkJQ9W9T1Cfc82OLjaPc9PCn1FyYGNHDQckJaTyPL2yEZbleqPpH5BL4aHzjhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587676; c=relaxed/simple;
	bh=SiKAou7/M44cB+Vx4AY8QfzMcvUMfUi8WR4Rw57U8EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdeMI66CLQy9XuLrAr4vNwBO2/vzD89C/WmByaPQdWFhVH1d811HdecYam/WWaboHZF992mhoSPTgCT2hZTcexxCcaGTLxX1kfnClCtAt2RylAQCWI6dF5ZRfvjGiF6rOj1OnyD2+xIFzAy8+kPNl+N0CKWs63/1Q/KB3+1eiwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJiTYB8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJiTYB8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D494C4CEE3;
	Tue, 15 Jul 2025 13:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587676;
	bh=SiKAou7/M44cB+Vx4AY8QfzMcvUMfUi8WR4Rw57U8EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJiTYB8w6zLhfiQrr87DTY3Vt65+7xORtg93gMF0fSo9Dvg6utXmYFlFckAaEVtFM
	 zPVHzO5k9fqWnqNkgxmk0gFu7dSkzgXWAC51jcSrWJScan2kR8qOQG7d61+CtA55+n
	 mv8ewK3h28rM3Fx28X2Eu5HriKKTZSMoJ/J/xSmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 060/208] HID: wacom: fix memory leak on kobject creation failure
Date: Tue, 15 Jul 2025 15:12:49 +0200
Message-ID: <20250715130813.355165601@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


