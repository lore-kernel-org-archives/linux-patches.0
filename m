Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F86E1D4154;
	Tue, 15 Oct 2024 11:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993236; cv=none; b=mzhml2kT8Xo8ySbRCSbZgndX9JmylwOvUdMX+oAq2uJDjnA9wwM87uZ2qP0DtMUcqBjDZT0w7TSiJjpZHojZt1I6pq+OJDl4/oha46LC2gegtffHDn9jPvXXmlsTDyMK/Trw3TN9g39xniZMknLSDAczzyrr6ZEGsqJIzNmo4OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993236; c=relaxed/simple;
	bh=eTc4dUqJSnx9vWT96gSs1PibJ78fCn47fVjQNZpD/nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMaHwQclauWTLYleaoiBll6R7wiiRPKTvfsMgKNHtyWAEDJa9zq4qvBWRqkQW6o7V3FLzxBAHQnvEqz0phwxQEpvwPGGyWwOk9awdmvo+I8jy5Q/xvf9dUHfyHFwDnPkKfp2YVcmv4+cDlbrVCWyhDS5ClFrBcOVzVI5aex91EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRiRVUh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRiRVUh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B180CC4CEC6;
	Tue, 15 Oct 2024 11:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993236;
	bh=eTc4dUqJSnx9vWT96gSs1PibJ78fCn47fVjQNZpD/nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRiRVUh84h1rsCV9nAc4o9QeJ6/TZSVU55t/0oe8icQ+szDVpj5bJEsrOSJTu1DyK
	 URdpLZPiE+kzmeYGopQKvbupaqvnEGHhrU2JckMbI7OdnWBYFjnnf5qUiEM3QYEp2L
	 ghvFcTINtt6CBDfoZ3J+jdqxxL2lJyUbwaHzFpVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.15 320/691] USB: misc: cypress_cy7c63: check for short transfer
Date: Tue, 15 Oct 2024 13:24:28 +0200
Message-ID: <20241015112453.038854122@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


