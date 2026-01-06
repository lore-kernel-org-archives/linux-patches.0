Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1323034A78B;
	Tue,  6 Jan 2026 17:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719952; cv=none; b=izykvyznGbLlBWGiilpjQgXiidb2AV786WE/4G8vpOhUz0o9m0UypFGer0WIUXwcTHrXMchjpgWNfCqj91/opKF8ixmC9wnS1xk3Q2DxbcDN3DDu0ZcfANCzLddbqBs56nlFHS6xw806sInEytkm37P1BgFqIzpwUZ8MtIq8CVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719952; c=relaxed/simple;
	bh=I/n3xfR0qv+Kj1Z2WeKbYI1ihNGp2i16BfAHzSzevyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAOQP2YLqrR2JHuikKYA1Lxk6n8UKd+etNeH8TWkEijI9+dqc82SciBtq8BAZl4pwv/893z0v2BZzsAU2J/DC2A7TECnIFd95XiDa8KaxojRmHcGkQnEbTnvV+2QQ3K0JJ2ogMipdwlWzNlWnGFV0MKpE3ZHlIIFZ0A15pt+SLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDG1W8Y2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDG1W8Y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDADC116C6;
	Tue,  6 Jan 2026 17:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719951;
	bh=I/n3xfR0qv+Kj1Z2WeKbYI1ihNGp2i16BfAHzSzevyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDG1W8Y2xqB3UsVgCHeIWZLfMwAfexkux6sNEY8Izo2VGhVHwvhoWwst0iY2NKUvk
	 mmUWeAmO2T92hsHlEuSxq4h2qCXEvzfVDbCiHpwKSaKQEi1uPcL/YAxnOM9geJKOJ8
	 5ro0UntutzEHipHLhwDBLAcBA12GdT6b0qS8gaHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/567] block: rnbd-clt: Fix leaked ID in init_dev()
Date: Tue,  6 Jan 2026 17:57:51 +0100
Message-ID: <20260106170454.622589614@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c34695d2eea7..5be0581c3334 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -1424,9 +1424,11 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
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
@@ -1435,10 +1437,9 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
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
@@ -1454,6 +1455,8 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
 
 	return dev;
 
+out_ida:
+	ida_free(&index_ida, dev->clt_device_id);
 out_queues:
 	kfree(dev->hw_queues);
 out_alloc:
-- 
2.51.0



