Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172A2324B1F;
	Wed,  8 Apr 2026 18:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672791; cv=none; b=pXh26O+QpD3WPeR3U0DzUrsBdbmIDEEmkqy9hxjEakOW9ZMliiNrlvkUt9APFRYSgAxKqvEF7wCQfmcp6Yibdb3xUk9hN7rNU3hTNfHmk5BS7JNz1w3LGI5bomtw1snlXTOoN5n4wtjm+I0DY1KfJcTo7Sh2PIysPTQifMKdRV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672791; c=relaxed/simple;
	bh=QV3iNBlDcw89yyORDOI0NFglyby/RW7RidZ8jU+O3EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ch+BOhB8fPIqOhocwvnXjUaTpst7+tDDKTkj0OaRHL5n4c5WPWpVLkAOAgTjcalQsoEZ5SSXanMpmZC6vW7n9Q33o/Rt/+VUy738rHrfGQfFAsc6I62SokHQamQNBvV6FKzF1XDekNx4rzNniCkV6a7b7ON1vnRMLrAk8CoA6yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvRtkjaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvRtkjaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B9EC19421;
	Wed,  8 Apr 2026 18:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672791;
	bh=QV3iNBlDcw89yyORDOI0NFglyby/RW7RidZ8jU+O3EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvRtkjaKzCW9aC5NnK3Q7qoWtlLj+WsHPd7+FtH1K65tLq1Mpl2A6ON836XGtNimg
	 fOkTGAyt775yDr2nVvaRrB/BP06ENvDgkbFs1F0+ujAwQjwqWePCGkH8vdOYpG+Y8F
	 TXCusMtezyoU5ElmpEPIdqvT20rPFmE6Ux0shG14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 6.6 144/160] usb: gadget: f_subset: Fix unbalanced refcnt in geth_free
Date: Wed,  8 Apr 2026 20:03:51 +0200
Message-ID: <20260408175918.569509260@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


