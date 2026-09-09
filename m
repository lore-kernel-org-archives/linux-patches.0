Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F41A57266D;
	Wed,  9 Sep 2026 14:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963300; cv=none; b=JeKiNRJIwQ7Bn6lFzP0IYa1C4X7hHf/IYNrC3Xw6rtrpnMZp32zAafkLbvvJXihUIfiaIol7IsCXQEs8+bkEAcVx8xI3/cOkwBuE0TLyvkSIAhiPu3HlnI6NzQzxqLJ7SuCNgOxsAtJsYPVfXF8jEmV53GHW9KoKFeRI2Xb2xwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963300; c=relaxed/simple;
	bh=bunR4semShZu2Z0wsNvE+dzjLnSdVl6eQit6ibld154=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMimf1rOl9/YrFdYKN1ThX6EF/uvbSWcQx3bRP1LepWdfzKBDQh/tE0vBSJW3GmRZhe4ThJU92y2wHv2Req41FFQEWngylC+Ycb8JMaJdRuMWR/GjIi5L/PtAiTsFoykWTZNFJUYJSKfnWtKqCQw60qGYGpAAvMhAga96y8a5IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebT0aSpT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebT0aSpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A94B1F00A3D;
	Wed,  9 Sep 2026 14:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963299;
	bh=VWaB+H2QT5KtLb/p8WGMO+KKoFPZC/Pi3XotINgUwD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ebT0aSpT5UnN5HRvd4MXRsBhmD1yhpK6faCAksDmv+dWmxtKdxhtucW7qTouXdf5Z
	 fkjLbYt6RIPAQiPgCsq8l6VTpyYs1pk/gRcQ+VZtc9zAPlbW7CU+M2Bn38e59nke3/
	 E0TYf2e5Qs1zUD6PIUQKYfN4RSl7q/Uy2ue5P14A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.18 030/583] USB: gadget: fix NULL pointer dereference in gadget_dev_ioctl()
Date: Wed,  9 Sep 2026 15:35:15 +0200
Message-ID: <20260909134238.873792595@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -1253,10 +1253,11 @@ out:
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


