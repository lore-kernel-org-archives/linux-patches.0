Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215259;
	b=lIaEBY526c83eyRRdbmAkZWGmrj/upbGegtrXEdVugnJ9gOzIPHXBoINuRP8fEL7Jjki
	 8T6tiGRIaBxFeuECnTA8AHnhTRFcgG7h80tEgkOihcjxMyEL7kKWqyKZYcbYfDHOm91CZ
	 JDCbAvSG6WogqA87IvgvH+5loj4Ojafx6lJS/YJaKiKbDNobTCndAGODs8GluXNCBCW4m
	 h11Ot1T3rVgceC7be17D0DZy9rFDqrq645TB6tQiW1X3O5yzTY2gPYUU3dAxVxc+c2PjK
	 cYoZwQCGlJgGvjO5r08qgPe4SzhTotfD5Jf6ej8F9hhcWYzqiVn2w8VVAOxrVhmT5og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AlzkOFTYdcApHH7XBYGEP/6ZuZw70NuRg1rvZ92YlW8=;
	b=QE/GS6GdEg7XVluv4fReR9GbYarBLSCiCGU0CwvYUquvUqb+AOJr+xqdKSOamxjjUskq
	 1C/JjTSyiJRbolysqAJcXLt2YuG0/C6LHEb83RbFvaFIpeeli5SsIuFfdeTkjr3xXInSn
	 ozu1TDicJXWG/mFNEQLl7t6fWTLq+qiyhdAx9mdDS6fjtM5PAedJ2eAskApnELKsejeRa
	 ahJMaewCVdyuqDgNC4JI9q6+K/INsPdF8i1FtCcnozQiNSL9kpcpolk+71cBY/uMLnc1O
	 xObT3hmN962bIUrUM7zyv617DgX9vvKIYYNmknX0UZPBIIapBYSu1jF0yh9ImZ/VEcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=156B5Kpe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF0D606A31A;
	Wed, 28 Oct 2026 19:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=156B5Kpe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DA81F01825;
	Wed, 28 Oct 2026 19:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215258;
	bh=AlzkOFTYdcApHH7XBYGEP/6ZuZw70NuRg1rvZ92YlW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=156B5KpehIfg2iU4fqK8D4mstyIKTmHMqkmEzDzxF3g0zJ5mHAYqiBkq0lF2gqZXZ
	 pQbzoBLtfkISZAEIxy9H+a1Ytdw1nHJe4Mw5VdERIyco57NasxstnbrI2lM6VvvFwJ
	 WXZKpN9SMElQOPWBgZYl+S9NC5Qk0tiIiVmipw3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1149/1887] usb: gadget: f_printer: take kref only for successful open
Date: Wed, 28 Oct 2026 17:54:05 +0100
Message-ID: <20261028170525.552805992@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 30adce93d5c4a5a1ec29d9249e3fdfcc391d406b ]

printer_open() returns -EBUSY when the character device is already
open, but it increments dev->kref regardless of the return value. VFS
does not call ->release() for a failed open, so every rejected second
open permanently leaks one reference.

Move kref_get() into the successful-open branch.

Fixes: e8d5f92b8d30 ("usb: gadget: function: printer: fix use-after-free in __lock_acquire")
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/80295742B820DA9B+20260626064617.4090626-1-raoxu@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_printer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_printer.c b/drivers/usb/gadget/function/f_printer.c
index b69e5244f6219..427d80849fa5b 100644
--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -360,12 +360,11 @@ printer_open(struct inode *inode, struct file *fd)
 		ret = 0;
 		/* Change the printer status to show that it's on-line. */
 		dev->printer_status |= PRINTER_SELECTED;
+		kref_get(&dev->kref);
 	}
 
 	spin_unlock_irqrestore(&dev->lock, flags);
 
-	kref_get(&dev->kref);
-
 	return ret;
 }
 
-- 
2.53.0



