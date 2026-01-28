Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6B82DF155;
	Wed, 28 Jan 2026 15:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615272; cv=none; b=oWYkY8bUrBXigeQqiIBzfOUh0odDG6bguJm3tnffq/vcF4p5u55y2kre/BamfyqqO/OhA8blbN50G78Ei2zjArhiouVvO7aNYZWsB1AtbYtL6OtuX7lR8gXSUFrAKcntaSoRsdhUXRLOKGO+LzdJOQnnbl56/0+DPZ51fSCZneQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615272; c=relaxed/simple;
	bh=4ikcEW48rDG0AJyynYPtwhXv2bTBedLUM9lGkjGAnTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjLh+QIGvdlt6U3D5IuQtLalxMihKiGu8fP2qPqt61tshOBOZh59jCA+vJsmyuDPFXyE57WiLBDjHWftZw2yHF3Jm4O8CPce5DkobauBks09eYnexjUqNYhJ+1yWRj18NQ/PfSEAeU+6VDdhvIgrBY25P2gHvGHb3LbvSUiYA04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IAbiPg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IAbiPg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA5DC4CEF7;
	Wed, 28 Jan 2026 15:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615272;
	bh=4ikcEW48rDG0AJyynYPtwhXv2bTBedLUM9lGkjGAnTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IAbiPg8g56D5kDQijwML5YIFOCMsZWB9mIapr2Hbld6W9W1i9PpRS+u520qx5DcF
	 MTFcMkOQaul04lL4SsxQInQ15ki+pbsOlNgcFeEKYNmuSfEis3HVVKdCf6kMj4UeqL
	 nVgYYj/y4fH9zc5Dht/zDg2U7S1Aj/XR+CxWRvbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 6.12 130/169] uacce: fix cdev handling in the cleanup path
Date: Wed, 28 Jan 2026 16:23:33 +0100
Message-ID: <20260128145338.688005823@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Wenkai Lin <linwenkai6@hisilicon.com>

commit a3bece3678f6c88db1f44c602b2a63e84b4040ac upstream.

When cdev_device_add fails, it internally releases the cdev memory,
and if cdev_device_del is then executed, it will cause a hang error.
To fix it, we check the return value of cdev_device_add() and clear
uacce->cdev to avoid calling cdev_device_del in the uacce_remove.

Fixes: 015d239ac014 ("uacce: add uacce driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Acked-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Link: https://patch.msgid.link/20251202061256.4158641-2-huangchenghai2@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/uacce/uacce.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -556,6 +556,8 @@ EXPORT_SYMBOL_GPL(uacce_alloc);
  */
 int uacce_register(struct uacce_device *uacce)
 {
+	int ret;
+
 	if (!uacce)
 		return -ENODEV;
 
@@ -566,7 +568,11 @@ int uacce_register(struct uacce_device *
 	uacce->cdev->ops = &uacce_fops;
 	uacce->cdev->owner = THIS_MODULE;
 
-	return cdev_device_add(uacce->cdev, &uacce->dev);
+	ret = cdev_device_add(uacce->cdev, &uacce->dev);
+	if (ret)
+		uacce->cdev = NULL;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(uacce_register);
 


