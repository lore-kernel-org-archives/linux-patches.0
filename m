Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A592A1D7E41;
	Mon, 12 May 2025 18:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072832; cv=none; b=j9af/a3fkfAL+0pAOpXM9WgiuPvH0ID6C+Xbw1ZJFbyM1SdI9J6dnSoX1pUH8Hgg4VmvMtx+7wyT7Wt4OyEY9S8EuXObSHHQUqnBegkua8k5YmW+QwtpFWKIXBFoeYGwPko1i6Yf0jjHGyjApHzh4lwbkyyd4s1YoLL7+Igl01s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072832; c=relaxed/simple;
	bh=mkPskb1RdPUSNU/onrUUvk/oS9PgBRHk22QznfFdLJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLbWWQOVQ7nrQ5p4jf9Mc5oQT9EkxCaeYwEtiypdd29noNtJXwhJnchwtoUZyCxxnMBOkjIBi5aOHBqsTY0fmXHjx7Qeqqpr4PGnOeniTbb4UM26sbJjhnhuWDx5SxbPvPkRNPGQKlQhVeo87uW34vkcV9RJYsFIPY229k6qduY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YX5+0pgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YX5+0pgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7036C4CEE9;
	Mon, 12 May 2025 18:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072832;
	bh=mkPskb1RdPUSNU/onrUUvk/oS9PgBRHk22QznfFdLJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YX5+0pgdopXtSnv2Pu0OwGRiIuQH00tpNE/l8/Is6ADd8Gzl4xXBp3AuJU0yIoikU
	 IX5xZlutNFLo1e+kjEmr7domezQIKEKtjzoaJ7HGSIKNpENHzpZefP5wAGvQEw8qxY
	 s5Dh5w3K4cSnb/0KNF9oq1qf7+OsyV/N0GK0w5Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>
Subject: [PATCH 6.12 070/184] staging: axis-fifo: Remove hardware resets for user errors
Date: Mon, 12 May 2025 19:44:31 +0200
Message-ID: <20250512172044.685034300@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -393,16 +393,14 @@ static ssize_t axis_fifo_read(struct fil
 
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
@@ -411,8 +409,7 @@ static ssize_t axis_fifo_read(struct fil
 		/* this probably can't happen unless IP
 		 * registers were previously mishandled
 		 */
-		dev_err(fifo->dt_device, "received a packet that isn't word-aligned - fifo core will be reset\n");
-		reset_ip_core(fifo);
+		dev_err(fifo->dt_device, "received a packet that isn't word-aligned\n");
 		ret = -EIO;
 		goto end_unlock;
 	}
@@ -433,7 +430,6 @@ static ssize_t axis_fifo_read(struct fil
 
 		if (copy_to_user(buf + copied * sizeof(u32), tmp_buf,
 				 copy * sizeof(u32))) {
-			reset_ip_core(fifo);
 			ret = -EFAULT;
 			goto end_unlock;
 		}
@@ -542,7 +538,6 @@ static ssize_t axis_fifo_write(struct fi
 
 		if (copy_from_user(tmp_buf, buf + copied * sizeof(u32),
 				   copy * sizeof(u32))) {
-			reset_ip_core(fifo);
 			ret = -EFAULT;
 			goto end_unlock;
 		}


