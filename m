Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861C02D6612;
	Mon, 27 Oct 2025 18:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590726; cv=none; b=WvSsAiwpx7xHVVBWSSGWUSf1h86T6If8yhHF7cHKy/k9O1yqgM4NFeXYRgZnDQXGG4jMj0ViSMLZh32qCdqUXcwGB14Qk8xPEy5FE3OQQptBeSrBXrt7zcRY4w9ricapLGAOHYhVNVTPMS1rJsJ3A4EEqANeoB9kyp9RN1SUHPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590726; c=relaxed/simple;
	bh=oggotWLO8yDqXE28MWuF4eXv6Rca7MK6f0yiC7ExPlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGy8ttma2th0WPfHE1aE4ly1RxYEKHnz/zELlxT1CUSMfOaQFvXhmekjEAX4yGe8nhqtG8IbucI5XZCENl6aBt5l/hM9hRuD3aR+0KrqRsdheU0FBe1aRCcQvaO0NF0UorglzfvXUdJUrM1ceQ32eVht/+WmBpskPsRrvaeied8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XJSe9Pq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XJSe9Pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAB0C4CEFD;
	Mon, 27 Oct 2025 18:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590726;
	bh=oggotWLO8yDqXE28MWuF4eXv6Rca7MK6f0yiC7ExPlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XJSe9PqmgZ4VKqjMMnTv4w/omV/I7unM0v9sLRDcX+rpNDpSLB1qvpk8Qj38jdcD
	 S1g1aew+TNfKcTZkvCRcxWpfKw42rf0o3rSmdiBZUGqARBV+Se1d6IVwmUMb+U6od9
	 rk419HCL+NQgkgA4lO5FM+smweBZ4VOuQFdj6wMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 154/224] media: lirc: Fix error handling in lirc_register()
Date: Mon, 27 Oct 2025 19:35:00 +0100
Message-ID: <20251027183513.074246328@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 4f4098c57e139ad972154077fb45c3e3141555dd ]

When cdev_device_add() failed, calling put_device() to explicitly
release dev->lirc_dev. Otherwise, it could cause the fault of the
reference count.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: a6ddd4fecbb0 ("media: lirc: remove last remnants of lirc kapi")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/lirc_dev.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -762,11 +762,11 @@ int ir_lirc_register(struct rc_dev *dev)
 
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
@@ -790,7 +790,8 @@ int ir_lirc_register(struct rc_dev *dev)
 
 	return 0;
 
-out_ida:
+out_put_device:
+	put_device(&dev->lirc_dev);
 	ida_free(&lirc_ida, minor);
 	return err;
 }


