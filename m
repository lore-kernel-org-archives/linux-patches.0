Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F7833710E;
	Fri, 17 Oct 2025 15:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713670; cv=none; b=don66BDPSfdcirtBbIz0myNe6HO5IhuON+6qMraOpTDov/Rwo1mFRUSW2J9LJQbt28IaYbq87G4FXhCE0fSLl/GgBWHQR34P9LQVRY7FDSuVYwNrb5CVClIQ9f5EblhvbA6zzm6f5wo2VtiwfW9vKQLaarDPfyBLUBubzcChzlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713670; c=relaxed/simple;
	bh=+39OfO5iAHs+Ndaaby6J4/5cUG8WqaIP2iwnVf9SXIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6aDBRvmtmwcePyz/mKgFDOqzWi6fJU5klAhmDWBAEgkJhskY2gMhq7sNurOiw7xQTiTCLKr7mnau9sI9lu/1HV5WxhUdFOWU0VFkwWTRNMyC+17ZLOG1reIIqBEpgzHvwCyYAmmjsRtngDPOx+PP5vH3CWo/x2alfI+ZOoVTjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fO0WWb+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fO0WWb+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB4FC4CEE7;
	Fri, 17 Oct 2025 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713670;
	bh=+39OfO5iAHs+Ndaaby6J4/5cUG8WqaIP2iwnVf9SXIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fO0WWb+MjqUHwnsB/nB513JGANO0JxEO6YwJ4e7RWeBzdmUVfqSEcUkfu/SpotKER
	 ZMCAFVLmcT2UVm7FnId9WN4D+20dkk7oxkosulXx7k60HRLkPnm56Ikuzp13fKHHdV
	 1Bg9Ts6KxpjzsNV+8ZN2JAH03hivXHkyZMG4pBE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 077/201] media: lirc: Fix error handling in lirc_register()
Date: Fri, 17 Oct 2025 16:52:18 +0200
Message-ID: <20251017145137.585017259@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 4f4098c57e139ad972154077fb45c3e3141555dd upstream.

When cdev_device_add() failed, calling put_device() to explicitly
release dev->lirc_dev. Otherwise, it could cause the fault of the
reference count.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: a6ddd4fecbb0 ("media: lirc: remove last remnants of lirc kapi")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/lirc_dev.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -735,11 +735,11 @@ int lirc_register(struct rc_dev *dev)
 
 	cdev_init(&dev->lirc_cdev, &lirc_fops);
 
+	get_device(&dev->dev);
+
 	err = cdev_device_add(&dev->lirc_cdev, &dev->lirc_dev);
 	if (err)
-		goto out_ida;
-
-	get_device(&dev->dev);
+		goto out_put_device;
 
 	switch (dev->driver_type) {
 	case RC_DRIVER_SCANCODE:
@@ -763,7 +763,8 @@ int lirc_register(struct rc_dev *dev)
 
 	return 0;
 
-out_ida:
+out_put_device:
+	put_device(&dev->lirc_dev);
 	ida_free(&lirc_ida, minor);
 	return err;
 }


