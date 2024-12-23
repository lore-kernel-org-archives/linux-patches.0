Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA2019E98B;
	Mon, 23 Dec 2024 16:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970444; cv=none; b=hjqa3TGEp8oBXKlTMyrpb/xD0Fw2TiufGHlHsCYzzvBGromKAkdYs170im/u4pPHhLY/cKwHFcVDvZDjwuZDcGmA7tknQb8znZcvtGwNK4Nm18mC/M1EB5MiRJOeHcH4SZfs5pbPgd+Uor3WH4lb7sQh7bK1JGk7p27FjZOaBqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970444; c=relaxed/simple;
	bh=7UnvwAYfO5dPwS/vqPNNfn0+6IaVJktUkyj7sjNBY8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NN6ZRHlhnkbti1ipKAcmoUYxoutBSSMGom2dGtLfchiY1lrTe4YxA9fgax6CIagztpZjp8tqP741D/67WAIUDdpukCoc5JAFj8zE3ioMKlktLh0JwlrrnRBAftfIE48uJBxm6wv2UMm3zE3xDPSTqbWKKsYrG8UhHba54vpyXxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmTOT5Pb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmTOT5Pb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD561C4CED3;
	Mon, 23 Dec 2024 16:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970444;
	bh=7UnvwAYfO5dPwS/vqPNNfn0+6IaVJktUkyj7sjNBY8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmTOT5Pb5YULQdP9osVqs6dAN+99aYakbf1SRYDLpfYcmreHgFwlUZyRiw1F+dzIi
	 YGkg/oYkdvns8wZvtnS4ndTS06gCbQMF83tYwc1HhLmgvfjZUFGHatIoxw3dslWOxg
	 BDcP0yvLXzieR/gb2q3TV+lIhQx3GgKYo+G5UBbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 085/116] zram: refuse to use zero sized block device as backing device
Date: Mon, 23 Dec 2024 16:59:15 +0100
Message-ID: <20241223155402.869566616@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
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
@@ -538,6 +538,12 @@ static ssize_t backing_dev_store(struct
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


