Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37EC158525;
	Mon,  6 Jan 2025 15:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178183; cv=none; b=jzyWFLR2buRFbY8gVmqbMBbtFolbFm4wydmFXTTXGcRvAb0Rzrh2TjXkbeK7Ow+qkXLg+YGCZkfz8qS456YIU7RuSylXvpqW4fXhv+SABjP8nf6t2tw1SMnVNJtDju6Fe5JRdqvzmlR2OR/VBEsg41fl625DarbvlO/qRNtUZeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178183; c=relaxed/simple;
	bh=4F+tw9nq/IftyWvPxb3s5FGdxoRCpYiC+4icxcNLK4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZ2z5GwYVP4/6JZ8op6jEA+6JgObR9/q/xg900ixq6joh5axw4HDKlEV4jO0RlULDMulRznPrTZyadhEQ9RQVB2NXToYd4PhqfN8fbBHiKCZ8SavhsXGb6Xjg8atZAh5iofB3OP86EQjcXtl7QnOsD2Q2QvTu3suDRiA7c16YuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjFC4aHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjFC4aHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F309C4CEE4;
	Mon,  6 Jan 2025 15:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178182;
	bh=4F+tw9nq/IftyWvPxb3s5FGdxoRCpYiC+4icxcNLK4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjFC4aHYo5IP7/aLKdfMl7d87+ZaKwbQtrpF42udtpeftiE8fAiaIOVEEzzzIWfcT
	 flP8AbmSr5/j1RB9ArS3hZNLQwhQmDyk9aBTuZt0PrXsJE52WHHqs2r2TNXTpdU6IL
	 6KHq1QMTFc3/jidgf76WvaW7T2WHc/8VwxiW+rII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 033/138] zram: refuse to use zero sized block device as backing device
Date: Mon,  6 Jan 2025 16:15:57 +0100
Message-ID: <20250106151134.474991677@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -502,6 +502,12 @@ static ssize_t backing_dev_store(struct
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


