Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AC42D5408;
	Wed, 28 Jan 2026 15:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614676; cv=none; b=frJxOGYwWdlRldTfa6sgR2LBd7m2onvjpUoOFLPhq/ApQWMH7lQqXrilWn6PfPSzi73kyGC5uDsn5TjoDSvlcwfxrpiHkMnw6TrjotyOYX84+uXxCyvMyBj5AGew4gENR7vNo/IVJWlz3HgR4zrVTu8eZva402Cx9d624HBypnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614676; c=relaxed/simple;
	bh=Pn4V0EUwDaZ7lo3Zmp1UjDM+lfB2yVMxNeD4eDUVvjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Es6sA2O9ncMYeG6KSVsGEkLxrdMnXTFGy5B3oCFD7a/mVfXXNbefSHuF+yUrpVijo+ius+SxTOBQwZ7S2MLKuDUG3fUNrXYEFc6ZdnBVDLpsZzXNV+pUOorKLOuKih1YlaHnbbp3IGwU9+EWcjQzhBwbGvFC2oLsG5xciYejuZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiCOZ/rF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiCOZ/rF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09C5C4CEF1;
	Wed, 28 Jan 2026 15:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614676;
	bh=Pn4V0EUwDaZ7lo3Zmp1UjDM+lfB2yVMxNeD4eDUVvjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiCOZ/rFEWMT0KEHY1YsyjS2dAvL0xDN9mYfpaygJR0jtA55cWctJCR1SWH0pemOd
	 vKIpMM23JVz/D1jD3MG750JfyfQWb5f1j0SwIRlSeBpz7MrJAzI5ld5n6bIEjkfgaX
	 2tuFIub9apo1g+M/V8rjFg98SkfDOIMFyEx7Xsg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 6.6 207/254] uacce: fix cdev handling in the cleanup path
Date: Wed, 28 Jan 2026 16:23:03 +0100
Message-ID: <20260128145352.244410563@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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
@@ -553,6 +553,8 @@ EXPORT_SYMBOL_GPL(uacce_alloc);
  */
 int uacce_register(struct uacce_device *uacce)
 {
+	int ret;
+
 	if (!uacce)
 		return -ENODEV;
 
@@ -563,7 +565,11 @@ int uacce_register(struct uacce_device *
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
 


