Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFFD3E63AA;
	Thu, 28 May 2026 19:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998308; cv=none; b=r6o7dAjmtczskIis3Tn+BBpQneg1/XXCuFtfk+bTB4AgmldgUPjfK3LJrtTgSI1CS1qIscOvJBlxqu1J+I89vZ4fOO5TmlHIuwpaAYGKmEhIxZc68k2wKVKfEBG06eymjwVT9cUle8U8npvSoOQJ2RUwVAPBCDSxew04Y65JQhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998308; c=relaxed/simple;
	bh=iZpFOaNfsMOfkJarLL7K4Y8phwtzRQ36FSt/sY5KxO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0Kcs0y330tjVgc9OycVXHK7eKVseDnNiYLJzAf+NZhpYFu9NZK3SyvOzIlWMVliasVv92Toasc2bf9yqE+Do9xOMunU4aG8wArvNKqNARPKiI7fmAXW8CtRGy/33rWQ1OZ8KtiI8JMiSrvgpfjodDsM3uHu0RwdlG/ulS2AFK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdrsFCpI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdrsFCpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292FB1F000E9;
	Thu, 28 May 2026 19:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998307;
	bh=f5ci2Wf8WDfx70/VvHTpdYA0dKj3F11ZBc2uPJQ57DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tdrsFCpIS1GVMYGOp8T/IHfAlTzHT0rEG+TAdQG5LJQDQWWga9iseTipAYtvVA8IN
	 ty7R4M2QlqcVlCiqL9oR4XaXTI3QeO8JxUynoXMWXbHKsVmOXaCAq43yGh6/c5Qjsd
	 mRxuKREp02efmdbrDA20gylItAuUn12M3C5m0q1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.0 128/461] device property: set fwnode->secondary to NULL in fwnode_init()
Date: Thu, 28 May 2026 21:44:17 +0200
Message-ID: <20260528194650.692060658@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 215c90ee656114f5e8c32408228d97082f8e0eef upstream.

If a firmware node is allocated on the stack (for instance: temporary
software node whose life-time we control) or on the heap - but using a
non-zeroing allocation function - and initialized using fwnode_init(),
its secondary pointer will contain uninitalized memory which likely will
be neither NULL nor IS_ERR() and so may end up being dereferenced (for
example: in dev_to_swnode()). Set fwnode->secondary to NULL on
initialization.

Cc: stable <stable@kernel.org>
Fixes: 01bb86b380a3 ("driver core: Add fwnode_init()")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://patch.msgid.link/20260506115701.23035-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fwnode.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -208,6 +208,7 @@ struct fwnode_operations {
 static inline void fwnode_init(struct fwnode_handle *fwnode,
 			       const struct fwnode_operations *ops)
 {
+	fwnode->secondary = NULL;
 	fwnode->ops = ops;
 	INIT_LIST_HEAD(&fwnode->consumers);
 	INIT_LIST_HEAD(&fwnode->suppliers);


