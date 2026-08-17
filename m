Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C45437124;
	Mon, 17 Aug 2026 13:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974504; cv=none; b=ixgIKwe/CIB7hafxK5FzsalbUZiZACnBgjIEY7fI2t0xiEnxm9KE3w0SudABcCihSuJuMR0YsAUfSjWe1ReXWvl47vrKriDELTxLeYpLw/0eVsM+ABU+Vf+0N5MsoE65vQdZTUfMnxzLWNbE0B8VLI6I7ecTV2J1RrXpu++72Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974504; c=relaxed/simple;
	bh=Qt8QkBEirmQJ1eemrJM+hNq97Sl+/Cz23VosLLEyzt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3DKb8TwrbcwQFiM0YtUuFMJFvLv7//a1SDWEspXFHe9dtaAj5IQvtf+OxhZyRmYOVlDnlQu5bRt2ldcVY9yC+m44cT4u8+X328jQRi+zdJbmO04RArKAIWFiMpGl+HO8R81J9658U9conh6GQVCek4bYQ7Ll28OX8096Pzb20U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTOHea5L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTOHea5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE361F00A3D;
	Mon, 17 Aug 2026 13:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974500;
	bh=ir5fcoqQGtUMr2sYy8D7Z3/s70aWsgI/sUDGLzMpOU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TTOHea5LIWzKQIo19s5WiQRyQE9a2zwMcctqfO3ziRW3ZC2b+UvivUgJI2DAo57/9
	 YLW8bnyyAGeMwvELXrUwoWJ06hM3ea4E2813Z7sHWYIGuRwb5xCvkJkZGi9swbhlk5
	 WL69faNGC/gZerarSKHUOu+jcWLfjwVNkhDSlY3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 227/271] dibs: initialise dibs->lock in dibs_dev_alloc()
Date: Mon, 17 Aug 2026 15:32:32 +0200
Message-ID: <20260817132546.106890242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -139,6 +139,7 @@ struct dibs_dev *dibs_dev_alloc(void)
 	dibs = kzalloc_obj(*dibs);
 	if (!dibs)
 		return dibs;
+	spin_lock_init(&dibs->lock);
 	dibs->dev.release = dibs_dev_release;
 	dibs->dev.class = &dibs_class;
 	device_initialize(&dibs->dev);
@@ -187,7 +188,6 @@ int dibs_dev_add(struct dibs_dev *dibs)
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


