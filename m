Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018457;
	b=HE4xMCiVs8PDBbB96KwXOHYItyJS5D0CN4iNbjoD96ARtV0GETuN6tO4YTkY1gja5KxC
	 pRtXFvrJGHqjT6KwTOjx0BuQsJFvl+NS84nN5Be/OPZy9K3NkAIoXA0QrzgxDMXod41Pr
	 ZtZfD1ff8r43oqsXnGLDj8X1wRysl9wlFlrwUX78uKktJcwDXfRjeHw9WrZde5/0qhTvj
	 IZHDQ0OP6cKK5y/QEfJ55xeuWKkyRGEsVvwFcdNOvwzlqhzebuV4NG4OM4M9pa3ghS/IV
	 wneu6QYrt/JI1xe7cf5Qr1Z+P+WGHCQ99tWF0CWSGSp9kUl7VtWxarYN46ZgLKs8ECg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TrSAh6QfhV5nomVE6FfDQ8Lezy1XHuhXbFUvUjqs3wk=;
	b=Ix6ryUGXJE7B7legCkKgDkKzXYrEaNsuiwMZgJGQwtsdo4hMyrCwHT7/BBiqlvAZEclF
	 u3wtFCkWJs8usJXahRbp4bRUcoa7lznNsOsn8QWEpOy0QUtIE6SA94Kso0Krg4ftc5M9v
	 Lpm768KCG3dZZ1BiN2eZhGDOYFkStkgLMI1EuQKINdJ/mR26FR8dAOa2xiSkvyyYMZi3l
	 U1Czxsh6UcIcVPN1w09RxFxdeF9VtSbMzYJmHL7Y7xnyzHaOe8P/6UjNUUKFAnTXT2MAM
	 vDx1MzPUGOxeA8XBUyVf396yRznmhVwgHNX/s0w5FSQ++JCDipP7OKIKDKffDzWfoVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w68tky0Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960C0606A32C;
	Wed, 18 Nov 2026 16:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w68tky0Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F011F1F000C4;
	Wed, 18 Nov 2026 16:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018457;
	bh=TrSAh6QfhV5nomVE6FfDQ8Lezy1XHuhXbFUvUjqs3wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w68tky0YDrI6k/sEBrEmCGreRX8HpI1YaMT7iLd1IKcr1WZKqFi+0RhAOxZB2EY5n
	 K/2KOwpK6Hj5HHQujEoGtAYKk6q1Q0T356Daxk+z4UsqGOQgtqKCeKEa/f1vYL2Fpx
	 mOWaXacHNFp8Fd2VqaeFeHzjMtkv0rRP53TBwmt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1246/2651] md: Fix the null-ptr-deref of mddev->private while submitting IO
Date: Wed, 18 Nov 2026 15:41:26 +0100
Message-ID: <20261118150332.842561908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 4c90b76e0198deb89376988daa8d96b48bea7fcf ]

Concurrent processes md_stop and IO submission can trigger a NULL
pointer dereference of mddev->private:

 BUG: kernel NULL pointer dereference, address: 0000000000000070
 RIP: 0010:_wait_barrier+0x2f/0x250
 Call Trace:
  raid1_make_request+0x150/0xf50
  md_handle_request+0x104/0x530
  md_submit_bio+0x76/0x130
  submit_bio+0xdd/0x250
  submit_bio_wait+0x1f/0x40
  __blkdev_direct_IO_simple+0x1f6/0x370
  blkdev_write_iter+0x3b2/0x520
  ksys_write+0x7d/0x190

One process can submit I/O through an open file while a forked process
uses the same file to issue STOP_ARRAY. The opener check permits this
because md_open() was called only once. do_md_stop() can then clear
mddev->private while the I/O is entering the personality make_request
callback.

This affects raid0, raid1, raid10, and raid5. Suspend STOP_ARRAY while
holding the reconfiguration lock so teardown waits for active_io
references to drain. Fail I/O in md_handle_request() if mddev->pers is
NULL after the array resumes.

The sysfs stopping paths are protected by
mddev_set_closing_and_sync_blockdev(). Apply that protection to both
clear and inactive transitions even when the array is read-only.
dm-raid teardown is already invoked with the device suspended.

Fetch a reproducer in
https://bugzilla.kernel.org/show_bug.cgi?id=222020

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3fe892ea5fc292e1353f
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://patch.msgid.link/20260922030538.1634904-1-chengzhihao1@huawei.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b103784a3cb3e..7821233836051 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -414,6 +414,20 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
 		if (!percpu_ref_tryget_live(&mddev->active_io))
 			goto check_suspended;
 	}
+	if (!mddev->pers) {
+		/*
+		 * The __md_stop() sets 'mddev->private' to NULL during
+		 * the IO submitting, check 'mddev->pers' before the IO
+		 * being processed by specific driver to avoid the
+		 * null-ptr-deref of 'mddev-><member>'. The check is
+		 * safe because the IO has got the 'mddev->active_io'
+		 * reference, and all __md_stop() callers will wait for
+		 * the reference to be zero.
+		 */
+		bio_io_error(bio);
+		percpu_ref_put(&mddev->active_io);
+		return true;
+	}
 	if (!mddev->pers->make_request(mddev, bio)) {
 		percpu_ref_put(&mddev->active_io);
 		if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
@@ -4673,7 +4687,8 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	case readonly:
 	case inactive:
 	case read_auto:
-		if (!mddev->pers || !md_is_rdwr(mddev))
+		if (!mddev->pers ||
+		    (st != clear && st != inactive && !md_is_rdwr(mddev)))
 			break;
 		/* write sysfs will not open mddev and opener should be 0 */
 		err = mddev_set_closing_and_sync_blockdev(mddev, 0);
@@ -8319,6 +8334,7 @@ static bool md_ioctl_need_suspend(unsigned int cmd)
 	case HOT_REMOVE_DISK:
 	case SET_BITMAP_FILE:
 	case SET_ARRAY_INFO:
+	case STOP_ARRAY:
 		return true;
 	default:
 		return false;
-- 
2.53.0



