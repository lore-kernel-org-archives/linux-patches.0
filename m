Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270CB32D7D8;
	Mon, 27 Oct 2025 18:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590962; cv=none; b=EvBDilQ2GApzhtbyPzhd9b4PvSSiC4dyp8Wx5QxuUmqaIw8UrukKo2JEsPSAMDJ/M+4oJY8eCodXagg1hDCl/GbeXaYfXqaP2Zd8wwXDxTzmitJGWQfU7elbBNSKkBCp+8zqTrQ79U2vGl41wtDhHos9nZpgevVTKUmndk/l8AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590962; c=relaxed/simple;
	bh=8kpQuwuW83FS6KT/LzQvKhb6KPcpfbi7YUeVGW8CS+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CI4vfA6oPghCigZvFyb2aZwL8jzXdTs6fTjbFfhxhjXJlwwuOTsw2wTLJUgqerEz9keyWFHzLTIPHAOvKhaNDs1vRK2xhKHeo7MMgVTWHPalCKlHp9kCkX7gbWJg21Y/SHg/n4JCoad+6T25bb7HLZuoqjzD14HIRuAW/0HZizc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHsrdgvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHsrdgvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50314C4CEF1;
	Mon, 27 Oct 2025 18:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590961;
	bh=8kpQuwuW83FS6KT/LzQvKhb6KPcpfbi7YUeVGW8CS+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHsrdgvRgiXldMbVPwWM1Jk4JlIn6bJ0itlJPQny4jvZ/OQ23IIax2gfwznNj2c2J
	 oh/s+zuyegigHNBLtAQVzXscegaVidS3wHT67/QLjG8PlcJY/rAUJnQVlw87tdd7GX
	 j6011bD1eRqFhsJ0LU87xJtbVvYLtAiYEbX/3vqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 5.10 015/332] staging: axis-fifo: flush RX FIFO on read errors
Date: Mon, 27 Oct 2025 19:31:08 +0100
Message-ID: <20251027183525.025163044@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -400,6 +400,7 @@ static ssize_t axis_fifo_read(struct fil
 	}
 
 	bytes_available = ioread32(fifo->base_addr + XLLF_RLR_OFFSET);
+	words_available = bytes_available / sizeof(u32);
 	if (!bytes_available) {
 		dev_err(fifo->dt_device, "received a packet of length 0\n");
 		ret = -EIO;
@@ -410,7 +411,7 @@ static ssize_t axis_fifo_read(struct fil
 		dev_err(fifo->dt_device, "user read buffer too small (available bytes=%zu user buffer bytes=%zu)\n",
 			bytes_available, len);
 		ret = -EINVAL;
-		goto end_unlock;
+		goto err_flush_rx;
 	}
 
 	if (bytes_available % sizeof(u32)) {
@@ -419,11 +420,9 @@ static ssize_t axis_fifo_read(struct fil
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
@@ -435,18 +434,23 @@ static ssize_t axis_fifo_read(struct fil
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


