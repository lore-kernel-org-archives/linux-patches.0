Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F275434E5D;
	Tue, 21 Jul 2026 20:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665362; cv=none; b=n5/8sPpvbl2GvlkH/4Sh4YkTLokv4LD46RCA4F9hd8fdryvPkNnHmRV7bukDlZg7h/c/cyLipkxPHYwoM+YgjYay3RK09957zb5UqEGYb1/rfVnWluSloK8p1KRwSznQHKMTpr/wWE2O4TPxnrgN0CIagVZj7gY9R7JyH5w5Wic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665362; c=relaxed/simple;
	bh=Oq+lUinZWswFk7uao2mw6mmUB7DrEfsYPWbbTFjwoBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWNNC+ApHAi/LA4opiMfTuvSf6fI14Kk7OtPGWuPVAtxQO+UK5WC6gOaH61F4k74+8CRzqryr6OZtAT1ydrgnTrrVa31ksyQYWS1u7kIH6eOgc0CIkPtRR9EaLrkdQjp4kiZ5SfjwioMQE2JAJl+iLp8d2NEJqvg1uuS5296tfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zg1ZtJeH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zg1ZtJeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842571F000E9;
	Tue, 21 Jul 2026 20:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665361;
	bh=PVd1UQeWIPm22MHL1Cbr60eZRuzwZpRW+BsnZ/y3+1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zg1ZtJeH/hVf56O3BIaVQphcQ6LvctFFjvc3ETiVmk1+5DC4mow0ZFQiygoZiQHkP
	 GqT0PxufBAuzJvcBMvNvFdZWmBXp8+LgAEhvqJDst5NkL1t5k7UOMcEEoYBrsrP6D6
	 hBiWKy44djshzqW8vOahLrCx5GQlLfXHcQnaZLWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>
Subject: [PATCH 6.6 0232/1266] usb: gadget: f_printer: take kref only for successful open
Date: Tue, 21 Jul 2026 17:11:09 +0200
Message-ID: <20260721152447.009163406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit 30adce93d5c4a5a1ec29d9249e3fdfcc391d406b upstream.

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
---
 drivers/usb/gadget/function/f_printer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -363,12 +363,11 @@ printer_open(struct inode *inode, struct
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
 


