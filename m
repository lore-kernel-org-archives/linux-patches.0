Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955C229B20E;
	Wed, 23 Apr 2025 15:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421319; cv=none; b=mM0MM1NHOWk57rtZGUeOg0w6knBKEyXcOAeILERqgBcsIRFHwvVvXkhyPOKIOL1uiVzOZrzVtCwq3PpYcpfA9uxMOWyoXPLERXTFwg2XM2nluU1p6j7MozNzxFEgum0QxrAFUA9B2kDyFRMD94x06JhghvxYkkfyjjSMm6Sc8QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421319; c=relaxed/simple;
	bh=fE35paCHpJu/SkuTSDel/ZNdApdNZWxQf0s9Ay9Wn/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TG6ppvmFdANn9wEELBLkROYOhoLVklYEgmlfAxn2XWWTBsSB8HvRwYLRoYtaXPwsgCWk5n/BnvRlsUWw0biZwAA0ulBYt+l9GV9uYWMGu/e2tWHhd6qUqo1F12qQRPlchaTfNYs/aWUX9Fh2jJMokNwXzvjbtc58n18Nspwdugk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfk+nsdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfk+nsdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD55C4CEEB;
	Wed, 23 Apr 2025 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421319;
	bh=fE35paCHpJu/SkuTSDel/ZNdApdNZWxQf0s9Ay9Wn/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfk+nsddSL/CJiev6moXkXM938wYPRYyzPcbDxB4sJUKQeZbUtBN5mw6uTjVY53lg
	 BxSQybNMxla27X3/axtkBVwrNjfDf1Rbu85jl2QR7/tIl9b8m0RrEQxHT3+UJgXJp5
	 P6Wod16FAU5PcFTS8TNRCqPW+0H3ZpUWjY1DJdqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manjunatha Venkatesh <manjunatha.venkatesh@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 168/393] i3c: Add NULL pointer check in i3c_master_queue_ibi()
Date: Wed, 23 Apr 2025 16:41:04 +0200
Message-ID: <20250423142650.309677574@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manjunatha Venkatesh <manjunatha.venkatesh@nxp.com>

commit bd496a44f041da9ef3afe14d1d6193d460424e91 upstream.

The I3C master driver may receive an IBI from a target device that has not
been probed yet. In such cases, the master calls `i3c_master_queue_ibi()`
to queue an IBI work task, leading to "Unable to handle kernel read from
unreadable memory" and resulting in a kernel panic.

Typical IBI handling flow:
1. The I3C master scans target devices and probes their respective drivers.
2. The target device driver calls `i3c_device_request_ibi()` to enable IBI
   and assigns `dev->ibi = ibi`.
3. The I3C master receives an IBI from the target device and calls
   `i3c_master_queue_ibi()` to queue the target device driver’s IBI
   handler task.

However, since target device events are asynchronous to the I3C probe
sequence, step 3 may occur before step 2, causing `dev->ibi` to be `NULL`,
leading to a kernel panic.

Add a NULL pointer check in `i3c_master_queue_ibi()` to prevent accessing
an uninitialized `dev->ibi`, ensuring stability.

Fixes: 3a379bbcea0af ("i3c: Add core I3C infrastructure")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/Z9gjGYudiYyl3bSe@lizhi-Precision-Tower-5810/
Signed-off-by: Manjunatha Venkatesh <manjunatha.venkatesh@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250326123047.2797946-1-manjunatha.venkatesh@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2512,6 +2512,9 @@ static void i3c_master_unregister_i3c_de
  */
 void i3c_master_queue_ibi(struct i3c_dev_desc *dev, struct i3c_ibi_slot *slot)
 {
+	if (!dev->ibi || !slot)
+		return;
+
 	atomic_inc(&dev->ibi->pending_ibis);
 	queue_work(dev->common.master->wq, &slot->work);
 }


