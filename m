Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF74921579F;
	Fri, 10 Oct 2025 13:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102565; cv=none; b=LVwNtDX+zTfLmhMtd8fJ74jNeASabXvWM7px4CmcKsv/+3Slk3OTeNq9dU9RqsPzX6Es4pHBU9Qrsf4ZwodOCRyO/Jn9xrfU9xaVGj9IRIElQV5Kx+59E4dneI4d+Ph89byXvc5kF3JffnKi8kjcxiU/YC4JG2P90s+ekbte68g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102565; c=relaxed/simple;
	bh=7qKwVTPQC2apNpFHB2Nq10aEeXyogM/6d9Ji1RUX/Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7qErYnfhIbKYMAgwxrn9PA+/mW9ZAVeKIXjygM2xQStrvzigb1beBNVqIgD4cr6p+mnSaS0rxpK2L3/WGlh4XrL6/gDi53Mq/BOOG4bOUGETq0D0mG0hFe15VI1VAM7IlARQd3cKfLbwWJp3FbniRQ7hLHumvb4762BC67XNPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqkDtLqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqkDtLqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EACC4CEF1;
	Fri, 10 Oct 2025 13:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102564;
	bh=7qKwVTPQC2apNpFHB2Nq10aEeXyogM/6d9Ji1RUX/Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqkDtLqHGqCjibuNAX3T/9DQcVQZyNzgkDofViih4Gka7T5UEVtln2O02gsxGkjga
	 Equu9o1rzGQBP71GQwUh3z0Nuj6N8uawH8AbiBD7S5JEFs+TiFUlI338b7lEzPdXbk
	 NzbZHz8K0PoEJo5NnyAqM2riFA3bPz+bj2Cc8uC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 6.6 22/28] staging: axis-fifo: flush RX FIFO on read errors
Date: Fri, 10 Oct 2025 15:16:40 +0200
Message-ID: <20251010131331.173373899@linuxfoundation.org>
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
@@ -396,6 +396,7 @@ static ssize_t axis_fifo_read(struct fil
 	}
 
 	bytes_available = ioread32(fifo->base_addr + XLLF_RLR_OFFSET);
+	words_available = bytes_available / sizeof(u32);
 	if (!bytes_available) {
 		dev_err(fifo->dt_device, "received a packet of length 0\n");
 		ret = -EIO;
@@ -406,7 +407,7 @@ static ssize_t axis_fifo_read(struct fil
 		dev_err(fifo->dt_device, "user read buffer too small (available bytes=%zu user buffer bytes=%zu)\n",
 			bytes_available, len);
 		ret = -EINVAL;
-		goto end_unlock;
+		goto err_flush_rx;
 	}
 
 	if (bytes_available % sizeof(u32)) {
@@ -415,11 +416,9 @@ static ssize_t axis_fifo_read(struct fil
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
@@ -431,18 +430,23 @@ static ssize_t axis_fifo_read(struct fil
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


