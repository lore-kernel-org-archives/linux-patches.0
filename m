Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9302032D7F8;
	Sat, 12 Sep 2026 18:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237352; cv=none; b=b50V+jbz6YaRq6eKQxB9R+Q4tG/qK60g0MRW36CC4UvJnj+DKsSJz4BrlEop7fWy/uw0V8BuKCflP0GZZAU90nzO+9RlfTgXqGtEfhSevlX/ejOqe/+1HqFVg0wh3vaPN0weg4QDbj3mO1uvkLXvTnG7TLKE1uR5ZT/CfmZuNxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237352; c=relaxed/simple;
	bh=Ffkc1mSa2/vTeY1qnHGSHdLWjZzTC8clI5eNmYf9WCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMR6BpWwawPQGXwwqFdocM34bDid/A+hD4Ij8r3oz5boyhOmA+wLV00vAI6OVU3SRIN29NbJqHVFVLA2cAFi9o6nQvE4jQT7yaGN5IbUsXHLr7EEyWRN4J6MP3sr0RsCh4UcLXMHaVP+YzcLaIFrVa+rpY0dXWUw/K+2TklVfCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vFNNFOx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vFNNFOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479891F000FF;
	Sat, 12 Sep 2026 18:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237351;
	bh=GFVZJgGTshSnjiCj08inSEigdLXdfiyIaXkpggNqPq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2vFNNFOxfcRNjxJB1/lmOBUJJN3VCNcWp4/FhOU0k8wK64XXKooQwpcIFT2JKk4fz
	 B0bhLaNLgxFKJvHOQRjvDUi4HM/dOKHj+W8K+De8MfLREo791M+hR/1XQsOOD6+9DR
	 aVpjVjqmF+kYc16TraT1+cERcT39BM0tJD54jAQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 241/935] USB: gadget: fix NULL pointer dereference in gadget_dev_ioctl()
Date: Sat, 12 Sep 2026 08:54:31 +0200
Message-ID: <20260912065532.352967122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1250,10 +1250,11 @@ out:
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


