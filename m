Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F56A4F054D;
	Tue, 13 Oct 2026 12:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894105; cv=none; b=s7JHiMiOlvCQejbLceXMIrnFLeksGUFfvdoDRe+UfZDkAgNUiF9Kk8xJ4Lf+XJ0Of7D+2/mj3gUIqMS0we0jUs1lk6R2AYCkhvpKKDJpm9Ht8RfoxjwhSl0FpBBeRa8BgCK/LR3P1ZRjwacChTLrU/ZpOtGFVniZddmR8XfMWRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894105; c=relaxed/simple;
	bh=hvnpPQHdha4iW2Rn8i83ibPVzBZaZZXnfevtC+lQ5Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDSjzD1YcjhLxTdoR/JGLN6XVbg06SACKRvHRp2wOgFpDxNMAdoefRGffsNWse0a8MfNsY02iiFeO/lfjWeBqWHIrEfnO2DZ4vE9YNk3+PQKXY/X1kfwKZkE4nL3jpBQ9Rm+13sKYYGE/cHqjXR0uA/yCGBalXkWkm/uP5VnYp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+M6Y3mo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+M6Y3mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E091F000FF;
	Tue, 13 Oct 2026 12:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894104;
	bh=bJOOV8NLmtuH3V9Oao2tiqPChj5X18JtQbW3E6tt+cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+M6Y3mobZJog77bTWigGq+4VbSHPZQ9aOD0bPPnFirEd9h5h13oEG+2qUcWCl/WF
	 jTtCplp8JRE5mWXBlFs7/mj0ecC7Bb+5QDRgtpeNF0EnBe8kl7cYJDcWVFeFWjmdJJ
	 tGo+5tANIrcre6I1apecRDzRcVdaKQg1pPSEquzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 449/621] tty: skip cdev_del() when no cdev is registered
Date: Tue, 13 Oct 2026 13:37:24 +0200
Message-ID: <20261013112931.486728383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index dd7231d9cab96..07e6bf5f8c6ff 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3327,7 +3327,7 @@ EXPORT_SYMBOL_GPL(tty_register_device_attr);
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



