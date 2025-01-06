Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387C986332;
	Mon,  6 Jan 2025 15:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179093; cv=none; b=UdXUJM0b3CVmym5qSsjBNtJHApRk/AUs2f6HKw05bl7jsqkfOIE7GP+G89XP67reEndDyLVNpEcQYC3cMl6aczAX2DZRV+0quy076rsRroHTOdx7y69zi1+KY8bSp7XpDPTH0O7cOtPRMoBxJ9mmtw7FzMOEsgi1gsXFQoIdkuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179093; c=relaxed/simple;
	bh=GGoQAklAL9YOZlRqFldmilEDderT6rt+FFb5wuSEPFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvmg3Ob4yRRyFBiVLcutMyLrvv1TTOYq8yHukiY33ooalirtNap2bqKqgcnyyIByBQfldl0+Dm87pwDYPXirE1Sz0fFsGlWb4jOaG0eksqCupWx8R8GGZMjIbOrZPyE83hQXeRGglxTysQkaeMxTfqeIzJW0w9b1KT04nhzh3+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkvioqOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkvioqOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0004C4CED2;
	Mon,  6 Jan 2025 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179093;
	bh=GGoQAklAL9YOZlRqFldmilEDderT6rt+FFb5wuSEPFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkvioqOCbYmkNfrOt5I/egxJ3tDE//3DXHtn4QI4BqbchY0JTPwzvImSBlRmiKQu6
	 KNB0doblw6i5rUmswDQ9aw+bkTTR4EQB637kT8TZWtWl7+JM0DvXdqIOlAHnwX+5vp
	 vj/buE/8A7jrF+bSqT0ieuLxvAPXCPm1ehgbYjrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 25/93] zram: refuse to use zero sized block device as backing device
Date: Mon,  6 Jan 2025 16:17:01 +0100
Message-ID: <20250106151129.654303077@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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
@@ -495,6 +495,12 @@ static ssize_t backing_dev_store(struct
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


