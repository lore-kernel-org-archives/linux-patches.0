Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD6433F368;
	Sat, 12 Sep 2026 14:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223454; cv=none; b=SAxJi1T6VbSsCdVbUDkVNMkVB9Q2hj23zyxZy+YiBcBDEaksLuM1ytUpAvwBYVJ1NGXEtXctf53akD37NkO26tNtFclGvKUgb8MHtzOIr3R3oLEYEWCC2lH9Ea32wn5O2/hiHxZTVO3moHHpGNkgrGBayHF5pV1zKSc+WfYiEBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223454; c=relaxed/simple;
	bh=qsTg7n4wsCW4BjDNE9cL0jriwVAehad1kTvK/bV/cAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgZ6P6vWKHEGBd1bxo6FbSzphV5neTnw1ryRc0yhvxgL+dIT7ZwjDZZrvtWznYCYyuRJ8qbDvZCIhrfjT+yRDfSM9LQyG7hFhHtbo8tguuR84kGt1JAWTeSSEJZPAhLNF4F+UN7eoBEbfFPPpYsOUddw657tC6mNTcjlYFZImuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/0koE9c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/0koE9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BD51F000FF;
	Sat, 12 Sep 2026 14:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223453;
	bh=m1KKxHcVjDvh0OVjgpYyQWm0w5IanPaxOJ/w8skNdKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/0koE9cVnxENod4GJz4re+9jmdA4HGhGNWAxfOXs7N0o1pti9FHSy1Oz6xqXu9zp
	 SgjVbG1XVMwINAEAXFKtcvrB2202/zZpujGwaF+1/Yv4WyUb6Y05c1+LbMrUJ9cjSS
	 aYvuT/5d0C6LvQ1EBtTAWMuTieTVhpUXec7CaceM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0793/1424] uio: Fix stale info pointer in failed registration path
Date: Sat, 12 Sep 2026 08:53:45 +0200
Message-ID: <20260912065625.056504990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 2d572f6c8ec83..887ba0082d16f 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -990,6 +990,11 @@ int __uio_register_device(struct module *owner,
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



