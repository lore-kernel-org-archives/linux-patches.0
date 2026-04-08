Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEEB324B1F;
	Wed,  8 Apr 2026 18:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672391; cv=none; b=hbS1DSmo6ja2ipL7Krx0KsXgr8x62SsK42DQJ5wYuy4WiFwbqITXCufXnx8eYCBgmqSkFgBcXVWdIitNpm/tDT5wtiEAMbykzd8KFPhk1mgZN6vCvv/ifoT5v+yELslVmUz//TQWEYUhAdbMArHYJfs4/Mp7Jl1ThlVnSHTEfO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672391; c=relaxed/simple;
	bh=lhvu2Ir/MEDK1t35MN+r+wX2zB9cyBKdkUTnngGkoZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXBuAP9QaT2RDAcHmXO7II+euuxPBZ6PY9nvHDiZQd13J07xKei/9y2jUBWMAklvoPnjziuQNjRi2yKKUSANc0zUxi+cnoXFe/Usx+aL4FMKMFFX1Zt85oKVeJIrDTq5HmiA3vE2xAiEW1/v0GjY59vMxM+/z95Rmmb49PsC+ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAm8vODa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAm8vODa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B8EC19421;
	Wed,  8 Apr 2026 18:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672390;
	bh=lhvu2Ir/MEDK1t35MN+r+wX2zB9cyBKdkUTnngGkoZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAm8vODaIG6Fi/C0d8cO8WjvBB7HAMTQ/jIil12KpFPTff8ov7YLR8/CLkjj24NjO
	 V+stc8wy209tofnfmzXBQIhBKiTu9zh4HYtFtJ+Mb+rnO7S8299YSwahybtY4gPCq1
	 IUKZ28WbYE+yPVXJ/QKmkl3ZabzmibVyQl7330r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.1 269/312] usb: gadget: f_subset: Fix unbalanced refcnt in geth_free
Date: Wed,  8 Apr 2026 20:03:06 +0200
Message-ID: <20260408175943.796324629@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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
 drivers/usb/gadget/function/f_subset.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/gadget/function/f_subset.c
+++ b/drivers/usb/gadget/function/f_subset.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2008 Nokia Corporation
  */
 
+#include <linux/cleanup.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -451,8 +452,13 @@ static struct usb_function_instance *get
 static void geth_free(struct usb_function *f)
 {
 	struct f_gether *eth;
+	struct f_gether_opts *opts;
+
+	opts = container_of(f->fi, struct f_gether_opts, func_inst);
 
 	eth = func_to_geth(f);
+	scoped_guard(mutex, &opts->lock)
+		opts->refcnt--;
 	kfree(eth);
 }
 


