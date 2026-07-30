Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36A439A4A0;
	Thu, 30 Jul 2026 14:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422708; cv=none; b=NqnBr2m9/qV0klspx6uv/21ELhibTtZ+qRd0nMHlHcjxJyQISmYoxrC1RuIoHiAmBV1je6798LKMF0xn5iM9zSyPPd9p2b29U/gTzQaZD5SSGcPgfdRH6a3fV9MGp6dH5uVXHT/G2R3Upi5PTQ0oX+BKJpuHZFSR/eF6OrtiLeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422708; c=relaxed/simple;
	bh=RExL2pFR/lfJbJ3gxDIU4/mMxUpj020GkrTsslxOBdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXERvn02Gk3xwcXpSu/1jKKIsyYGTlO/jW1XJRYoaotPP4RaWh4qXJ2z/6fgTkQvXVFqUIF2mTq9vZ0HkJqJDO2ZoWgBa1Sp0ZjYUpWC7RknX8lRFx0xVlaAgOYb5p3x5rFA3rLzUl84cpNHDNrerpDZNIoGzHhG+/OXO/f7ZFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzx1FZiK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzx1FZiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF7A1F00A3F;
	Thu, 30 Jul 2026 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422707;
	bh=edZ7VLQCqBWT3Z2B19MOrNpOFCV/9xaXaLopetcyNc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tzx1FZiKODiXMz60vwUJk7e2Hs1liiPM5WMlHiL9HpNQzPe5y29aQ4/A+v1muUH06
	 igj5fuvKIc43HONdjS2HUWkGKBVvy5w98C03X+5XF1k+wySz+QVIe8j7uyAkMbEqF+
	 K2JKpzHCzOjwldYYilPeO7wEB/ERJ+N4Wzri6RiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zile Xiong <xiongzile99@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 530/744] media: vb2: use ssize_t for vb2_read/vb2_write
Date: Thu, 30 Jul 2026 16:13:23 +0200
Message-ID: <20260730141455.537173281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
@@ -2990,8 +2990,8 @@ static int __vb2_cleanup_fileio(struct v
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
@@ -3154,15 +3154,15 @@ static size_t __vb2_perform_fileio(struc
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
@@ -1093,8 +1093,8 @@ __poll_t vb2_core_poll(struct vb2_queue
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
@@ -1103,8 +1103,8 @@ size_t vb2_read(struct vb2_queue *q, cha
  * @ppos:	file handle position tracking pointer
  * @nonblock:	mode selector (1 means blocking calls, 0 means nonblocking)
  */
-size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
-		loff_t *ppos, int nonblock);
+ssize_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
+		  loff_t *ppos, int nonblock);
 
 /**
  * typedef vb2_thread_fnc - callback function for use with vb2_thread.


