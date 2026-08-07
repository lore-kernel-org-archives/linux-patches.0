Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA91A18E02A;
	Fri,  7 Aug 2026 15:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115813; cv=none; b=XIrAyFZ7eGeEbfy78zfGX+/tR4dZi4XlnsEk+Ef3raprXL95fQOIGdfBGO/MwMLE1xhunTuB4ZcsMiMawSWxiubMqqEef8Wm/qYu0SkXUO7/nN5RqL9RAkxZ1UkF9mGMaLcbLzcWUMBT4QOnwJCbYNKb6DEZ7x85NXVUW+hgKUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115813; c=relaxed/simple;
	bh=U/+zlx3Zxnw5p2CR2rEeU/I5sVrFC2A4C+CXE78jIcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UC8yb2/ZgqP7AI2CUu6mJ91o7FntQ/xFF/7EKqos2CRl9zKOC4xWBbF73NeJE9lipLqDj0shLFTEoIYrHOkGSkcgXeLyeahnhauMyidL9AN2hZejhKgUyNWx3LHQ7S3caFYavyXHUnIln73NDP74nF95Zrzgdvd+FcNLGpEcc34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GIQkfZy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GIQkfZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEDB1F000E9;
	Fri,  7 Aug 2026 15:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115812;
	bh=I/fmKOHMdlKN0ukAjPg1RfvFIyVleBGH/IfHLScMOds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0GIQkfZyQTYpqR81ephBCLjm/9NS6R2/JEz1JDA0+7JBYbl+nkGrfk5Ajso0sc8t8
	 Mg3Nat/7+IDnNPsl4gsM+ruXDR5iStvdmK1x3ZmTVpSFcGCdKXNcuxdKflsehN70KV
	 C55Dzjgk5bRelIuc117JDaH0KkRnezehHpmfJGwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/261] dmaengine: idxd: fix fdev setup failure cleanup in idxd_cdev_open()
Date: Fri,  7 Aug 2026 16:36:09 +0200
Message-ID: <20260807143415.629858616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit ee1d7274102285d78a53161fc705a8d8cd40b066 ]

The failed_dev_add and failed_dev_name paths drop the file-device
reference while wq->wq_lock is still held. If put_device(fdev) drops the
last reference, idxd_file_dev_release() runs synchronously and tries to
take wq->wq_lock again, deadlocking.

Those paths also fall through into the later ctx cleanup labels even
though idxd_file_dev_release() owns that cleanup and frees ctx. This can
make idxd_xa_pasid_remove(ctx) and kfree(ctx) operate on a freed context.

Move idxd_wq_get() before file-device setup can fail, since the release
callback always calls idxd_wq_put(). Then unlock wq->wq_lock before
put_device(fdev) and return directly from the file-device setup failure
path, leaving ctx cleanup to the release callback.

Fixes: e6fd6d7e5f0fe ("dmaengine: idxd: add a device to represent the file opened")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260525141550.1385581-1-dbgh9129@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 5ded4a0887bc8..e885d5af485b2 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -293,6 +293,7 @@ static int idxd_cdev_open(struct inode *inode, struct file *filp)
 	fdev->parent = cdev_dev(idxd_cdev);
 	fdev->bus = &dsa_bus_type;
 	fdev->type = &idxd_cdev_file_type;
+	idxd_wq_get(wq);
 
 	rc = dev_set_name(fdev, "file%d", ctx->id);
 	if (rc < 0) {
@@ -306,13 +307,14 @@ static int idxd_cdev_open(struct inode *inode, struct file *filp)
 		goto failed_dev_add;
 	}
 
-	idxd_wq_get(wq);
 	mutex_unlock(&wq->wq_lock);
 	return 0;
 
 failed_dev_add:
 failed_dev_name:
+	mutex_unlock(&wq->wq_lock);
 	put_device(fdev);
+	return rc;
 failed_ida:
 failed_set_pasid:
 	if (device_user_pasid_enabled(idxd))
-- 
2.53.0



