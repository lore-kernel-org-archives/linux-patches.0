Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F5329CE7;
	Wed,  2 Oct 2024 13:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876854; cv=none; b=ZywuP8GG1FFaClAF95D9u+8BaUBu3p0gysxpBhrur9CrkMSzNCyI0onwOHDzdS1kdv6G8QFn2Xhpw03AwFoAkHxpdmaG9A7P0+XuT11EY+UaBJt5QBv52AkmIdnrVkRHSIhN7chddPNdEnZUf8OHzI5DQMqtYgkNH3OOuqjqMJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876854; c=relaxed/simple;
	bh=YDkJRvtSZOMck0FIVqpqArb7iYVWE0gYwBrdxfn1ibc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZ/tvOiyAVrG92UpIq1gsPxTO0kzCWWHk2L9RUnD+9W1xDUz6uaJFxBhaEUMaPFpdlzALRGbocKazUPuZiNAfQJLViRmOrqWgfusyLPdiXXoqCz/nvooUDbcGQygiOLcNKVrheRmE/s5V8e+gQyBiuzaWjrJx1JBhWWntXiEeyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKr+gfjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKr+gfjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BECAC4CEC2;
	Wed,  2 Oct 2024 13:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876854;
	bh=YDkJRvtSZOMck0FIVqpqArb7iYVWE0gYwBrdxfn1ibc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKr+gfjk2Jezh+OPyCsCZRgVp6PjWP6/Ls6lDKI0sJlAlSQlU3nT/i1+W2FX99O6F
	 SOywE3Pb5gJ0AmUJsb0RcRlY9G3a2igBQ5LBwK+KbqWnHSSt88Hf96sJf97T2xShGD
	 Sv+F/M7urahUDz0vLKxd5gOq1vKHICIfFS0ZldJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.11 582/695] USB: misc: cypress_cy7c63: check for short transfer
Date: Wed,  2 Oct 2024 14:59:40 +0200
Message-ID: <20241002125845.744655568@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


