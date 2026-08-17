Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAA23C661A;
	Mon, 17 Aug 2026 14:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976993; cv=none; b=p5b9mova+/VHOdT7/Xln6qBbVb9BKKuqwP1hUAfgyTvCOyCGH2x87bJwcXNMC8CMq5wOu7dktbxpEbtWZ04p5vLGMjZdOXENnwdDwsKpoI70xwnH4eqDR6kT/XEjluNlW4QpCeWGgkm6Uib3omCrMmNNnVctlWuqM+N9IjnGOQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976993; c=relaxed/simple;
	bh=uMWVJCBlchH5MCy7d/1tDUqzzwV8MT0/HeQ4onjSm+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myzmBgXZ8wVu5pyegxSjbuJUc5HEzydOVATiIVsWF/VlX/xOs9+s+9MlgtuGBkmW/ShIK7btsZKCMqAJxH0dNk2152rq1tWmlSPE5AXC4C6CrDcUJGTpYl+p4UukXnY9xfqeBe84URXmqAKawUVkFZyADWEXlgXRcO3p8clpbAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWOHXKqO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWOHXKqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AC71F000E9;
	Mon, 17 Aug 2026 14:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976991;
	bh=SfjSdsNTaNsITR99d/AVTH7RjBhMi8fV/s+sL0lx97A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RWOHXKqOPfjdoUi+aoNd0vAGafnUGqcTCyMc5z7IzTsqZYY816ymQnpeOpHQt/z2u
	 EgHh6ibH+paO6XMDrwuSyu6oAfEwMmr9mzkpbiVdg60qoSdFm0D9fUC/i4hmFU7TC2
	 ODrEX7Dc2RYk4CF9Tk53Pibf6mT+DlDfdfPDBE7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zile Xiong <xiongzile99@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 174/456] media: vb2: use ssize_t for vb2_read/vb2_write
Date: Mon, 17 Aug 2026 15:29:24 +0200
Message-ID: <20260817132546.925377867@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Zile Xiong <xiongzile99@gmail.com>

commit a562d6dc86bdfdd299e1b4734977a8d63e803583 upstream.

vb2_read() and vb2_write() return size_t, but propagate
negative errno values from __vb2_perform_fileio().

This relies on implicit signed/unsigned conversions in callers
(e.g. vb2_fop_read()) to recover error codes:

    __vb2_perform_fileio() -> -EINVAL
    vb2_read()             -> (size_t)-EINVAL
    vb2_fop_read()         -> -EINVAL

This relies on implicit conversions that are not obvious.

These helpers are exported (EXPORT_SYMBOL_GPL) and part of the
vb2 API, so changing their return type may affect existing users.

However, they conceptually follow read/write semantics, where
ssize_t is typically used to return either a byte count or a
negative error code.

Switch vb2_read() and vb2_write() to ssize_t, and update
__vb2_perform_fileio() accordingly.

Signed-off-by: Zile Xiong <xiongzile99@gmail.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: b25748fe6126 ("[media] v4l: videobuf2: add read() and write() emulator")
Cc: stable@vger.kernel.org
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/videobuf2/videobuf2-core.c |   12 ++++++------
 include/media/videobuf2-core.h                  |    8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2719,8 +2719,8 @@ static int __vb2_cleanup_fileio(struct v
  * @nonblock:	mode selector (1 means blocking calls, 0 means nonblocking)
  * @read:	access mode selector (1 means read, 0 means write)
  */
-static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_t count,
-		loff_t *ppos, int nonblock, int read)
+static ssize_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_t count,
+				    loff_t *ppos, int nonblock, int read)
 {
 	struct vb2_fileio_data *fileio;
 	struct vb2_fileio_buf *buf;
@@ -2880,15 +2880,15 @@ static size_t __vb2_perform_fileio(struc
 	return ret;
 }
 
-size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
-		loff_t *ppos, int nonblocking)
+ssize_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
+		 loff_t *ppos, int nonblocking)
 {
 	return __vb2_perform_fileio(q, data, count, ppos, nonblocking, 1);
 }
 EXPORT_SYMBOL_GPL(vb2_read);
 
-size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
-		loff_t *ppos, int nonblocking)
+ssize_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
+		  loff_t *ppos, int nonblocking)
 {
 	return __vb2_perform_fileio(q, (char __user *) data, count,
 							ppos, nonblocking, 0);
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -1044,8 +1044,8 @@ __poll_t vb2_core_poll(struct vb2_queue
  * @ppos:	file handle position tracking pointer
  * @nonblock:	mode selector (1 means blocking calls, 0 means nonblocking)
  */
-size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
-		loff_t *ppos, int nonblock);
+ssize_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
+		 loff_t *ppos, int nonblock);
 /**
  * vb2_write() - implements write() syscall logic.
  * @q:		pointer to &struct vb2_queue with videobuf2 queue.
@@ -1054,8 +1054,8 @@ size_t vb2_read(struct vb2_queue *q, cha
  * @ppos:	file handle position tracking pointer
  * @nonblock:	mode selector (1 means blocking calls, 0 means nonblocking)
  */
-size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
-		loff_t *ppos, int nonblock);
+ssize_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
+		  loff_t *ppos, int nonblock);
 
 /**
  * typedef vb2_thread_fnc - callback function for use with vb2_thread.


