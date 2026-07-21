Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EC640926D;
	Tue, 21 Jul 2026 22:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674767; cv=none; b=S7+TyNW9hFpSOW89Bi8qeFSypVD/5mMYt2CwFeL0X6RDg3arcTDCA2m86upPskyMUoXcAQBTc1a4FWc4FBrzOWHgpxhUYP9gPEkSjiahIqxl1cYnc9nxhIO7MIIQxAoOpD4FDRdjb2CiLP7E+CKu9BFZkPjlMbnvRByXZUg+Fys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674767; c=relaxed/simple;
	bh=n2LLeZ4ztTzq1a6ON1w7QJnYpufA6cEQtGgR38H26XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvoSGN/DwFaA/YjHYAZjvyueE9p2ZjpZvwy4uSn9hBQdmbequVQ0td2jqi0SpGJToJ3/8y1Rl1oYzCCmYpUmb7SGBC2oiEUviTk20ellbQstxJG+q/W5wzMGi2iFCouXLQpv2dBQ1V91WExSVHv3OKtPprVqIlfzPFKNRHsdhhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oap4Ul/U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oap4Ul/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EC91F000E9;
	Tue, 21 Jul 2026 22:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674766;
	bh=dUwKPFwPcSxfbcG4L/zmSDt4tSxkR8+Nt1/Zpn/uuU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oap4Ul/U6s8xlNL9/LUa/jcBfwbTqRLFcHCav0Zc40CTVUweas4G0wcokSVIuVn8L
	 qe2t0F1cMGWzFIQMVsuUYI8JWoNpMhfuKGnYABhMRUZTnlMPRIknrD8a/S86qpq2uH
	 9QYjiZrDlVYM1tXBYZ8JzLq0eSHBd2aDNIv7jiPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 664/699] usb: gadget: f_printer: take kref only for successful open
Date: Tue, 21 Jul 2026 17:27:03 +0200
Message-ID: <20260721152410.743357102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_printer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -358,12 +358,11 @@ printer_open(struct inode *inode, struct
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
 


