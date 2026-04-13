Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47CD335072;
	Mon, 13 Apr 2026 17:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099617; cv=none; b=oKwK2/WyO+7fX62S07Sq+As+2QQ+04u0ImTpdLX52oVvMMxfv5GDYsdPYp/j6IdiLsKk3OaM7biMWVfBEk6BdBOdzkOkZsqfwWODzDkUVhM8yDGocQeDo5ckMrO1CZDnnQuHGoWklr7Va1S4Jq8Zdr2kgXjVQYmbgF3dzZIfVDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099617; c=relaxed/simple;
	bh=b942IEwDO0UAWHcDuG3XFb9DJrPCzB2x2nDnDod95y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipFCd55ZCC0+KZads2spab7cmcUh+C2P1n+y2T7baXWTQmgO/fiSogrj/EP3ns/eyBXSPiSOicnf4YFFmfNPtiJKaaPPrDoH2bAh4ABdFgNhEkqIv0Beb6yAXyULgHZwi5jKsWxk+lZW9672P7GXuy8hxBcqz+NU/Emf7V45lQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPyiJH0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPyiJH0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A998C2BCAF;
	Mon, 13 Apr 2026 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099617;
	bh=b942IEwDO0UAWHcDuG3XFb9DJrPCzB2x2nDnDod95y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPyiJH0Z8IatkL8WIE1ExqkEmBJEZtwAfsOBJPH7bFYEI54Is4zKcDYwgtTXLp2qX
	 wrNLgP6qO9jP6bwBt+dYJl58didHq65qT6pgV31D866VPvJ2mRWUqmdA/S66H87Qrr
	 XoK3Yqk7uPhq2eZPhGtS4XjSodBOox6Y3WyQR8fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 5.10 409/491] usb: gadget: f_subset: Fix unbalanced refcnt in geth_free
Date: Mon, 13 Apr 2026 18:00:54 +0200
Message-ID: <20260413155834.343847257@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Kuen-Han Tsai <khtsai@google.com>

commit caa27923aacd8a5869207842f2ab1657c6c0c7bc upstream.

geth_alloc() increments the reference count, but geth_free() fails to
decrement it. This prevents the configuration of attributes via configfs
after unlinking the function.

Decrement the reference count in geth_free() to ensure proper cleanup.

Fixes: 02832e56f88a ("usb: gadget: f_subset: add configfs support")
Cc: stable@vger.kernel.org
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260320-usb-net-lifecycle-v1-1-4886b578161b@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_subset.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/gadget/function/f_subset.c
+++ b/drivers/usb/gadget/function/f_subset.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2008 Nokia Corporation
  */
 
+#include <linux/cleanup.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -451,8 +452,14 @@ static struct usb_function_instance *get
 static void geth_free(struct usb_function *f)
 {
 	struct f_gether *eth;
+	struct f_gether_opts *opts;
+
+	opts = container_of(f->fi, struct f_gether_opts, func_inst);
 
 	eth = func_to_geth(f);
+	mutex_lock(&opts->lock);
+	opts->refcnt--;
+	mutex_unlock(&opts->lock);
 	kfree(eth);
 }
 


