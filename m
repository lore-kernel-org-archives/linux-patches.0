Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7811C43B4A2;
	Tue, 21 Jul 2026 21:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670930; cv=none; b=jSjGoe/+ffDvG8JQctIND4gSp9lsSJZs/JixZWvkbmJCXX4vn/lu/7Y/1P06+m6i60aixEilzxfr8i2P6E5zezkEhR83QkCPtbENfVcUolTNedyHEcFERxfkUnbbWbWGI2Iv+eL7zT7tb++ByIoStqM7/qlwtspbe4178+MQhSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670930; c=relaxed/simple;
	bh=OMWpbq8YQ12iwtXfIUWwDI24LDHhQUurCzVw99lLoIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lbSWtb2l97wLluEEsTfTlp3FuMRJzvxR3bCRCm19cGgIgcZ6015CSsTk6b5JQYZ3+W2igv//15jpYelK4pPN0NwvVjfzPtScXysDB4SELs2LHbSrcQP93XoB0vwbvQ2+33rBAWFIjMcTHg6njM3sCiuruon60SknFC172hAbN9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RviS9J1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RviS9J1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5AD1F000E9;
	Tue, 21 Jul 2026 21:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670929;
	bh=UGYntsEcrKt1nwPW2j3hpCd7LKeLXRl7l5bmcQxFaiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RviS9J1S4dOaLLz8KEvxjZ9FoeMT/yIHIEtyv05Y/4AUQj7RUw8LkuQ+9O17kNDfZ
	 XIUO31DnZoDS1JwohqcbR81s5cCx4pEZoz9CUNOzCBmprOqAdcWGodaQeF19Hyddf0
	 46EQgHxSkCtAe+0kE3fTDBbGqW0+LmJ2/CD0VhzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.15 054/843] iio: event: Fix event FIFO reset race
Date: Tue, 21 Jul 2026 17:14:49 +0200
Message-ID: <20260721152407.200515530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit af791d295737ea6b6ff2c8d8488462a49c14af01 upstream.

`iio_event_getfd()` creates the event file descriptor with
`anon_inode_getfd()`, which allocates a new fd, creates the anonymous
file and installs it in the process fd table before returning to the
caller.

The IIO code resets the event FIFO after `anon_inode_getfd()` has returned,
but before `IIO_GET_EVENT_FD_IOCTL` has copied the fd number to userspace.
But since fd tables are shared between threads, another thread can guess
the newly allocated fd number and issue a `read()` on it as soon as the fd
has been installed.

This means the `kfifo_to_user()` in `iio_event_chrdev_read()` can run in
parallel with the `kfifo_reset_out()` in `iio_event_getfd()`.

The kfifo documentation says that `kfifo_reset_out()` is only safe when it
is called from the reader thread and there is only one concurrent reader.
Otherwise it is dangerous and must be handled in the same way as
`kfifo_reset()`.

If that happens, `kfifo_to_user()` can advance the FIFO `out` index based
on state from before the reset, after the reset has already moved the `out`
index to the current `in` index. That can leave the FIFO with an `out`
index past the `in` index. A later `read()` can then see an underflowed
FIFO length and copy more data than the event FIFO buffer contains. This
can result in an out-of-bounds read and leak adjacent kernel memory to
userspace.

Move the FIFO reset before `anon_inode_getfd()`. At that point the event fd is
marked busy, but the new fd has not been installed yet, so userspace cannot
access it while the FIFO is reset.

Fixes: b91accafbb10 ("iio:event: Fix and cleanup locking")
Reported-by: Codex:gpt-5.5
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-event.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -207,6 +207,8 @@ static int iio_event_getfd(struct iio_de
 		goto unlock;
 	}
 
+	kfifo_reset_out(&ev_int->det_events);
+
 	iio_device_get(indio_dev);
 
 	fd = anon_inode_getfd("iio:event", &iio_event_chrdev_fileops,
@@ -214,10 +216,7 @@ static int iio_event_getfd(struct iio_de
 	if (fd < 0) {
 		clear_bit(IIO_BUSY_BIT_POS, &ev_int->flags);
 		iio_device_put(indio_dev);
-	} else {
-		kfifo_reset_out(&ev_int->det_events);
 	}
-
 unlock:
 	mutex_unlock(&indio_dev->mlock);
 	return fd;


