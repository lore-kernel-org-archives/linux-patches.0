Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA78439908;
	Tue, 21 Jul 2026 21:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668249; cv=none; b=qohAMMb0FPaXCMayBkWXFjOQqYn3un+Q4+u//HJcfaiUT7h+r2CyJ0L0o5mT6t5/H4z4i5QjzIdsQ6RbEFfMNnhVSLSEIZg44dXOvHNhx2lw/jQJyh0tXYd15osKKrUIuRTKUjsQUdrCmvZcfo0l++d+gtAnEIsPNy8G8awE3xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668249; c=relaxed/simple;
	bh=prfo4ysZOr+Efr4zKDq7839RGBw3hRmCgkvS9DikH+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pL/9aK8x5Ee5A3otgKjl35b6dBkg/ieMA2E56hQCzlCK3QXhmoSCDFYQxkY+/nKtvxAWTDIPz/oGPIAthNpSFsCsJHEBbY5x3c2VTOg0YoY/U0H2MMeWXV3SI7F3hfknjMPdk8OLyMDZ0A0FazvCifQgHy50n65fZVcSTmWJVi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mE+fjwfd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mE+fjwfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28CF1F000E9;
	Tue, 21 Jul 2026 21:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668248;
	bh=XUrL7JPYRKTMlnzQJQGKw/X7S7AGh9xyAbo0XONXgSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mE+fjwfdsklG4QYa5DIGDanuuxxBB7dXqfAoIIF9QoJGmwDs/AvfxGxDRgmaQeRfV
	 XZI3tviiZIKd4eEWuepSDv9wL0xePGQFE8wluF/5eAF6fBaeDN/gvE4GHyS2uSdLNK
	 +IFk2s+hrN+5+mQbMONhWHHyPabty1xzQ/42y4PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 0060/1067] iio: event: Fix event FIFO reset race
Date: Tue, 21 Jul 2026 17:11:01 +0200
Message-ID: <20260721152425.910790806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


