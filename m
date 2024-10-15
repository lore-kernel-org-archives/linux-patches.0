Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15A51AF0B1;
	Tue, 15 Oct 2024 13:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997583; cv=none; b=YFaTXQVaRrRZGQB4/pod6Klk4Zskq3Us4cJb92pB5fuPYW/6X1mZMuy/yiwxcl2k1a5LYRYE5ZjsqooS2lhpIDgWX3UjEZMpPwf3HOe1I5IfylEz5kxRR0Q5UbyvqB/E1o6cO2Gl34olUV8xl7iNJT73h1GodXFdq+g6SK6VoZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997583; c=relaxed/simple;
	bh=oht2Z8/bk+thOcKTo8acRO1A+s85xIVa+trlMnu01X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJNJsloOKIgKtp/LreciNXC+lNbDpvf0AmKA8mlNKb8S7fl0rLAqm1d1Q3HkEgRXCRLFAQzUTgyl27wQ5a/9aGPfLXABksDwDaDRBFJVy6KL/xUVo3GKgCt9F59X3F0GESCXwm+z8qlVu4mvHGq0rwjQ9kX7I7TDL+d0dZUHigo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtVNBTzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtVNBTzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D092C4CEC6;
	Tue, 15 Oct 2024 13:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997583;
	bh=oht2Z8/bk+thOcKTo8acRO1A+s85xIVa+trlMnu01X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtVNBTzuhjVwFS9wtuxOTFXeZLBufSBb8rePFjG0ej93Z7qefNuzi5bkuZXVJKakP
	 fk8VMFb5HIcPi7AB21R713noMFTwnoV4B0UqnjF4fW1z/sb8zjBYroHR30oCcA/Nhq
	 Vb0KGp+ihqL4ZjctJirSToGK2kZZLwWcJSy2Azwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.10 225/518] USB: misc: cypress_cy7c63: check for short transfer
Date: Tue, 15 Oct 2024 14:42:09 +0200
Message-ID: <20241015123925.682613016@linuxfoundation.org>
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

commit 49cd2f4d747eeb3050b76245a7f72aa99dbd3310 upstream.

As we process the second byte of a control transfer, transfers
of less than 2 bytes must be discarded.

This bug is as old as the driver.

SIgned-off-by: Oliver Neukum <oneukum@suse.com>
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240912125449.1030536-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/cypress_cy7c63.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/misc/cypress_cy7c63.c
+++ b/drivers/usb/misc/cypress_cy7c63.c
@@ -88,6 +88,9 @@ static int vendor_command(struct cypress
 				 USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_OTHER,
 				 address, data, iobuf, CYPRESS_MAX_REQSIZE,
 				 USB_CTRL_GET_TIMEOUT);
+	/* we must not process garbage */
+	if (retval < 2)
+		goto err_buf;
 
 	/* store returned data (more READs to be added) */
 	switch (request) {
@@ -107,6 +110,7 @@ static int vendor_command(struct cypress
 			break;
 	}
 
+err_buf:
 	kfree(iobuf);
 error:
 	return retval;


