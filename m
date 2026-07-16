Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366F342900C;
	Thu, 16 Jul 2026 14:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211076; cv=none; b=PK9Q/4sFZ20QdvQxN6aiiviAofIELqlbCzSJgt/BPZHQPxsfPSZd+EuVu+y1uc64JtzIR4h7/ROy4PLSwkj5Tl/EG1cz5lpml9n/26JfO3XDmjOi6HMRlYmo4Ol7LPTZJmkQYwPf20/h/2PdyFBVQoMvPONcXTJU97x79X2naBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211076; c=relaxed/simple;
	bh=SNp4Hzl6vtUvNrntDSXPd+2uc4x2GnjDPSww5A8JR9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2hB4iLdiM15NAugXixn+nGxrxrtW5sXatss+VHo8JISt9WVhVr9rKG3/BuYCH81PiShwR3rnKuPhKwdTgl9agcw8bLhf5W5llUdlzLRAw6s/evHk0T9BMu+RUzgKj2wRnii9x+T7bAjn2yEHV0+Kn8KhrEaZIenkhIPWCuyhBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHRdup5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHRdup5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7AD1F000E9;
	Thu, 16 Jul 2026 14:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211075;
	bh=ppSGaUCcKlbsjbAuYIYFMRMrwgBEE5M/WpEx4wAoRCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHRdup5tdd2HlURjnKX4mL6C59NfNUc8e/5xFMTg0zl90D4lzROGgXlLqxwU8SeSv
	 2nS+bbNlzFPFxTCeL+/+WxGvZDszUkYOBfNPNP8XA2gEmkNnzj2ry6duxyZQEwl+wh
	 6loLiAwe4fq31l3tN0bJB+kyMF1JeP2LD2nwmkXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>
Subject: [PATCH 6.18 291/480] usb: gadget: f_printer: take kref only for successful open
Date: Thu, 16 Jul 2026 15:30:38 +0200
Message-ID: <20260716133051.116419662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
 


