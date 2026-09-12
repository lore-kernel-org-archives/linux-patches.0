Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C7837F313;
	Sat, 12 Sep 2026 11:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212996; cv=none; b=aZNmPol7OVsxB+QYEGRn9ML/COEHiSprZY21a5hQH27epufaVGRtO0P4P3uoVgY9hh8Pym+UlPC4Cg8jxvP8gveWHo6MX8pAcjddB7k6K/k75PeqETKfy693djr8zjVsgQL7gZkBwVM0s8l9Dcsf03FhLf6xrU5s2/SUz1AEifI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212996; c=relaxed/simple;
	bh=MLTnncWsRVbCTwjdrGG4egdpqG2T1jzdkl8C5X00fW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cX44ThQSyH4ynqOOSJBHRC8Z6+XD79E/XfzUqpgiTwCIOsfCAcb2EAMgnFPrj4BJUnF53AECAHGr2/uBo89Q3KloO88wJvU9u08lTLzy9uo5JhyreyxMSaIA7pbX3kPcvy12CjXboPbRqwWiIWjgRQusFT1ym4FJH9mjfrxoRrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwtX+evY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwtX+evY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA6C1F000FF;
	Sat, 12 Sep 2026 11:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212995;
	bh=3YmL3QblArH7Y3WcmvxIFok00WTqOOY23L5sVud7OyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwtX+evYY056X+VISk/uKef853Iz+Qdr8q1xTol2XjIy8oq/nH5mvfWyvgS3A4wNc
	 ZPmMm+iXs18DJraVcVdt8ihW+Ge/HEV3FzY7+qEvm/ors6QdU7ded7NquuPsY7SyQh
	 8txoGly4qUMKO/8EKxxTIwse5eHnQ80UJKLHBc9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 0030/1376] USB: gadget: fix NULL pointer dereference in gadget_dev_ioctl()
Date: Sat, 12 Sep 2026 08:40:56 +0200
Message-ID: <20260912065608.222631666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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


