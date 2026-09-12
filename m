Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A010137EFE2;
	Sat, 12 Sep 2026 19:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241843; cv=none; b=UmnNoRF5wgewae6xDAyHxQiOG9nq+SpRGfe+FbnBYIIpr70DYWTJF0+nkZMvavfLNz5XSYBGu27ahdyXxDbCLzeh45xJDhszx+8UBMRkQvNT1BPVP1v5srVkYaT5OtxXUtm+n7rEdDNJI7QHotLvsYJWhzl5NspUzmkhXzBztqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241843; c=relaxed/simple;
	bh=0zpMFaOwFuhBpAhgQowsDdvDVfWmfZ9hdc+TrHWlfMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryf7o5PfEPglqe+hbsz/X4fAUppWNzOvd68Mrmyguj8Ss8YoJmM9hsih9i+MOKRM7xoN6CBIrh2xeBJSt7yNZlQh9QlOM2/9O1S0pAZ1p4rZ0vNjtvo8AkQwoQX/EwHq8d/pbA0rtESTBaIMRSaAEyiVDX0+2YiEL115rHK0KzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxMQKZRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxMQKZRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABE61F000FF;
	Sat, 12 Sep 2026 19:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241842;
	bh=jZeztFFxyg2QWoOvneOOYsxEwYoSBB94ndaLAJiBtNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sxMQKZRAsgyXcpkqLE61wDBg3Cm/n/66NlQI3mzkUk53PeOhBOooJzhaHyo3Vww8i
	 E2JYLXXydW1mDWpHxE9rdETU99sgj0MU2N71TCyx6v1iHz6DMh4t3XqdUjGxZzMWxd
	 S3Ou2WIZMFxMTPPcCVl0fzV/KmHfQccQRDlDghfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 219/798] USB: gadget: fix NULL pointer dereference in gadget_dev_ioctl()
Date: Sat, 12 Sep 2026 08:57:27 +0200
Message-ID: <20260912065522.140326495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
@@ -1249,10 +1249,11 @@ out:
 static long dev_ioctl (struct file *fd, unsigned code, unsigned long value)
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


