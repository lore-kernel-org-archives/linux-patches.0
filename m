Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E601798C;
	Mon, 14 Oct 2024 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918390; cv=none; b=oLEPpMZdkuoUOCaQQJaNcacFdqY7sh2h597EHJ+dTr1fw1dBEeaDQQV+ZCx+p6532RMgDZjluJG09uFtf+f22ZwMqt6MHUceMUSXkvZGpT6Rir1OoVjM3O/Dv1rGJaAhYpUooN/Y+arBoFaDMP4idkPQ0L1ARJygOPh53hKGhXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918390; c=relaxed/simple;
	bh=5KzafU7FVn1C1Gh34FeRmVVTHFAz3/Ph/Xb3GEm70ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPhNS/EfxUOO+a4+Lkz2AUUsrL4yDYvPOF7dmCuC7rQprjmpr+WUehewZNfB1EZvAkud5sqZk3dO6AC+ffkvXvoq8OVohoQnfjeeYCsSY6dbgOPdkZPotmsVnL1Ytt+vSvMgzx4RPtQztd22HqDBeV8wwGuR50kUhqcZfAYw55s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubBnpBHy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubBnpBHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1FCC4CEC3;
	Mon, 14 Oct 2024 15:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918390;
	bh=5KzafU7FVn1C1Gh34FeRmVVTHFAz3/Ph/Xb3GEm70ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubBnpBHyIzYerhkpEcbXFIR1xjzhkLQQ8Aww/RQeYUQFlxGuimeHz6CofgnSkfZfI
	 CzkbdWatX4FPIh/uEQbKKfiO2/fsQsnwp+5TJxAS6RN57pGy81yeqpWHcXsh7YETUe
	 zC0+9R+E/dXReeDP0Fpif7/LeriF1KN/C/eW7RMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 309/798] USB: class: CDC-ACM: fix race between get_serial and set_serial
Date: Mon, 14 Oct 2024 16:14:23 +0200
Message-ID: <20241014141230.088245898@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit b41c1fa155ba56d125885b0191aabaf3c508d0a3 upstream.

TIOCGSERIAL is an ioctl. Thus it must be atomic. It returns
two values. Racing with set_serial it can return an inconsistent
result. The mutex must be taken.

In terms of logic the bug is as old as the driver. In terms of
code it goes back to the conversion to the get_serial and
set_serial methods.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Fixes: 99f75a1fcd865 ("cdc-acm: switch to ->[sg]et_serial()")
Link: https://lore.kernel.org/r/20240912141916.1044393-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -938,10 +938,12 @@ static int get_serial_info(struct tty_st
 	struct acm *acm = tty->driver_data;
 
 	ss->line = acm->minor;
+	mutex_lock(&acm->port.mutex);
 	ss->close_delay	= jiffies_to_msecs(acm->port.close_delay) / 10;
 	ss->closing_wait = acm->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
 				ASYNC_CLOSING_WAIT_NONE :
 				jiffies_to_msecs(acm->port.closing_wait) / 10;
+	mutex_unlock(&acm->port.mutex);
 	return 0;
 }
 


