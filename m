Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B43C358D30;
	Fri,  9 Jan 2026 12:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962296; cv=none; b=rnXzZMSG2XF+TxuNX8CN80UmnXxnEHG98flnOMlQqTUvgLyMsvRz/ujsfpaFFHlJfiZv7lDgq2isNHNjK/te9f8NBMb2mII0TdI/JeZHmsxV7eWp2/Zqiuwybwc/zPrjpx1uP3q/0YAHczUYZwuSYdFiZG4VyT718Ypf7fMA+Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962296; c=relaxed/simple;
	bh=Wq67FhFgAN2dZv/byromzdazjiKOY5SbGcN25s1PYlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpWFGBQughg4x4ohkLR7xdXWKNfN+tTqNbVwK82jNo1gp8vgUzt9cDP8jR+k+Uti+3kihuXX8GNKK9xpnjHa8BLjop6G9EbkflVy4JLQcE+DL6x2oNb4tLQO1sENxx5Y77JTjoNdERycPR4KB2E4k4LXv38DvkTPYZsUbP17Nr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tePmg9Q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tePmg9Q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0E0C4CEF1;
	Fri,  9 Jan 2026 12:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962295;
	bh=Wq67FhFgAN2dZv/byromzdazjiKOY5SbGcN25s1PYlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tePmg9Q8eNPI/I6l9LZ0y5QgBbdfW5uu1rMjwWIxReUTl87iyC3pZ3wNH70YovHl6
	 E/3Zzhlf+eZw9UxY1TKK2mIEWq9VzcW4vazPHdFLYvcHEL0xhT1HemqwhqI0xZg9Xo
	 +27WyW+R46RrpB7mlzajyVeCtqhNgSjKahMP4RRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 282/634] block: rnbd-clt: Fix leaked ID in init_dev()
Date: Fri,  9 Jan 2026 12:39:20 +0100
Message-ID: <20260109112128.143742795@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit c9b5645fd8ca10f310e41b07540f98e6a9720f40 ]

If kstrdup() fails in init_dev(), then the newly allocated ID is lost.

Fixes: 64e8a6ece1a5 ("block/rnbd-clt: Dynamically alloc buffer for pathname & blk_symlink_name")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-clt.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index 5eb8c7855970..4291bdbe36ba 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -1440,9 +1440,11 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
 		goto out_alloc;
 	}
 
-	ret = ida_alloc_max(&index_ida, (1 << (MINORBITS - RNBD_PART_BITS)) - 1,
-			    GFP_KERNEL);
-	if (ret < 0) {
+	dev->clt_device_id = ida_alloc_max(&index_ida,
+					   (1 << (MINORBITS - RNBD_PART_BITS)) - 1,
+					   GFP_KERNEL);
+	if (dev->clt_device_id < 0) {
+		ret = dev->clt_device_id;
 		pr_err("Failed to initialize device '%s' from session %s, allocating idr failed, err: %d\n",
 		       pathname, sess->sessname, ret);
 		goto out_queues;
@@ -1451,10 +1453,9 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
 	dev->pathname = kstrdup(pathname, GFP_KERNEL);
 	if (!dev->pathname) {
 		ret = -ENOMEM;
-		goto out_queues;
+		goto out_ida;
 	}
 
-	dev->clt_device_id	= ret;
 	dev->sess		= sess;
 	dev->access_mode	= access_mode;
 	dev->nr_poll_queues	= nr_poll_queues;
@@ -1470,6 +1471,8 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
 
 	return dev;
 
+out_ida:
+	ida_free(&index_ida, dev->clt_device_id);
 out_queues:
 	kfree(dev->hw_queues);
 out_alloc:
-- 
2.51.0



