Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6292F745E;
	Tue, 16 Jun 2026 16:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628176; cv=none; b=vEs9gJDK3uxwLxVhoqHsPoWeerBnQyqf8ALqpkbD7zZyMQXy8lNEwtQRY7qI63rI49Eo2PLWexv2YPZZurbhjeEa3iWq1RkaMaLYY6wb3TyhJaHvcVK1Od7WQg1VdW2lGfae+SS/sqrWZQcAR0jJvdOZoa+WzwvSk/DlsWeU/Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628176; c=relaxed/simple;
	bh=rYSHQYd5IAE0pWiYcNMy1TpNeu76sHXWQTNOJP7ldQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uzb5ktctOQmzAIzpq1mY7SKx8SyHcsB3l7IWkdXc+sex04UTIqU7fVZjzqHZt1TZ07FPyqqlYtbr03C6a2j5P06yvu69UTrZ4GtKbXDyOMWJg61BhRdTgpV9OiBJphySfI4R+6li0PW4EZodMyGpOcyCXRobfk8f6GlpJnmf+Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebyAutkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebyAutkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7830C1F000E9;
	Tue, 16 Jun 2026 16:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628175;
	bh=WAjU6tMJ1EzMU7peSHDn5FHZapuCgqKB4LFPvL84YRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ebyAutkC1/JHMgOYrSu25pjQDhO6sKvQlsKUYDBz7J/oE9H6+wVKxiZbkE3c8RDyq
	 gVvCSIcmhYx4qjQS+4sw8DswBHOiMunvLTe1l0wnrw8+g8YZjzXYGjnXjPaI5rSyOz
	 ygrYqdcCxssMoRAysksCNld6QcnRFYSlwjeuqTB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@fnnas.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/452] bcache: fix uninitialized closure object
Date: Tue, 16 Jun 2026 20:23:53 +0530
Message-ID: <20260616145118.131745780@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

[ Upstream commit 20a8e451ec1c7e99060b1bbaaad03ce88c39ddb8 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a66423cf12d0a7..6d9349f6f8fd75 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1372,7 +1372,8 @@ static void cached_dev_free(struct closure *cl)
 	 * The sb_bio is embedded in struct cached_dev, so we must
 	 * ensure no I/O is in progress.
 	 */
-	closure_sync(&dc->sb_write);
+	down(&dc->sb_write_mutex);
+	up(&dc->sb_write_mutex);
 
 	if (dc->sb_disk)
 		put_page(virt_to_page(dc->sb_disk));
-- 
2.53.0



