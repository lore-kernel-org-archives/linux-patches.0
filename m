Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52DC2D5A01;
	Mon, 17 Aug 2026 14:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975225; cv=none; b=A8zx0kSexXrnxn1bXxF9+AmK0rkw7ipmo9oglv9SMIk8B4zz7wkAXcJ/xlKQqDveTadd9mfiMf+Dj9F5Rlp4gnjTg6fC8fqBuXQ1mIgTqeuEJUYWiV97pXzV8yZF6HWFDnB8vgiLLGzugQ6AOgvxTiH9mBa5a2LHjf6qPeEHjBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975225; c=relaxed/simple;
	bh=/linO9qX7BCihi4rmV/0Jz/8++SYxOkN0ihMnxUUizM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKnLiTTiO5O0BKYC0KA14rCkZcQj6sSjqGYcn9B0+OOmSobV46P5CWEmlDjQZpJEfKpMZ9zip9FUMuoiUdfqdjzG28K+02winD15GrCaJhArJPyRSIpyDdVAtaW2iND0gtdsnVmmgpfzX0ft2VCODAiWaT9PXzzEpM6kSYdjF8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKs4LgMg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKs4LgMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9F11F000E9;
	Mon, 17 Aug 2026 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975224;
	bh=D44P225S1vIe8QA7RIXhKRoaHs+B/+I7h2Arer2DCRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKs4LgMg36tDS05nonFAF1LuNVqBFQMbhhTO1hyUdfAYYRSn/+/WOQWfcbCWGA7Dm
	 s+s8q587sAK5VVjmcvQzsbVa2mGN1+irFVw3acv3w8VLMijLdL3RL8fynz+KGK7HMS
	 4ncr/CLRc1OaSMBhT9Z6KIWXG9EBM/y0hFhu6BSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 198/250] net/dibs: Correct freeing of dmb_clientid_arr
Date: Mon, 17 Aug 2026 15:32:39 +0200
Message-ID: <20260817132544.644444210@linuxfoundation.org>
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

From: Alexandra Winter <wintera@linux.ibm.com>

commit 9e6869be49064915edb6c8776b27c376cfdb0df5 upstream.

A dibs device interrupt handler can be active after dibs_dev_del() and
may still access dmb_clientid_arr. (UAF)

In case of a failure in dibs_dev_add() being called by dibs_lo_dev_probe()
dmb_clientid_arr is freed twice (double free).

Free dmb_clientid_arr in dibs_dev_release() after last reference is gone.
Note that allocating in dibs_dev_add() instead of dibs_dev_alloc() is ok
for now, because no dmbs can be registered before dibs_dev_add().

Fixes: cc21191b584c ("dibs: Move data path to dibs layer")
Cc: stable@vger.kernel.org
Co-developed-by: Hidayath Khan <hidayath@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Link: https://patch.msgid.link/20260810111432.2334900-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dibs/dibs_loopback.c |    1 -
 drivers/dibs/dibs_main.c     |   14 ++++----------
 2 files changed, 4 insertions(+), 11 deletions(-)

--- a/drivers/dibs/dibs_loopback.c
+++ b/drivers/dibs/dibs_loopback.c
@@ -335,7 +335,6 @@ static int dibs_lo_dev_probe(void)
 	return 0;
 
 err_reg:
-	kfree(dibs->dmb_clientid_arr);
 	/* pairs with dibs_dev_alloc() */
 	put_device(&dibs->dev);
 	kfree(ldev);
--- a/drivers/dibs/dibs_main.c
+++ b/drivers/dibs/dibs_main.c
@@ -127,6 +127,7 @@ static void dibs_dev_release(struct devi
 
 	dibs = container_of(dev, struct dibs_dev, dev);
 
+	kfree(dibs->dmb_clientid_arr);
 	kfree(dibs);
 }
 
@@ -193,12 +194,13 @@ int dibs_dev_add(struct dibs_dev *dibs)
 
 	ret = device_add(&dibs->dev);
 	if (ret)
-		goto free_client_arr;
+		return ret;
 
 	ret = sysfs_create_group(&dibs->dev.kobj, &dibs_dev_attr_group);
 	if (ret) {
 		dev_err(&dibs->dev, "sysfs_create_group failed for dibs_dev\n");
-		goto err_device_del;
+		device_del(&dibs->dev);
+		return ret;
 	}
 	mutex_lock(&dibs_dev_list.mutex);
 	mutex_lock(&clients_lock);
@@ -213,13 +215,6 @@ int dibs_dev_add(struct dibs_dev *dibs)
 	mutex_unlock(&dibs_dev_list.mutex);
 
 	return 0;
-
-err_device_del:
-	device_del(&dibs->dev);
-free_client_arr:
-	kfree(dibs->dmb_clientid_arr);
-	return ret;
-
 }
 EXPORT_SYMBOL_GPL(dibs_dev_add);
 
@@ -246,7 +241,6 @@ void dibs_dev_del(struct dibs_dev *dibs)
 	mutex_unlock(&dibs_dev_list.mutex);
 
 	device_del(&dibs->dev);
-	kfree(dibs->dmb_clientid_arr);
 }
 EXPORT_SYMBOL_GPL(dibs_dev_del);
 


