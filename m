Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C1938330E;
	Sat, 17 Oct 2026 16:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255101; cv=none; b=MZyBeWBbNql/LO3tbzRPOhEoWxOk2X3QcJPyEc31zsz9DCgcZDj+iNEI/IBdBtkUeYUKniLe2kJKDj73u3/tSMawZJkSvukryZRxLxFzgCwtaLxZT8Gk5rk1kbR8LfN2uFn7uTCv2OY1ohzKhl7ht4IsLasqV6FXyul2sqtSzc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255101; c=relaxed/simple;
	bh=Tn0HUXE6EiXIUJ2RDgcOiqlpd93r+UoaQb0FCBzCX7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shNUL+7RaDSCwP4KTrEINGRu0OY7pbYZeleaY7d7m0fR8/8IqkaHSWGIA1wF92gO/7GTO9v4/3XurS9k4vCkjWX8M3oky09pao7bysQBupPcxQKbSNSGdYEMXykYm/pW9YzzcHEWuPUB55SsE+QrQr7FJJpSrhpYYozuK+Y3BLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oV+ECKQA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oV+ECKQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7464A1F000C4;
	Sat, 17 Oct 2026 16:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255100;
	bh=zwkoggBiWXHCBPKGYy/CT7YViqKg1A1Q3JkQe9JMwLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oV+ECKQAuOnI5qWJZN4WXFJB+vDM9kzsbH8YXhciZIsgn8eWPupALuHjRBltVBw2z
	 xPbVTj9AGYNuFfuYp3lsIqnjGTpNNyZ4x/a6Yq+YwVxstVgi3c6UIJR6M+99gXPuLu
	 uI1hxr2m2kKE+kR1esZzgs4bZA1TSIkShl1dxFWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 666/869] tty: skip cdev_del() when no cdev is registered
Date: Sat, 17 Oct 2026 17:58:27 +0200
Message-ID: <20261017160054.067874619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 07e1e901dea59..dd2e2508df4c4 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3341,7 +3341,7 @@ EXPORT_SYMBOL_GPL(tty_register_device_attr);
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



