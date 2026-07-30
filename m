Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B412930567C;
	Thu, 30 Jul 2026 15:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426199; cv=none; b=pdqKl88FpGXFgpXgv4fHSFeisZfr0urzPpAe11UNR/Q8nZoCr12KZSCKhnpPUS09b7R5M61U6G1pdeT+JsTYko7tEYOiESbhUa3MclRmDpiNV7qsmKp2scniAw40lEamwxG/Zp9Tz8POnpBhz6xJZ9ac3JLvAcQuR5qSA8ELFZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426199; c=relaxed/simple;
	bh=kgj4sRSSCCGUgOvyF79QEBlGQiOrn4lT+P6vmWNXwIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lvqdn75Dm0NNwoxIOMrf4MFfwE7DGSvjDdyMTNArrFM6JtwNJ6MK4uxQNN/VrHkzGXoRsC0D0wMDluOFCkxSMU6m/OR8UO6zQVU269Vm4V4rDo2i5QBCVwVbR8MvANc96/fG7/AatXhD+X5GP4f1jWfiBQqAKuVGG5/aSOCyIsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcbUPhry; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcbUPhry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98691F000E9;
	Thu, 30 Jul 2026 15:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426198;
	bh=x7RyizdnCTmlrrZPWCUs4hAzVNCpX5BCFTXrArFFrjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcbUPhrysAZM8whVawGi1AewlwKzb28Eywcb+tqDAUr0kY9U3MHsMpuB42d+13+hM
	 18674+dlYCZz0AAj/upvw5kKqSMYb3InWUvQ7Sf4TNCwFTEiflVrJGU0U7zCfljTkA
	 X8HjvNNlhbmwKv0sepBOrfdVCYR8nk55bg9SgFEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zile Xiong <xiongzile99@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 336/602] media: vb2: use ssize_t for vb2_read/vb2_write
Date: Thu, 30 Jul 2026 16:12:08 +0200
Message-ID: <20260730141443.022245950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2991,8 +2991,8 @@ static int __vb2_cleanup_fileio(struct v
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
@@ -3155,15 +3155,15 @@ static size_t __vb2_perform_fileio(struc
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
@@ -1106,8 +1106,8 @@ __poll_t vb2_core_poll(struct vb2_queue
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
@@ -1116,8 +1116,8 @@ size_t vb2_read(struct vb2_queue *q, cha
  * @ppos:	file handle position tracking pointer
  * @nonblock:	mode selector (1 means blocking calls, 0 means nonblocking)
  */
-size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
-		loff_t *ppos, int nonblock);
+ssize_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
+		  loff_t *ppos, int nonblock);
 
 /**
  * typedef vb2_thread_fnc - callback function for use with vb2_thread.


