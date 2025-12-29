Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9A29460;
	Mon, 29 Dec 2025 16:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025313; cv=none; b=oA2q/QL6VKDqgOaVffVWwHuktT/+/CismRmXcfPI8h/QJf9J2y31N9X3uUu01q1dx+60kYzvOWY28EhIuuY+PtFo5bwyND2O5nIp6xkRhkFG/bWrXSVnUtDbFIRDa26GUK4XHRl8x4gfHRYYKgB62YbJzPziuu9mEpSjwjmP25o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025313; c=relaxed/simple;
	bh=QddRe0mOK9OVHWc2fjpwUeZAcm6W9SeUj8SakfPg06M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmIOkfgq/xRfNd/YbPFQjIMrlsr6zJ0WYEFeIa88LPyD6/gJwINe6hnYj9Pq6trViRA18Wl3FV3ILpekGVKOKmq0jM/CFPRsXnTATYuYXLWxIsGR/p6iuXou8Au4FrTuME44QDaOgWJ7NuyDw7LPMNqn7SmPsVU3p4rIDhqUOxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zF6Ry1JR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zF6Ry1JR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7DAC4CEF7;
	Mon, 29 Dec 2025 16:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025312;
	bh=QddRe0mOK9OVHWc2fjpwUeZAcm6W9SeUj8SakfPg06M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zF6Ry1JRsTpcgbFiJLT9mHNBDYhS+6tkbwbTWDmLIG3+QvtDrZ8o21yKMazrTpn2U
	 hfQI9Y+XslWzZYsVzIrj3NGOu0CQVsfpv/g/gz/MOCben1CYAr2rYfSKQh0l+RE3Kf
	 iKN4J8N+B9PXxhGPk+/qTXM9RaZ1yBiLEMWCvcpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 136/430] block: rnbd-clt: Fix leaked ID in init_dev()
Date: Mon, 29 Dec 2025 17:08:58 +0100
Message-ID: <20251229160729.368719561@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f1409e54010a..d1c354636315 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -1423,9 +1423,11 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
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
@@ -1434,10 +1436,9 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
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
@@ -1453,6 +1454,8 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
 
 	return dev;
 
+out_ida:
+	ida_free(&index_ida, dev->clt_device_id);
 out_queues:
 	kfree(dev->hw_queues);
 out_alloc:
-- 
2.51.0



