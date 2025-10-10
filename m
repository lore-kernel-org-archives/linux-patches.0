Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C4B2F5324;
	Fri, 10 Oct 2025 13:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102279; cv=none; b=TDwU+noH5XiyY/xWynW5QA+tWxyaxg+MTnbKiaAPAQozig05sASQKFbNZf0kL8duu2KzmLL36icDrdA0Wy9F5xGUZL7DfDkOBW17SgrF2o8q9GTUk/eskpxxj42YN0G3UX4Oj9MLbzO8PgPCwHMIxwX2fLaV8Fbdx7Htcz7xVbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102279; c=relaxed/simple;
	bh=cidHAhLQK2BGEfwXKgdbHDJoUEkd7o35n5KfyIKUeds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8LyMfI873lg44G+F8yHtp/o0ZkVKtuRumo8QTZqFuapHH1zzT/KgOooBYSeupittQK9qavmu98yO4HZV6bgKeKi4bKRbSLDwdIrd9n6ZxolKLWHFSTZTUuF3dcla0XMcG+SpS2BMssNR7zHx3R/WUlGYL+CF4V2I5kMpbUbBCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yuz+E6jo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yuz+E6jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0B9C4CEF8;
	Fri, 10 Oct 2025 13:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102279;
	bh=cidHAhLQK2BGEfwXKgdbHDJoUEkd7o35n5KfyIKUeds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yuz+E6joNalYfTs649vf0NUJdTRDMgFuj0DxTz+O7wJNR3xLLwUzZdpSyY8kdTojJ
	 8IhrL711H6cE8zxcXb2WAFFkfI0XkD7r0uBXz4HAgUnNFxYfYnJGPYdMjK8I/zVlZa
	 lhDMig5KfNRxpkdVFonRmHlbs9nRuSOxoopNxN6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 6.17 17/26] staging: axis-fifo: flush RX FIFO on read errors
Date: Fri, 10 Oct 2025 15:16:12 +0200
Message-ID: <20251010131331.836270755@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

commit 82a051e2553b9e297cba82a975d9c538b882c79e upstream.

Flush stale data from the RX FIFO in case of errors, to avoid reading
old data when new packets arrive.

Commit c6e8d85fafa7 ("staging: axis-fifo: Remove hardware resets for
user errors") removed full FIFO resets from the read error paths, which
fixed potential TX data losses, but introduced this RX issue.

Fixes: c6e8d85fafa7 ("staging: axis-fifo: Remove hardware resets for user errors")
Cc: stable@vger.kernel.org
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Link: https://lore.kernel.org/r/20250912101322.1282507-2-ovidiu.panait.oss@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/axis-fifo/axis-fifo.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/staging/axis-fifo/axis-fifo.c
+++ b/drivers/staging/axis-fifo/axis-fifo.c
@@ -227,6 +227,7 @@ static ssize_t axis_fifo_read(struct fil
 	}
 
 	bytes_available = ioread32(fifo->base_addr + XLLF_RLR_OFFSET);
+	words_available = bytes_available / sizeof(u32);
 	if (!bytes_available) {
 		dev_err(fifo->dt_device, "received a packet of length 0\n");
 		ret = -EIO;
@@ -237,7 +238,7 @@ static ssize_t axis_fifo_read(struct fil
 		dev_err(fifo->dt_device, "user read buffer too small (available bytes=%zu user buffer bytes=%zu)\n",
 			bytes_available, len);
 		ret = -EINVAL;
-		goto end_unlock;
+		goto err_flush_rx;
 	}
 
 	if (bytes_available % sizeof(u32)) {
@@ -246,11 +247,9 @@ static ssize_t axis_fifo_read(struct fil
 		 */
 		dev_err(fifo->dt_device, "received a packet that isn't word-aligned\n");
 		ret = -EIO;
-		goto end_unlock;
+		goto err_flush_rx;
 	}
 
-	words_available = bytes_available / sizeof(u32);
-
 	/* read data into an intermediate buffer, copying the contents
 	 * to userspace when the buffer is full
 	 */
@@ -262,18 +261,23 @@ static ssize_t axis_fifo_read(struct fil
 			tmp_buf[i] = ioread32(fifo->base_addr +
 					      XLLF_RDFD_OFFSET);
 		}
+		words_available -= copy;
 
 		if (copy_to_user(buf + copied * sizeof(u32), tmp_buf,
 				 copy * sizeof(u32))) {
 			ret = -EFAULT;
-			goto end_unlock;
+			goto err_flush_rx;
 		}
 
 		copied += copy;
-		words_available -= copy;
 	}
+	mutex_unlock(&fifo->read_lock);
+
+	return bytes_available;
 
-	ret = bytes_available;
+err_flush_rx:
+	while (words_available--)
+		ioread32(fifo->base_addr + XLLF_RDFD_OFFSET);
 
 end_unlock:
 	mutex_unlock(&fifo->read_lock);


