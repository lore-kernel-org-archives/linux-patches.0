Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039A822331C;
	Mon,  2 Jun 2025 14:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874566; cv=none; b=VtrwLUnlBPIMUvxCxk3KmLBSm6dLlw9m5xNxALGQI4DNAR8wY/rlZKWMnZGsPtoI4skc0ERoumn8ywpCHpR6Ro8PzYeXg7ibKJcI5MrQEivHoJUNBTgy/mKjFASxe8LnUCd8isUlno6p+d8gaY/seZlTdjB/uyoNtrLtDkSJZJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874566; c=relaxed/simple;
	bh=VHeGDj7hfq3sjnbgzyWi5L5kkUazACXlLVZVRv1o58s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9ZN4WSolXEeT/9xt01Ufqe6kbdCgT2lTonn93Cy+5/Bnl5e0Kn7U/fWsPVhVbIeXVyvepHCdT+5U2FPiVwM8CuhpKiZMG1yhnYLBS4k0hqXqjr7eywDftn3x8c5NV7Her0oPVUZh18QD4K4+MUv9gzboW7C6VPLJ+03cIgLE/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdOo3RBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdOo3RBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6992BC4CEEB;
	Mon,  2 Jun 2025 14:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874565;
	bh=VHeGDj7hfq3sjnbgzyWi5L5kkUazACXlLVZVRv1o58s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdOo3RByh6PBpFb+JECXvkBWdWxF8IrYHcl3twsTZzWL+USqzp1+DAXBlA/IJHdS8
	 LknnpgKXk8cmCVnFy9kodjolr5U3gxWLhOu1iMGUTSzDvfKgcvI48PE6c8JLqeP9J7
	 6aoGcoTjbHBk/lHyHjnp7qA1/Jcf+0dXttkpr954=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/204] staging: axis-fifo: Remove hardware resets for user errors
Date: Mon,  2 Jun 2025 15:46:37 +0200
Message-ID: <20250602134258.195369226@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Shahrouzi <gshahrouzi@gmail.com>

[ Upstream commit c6e8d85fafa7193613db37da29c0e8d6e2515b13 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/axis-fifo/axis-fifo.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/axis-fifo/axis-fifo.c b/drivers/staging/axis-fifo/axis-fifo.c
index c1dd01c5c9ea6..42528d4593b83 100644
--- a/drivers/staging/axis-fifo/axis-fifo.c
+++ b/drivers/staging/axis-fifo/axis-fifo.c
@@ -401,16 +401,14 @@ static ssize_t axis_fifo_read(struct file *f, char __user *buf,
 
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
@@ -419,8 +417,7 @@ static ssize_t axis_fifo_read(struct file *f, char __user *buf,
 		/* this probably can't happen unless IP
 		 * registers were previously mishandled
 		 */
-		dev_err(fifo->dt_device, "received a packet that isn't word-aligned - fifo core will be reset\n");
-		reset_ip_core(fifo);
+		dev_err(fifo->dt_device, "received a packet that isn't word-aligned\n");
 		ret = -EIO;
 		goto end_unlock;
 	}
@@ -441,7 +438,6 @@ static ssize_t axis_fifo_read(struct file *f, char __user *buf,
 
 		if (copy_to_user(buf + copied * sizeof(u32), tmp_buf,
 				 copy * sizeof(u32))) {
-			reset_ip_core(fifo);
 			ret = -EFAULT;
 			goto end_unlock;
 		}
@@ -551,7 +547,6 @@ static ssize_t axis_fifo_write(struct file *f, const char __user *buf,
 
 		if (copy_from_user(tmp_buf, buf + copied * sizeof(u32),
 				   copy * sizeof(u32))) {
-			reset_ip_core(fifo);
 			ret = -EFAULT;
 			goto end_unlock;
 		}
-- 
2.39.5



