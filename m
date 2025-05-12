Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADF8298CBC;
	Mon, 12 May 2025 18:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073321; cv=none; b=ly4J7Rz/8Lh/RwkS0hqWMERDyRD9y0WfLO+Caw4/5q0N1Z9qxD2BYlfSbYfV+pB1rSIwquwsWYsvf1C9nc79MTsv1fWkcXJtZfUv1ZhXpzZeuB04R4+92Q/xbdlyQQNK5N8Y+uCB966GJNSVKpl/ooyTuwjigph9zbOrFkQ82MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073321; c=relaxed/simple;
	bh=CtzNqcF8Ar15ajOOIjzyDce+R4Wtysh4iU9tDTNkwjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JozDOyjbvoi7oJKvpYTSNG49CcP7f18pn/Ec2x1yBNeI4soA7M/1LhjqxFWxgSJudVF4IE7nS/LK+cTjrXpoA1Dupx32B4w/hZRR4glMAbzrOc681T5PbleN4CIUgv586Spl7lcp+uY32oBUEqHtyU2xIMVq76so9BRcT8GOqq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsZSHUO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsZSHUO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A574C4CEE9;
	Mon, 12 May 2025 18:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073321;
	bh=CtzNqcF8Ar15ajOOIjzyDce+R4Wtysh4iU9tDTNkwjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsZSHUO7vTJz61DZhcUurShpSPUJ7RJX9tB8aMu+f2N1YE9f3RFrvfzr59z18gIEI
	 PriYGA+2aSvYP5Zi3ocMaoecfu0NfUkBkdxTTVk2pRR+97nMp1mUfkehrz12BXQMH4
	 OP1qiJaKas4LIw3HzkCPeaIHFbGPD7a4gE9ayffk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>
Subject: [PATCH 6.6 038/113] staging: axis-fifo: Remove hardware resets for user errors
Date: Mon, 12 May 2025 19:45:27 +0200
Message-ID: <20250512172029.221238191@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Gabriel Shahrouzi <gshahrouzi@gmail.com>

commit c6e8d85fafa7193613db37da29c0e8d6e2515b13 upstream.

The axis-fifo driver performs a full hardware reset (via
reset_ip_core()) in several error paths within the read and write
functions. This reset flushes both TX and RX FIFOs and resets the
AXI-Stream links.

Allow the user to handle the error without causing hardware disruption
or data loss in other FIFO paths.

Fixes: 4a965c5f89de ("staging: add driver for Xilinx AXI-Stream FIFO v4.1 IP core")
Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Link: https://lore.kernel.org/r/20250419004306.669605-1-gshahrouzi@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/axis-fifo/axis-fifo.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/staging/axis-fifo/axis-fifo.c
+++ b/drivers/staging/axis-fifo/axis-fifo.c
@@ -398,16 +398,14 @@ static ssize_t axis_fifo_read(struct fil
 
 	bytes_available = ioread32(fifo->base_addr + XLLF_RLR_OFFSET);
 	if (!bytes_available) {
-		dev_err(fifo->dt_device, "received a packet of length 0 - fifo core will be reset\n");
-		reset_ip_core(fifo);
+		dev_err(fifo->dt_device, "received a packet of length 0\n");
 		ret = -EIO;
 		goto end_unlock;
 	}
 
 	if (bytes_available > len) {
-		dev_err(fifo->dt_device, "user read buffer too small (available bytes=%zu user buffer bytes=%zu) - fifo core will be reset\n",
+		dev_err(fifo->dt_device, "user read buffer too small (available bytes=%zu user buffer bytes=%zu)\n",
 			bytes_available, len);
-		reset_ip_core(fifo);
 		ret = -EINVAL;
 		goto end_unlock;
 	}
@@ -416,8 +414,7 @@ static ssize_t axis_fifo_read(struct fil
 		/* this probably can't happen unless IP
 		 * registers were previously mishandled
 		 */
-		dev_err(fifo->dt_device, "received a packet that isn't word-aligned - fifo core will be reset\n");
-		reset_ip_core(fifo);
+		dev_err(fifo->dt_device, "received a packet that isn't word-aligned\n");
 		ret = -EIO;
 		goto end_unlock;
 	}
@@ -438,7 +435,6 @@ static ssize_t axis_fifo_read(struct fil
 
 		if (copy_to_user(buf + copied * sizeof(u32), tmp_buf,
 				 copy * sizeof(u32))) {
-			reset_ip_core(fifo);
 			ret = -EFAULT;
 			goto end_unlock;
 		}
@@ -547,7 +543,6 @@ static ssize_t axis_fifo_write(struct fi
 
 		if (copy_from_user(tmp_buf, buf + copied * sizeof(u32),
 				   copy * sizeof(u32))) {
-			reset_ip_core(fifo);
 			ret = -EFAULT;
 			goto end_unlock;
 		}


