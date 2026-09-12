Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCEA32B126;
	Sat, 12 Sep 2026 18:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239047; cv=none; b=TGCkvARpLGYN+AC9M09/SCc0ZC0tjr90yH8a/ECkmc7e427+TOnyuNzA4oWmr0+iD9Ug5HK43dsQS0kT2iRPkCcQJJAxCfUYj+xF3laoboVj5vwDrOTpvX5OuYUBzAoqS8TZuVuXouKQG/wE3bLxTNPlVtrBU2lBrvR++tq122c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239047; c=relaxed/simple;
	bh=bMwTymdvPM1/c3ZYZrP6ITcUtjElKkvxYUHLAyqC7GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rt/R8cPCqhRTFkWo9s0Vrj9uZIYfYNys5XklkPjLmvSWip2FFXqD0jhW4Ndn1Q4p6A0Rnw/xfHbcKVoF2Z9C8HpviFGQuRj2JhkXvCeyHDDGDuIsomAtL5mBzu6LGpb8yUvagPgDA73uzSGIwN7dc8GV9usNpdjqKTG+rxix+dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DS9RcBz9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DS9RcBz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A281F000FF;
	Sat, 12 Sep 2026 18:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239046;
	bh=MU/SzC/1E4uo9kQE4r4MOPAYPkxjgecFpEE+51zp8Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DS9RcBz9XAd/08PBafBqXQ3g6beg7AoIgxngQk5ZU9PX+npZgJgjhscS+WVnbQU0K
	 NDkHShxYfBwAAxGEG9otgXDAaai3d30bEoMrdFjPzIckibe3fRMdqoyBPWftJZ8xDC
	 vBuIfbtLF91KrbrGS8HgfzlFZlWoQ6MBFQu/8f6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 542/935] uio: Fix stale info pointer in failed registration path
Date: Sat, 12 Sep 2026 08:59:32 +0200
Message-ID: <20260912065539.255764790@linuxfoundation.org>
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
index e9b739def70e3..4143470933023 100644
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



