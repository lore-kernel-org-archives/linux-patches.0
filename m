Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A46F3DA5BB;
	Wed,  8 Apr 2026 19:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674959; cv=none; b=d1Vjo24j/oIF31Kvo8cxfg/8hh5xL5r70Xa2falSKNtruQkLCBPUuZ6QwAWjiXWGDAgKkM8uN3Fr7vkV3XynVrGeBivfU+lH1r1Z+9hCSzKaIhrxxqJFzO8oeHNb6/WYI9bQD5nQ6eNLyfZSbqamYF/5tb33tLnRK8Lz2KHkFnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674959; c=relaxed/simple;
	bh=oOSvkCdM5E9qIczrTiWCTZF03e6ZozCLmqLTwGXdH6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqyUjT9QI1nl7uVXyArLgZFfGw1AWI/vlav6BAjNPqf1+WrnTp2jJHHWdwx8iMnv8gFF/BZ9XXu5VOtIIhDmhz0iIUIwz5fGE9CmuR/qqwgfcFbyKCYN/m4ZHL/oPjZk+VpZwUUHZ4ujZWYpbFqrVEtxBHQJqIfxk3HYUBL9l14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqcQnX66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqcQnX66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E166C2BC9E;
	Wed,  8 Apr 2026 19:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674959;
	bh=oOSvkCdM5E9qIczrTiWCTZF03e6ZozCLmqLTwGXdH6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqcQnX66+A08aOaefqCbv/k6MIs415vdov88zW+2eP05ZVNuBh6h5lU6oheHIDh+k
	 XJeSVZFMcbl/QMvTyOXMKEWHGVAu4NBNnz8okgzGBABJSI5yyZzRGu5WBrh/BOOS/q
	 6A2pkNtbbQ+yvTUBk1SfD74KlCPA+Olme7Oes670=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.19 299/311] usb: gadget: f_subset: Fix unbalanced refcnt in geth_free
Date: Wed,  8 Apr 2026 20:04:59 +0200
Message-ID: <20260408175950.536502396@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -449,8 +450,13 @@ static struct usb_function_instance *get
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
 


