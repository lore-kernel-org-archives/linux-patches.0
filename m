Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF4B13AD11;
	Mon,  6 Jan 2025 15:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178729; cv=none; b=rD1VnB4aq8/tPnDmfMBC9IaeZ3DK4AafCQ/CANmaMSUbw3E5dZ6twzqKKjSc9QL2FihHqvpvs2Iin5IUPzGICVFLLCfQjS19DDLQFhSwxjPQR3eq9v5E1Fc8ILLLiz0ID5HgcZgup+jzmhSkj+kJ9jqWa7yM2XCAzDOBcIFTNy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178729; c=relaxed/simple;
	bh=CAxqHcKmPtsQyUDMEpFb6BR1L7Z3KfUHuenyKHzbsiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6wJXgowWwn5NTYeIhvCALq03krmxBiPJM+lgZkR+8dmMrqsY6t5rGF7isyzWgNGdPJi7LeFNh8UqFUNKevDOiCdcOu/aCM+2IXN7mP4mnlmQTvFPQ7KPguDAX3XmTxIP3xSsJPB/TjYk2QWrm+l8hf+7bxPWUh0VKBG4z+WVx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdKC5GM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdKC5GM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B13C4CED2;
	Mon,  6 Jan 2025 15:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178728;
	bh=CAxqHcKmPtsQyUDMEpFb6BR1L7Z3KfUHuenyKHzbsiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdKC5GM1dXRxZzJE3DujQa084ho1fiBSUpPuFk3j1NHFO+RY29vmr/Md/3gbrV7lm
	 jjp2nn34NoMiRV47LDHmtlpZ1XVxaW1aPvB8HBtlPLgg3+AAiXrT4A3IhJdBgq0W8B
	 pAEFGB7LFSwjzMhhJuSlxMYG3G1EMAJsLXeWSfOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 041/168] zram: refuse to use zero sized block device as backing device
Date: Mon,  6 Jan 2025 16:15:49 +0100
Message-ID: <20250106151140.015362477@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kairui Song <kasong@tencent.com>

commit be48c412f6ebf38849213c19547bc6d5b692b5e5 upstream.

Patch series "zram: fix backing device setup issue", v2.

This series fixes two bugs of backing device setting:

- ZRAM should reject using a zero sized (or the uninitialized ZRAM
  device itself) as the backing device.
- Fix backing device leaking when removing a uninitialized ZRAM
  device.


This patch (of 2):

Setting a zero sized block device as backing device is pointless, and one
can easily create a recursive loop by setting the uninitialized ZRAM
device itself as its own backing device by (zram0 is uninitialized):

    echo /dev/zram0 > /sys/block/zram0/backing_dev

It's definitely a wrong config, and the module will pin itself, kernel
should refuse doing so in the first place.

By refusing to use zero sized device we avoided misuse cases including
this one above.

Link: https://lkml.kernel.org/r/20241209165717.94215-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20241209165717.94215-2-ryncsn@gmail.com
Fixes: 013bf95a83ec ("zram: add interface to specif backing device")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Desheng Wu <deshengwu@tencent.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -499,6 +499,12 @@ static ssize_t backing_dev_store(struct
 	}
 
 	nr_pages = i_size_read(inode) >> PAGE_SHIFT;
+	/* Refuse to use zero sized device (also prevents self reference) */
+	if (!nr_pages) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	bitmap_sz = BITS_TO_LONGS(nr_pages) * sizeof(long);
 	bitmap = kvzalloc(bitmap_sz, GFP_KERNEL);
 	if (!bitmap) {


