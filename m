Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D747D41B366;
	Wed,  4 Feb 2026 14:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216601; cv=none; b=Ry0u4z0fGdvv09/EEiLIOv6233ron3Xnsx5YeEQj63i49OFO+mVRwshJAzmRVXcjNm0wwB2LNphL9cdaRPkamiyEL2suMlpSBfutHSuSorAQqacVwQU2ODWeoJhms96bsHYkABcNpLaLXtNMZ5DJLlX8hhGcL8mcxVtxgNEK+mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216601; c=relaxed/simple;
	bh=wIDE6Gax3q1NfNYLJNy6eer4gTtyQ7NjobtVftA4qz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKRyYP7QMViQ8ZnK4aPPUJF/gkNUcnbqYQY2Wphz1i4dfB7zn+UdmME+L1Sr3Biu5NAAjz6QLzhjLJIs41XYW0OzSiYm0iHmECW8FwbWIBylhNNCwm0R6RPBGD6NgyGyzggkqGPPSMrY9JDi6rElbw8ndp2rfXYQoUdlkg7wHGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pp5FArmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pp5FArmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16205C19423;
	Wed,  4 Feb 2026 14:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216601;
	bh=wIDE6Gax3q1NfNYLJNy6eer4gTtyQ7NjobtVftA4qz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pp5FArmhtFL6zbtm9x/Sb6THFeRsnnkCBkhQjbw0J0TAYMzzjWMQpldVLvSQld9pl
	 E2KXRaQkYwiVTRdOayX7S02tt11fQ8ylCysbfjq6KYmRdhNiJKp371JBpsKlVx4abe
	 dN1kRKaVLgtTti3PDB/RJv03xGsIrTaKO8NNr+LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 5.10 102/161] uacce: fix cdev handling in the cleanup path
Date: Wed,  4 Feb 2026 15:39:25 +0100
Message-ID: <20260204143855.416825660@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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
@@ -482,6 +482,8 @@ EXPORT_SYMBOL_GPL(uacce_alloc);
  */
 int uacce_register(struct uacce_device *uacce)
 {
+	int ret;
+
 	if (!uacce)
 		return -ENODEV;
 
@@ -492,7 +494,11 @@ int uacce_register(struct uacce_device *
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
 


