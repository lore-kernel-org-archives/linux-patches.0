Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B87331203;
	Sat, 12 Sep 2026 19:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242599; cv=none; b=LnPyugOKTnbfk6CYJmIuhyzBvZv39XQbbJb6pqYD+nrunLaal9m1vMOn+z8FYf9I7SDa8JIDt21bkNR4sV8w/XhSb3buiRcnj/JmlaYyO+pBWKSwzNb3Q/MgvKVP6pkAbDkWZXQA4GhwmMBKvCmi/0fUR2lA/YoUgovkf9QSRYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242599; c=relaxed/simple;
	bh=kzfY+QaNeLRm3vAMV519FosAnovUmi+R+Jlofg9VVOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qn/GoPz7jbboWtudFcBU4lZSonGySAfQzeCGbzQnWxQfSuZf1aswcab0QN6hVwKcP9kwr0fdpHcgqoU6ksxTsF6yhuhbk9dePBFpdNN/LJsPBXVBO+2ZjzaRR0Vf5B4HyumIP5ns+WLOgPorONLPI7bqXX3XsBBwXJ9depXjJWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7PWsVmH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7PWsVmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6318F1F000FF;
	Sat, 12 Sep 2026 19:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242597;
	bh=09ctqRXCgzAQz0hYsqFmcdPytBkHUeJ4BwOLSpE61tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7PWsVmHmWSLBlFORHvvKlhC/GAdqq4al1iW1FgO+fABjzQeyKSj9C2ZLgjlCCC1J
	 jfpbfwRAWNzIjROfctcsxtsnNuRcc3TsxH5J02udKin6ZHwReFEfH7hvdRV2dbpRYH
	 euk/b1sEJQKQYJpOc78erTKqnh8rl+ZAhutxcuRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 459/798] uio: Fix stale info pointer in failed registration path
Date: Sat, 12 Sep 2026 09:01:27 +0200
Message-ID: <20260912065527.666642351@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 67b6fc084b034a91c3ec7907a3fed89a2450f30b ]

After device_add(), the UIO device is visible to userspace and /dev/uioX
can be opened. If a later setup step fails, __uio_register_device()
unwinds the device but leaves idev->info pointing at the caller-owned
struct uio_info.

That is unsafe when an opener races with the failed registration path.
The open file keeps a reference to the uio_device, while the caller sees
registration failure and may free its struct uio_info. Later file
operations can then follow idev->info and dereference freed memory.

Handle post-device_add() failures like unregister: remove UIO attributes
while the info pointer is still valid, then clear idev->info under
info_lock and wake existing waiters/async users before removing the
device and minor. This makes already-open file descriptors observe the
same "device gone" state as normal uio_unregister_device().

Fixes: a93e7b331568 ("uio: Prevent device destruction while fds are open")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260630192714.1867170-1-dbgh9129@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index f453b3c7ee422..3b58a5dc7ea0c 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -988,6 +988,11 @@ int __uio_register_device(struct module *owner,
 err_request_irq:
 	uio_dev_del_attributes(idev);
 err_uio_dev_add_attributes:
+	mutex_lock(&idev->info_lock);
+	idev->info = NULL;
+	mutex_unlock(&idev->info_lock);
+	wake_up_interruptible(&idev->wait);
+	kill_fasync(&idev->async_queue, SIGIO, POLL_HUP);
 	device_del(&idev->dev);
 err_device_create:
 	uio_free_minor(idev->minor);
-- 
2.53.0



