Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282073E49E0;
	Mon, 17 Aug 2026 14:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975237; cv=none; b=Z6LgBCU+rMlUa2es6IclfUGTCcVhzYq02dlgrOCuz99dmDNfL2iU05qbHhkhct7/iW2N89eY1sQZEy0VlkQ5JWeljYS+HMLzsAVeG0SBfFJV8tQHoQ0TBN+shOtsXmZUxVQkkSS4A4icTlW973myRoh5h35XYn3IH12Uy/SIG9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975237; c=relaxed/simple;
	bh=ZFiH7k8mmvu0zz4jypJ8E1vD+BIZV5lgw3tl8w9foTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnLF7vZIKY5pJd7Do1xJrchPdFvfMpeo+imykOl1nDVoWNFSpM4qF9ks8lnLnEAMdP/3dGge22bLBRe4AxzrFfvoYCHfyP2Je32KRJKBqbkwC81zYFoK99dMaDfze3QO12SfMz7nDDPSkVPZUnXoxl9xbStMG/VOmihGYxps2LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZpRHnCa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZpRHnCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808AA1F000E9;
	Mon, 17 Aug 2026 14:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975236;
	bh=uG5mNqUufCYxO/t4LjY2XceZXb5v7yh8+mbt1USbJG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZpRHnCaEp6vLZVe1vdkpjkF9gPverBHv4P3acueBTlGXm+POZp0BqDVxiMtZIPsw
	 i39vHFd+UliNlAINQ7hmBV4lp7UfsYbteapwwDwS6kRfcJgv1SA3a/+R6XTNjKhQGM
	 HFKMq9Xgzoagg4nZE+qLwg1rSo7+hb+jvkdg9loM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 210/250] dibs: initialise dibs->lock in dibs_dev_alloc()
Date: Mon, 17 Aug 2026 15:32:51 +0200
Message-ID: <20260817132545.136464316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hidayath Khan <hidayath@linux.ibm.com>

commit c27e360545373b7aee9862a5beef3b9fb3df0c25 upstream.

dibs->lock is initialised by dibs_dev_add(), but a dibs device can
already take interrupts before that call: ism_probe() runs
ism_dev_init(), and hence request_irq(), before it calls
dibs_dev_add(). No client can have registered a dmb at that point, so
no dmb interrupt can occur, but a GID event interrupt can, and
ism_handle_irq() takes dibs->lock unconditionally on entry, before it
inspects anything else.

Initialise the lock in dibs_dev_alloc() instead, so that it is valid as
soon as a driver can publish the device to its interrupt handler.

Fixes: cc21191b584c ("dibs: Move data path to dibs layer")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
Link: https://patch.msgid.link/20260730124227.167829-1-hidayath@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dibs/dibs_main.c |    2 +-
 include/linux/dibs.h     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dibs/dibs_main.c
+++ b/drivers/dibs/dibs_main.c
@@ -138,6 +138,7 @@ struct dibs_dev *dibs_dev_alloc(void)
 	dibs = kzalloc(sizeof(*dibs), GFP_KERNEL);
 	if (!dibs)
 		return dibs;
+	spin_lock_init(&dibs->lock);
 	dibs->dev.release = dibs_dev_release;
 	dibs->dev.class = dibs_class;
 	device_initialize(&dibs->dev);
@@ -186,7 +187,6 @@ int dibs_dev_add(struct dibs_dev *dibs)
 	int i, ret;
 
 	max_dmbs = dibs->ops->max_dmbs();
-	spin_lock_init(&dibs->lock);
 	dibs->dmb_clientid_arr = kzalloc(max_dmbs, GFP_KERNEL);
 	if (!dibs->dmb_clientid_arr)
 		return -ENOMEM;
--- a/include/linux/dibs.h
+++ b/include/linux/dibs.h
@@ -439,7 +439,7 @@ static inline void *dibs_get_priv(struct
 /**
  * dibs_dev_alloc() - allocate and reference device structure
  *
- * The following fields will be valid upon successful return: dev
+ * The following fields will be valid upon successful return: dev, lock
  * NOTE: Use put_device(dibs_get_dev(@dibs)) to give up your reference instead
  * of freeing @dibs @dev directly once you have successfully called this
  * function.


