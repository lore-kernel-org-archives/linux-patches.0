Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E4B42F6FA;
	Thu, 16 Jul 2026 14:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212177; cv=none; b=XZ/3Tl42BDKWvSjbA6E14vokMwFu6vJKFk3K5icelODXES/E7pM6Y2meAcP59rczB1ZR58nsGsLTlJeYgYrwsMhNbfo14NsesUMR5k5p5ms2AXbqXVS+qhMDA269hJOO6A66vXgbii/NSzVaMn6a40hBnahtdHlhiyQQmn6IX3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212177; c=relaxed/simple;
	bh=MxtEEeMBUQskrK4CbJuKjm6gPWX4zovh/NvX0TqKE0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLsFjs90a85pzyC1EaUVjPm6RWV6yhqZazu60u7FUECF69kNPFteMAtM3cho9Q2wcxHb1wlyNgxo8hSvWA8URqqyw+GBQAraFF/TotwxPycMqHdgTYfIXO9iT0Tv2RldhHlfqahiCI3wQ63YYMqYbcwb5TVw+7Lc0tdiOg8dqT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uD86B22K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uD86B22K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623A31F000E9;
	Thu, 16 Jul 2026 14:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212175;
	bh=U1BbS6IjYlM3Q2d6USXi6S02DPJuLcjDKBGghgEZpr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uD86B22K6kiWxK7oAGWO7SUJ6vC/1z30i34mBe4embg7zDmpdJs+sNz6CGZtsv6dg
	 exgGrvlIZLM1Gjyuzwc1xdO/YDU6h+ByGCrOkXufFt2BdQQT8NG+wdZDcGhK80910I
	 gZAzdRRhBnJZOOA5MRVKoijDfieOnxE/CgOCqbUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>
Subject: [PATCH 6.12 227/349] usb: gadget: f_printer: take kref only for successful open
Date: Thu, 16 Jul 2026 15:32:41 +0200
Message-ID: <20260716133038.442212885@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
 


