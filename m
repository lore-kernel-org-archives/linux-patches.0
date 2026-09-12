Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DD41F1534;
	Sat, 12 Sep 2026 08:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201453; cv=none; b=UJUjo/kXgtT0+Ydz2T4ErrmYTyxrqF566WdozPmJ/APg5XEndT3X3xDA6uyCPF5dTHCzzB2px8XjlQMZJAXLD3qRkiPuGb5E1zyLVRKELYTXrcnQc5ZG//rXy41PUxP92iJsByxwMoMM4SyGwz5oFiTo5kOomgLDJFw0y2+J148=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201453; c=relaxed/simple;
	bh=XJRwnDDs0+xwhf4DXlK08JzsbT53IuMBvTCZuLXx5k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhbmqlhWBeZVj83h+S/9Gp0Yx3npV8gHW7fdccYSlgwzqrst6Cs6zOEgplli3do+NruaVI/f+WEXa2GEUxAjLQultyYrApLA77rX7KlP4kzrcCVH1Oh2t71RDDZXpNxGtOE7+ZeqtJFzs+wJEoJS0c7/eTjALTPH6mMPe5AO2Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRzVFu4v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRzVFu4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BCF1F000FF;
	Sat, 12 Sep 2026 08:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201451;
	bh=ZOFOGb382DxbRAPmYcVaheIl1bVkbHcVspf0JUdntGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRzVFu4vm+1I5edsq1FUDCaDaN4xQOVwCu1bVYEaRiT9cTV1hXfgYusRmRKkgG4br
	 U/kX79pZSv7w7AWSQ7bAk2tscuycSAIsSdSiOWvA1CpdTjp5XqiuaVFF/ceVmP1CT8
	 iRUzvsjvnoi6Ud8taxlSSPCXvIlFoebP0yscHBJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0997/1815] tty: skip cdev_del() when no cdev is registered
Date: Sat, 12 Sep 2026 08:45:47 +0200
Message-ID: <20260912065712.404843631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit c3b5623fd97648f2747444aa8932ae604662df93 ]

TTY device registration can fail before a cdev is allocated.
Serial core keeps the port so setserial can still use it, and later
removal passes the NULL cdev slot to cdev_del(), causing a NULL-pointer
dereference.

Only delete the cdev when the slot is not NULL.

Fixes: a3a10ce3429e ("Avoid usb reset crashes by making tty_io cdevs truly dynamic")
Fixes: da4c279942b0 ("serial: enable serdev support")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260731181844.11330-4-kmehltretter@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 6b283fd03ff82..e742bf9d86312 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3305,7 +3305,7 @@ EXPORT_SYMBOL_GPL(tty_register_device_attr);
 void tty_unregister_device(struct tty_driver *driver, unsigned index)
 {
 	device_destroy(&tty_class, MKDEV(driver->major, driver->minor_start) + index);
-	if (!(driver->flags & TTY_DRIVER_DYNAMIC_ALLOC)) {
+	if (!(driver->flags & TTY_DRIVER_DYNAMIC_ALLOC) && driver->cdevs[index]) {
 		cdev_del(driver->cdevs[index]);
 		driver->cdevs[index] = NULL;
 	}
-- 
2.53.0



