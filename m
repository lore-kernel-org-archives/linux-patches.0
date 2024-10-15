Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5B91C07FF;
	Tue, 15 Oct 2024 13:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997586; cv=none; b=rY+tbJDH5HyMK2/zuC2QGt/uFzaXoZB8jVT7toPxsOkLp9Bb/6uUv1IQdb4h41eNjZ4lpUjz2Cb5bj0k3Cbd5Mhg7jbtiCv0GKTd7nvBSTp1/nuTPvicko6xM1kv/FJuUXqNNADDy53a8bj+Yw9IbOkyU0UAFEjF8cxP2bp4e5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997586; c=relaxed/simple;
	bh=R43xR5LiByC471C2ZifXsJbgTOucQCPr5DRRE5VGxYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pU2bE+1AQQV7+5UG1mZP2XNWMovx9wZC1cdCPKb5KhTbtE+d9T9MFvpdm/DND4sSucKPAvMF83O7ex+/cAwEBVXJow+k0X/730a29bzPtbsJuj1W2iA9cvOm7ZiMmOYNi044c/uS/lBQTRw/Z3m5m+fRM2HUZck2V2BDKHyPd7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUlNLn4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUlNLn4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B25FC4CEC6;
	Tue, 15 Oct 2024 13:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997586;
	bh=R43xR5LiByC471C2ZifXsJbgTOucQCPr5DRRE5VGxYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUlNLn4YPDmuTX9SPK6UWN0JW4h2w1Qz5rpVlWe/LvWej9NL3N3SW6YbCZVtWZXux
	 Tb2FRPfrELHB4lgrVZ3DQYLHaIO0MMDsTBP6mvzRxsycERHCOpdf2Akw2RelciGdtX
	 5v+CUWc/0/KpYvznMYQDBSY802EieRNlU05bofmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 226/518] USB: class: CDC-ACM: fix race between get_serial and set_serial
Date: Tue, 15 Oct 2024 14:42:10 +0200
Message-ID: <20241015123925.719933128@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -942,10 +942,12 @@ static int get_serial_info(struct tty_st
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
 


