Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216520;
	b=0cqX9rtY8Is7CDR4KjWnxLLkPCP7/dk7VpWAI183VxEL05v4HCcd4sbpwNTTIPjIM657
	 xuMiNmRP4yIdvEf6VU3hR3GJAPQIGE5SDCteikNQGIcZm6Gpymi42UpvDCTuBpV6DiNbh
	 KIgfzZocVjYk1GJ5j2nS2Sh9zh7ESlcdJNtZmSx+js1knqctFJ8Gzjjd3/Hed5YububIt
	 m3bjrO/jwu6wZlq+kr76uvsKVmzBLGFqh+EvIbuqyuDswBOk1cLxj7xxUPQwvG+VHBjvQ
	 h0U9+Xsmdts5JNnveSa4V5yP2uywSWM1eRt7yDdUcMDaHNSn11wbriZA9Ya2JQ1QSbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s/UOgk8zGwPooMYvT8D/OL/H1pXPlYLDGlw4nyoIGNA=;
	b=JpAal7aakuiJRumQnkMUo6xBytEUW0NWlOGT+qSs9KAgGrw+mn32BwZ/D+VxcxVRVckL
	 5meEiSzjkIZ9dBWYnQbg1GexOk2Y9UwTg45syJJpPR9v17TLboyXUOEg1oHWllS4zkVpn
	 HLa6HINxvBJh5cth4uymm4P2Hobgo/1TocDIqE0CmOTou7BlrFzpwBERXAq8exq9dGTxC
	 OKA5qLhPMz23skicSyZU4FGSODXAaqGw24k0g5jYHzJAC1SMojEIsqANXN3JpyxRNSgSB
	 Y4DQHd0KjGU9dagvLcPIAcTgRKRhMM7IRhCMlfI6hBU7HZT067iqw/FSc4eDTVfaSBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rXxzDP5J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D077606A31C;
	Wed, 28 Oct 2026 19:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rXxzDP5J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9271F01825;
	Wed, 28 Oct 2026 19:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216520;
	bh=s/UOgk8zGwPooMYvT8D/OL/H1pXPlYLDGlw4nyoIGNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXxzDP5Jlb6DwgdenIMoW38M98dNMUQxytvkpyzw/AVCPyQmi1+lh69PS96WwALJS
	 uwqqGla2h7ejuOIhWCZbIsUZDD5YsCTTC3w5dah1NOmNx1+rm/3SjXGgne8nFdRfz6
	 U9A7uJvkyXr1wzZFR6htuAl9+PMQqHNc1iWn602g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1584/1887] tty: skip cdev_del() when no cdev is registered
Date: Wed, 28 Oct 2026 18:01:20 +0100
Message-ID: <20261028170535.513237657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1e78cc10b77d4..1e36eda7fd3b2 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3314,7 +3314,7 @@ EXPORT_SYMBOL_GPL(tty_register_device_attr);
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



