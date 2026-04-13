Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49551D5AD4;
	Mon, 13 Apr 2026 16:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098372; cv=none; b=CABl+ZIc/rvUF7flZiiC6Fk5wEI4Gu5JVcgJzqL8y5LLi08beH7ef1SbIWDgqDjtsWJHXgBdvOhfN+6uYTPVxysTZqQ2EaQtseYRToBN8qtGpy+y+po4HYwZVTUaF74GMmWXwhrvDooS0aaYZsmw4hGc5mlIT0LdKMfTLypakvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098372; c=relaxed/simple;
	bh=HhXfXQ1TMPeaCP7wifvnK7WAnq/57LXuKwgUMQGk9og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHZgLKmB6QogVw1Gacnzk2YI6jwsopMmu3h61TbvN0lFsp3xRLfjp6dKwHJW/SBk7HVocbHf7eQXDEOuWot4oCNOVt5LYahyu+4VAI8RZJsB8OH/D/S6Szcf1H+aY6GKmaBzYvVK+2ywDTVNCSwdLqxbhsZiZE0R/9mKEjQ5nRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDstiDdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDstiDdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B246C2BCAF;
	Mon, 13 Apr 2026 16:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098372;
	bh=HhXfXQ1TMPeaCP7wifvnK7WAnq/57LXuKwgUMQGk9og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDstiDdMfvl7A5fJGN2xy/HAzHhE4nP9ZDb1LQkKNCla2VNmkAYRZY2gvimxOeuuF
	 Dmha+E59ZMN2O8a0kcM+c5XkvvFmge+/FaF+0/bE0v7hXV4knRj8BKAZ0JgnRm6zF4
	 0a5E+Skj95AJ7h3mb4QQwEpNrP3sx9Zs7IIzbO/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>
Subject: [PATCH 5.15 499/570] usb: gadget: f_subset: Fix unbalanced refcnt in geth_free
Date: Mon, 13 Apr 2026 18:00:30 +0200
Message-ID: <20260413155849.148471721@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
 


