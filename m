Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86531371076;
	Fri,  7 Aug 2026 14:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113778; cv=none; b=LJb4/nosI68FMZOZOh1mOvD2BUDi0VrPzCr0rC8jSbIk8DQUqLtrc9iWKBrIKA2dee5VbxAK7/myW7eSxDO0uxrPELHL/1CWVVNbh+3C39xAcSjUCIQTIz3pcpiYCJE+mZ40ZrUpr69//GGex2ZDfHynpDLY7DjWD1ja0jEBDxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113778; c=relaxed/simple;
	bh=qRYk/3Q0DcPn70hwHaLxDv40iWPGG/w5oazj/YYCClo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOekmWAbMugERBYfc/aPg7NPm/WzBzq8Jxnx2pdT3ki+RG62j61Tvma3oCTjKzGx2tRCoJ35xTnZv4atS+qdNwk0NZawlbkaA+xP6ya+l1MLZYy8MU56L4B2MUh/yVF9beluOpfhMlCo+wLVPVZjMooe+3qVFHvcl2oyMWh8s+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfzF0XAX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfzF0XAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7988A1F01558;
	Fri,  7 Aug 2026 14:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113754;
	bh=ntaw7rKa3JFf3fZvCvrvdNwGomi4whBr2vRWFAS0oB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UfzF0XAXJf+qkgKninhiMjCO35/ucyjY2ZG5wq4bKfEuQZbAEZ3W1/B1WoiaDOi2F
	 93MIl5MCGwvnebXujVKi5m5Xju8K/6rsPxREyITlAmcGt0ASOPFGAaiv1HGDebhGyi
	 uvzi/fBh+U7ksOABMljeTVneUUrNKrEujddyyx5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/337] dmaengine: idxd: fix fdev setup failure cleanup in idxd_cdev_open()
Date: Fri,  7 Aug 2026 16:33:46 +0200
Message-ID: <20260807143419.021628405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
index 8dcd2331bb1ac..14b322ac6e6c6 100644
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



