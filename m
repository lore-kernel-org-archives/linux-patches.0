Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B79413254;
	Wed,  4 Feb 2026 14:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217100; cv=none; b=Hld9+5gt5Ze5I6kVrgkkA/pawhKqljPnUb31tAD5wkcxBwLsagtuuV9exgnqkyalJ8MWavdvbVZr7/gUgbVwJzY1y7c1swBu8XQBZHuyYcQvt8TAe6u5haV01YtybXRTbxWamHI8tnVL3EVleR+tJLy3lZAUKrKw/lr6I1uu1Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217100; c=relaxed/simple;
	bh=yvbMy0lIx23rOS5YSyyaVhKumft4GudyxuCZX7vladA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jB9wfRXQ/7wXJz39MISmtVLtJe5icMg1NpcDoF8IYf1eEf84QqELNBkAOPWNmB5q2bN70QEivFFJAWZVglXOBf+zvfD9wenuQEvEkRZ3xNcU7GP4h2p/q2j/1bEaEV7RztsxHaLxQB/Bh5RW9+x7j5kXp9pH8ZyshZDm5Vp4AKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1I0ucjMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1I0ucjMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A680C116C6;
	Wed,  4 Feb 2026 14:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217100;
	bh=yvbMy0lIx23rOS5YSyyaVhKumft4GudyxuCZX7vladA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1I0ucjMO4iaMHn2B2/r2KcVdTCgCnT+6bVbxdE2F4OOSBLXFCAsETO0XggvnnneMm
	 GFb0DbqmCgesDr+aCmVHG4g5xP84MDAgr9FhwBJ/gMOn29af/95y1eNa86fcCduFWO
	 /ZYxhVp1ALjusW0wfvDHVdeAjrS7JckDOal8mdVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 5.15 122/206] uacce: fix cdev handling in the cleanup path
Date: Wed,  4 Feb 2026 15:39:13 +0100
Message-ID: <20260204143902.595892296@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


