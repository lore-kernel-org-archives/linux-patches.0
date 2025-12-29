Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C1C2EDD52;
	Mon, 29 Dec 2025 16:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025679; cv=none; b=kqLCQePAs0h8cm4F4wlLAuJzfJrYkDhCnu6MDPKhZnPmBUhsoOjTkGIzcOpovbTb2Oaf0my9JpVmMUOgJfnVykBS43C/SWZRAtnY7XI2qDyRAoKmpRnpFOGw74Q8iclzSpwLPlKFahwO2lHmoiH0LXUVXMfJy9Xble4Bk7a7aBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025679; c=relaxed/simple;
	bh=x2E0ZfiCWaUG0zK6KJTah7XPnsQI5DJNUhI82eOv3sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1IS7r3YJ2CYG5QVeMhBLNgkDoM9qNKsF6D2Nha7mvNWgZh0tv1t2lztl34KtZtzTjbUqJwSocwDCiDzfZAtD9jlqWDiJoT3ciZe1nK6YFEWWdDEz7CVuYP8MPRwymdbroTAYoK/DJcrKt9yAcFF5AzNHSvzeJbK8VQiPgE5B4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLPN9C1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLPN9C1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D412C4CEF7;
	Mon, 29 Dec 2025 16:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025678;
	bh=x2E0ZfiCWaUG0zK6KJTah7XPnsQI5DJNUhI82eOv3sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLPN9C1YCSg2lYRyHwyGuEjOYa/Nw44RxjUklJN9ICgxWgKVzLZcu5NAfZH/RiGmN
	 CNtPS3m50IF4PWJw7YYmRHEcKUjjBhbAzfxbvwZNLj5I6rIXsCN8fyRX7IMdGPoliL
	 Nfm2wk3Pjw1tdtfVoJB46IZ/SDWa1CKKdqCUdj2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ma Ke <make24@iscas.ac.cn>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.18 298/430] mei: Fix error handling in mei_register
Date: Mon, 29 Dec 2025 17:11:40 +0100
Message-ID: <20251229160735.305171603@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit a6dab2f61d23c1eb32f1d08fa7b4919a2478950b upstream.

mei_register() fails to release the device reference in error paths
after device_initialize(). During normal device registration, the
reference is properly handled through mei_deregister() which calls
device_destroy(). However, in error handling paths (such as cdev_alloc
failure, cdev_add failure, etc.), missing put_device() calls cause
reference count leaks, preventing the device's release function
(mei_device_release) from being called and resulting in memory leaks
of mei_device.

Found by code review.

Cc: stable <stable@kernel.org>
Fixes: 7704e6be4ed2 ("mei: hook mei_device on class device")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Acked-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20251104020133.5017-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 86a73684a373..6f26d5160788 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -1307,6 +1307,7 @@ int mei_register(struct mei_device *dev, struct device *parent)
 err_del_cdev:
 	cdev_del(dev->cdev);
 err:
+	put_device(&dev->dev);
 	mei_minor_free(minor);
 	return ret;
 }
-- 
2.52.0



