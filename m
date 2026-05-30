Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020B0481DD;
	Sat, 30 May 2026 17:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160776; cv=none; b=RRhLGX60JFrZ7Ekht5toDbsYMk8CwjOWw867gQdxcELKn2BZH2PffHQ7oh/W0D/+cngWlNHbmMvrHOTz4Ow4W6X/5ww0NXzAId+yTOLFnMLvbZf3eE3s1U1C1DEAykER4hojkAUslxdrENxr9SGcft9Ut8GdGzTvBpDR8Wc9T50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160776; c=relaxed/simple;
	bh=5uAjR2NEvfnFoJNKZzL4eQxI4bR7Zq9a5wdWdYRN81I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g52YHqfZYWZZmVK0BYiVIF0HdfY5TY+jzQbiPSWPKqZ0jyTTc23Pm9uFYU/lE4b7zha0sw5y0Bn/kojbn8HMT7oBjNsOY4aALTAWUDL7GaWrxRc2pOEem6fYUAy6JxkuzFT9szgkdga04Uc8uhVsVbjqD7WW7y2cZNY9bGdrpIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mn+iuyjM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mn+iuyjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4677C1F00893;
	Sat, 30 May 2026 17:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160775;
	bh=/XbOxj25JCFzjPD5ECNZt/I1ePP+wVEfgRGno9rIAdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mn+iuyjMGl0iy9pqvYcWEQrpj5GaQujPZ483ddXTq41AXSd3ucDo4AJBG1pqhuzgZ
	 nvIZDiLFhc2i2PIvw9KdaeYZVNGTspxuZ+7NBV9jLve9fIn8bghXn3q/YMidYWjqKu
	 Zz7JasKZRnUfwWHjo1MQOy/WWdW6AuHhwACII6hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@fnnas.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 431/969] bcache: fix uninitialized closure object
Date: Sat, 30 May 2026 17:59:15 +0200
Message-ID: <20260530160312.161639627@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

commit 20a8e451ec1c7e99060b1bbaaad03ce88c39ddb8 upstream.

In the previous patch ("bcache: fix cached_dev.sb_bio use-after-free and
crash"), we adopted a simple modification suggestion from AI to fix the
use-after-free.

But in actual testing, we found an extreme case where the device is
stopped before calling bch_write_bdev_super().

At this point, struct closure sb_write has not been initialized yet.
For this patch, we ensure that sb_bio has been completed via
sb_write_mutex.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Signed-off-by: Coly Li <colyli@fnnas.com>
Link: https://patch.msgid.link/20260403042135.2221247-1-colyli@fnnas.com
Fixes: fec114a98b87 ("bcache: fix cached_dev.sb_bio use-after-free and crash")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1373,7 +1373,8 @@ static void cached_dev_free(struct closu
 	 * The sb_bio is embedded in struct cached_dev, so we must
 	 * ensure no I/O is in progress.
 	 */
-	closure_sync(&dc->sb_write);
+	down(&dc->sb_write_mutex);
+	up(&dc->sb_write_mutex);
 
 	if (dc->sb_disk)
 		put_page(virt_to_page(dc->sb_disk));


