Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED2C3B3BE6;
	Fri,  9 Oct 2026 14:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555797; cv=none; b=GS9CKSTeB5wDcYE7CWuxaXSIeStcBo3WjjA+zP7ZRMvl/RhZOweMr3Y5gcXJDss00KUSE6ieKeCiFUkjAweq0WR3xDZ1B9/TIUFRZc0xBGDUGV7DAt61gMzkvZrPXk15NKmEPqU+j/cVyMhWQJJ+J/+PbQzmYSIEPcCMkTT9gEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555797; c=relaxed/simple;
	bh=voN9gFMkvyMxc5nN1Dos9TWJ+Jg70dyeWFxECx3D2Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tj9XnpE/Kgipsbsuuda03Kuv7dy1hNDrXpzXDoH6Kl3BwQPNGb4RVLGkjyZ3a0Izu68uvj0r6YyPvPmYtfdReyvyPwVERDyX46w2mEO5mM6liWTYdK3PeVGxzSNr8/JLqIWgdoq4I87iwqPg032cIE1laqKqCdjeffc7QRPc4qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eiCva+CV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eiCva+CV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485EB1F000FF;
	Fri,  9 Oct 2026 14:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555796;
	bh=p90ek6yTax+QGJDCwEd1tmDL2mn6kREbM4qCIvXCw4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eiCva+CVv33Shx/EePmpkgIyB0i5CvLfaUDJi5aQXSO6I51bsXbidRcN21eA02jjj
	 yjU7AWE71MOLCvqsN0k6t5BvtJQVTQgoU3nmEsFh1mFLSceEEdTyD2SJ3r6zfgUbfY
	 +s1aND0BmkV8yIJp/+vUUBY8iKZdKQnyFN1AMY5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 071/428] nvmet: preserve device path on allocation failure
Date: Fri,  9 Oct 2026 16:06:48 +0200
Message-ID: <20261009140947.715395532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit 2f271b812170d4cad578bae1f91db72f3c2e36e7 ]

nvmet_ns_device_path_store() frees the old path before allocating its
replacement, losing the existing configuration if allocation fails.
Allocate the new path before freeing the old one.

Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 6286e38436ddf..b03b5d1c2dc3d 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -534,6 +534,7 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
 	struct nvmet_subsys *subsys = ns->subsys;
 	size_t len;
 	int ret;
+	char *new_path = NULL;
 
 	mutex_lock(&subsys->lock);
 	ret = -EBUSY;
@@ -545,12 +546,14 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
 	if (!len)
 		goto out_unlock;
 
-	kfree(ns->device_path);
 	ret = -ENOMEM;
-	ns->device_path = kmemdup_nul(page, len, GFP_KERNEL);
-	if (!ns->device_path)
+	new_path = kmemdup_nul(page, len, GFP_KERNEL);
+	if (!new_path)
 		goto out_unlock;
 
+	kfree(ns->device_path);
+	ns->device_path = new_path;
+
 	mutex_unlock(&subsys->lock);
 	return count;
 
-- 
2.53.0



