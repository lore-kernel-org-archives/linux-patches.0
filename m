Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3CD3D7D74;
	Thu, 16 Jul 2026 13:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210297; cv=none; b=tQUQpNZMAAkX6jGX4dmYiXIkoQabLznlQINZpZiQsVFZEkn9ndLtZEkhjww92QYag3dBzw+/NpiXurm0TG8Zu7VlwPQjCsOHuWgsy9Lw9FzaWoU3Fc7DTz5Dy+vBiNBfGWcjDUUN3lZ8K1E0xGVI/85YuYwwF8OamaBITL0i0Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210297; c=relaxed/simple;
	bh=jeRIAT8LwDH3Ig4M2w8CmilFU3fPKeMSSvAvoLyTGkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0f4yspAH0dFe/nMr6toTOJVKABUCrr2pIgMPtuXe69m7p3Iiplk5X3txC3DbJ5ocoNHI70ASmJukScn48D3C8ygfbC4mU1vualyUrmZZNIfoXInYGk7OUQLMZZTk/S527iLeJakDF/7jDbcxY9QziiZX2VHpNZ+9cWiSgeDMss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtFZwetQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtFZwetQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19CB1F000E9;
	Thu, 16 Jul 2026 13:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210295;
	bh=5xR/+7NXor0tYfXGCowFhj6WmTs3XwGB/v10ZVxbTGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xtFZwetQ7e9NPszJuJpY2Kog5jpuBiD/EbuQhfITLthXQNsktJdHnBZFbROwWOVWm
	 IFjGyBCrpiExskhXR1ijv1t/RVkJFNzSprUxZZmXw9aD5g86NAU8MpU2a5SvUoK+/2
	 zs8uMxfDA+fAJfOGBIJghWYdQPGkVLahTtDMNjy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Berkant Koc <me@berkoc.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	stable@kernel.org
Subject: [PATCH 7.1 512/518] fuse-uring: Avoid use-after-free in fuse_uring_async_stop_queues
Date: Thu, 16 Jul 2026 15:33:00 +0200
Message-ID: <20260716133059.040123966@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bernd@bsbernd.com>

commit d351da75066955144515cb2f9aa959f24a04287a upstream.

fuse_uring_async_stop_queues() might run when the last reference
on ring->queue_refs was already dropped.

In order to avoid an early destruction a reference on struct fuse_conn
is now taken before starting fuse_uring_async_stop_queues() and that
reference is only released when that delayed work queue terminates.

Fixes: 4a9bfb9b6850 ("fuse: {io-uring} Handle teardown of ring entries")
Cc: stable@kernel.org # 6.14
Reported-by: Berkant Koc <me@berkoc.com>
Signed-off-by: Bernd Schubert <bernd@bsbernd.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -467,6 +467,7 @@ static void fuse_uring_async_stop_queues
 				      FUSE_URING_TEARDOWN_INTERVAL);
 	} else {
 		wake_up_all(&ring->stop_waitq);
+		fuse_conn_put(ring->chan->conn);
 	}
 }
 
@@ -478,6 +479,7 @@ void fuse_uring_stop_queues(struct fuse_
 	fuse_uring_teardown_all_queues(ring);
 
 	if (atomic_read(&ring->queue_refs) > 0) {
+		fuse_conn_get(ring->chan->conn);
 		ring->teardown_time = jiffies;
 		INIT_DELAYED_WORK(&ring->async_teardown_work,
 				  fuse_uring_async_stop_queues);


