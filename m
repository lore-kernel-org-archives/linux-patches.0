Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5342882AC;
	Fri, 10 Oct 2025 13:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102411; cv=none; b=fRZdMRvLDUJpb0jnOGqRmBdkqXto87Jl4n2vfzZgYcI87xDMP7Oc8U5ePFvNgO8kLsBnXih6MTSsWPx0j2oT38xYpsnsCfQs5hzt2hX9EXKTXkDAVCKCEycc9IpKaRUgy7Qm3zY/P6TE5OptVoP+nkC+xD15yYnl0qk+SWae+vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102411; c=relaxed/simple;
	bh=or9AUi32cbtxTLNE3DjXenBy5ERB4q3pPM5C+rfzWGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i92/Tl7YzOI93jHi2dMkSqBJggIIdKsM6Yoh9VvnfHhGG6sO7tvcGKjWr+tLbZPL5RA3wuONbIcnvchjerdMPcOh56mo1q2BIJgsJxXJbDT1Q1Vl6cqFqOCvkisU2nAcY+tAHiHT7nDVfWV/P/Cvlkk5lnEWz6IYiOfJjPSVgog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e78NwoVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e78NwoVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D0BC4CEF8;
	Fri, 10 Oct 2025 13:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102410;
	bh=or9AUi32cbtxTLNE3DjXenBy5ERB4q3pPM5C+rfzWGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e78NwoVM2BO46qQg0Db2dpUisTQxIXzLIN4cu1IiRNDtWmo0QvTYXSNQ5Eg092p0r
	 xRBHgh7NPGVBQIweLasemu6cSHjaqvf8M9qwcAmwKC5fWKOzhoqb0fCwvrOHeZHD4n
	 E1FgbWcEk7R156ZCMuZjiJeAQ09Wyyam2BWpGA+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 6.16 35/41] staging: axis-fifo: flush RX FIFO on read errors
Date: Fri, 10 Oct 2025 15:16:23 +0200
Message-ID: <20251010131334.681099664@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -391,6 +391,7 @@ static ssize_t axis_fifo_read(struct fil
 	}
 
 	bytes_available = ioread32(fifo->base_addr + XLLF_RLR_OFFSET);
+	words_available = bytes_available / sizeof(u32);
 	if (!bytes_available) {
 		dev_err(fifo->dt_device, "received a packet of length 0\n");
 		ret = -EIO;
@@ -401,7 +402,7 @@ static ssize_t axis_fifo_read(struct fil
 		dev_err(fifo->dt_device, "user read buffer too small (available bytes=%zu user buffer bytes=%zu)\n",
 			bytes_available, len);
 		ret = -EINVAL;
-		goto end_unlock;
+		goto err_flush_rx;
 	}
 
 	if (bytes_available % sizeof(u32)) {
@@ -410,11 +411,9 @@ static ssize_t axis_fifo_read(struct fil
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
@@ -426,18 +425,23 @@ static ssize_t axis_fifo_read(struct fil
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


