Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16874468C2C;
	Wed,  9 Sep 2026 13:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961727; cv=none; b=nNvqY9MjN2bGNj0/Jw8e6tpptp/N+sJfSr7hs32t3S1yIR2Z4CGyY2UlDUGfYYqVhebIwT+ZOnbjXtWZipxQIN4ndB9gCuEsnJSao6RA03dTpg0643RO8CuSz/ClcHdTVQL7Rf04xdc2HK6Jj6xAA67p23fRXcQP3pcVGc4jupI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961727; c=relaxed/simple;
	bh=1/cDvtEzAWqsbydEi8Xx+3K5b7HjxC4Ej7z+Dpreblo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lyq9cPW6l4hUSBeCF65708BJplr48ZvgemgVDYCtxaKZQh+mnJs2aFm651IGTUDOClXF1epFDDTOIhaQcDZCKdt8XkBNT61aXCeoIMsuBxY6A2RXLH9J/DeG9yFgXBiirx9Nk14Hqx2BxHyHfXT3OrGYby77lC8MawANMqcNqM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W09fUY+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W09fUY+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665931F00A3A;
	Wed,  9 Sep 2026 13:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961726;
	bh=+tOvzHJcMudebx1XQphkFWpX9N0t3jl2Lsx8iWvv7Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W09fUY+ty+p6tObAdYGlnyRJX7apaoRzRsqzo/pmtuXpCiI9kBr9iwnjaOmyxWPoA
	 zv7p6HHQod0vehmOv0QyXcFhtpJS39CZ4xUJfo5Vkd/iZn9h/lZJSmoir5jByJ+2Ll
	 mkhCsOc1gwcucYsqkyY+5GJILMWD++a3nUNkDnu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 7.2 048/556] USB: gadget: fix NULL pointer dereference in gadget_dev_ioctl()
Date: Wed,  9 Sep 2026 15:35:28 +0200
Message-ID: <20260909134232.171781125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>

commit dd0eed9e165b1a6292f49e622e3dd0b7d99b106d upstream.

gadget_dev_ioctl() reads dev->gadget before acquiring dev->lock, but
dev->state is checked after acquiring the lock. Therefore a concurrent
bind can change the device state between these operations, which can
leave ioctl with a stale NULL gadget pointer and causing a NULL pointer
dereference at gadget->ops->ioctl.

Read dev->gadget while holding dev->lock so that the gadget pointer
and device state are sampled consistently.

Cc: stable <stable@kernel.org>
Reported-by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Link: https://lore.kernel.org/all/20260824113510.1141236-1-jjy600901@snu.ac.kr/
Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Link: https://lore.kernel.org/all/20260824113510.1141236-1-jjy600901@snu.ac.kr/
Signed-off-by: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260825171343.459630-1-lovekeshsolanki00@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1251,10 +1251,11 @@ out:
 static long gadget_dev_ioctl (struct file *fd, unsigned code, unsigned long value)
 {
 	struct dev_data		*dev = fd->private_data;
-	struct usb_gadget	*gadget = dev->gadget;
+	struct usb_gadget	*gadget;
 	long ret = -ENOTTY;
 
 	spin_lock_irq(&dev->lock);
+	gadget = dev->gadget;
 	if (dev->state == STATE_DEV_OPENED ||
 			dev->state == STATE_DEV_UNBOUND) {
 		/* Not bound to a UDC */


