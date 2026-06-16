Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1488472769;
	Tue, 16 Jun 2026 16:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628444; cv=none; b=UbHNisANqGOeN9NJxOPqjpreWw7lA96+WQELjQjtgyRIp0izx3FzDeud0TQAHkNOg7RNoyxWlVhS3FkO6bdZ4ONR9zFRmqbRebQmvE7bOLldwKoUDPBgycFwp7r0Xu7djtv+OB/TV4LJe/Ijp4+gtbpK0eqAlDsWpjCGTQVJxFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628444; c=relaxed/simple;
	bh=GkfGytKgO9jRPg5W42xShiA0Dh32FFcG3u8PbXLq9Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mf6DpDOnWMq9Xbl8KEIyOANIDke4GTDCEc/P1TtLPsifJVngYRb09tUATtllUV6yWKvqVYTjWnaVeVn+einc8yy85gFdABqv5bvkVIRBI9Q3aFO99X9+1dbDg9pAUdnCQVl6w8nJhM2Cg6STZA/yvKxJxV4fLpyA4+FyqXeQoO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwcEG6iN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwcEG6iN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6884C1F000E9;
	Tue, 16 Jun 2026 16:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628443;
	bh=al0ZDE9Kfl9W6hyi63XA3sbJ7NW8+Hgvc4OvCMpm/sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZwcEG6iNiky12NHsdblTGiv7KSMqgcQ6VjZtCfE/10UiO4kl0RMGsjkW5cRKKDESQ
	 Vw7yynRoYoUOMixaf+7o1CwEDKAJxy8JY1J3wNEPdRqNmTQzaz2XzdoBuWjwQKA7su
	 qwqCApVHsbheHxH6u5vM2iLlCV8oifv34cSKGJvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.6 096/452] auxdisplay: line-display: fix OOB read on zero-length message_store()
Date: Tue, 16 Jun 2026 20:25:23 +0530
Message-ID: <20260616145122.851493401@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Stepan Ionichev <sozdayvek@gmail.com>

commit a7511dcd9dd4bc55d123f9b800c8a4ed2662e5c6 upstream.

linedisp_display() unconditionally reads msg[count - 1] before
checking whether count is zero, so a write of zero bytes to the
message sysfs attribute hits msg[-1]:

	write(fd, "", 0);

	-> message_store(..., buf, count=0)
	   -> linedisp_display(linedisp, buf, count=0)
	      -> msg[count - 1] == '\n'  ; OOB read

The kernfs write buffer for that store is a 1-byte allocation
(kernfs_fop_write_iter() does kmalloc(len + 1) with len == 0),
so msg[-1] is a 1-byte read before the slab object. On a
KASAN-enabled kernel this trips an out-of-bounds report and
panics; on stock kernels it silently reads adjacent slab data
and, if that byte happens to be '\n', the following count--
wraps ssize_t 0 to -1 and is then passed to kmemdup_nul().

linedisp_display() is reached from the message_store() sysfs
callback (drivers/auxdisplay/line-display.c message attribute,
mode 0644) and from the in-tree initial-message setup with
count == -1, so the OOB path is only userspace-triggerable via
zero-byte writes; vfs_write() does not short-circuit on
count == 0 and kernfs_fop_write_iter() dispatches the store
callback regardless.

Guard the trailing-newline trim with a count check. The
existing if (!count) block then takes the clear-display path
unchanged.

Affects every auxdisplay driver that registers via
linedisp_register() / linedisp_attach(): ht16k33, max6959,
img-ascii-lcd, seg-led-gpio.

Fixes: 7e76aece6f03 ("auxdisplay: Extract character line display core support")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/auxdisplay/line-display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/auxdisplay/line-display.c
+++ b/drivers/auxdisplay/line-display.c
@@ -80,7 +80,7 @@ static int linedisp_display(struct lined
 		count = strlen(msg);
 
 	/* if the string ends with a newline, trim it */
-	if (msg[count - 1] == '\n')
+	if (count && msg[count - 1] == '\n')
 		count--;
 
 	if (!count) {


