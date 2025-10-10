Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FB52F3605;
	Fri, 10 Oct 2025 13:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102562; cv=none; b=ZQOzHUBzL81a6ixYPyEusfEDyzG5B4nV0xqyOi7WocY7aj+cMXSlh/xVh0cpdn7774I2Rki7AQN8lhzt1S4KWv3VW0mHuTxkMA5JRr6EECVsIO6zsyJd6VG1no6lxGlS42wmxSrC8rOsrryP8mLcya6D2c+AFkuLQByQnPCS/GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102562; c=relaxed/simple;
	bh=oY0YYMFLXCnYSE5u/W41JMpP2coM757qqadRTg1JWbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1YAI9f6uFY05dAdCs17nKDoEl/d2bzlzXUF7Cp1xCv0+yeotO5ZrpkzTXXnOoXgJuadRkAxdCgyudR2uQ2Aqla9vlxNa1GMvnmeGsqVgugJ/rMtTrf9mM3NaOIiVOLsGcAbaj1dATCa09P15ROqFayp3Gm0D6Tsb/nyM7u53mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcSPxU6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcSPxU6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D57AC4CEF1;
	Fri, 10 Oct 2025 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102561;
	bh=oY0YYMFLXCnYSE5u/W41JMpP2coM757qqadRTg1JWbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcSPxU6kIRcbOukJ55MGlhRGpyp2T9F4RES04HbEEGLJEd/Jlp6CSHyWYO7OTZYCX
	 k/GwuVbzntMz5GynZJZ7Op+RUr1Ux52Pl7cH7HPwMNe/YT4CeZGVjoUIKtP48iFy5Y
	 ixKYTbf3YB/uu6odzqOeRBysoWnH1UMcHiZMQsdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 6.6 21/28] staging: axis-fifo: fix TX handling on copy_from_user() failure
Date: Fri, 10 Oct 2025 15:16:39 +0200
Message-ID: <20251010131331.137111768@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

commit 6d07bee10e4bdd043ec7152cbbb9deb27033c9e2 upstream.

If copy_from_user() fails, write() currently returns -EFAULT, but any
partially written data leaves the TX FIFO in an inconsistent state.
Subsequent write() calls then fail with "transmit length mismatch"
errors.

Once partial data is written to the hardware FIFO, it cannot be removed
without a TX reset. Commit c6e8d85fafa7 ("staging: axis-fifo: Remove
hardware resets for user errors") removed a full FIFO reset for this case,
which fixed a potential RX data loss, but introduced this TX issue.

Fix this by introducing a bounce buffer: copy the full packet from
userspace first, and write to the hardware FIFO only if the copy
was successful.

Fixes: c6e8d85fafa7 ("staging: axis-fifo: Remove hardware resets for user errors")
Cc: stable@vger.kernel.org
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Link: https://lore.kernel.org/r/20250912101322.1282507-1-ovidiu.panait.oss@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/axis-fifo/axis-fifo.c |   36 +++++++++-------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

--- a/drivers/staging/axis-fifo/axis-fifo.c
+++ b/drivers/staging/axis-fifo/axis-fifo.c
@@ -42,7 +42,6 @@
 #define DRIVER_NAME "axis_fifo"
 
 #define READ_BUF_SIZE 128U /* read buffer length in words */
-#define WRITE_BUF_SIZE 128U /* write buffer length in words */
 
 /* ----------------------------
  *     IP register offsets
@@ -471,11 +470,8 @@ static ssize_t axis_fifo_write(struct fi
 {
 	struct axis_fifo *fifo = (struct axis_fifo *)f->private_data;
 	unsigned int words_to_write;
-	unsigned int copied;
-	unsigned int copy;
-	unsigned int i;
+	u32 *txbuf;
 	int ret;
-	u32 tmp_buf[WRITE_BUF_SIZE];
 
 	if (len % sizeof(u32)) {
 		dev_err(fifo->dt_device,
@@ -540,32 +536,20 @@ static ssize_t axis_fifo_write(struct fi
 		}
 	}
 
-	/* write data from an intermediate buffer into the fifo IP, refilling
-	 * the buffer with userspace data as needed
-	 */
-	copied = 0;
-	while (words_to_write > 0) {
-		copy = min(words_to_write, WRITE_BUF_SIZE);
-
-		if (copy_from_user(tmp_buf, buf + copied * sizeof(u32),
-				   copy * sizeof(u32))) {
-			ret = -EFAULT;
-			goto end_unlock;
-		}
-
-		for (i = 0; i < copy; i++)
-			iowrite32(tmp_buf[i], fifo->base_addr +
-				  XLLF_TDFD_OFFSET);
-
-		copied += copy;
-		words_to_write -= copy;
+	txbuf = vmemdup_user(buf, len);
+	if (IS_ERR(txbuf)) {
+		ret = PTR_ERR(txbuf);
+		goto end_unlock;
 	}
 
-	ret = copied * sizeof(u32);
+	for (int i = 0; i < words_to_write; ++i)
+		iowrite32(txbuf[i], fifo->base_addr + XLLF_TDFD_OFFSET);
 
 	/* write packet size to fifo */
-	iowrite32(ret, fifo->base_addr + XLLF_TLR_OFFSET);
+	iowrite32(len, fifo->base_addr + XLLF_TLR_OFFSET);
 
+	ret = len;
+	kvfree(txbuf);
 end_unlock:
 	mutex_unlock(&fifo->write_lock);
 


