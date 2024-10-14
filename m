Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630A91BDC3;
	Mon, 14 Oct 2024 15:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918387; cv=none; b=osjaeH2REG8YOXNOfaJuZbTdLi7GY2kXSF6izHZ8zwgCx59uFECoI+UO/HEZNe52Jd/YXfa2VThbcZoj+jUOdweB0Tsl4I6Rmg4CikRH2SU0GeYTVnEnMh9jMRxdyNemiG6nzP5Z7XO5bJ2QczL1TnJ3+o2NCKXhvHsJhRXuwuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918387; c=relaxed/simple;
	bh=2s02YgRQQenaJjglrODn6uSys3OhICEwB7EMu03Z+mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sseyiN+19z6/ilb8hRWbn5GpFY79Sw28TzZLCeFoqNGFPI7VfXNrPMVoBqAh6QNyJ7UMyjvxHG/Kr1wsleNmHApU9lpxqIK/KNS6gj4OwYqmegRHFUl2M6ynB6hqXVDlOfDBpOhuVTFCv1qxxZQtHfvffzR/nDPwUmVNM1/8IRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suRcaOZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suRcaOZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B91DC4CEC3;
	Mon, 14 Oct 2024 15:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918387;
	bh=2s02YgRQQenaJjglrODn6uSys3OhICEwB7EMu03Z+mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suRcaOZo9JBeun/CEARzlknwBGfS0J9wY5g7/uPxzVfrYlDvvFKl0daFw4iOxb/Kb
	 +vo/Yy4kj0bldu5FsjT+VqdAsnqSKozk6MpErsVQGz3630BZEqH2IlVgfAk8IosU9x
	 NpkAbThWL36gxFEErfwqn5sjJE61L6l1NqwIczQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.1 308/798] USB: misc: cypress_cy7c63: check for short transfer
Date: Mon, 14 Oct 2024 16:14:22 +0200
Message-ID: <20241014141230.049299356@linuxfoundation.org>
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


