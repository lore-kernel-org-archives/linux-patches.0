Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997D73148A3;
	Mon, 13 Apr 2026 16:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098802; cv=none; b=mcmh+T7XkUAIvBqOiYrsTFLXqxCJWFoWvAgboYkq0IqsCcQrvSDACrJndnRMUi+ENQsS2nVNRzcZJIS+Gp7uNasWQbHq7gxQrbR248ueKEnXPmEoYnni0eKkbK6cC4YkeTC+Q2bubX90P85qIwxYDUUCQBgm59Hl+xDwqipreag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098802; c=relaxed/simple;
	bh=PPjw+QqalDK7SpmS1Glm1ou0iWOLswEZUPmy+zEXZ+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6QR3Jn1GFkDtSTVLt7f6MsCEi3gDotsbEX0MwxNKuhm7q/LRJO86lu9dkg+hADGHVK2QzNam3JkXAgebMqZJqRt+E2qdseGgnJHTSnPzjdKHwDdY60UxcY4Nhg/a+xvh51Idro/hx9z0Pougnr9ePhaKRU2UYmLDlnYPY+uMwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkZngz5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkZngz5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D25C2BCAF;
	Mon, 13 Apr 2026 16:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098802;
	bh=PPjw+QqalDK7SpmS1Glm1ou0iWOLswEZUPmy+zEXZ+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkZngz5ZzyfQQ6dbGCsq8sc8SiOXniW3UEZs05gpKvxhefeZSVYrDbDN52oNC1n3q
	 nlOisqwFt5BB3bJtM8GB6x40rABarCRcBGjtGzI0zvUc9i5oVWDiOFQLiHBW3PtmiT
	 qp//A6y4q4PvNEez9RjpTrUdDKPkjIzbmsrFNRKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.10 094/491] usb: yurex: fix race in probe
Date: Mon, 13 Apr 2026 17:55:39 +0200
Message-ID: <20260413155822.564600070@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

commit 7a875c09899ba0404844abfd8f0d54cdc481c151 upstream.

The bbu member of the descriptor must be set to the value
standing for uninitialized values before the URB whose
completion handler sets bbu is submitted. Otherwise there is
a window during which probing can overwrite already retrieved
data.

Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260209143720.1507500-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/yurex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -271,6 +271,7 @@ static int yurex_probe(struct usb_interf
 			 dev->int_buffer, YUREX_BUF_SIZE, yurex_interrupt,
 			 dev, 1);
 	dev->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	dev->bbu = -1;
 	if (usb_submit_urb(dev->urb, GFP_KERNEL)) {
 		retval = -EIO;
 		dev_err(&interface->dev, "Could not submitting URB\n");
@@ -279,7 +280,6 @@ static int yurex_probe(struct usb_interf
 
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
-	dev->bbu = -1;
 
 	/* we can register the device now, as it is ready */
 	retval = usb_register_dev(interface, &yurex_class);


