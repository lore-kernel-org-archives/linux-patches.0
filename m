Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98073CF1F5;
	Sat, 17 Oct 2026 18:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260114; cv=none; b=n0xaHNg2Gv7m5IZIwp1Ka1CtWYSgpPpN9JfAvlTtHaD8r1HfDzxMK0TUOSYwb9aITxSAaWiuPUv1Uqt3AxZ3XzB2pFX98kXtg0CMupJ5fT4k64fmo6zw4rdfrJelq8sQT/5Gu/NU53ha4tQ2qeb15t1YFZp7/bvd/i+f/GItI4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260114; c=relaxed/simple;
	bh=KgAXFxMBulZyjfVdOR9tVDhwJity1idIYc8BuaA45/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaG5mQc6d9G1hBLu0kxoXlophSsaLl9UZPGHGa2tqcobdjM0otu6mNv1dn6vIZrT0IIOeXUCWadrda94nTSnUDb7zQn9QgqWUlS/gPY9YqACYGK+5QqMxByhKOo+f+W9cLwTxybd9dRyuRB1M3Pg3uS1I+s7qWjpA6V5b7fbsJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkmiRw4S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkmiRw4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBBE1F000C4;
	Sat, 17 Oct 2026 18:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260113;
	bh=FNRUv/BQ5mxIsbUjP8BE+6+hnEaRRWLbLeqeo5qv+3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkmiRw4Ss5ttqyTFHUfWlF4ZQwHZCefyBQS1b7S9R9aA19seN1cUEACi0Sh0NE1NQ
	 S3witmovFxOQpEA7QZ8JQL4gLkD0mn6HF3nTS3PKWTCWgcH2XgC+RFfylTQEgN2f84
	 RKNvk347HPJjqdrE2Xc3zjVmdLsmsCU252KO5RDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1437/1674] tty: skip cdev_del() when no cdev is registered
Date: Sat, 17 Oct 2026 18:01:49 +0200
Message-ID: <20261017160508.067200352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 84fc068cdd745..817370cc4165c 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3317,7 +3317,7 @@ EXPORT_SYMBOL_GPL(tty_register_device_attr);
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



