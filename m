Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D753D522C;
	Thu, 15 Jan 2026 17:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499345; cv=none; b=Pogu9fNM1tpEVqsOVWGVh2eg4LoXym53kTZLuWQDXc2AzPJwlyx1Xl48nbrCebk7kFhG2su/D996fE6lOuZ88bpJftb7J7cbMyOkH/APYrJIFLX5YAjjhBZh1X3tvmRjUXmAepsXrL0B9VF1/NIJkhl31k7z5hCdOiTQebMO6tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499345; c=relaxed/simple;
	bh=lI9My9LglapK0/vtJf7eh3mYFHRfUbRjpoUjrz05cXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcW1b7C9gQ9Azfqg5y130qZauJEydicMKOkHYK/JM0mghF63y4n9V9miabS/LCwvzyex9GeWVL98fu6lANUuK7Adtybrm/ceI0S+VGBqNysg4HJHvsyDKu5G2virvKnX8Y29Ky/AZ61EXU3WFn5hkFYrGa/ejn8Z5iAb+lxq/10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfLfVxqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfLfVxqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6A4C19423;
	Thu, 15 Jan 2026 17:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499345;
	bh=lI9My9LglapK0/vtJf7eh3mYFHRfUbRjpoUjrz05cXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfLfVxqKby+W+iMxqvlnM6zO3JROYH159K+yjIb5plMK3zsznyKtWg/8Sg21w4sUV
	 RkvASFhmfTvJHjdJQFS94oKFuQPuriwwS9+d13f8Pn6sDSXdSnZ5YVKG9I1BgCIKTw
	 hq27Q69v1VbRx6yQ/IylrwxlaG/Ripj8OaE2DU2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/451] block: rnbd-clt: Fix leaked ID in init_dev()
Date: Thu, 15 Jan 2026 17:46:34 +0100
Message-ID: <20260115164237.883966937@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ea4b7002f438..2aebb07eff92 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -1378,9 +1378,11 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
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
@@ -1389,10 +1391,9 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
 	dev->pathname = kstrdup(pathname, GFP_KERNEL);
 	if (!dev->pathname) {
 		ret = -ENOMEM;
-		goto out_queues;
+		goto out_ida;
 	}
 
-	dev->clt_device_id	= ret;
 	dev->sess		= sess;
 	dev->access_mode	= access_mode;
 	mutex_init(&dev->lock);
@@ -1407,6 +1408,8 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
 
 	return dev;
 
+out_ida:
+	ida_free(&index_ida, dev->clt_device_id);
 out_queues:
 	kfree(dev->hw_queues);
 out_alloc:
-- 
2.51.0



