Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D8F343893;
	Sat, 12 Sep 2026 07:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198995; cv=none; b=gZhRWnRQcrUOkYrbyJwYJf4RYwRSjrC9bkh1v1ke5fRjJmerVXYfrA+uqulp+FKcnIs36R7yxZ9OPcYqDfQvBuaH+Jc5bFIhX6VQvrqtDTNC9aTux6LSLlJrZdnyjTSNqVAlaWTwkfPXDj4t4w7YQx+V+WZ423VeP0jKSt8R8KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198995; c=relaxed/simple;
	bh=eN/Er+7ebaN8Hq6Q3Os0pOLQYJQRRO//QAeZyVVQNv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K16Qt7uVXSqFdLhB7263gkoFf848hGds+pSJ6wv6ZKL2IQYve8CxcW4AKyjUxqlAfF4PfL7uNeqHm513r5K8OqwIwE1ZDHX22wcksRESkVNep47Jj34ZAXMroUW1zwfC6ImkRhO+aD7A7neFzd5oFr/X+NLKtsHuTQOxhgEXWzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iW5qpzYP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iW5qpzYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4ED31F000FF;
	Sat, 12 Sep 2026 07:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198994;
	bh=qsL9T/hi46OUEMFMVcH4sxtCuR2PMNK8V1qYWN/uMRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iW5qpzYPX2oOtUMHXBtXI5IGdZRJ12/sEJ+tsZOk94a7sML4cY5FVpIHLHcaAX6SC
	 bZY2cCAuFfI2Q3/41qifIiYi/feYXKNF2WiFusSUGljEFsucJE4pA/r7IuBboQwiih
	 uH7kRHLM4qvZ6Ma7weMJ53jsrVUPaHqC3JJv948A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0493/1815] uio: Fix stale info pointer in failed registration path
Date: Sat, 12 Sep 2026 08:37:23 +0200
Message-ID: <20260912065700.464946829@linuxfoundation.org>
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
index 1e4ade78ed849..e77d5e7d5f64c 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -1057,6 +1057,11 @@ int __uio_register_device(struct module *owner,
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



