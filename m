Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08782421EE1;
	Wed,  4 Feb 2026 15:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217967; cv=none; b=AIXzv/5S12ROy6XeYJux2puEvP60N7+/jScYbxWZMR3+eUegzJbVkvy4d1boHfvhED6uov23r9XqDdC9kU9vWFb5w2AWI8OsCbU9LHGeCwDSp3+t44IM3svt1hCX25AxJyijdVTz1IxbJSRRv7Aa4JwQCoA/1ZT/4AP9iqXZVaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217967; c=relaxed/simple;
	bh=Sj2ajQLaN/5SAwaPBIXc1zmTAm0w0XHdrb8NUCHIizE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAlMs3BfyKO3urmDHNjaDmEzM5MZnmoz5tHOeuD/bB5fKgrAGbfHJP7KpwssiyAkK0vuYJnMAgFORCjV6ZuhPxvRk3NvEcmSDspkItS8ClskBCkSgq/4c+7+tOMlk3kaTjQRyFsDebyxSQu9eiiFOIKMOH3xGxtMhZW62oLLt7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xG1Ow7Ai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xG1Ow7Ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD3CC4CEF7;
	Wed,  4 Feb 2026 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217966;
	bh=Sj2ajQLaN/5SAwaPBIXc1zmTAm0w0XHdrb8NUCHIizE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xG1Ow7Ai1MTKDOULc+xUXnP9EvuW3qZCLAPTYXghwNAcqCwBRN2TKugnO2ScmgTsi
	 xtTsFN0vt1Go2RI73ixWLXXMsuuyJN8NY90PYRUuqzkh3FmBNbFMdYVVpPvkw/MTr1
	 gICSs12HHPZB+z1cOcJZo3qsTh6xGgmL2ffXR5sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 6.1 173/280] uacce: fix cdev handling in the cleanup path
Date: Wed,  4 Feb 2026 15:39:07 +0100
Message-ID: <20260204143915.847359425@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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
@@ -500,6 +500,8 @@ EXPORT_SYMBOL_GPL(uacce_alloc);
  */
 int uacce_register(struct uacce_device *uacce)
 {
+	int ret;
+
 	if (!uacce)
 		return -ENODEV;
 
@@ -510,7 +512,11 @@ int uacce_register(struct uacce_device *
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
 


