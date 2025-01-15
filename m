Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3A2248BA0;
	Wed, 15 Jan 2025 10:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937826; cv=none; b=ealaaxGDqWCghhsJ8t9oImYj2akgq3drFge2Hq94DjDuadZaXemrK4BaJBWLhhj7v8LPYxBQq3qkyY2Eaj3wp+UicbCVOta9smrHiw7L8ZosU0zhYJgTDh5Deu/lkhK7+txyEUdlNzoxFD95krfEq6Btrp99TGKDyLqc8pV9HAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937826; c=relaxed/simple;
	bh=D4X7qoZbs6DE4wRv3N94aNUnHVvAPzEVyr/J5tmGg9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5thbUAaNi/DRbdyJ1pYFpzKut5se6RJMVwaUcfATKe1O1WZOwAOF+S6KnD/DVJl7XSojf4Kk6Ra0mFT7aGTyh5MjzHShXmsU2sTCv67OnACp9YJQwBnk1yPiIkAAhWWXCj2+9Vrs8bO6yuFvU5wdz/jdq2M+N8DIi1lNVuRmI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5iYVDuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5iYVDuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AFCC4CEE1;
	Wed, 15 Jan 2025 10:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937825;
	bh=D4X7qoZbs6DE4wRv3N94aNUnHVvAPzEVyr/J5tmGg9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5iYVDuLAmzRHDmyzKoErQL7lpUxUSGR1Zh7z1Nz5/sLstP/uiA+pfII3bXvsQ3Xz
	 iD33n3kdU4LKwdl/GI37Yo7EcZMm4FOEzt6FYV2D3Y/Ao3bMtCPqp2rLbrSEHpi0JA
	 Py75LbeD6ojqZOMG5hi6blAgvAICGr4hwBP4VjZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jun Yan <jerrysteve1101@gmail.com>
Subject: [PATCH 6.1 64/92] USB: usblp: return error when setting unsupported protocol
Date: Wed, 15 Jan 2025 11:37:22 +0100
Message-ID: <20250115103550.111676345@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jun Yan <jerrysteve1101@gmail.com>

commit 7a3d76a0b60b3f6fc3375e4de2174bab43f64545 upstream.

Fix the regression introduced by commit d8c6edfa3f4e ("USB:
usblp: don't call usb_set_interface if there's a single alt"),
which causes that unsupported protocols can also be set via
ioctl when the num_altsetting of the device is 1.

Move the check for protocol support to the earlier stage.

Fixes: d8c6edfa3f4e ("USB: usblp: don't call usb_set_interface if there's a single alt")
Cc: stable <stable@kernel.org>
Signed-off-by: Jun Yan <jerrysteve1101@gmail.com>
Link: https://lore.kernel.org/r/20241212143852.671889-1-jerrysteve1101@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usblp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -1337,11 +1337,12 @@ static int usblp_set_protocol(struct usb
 	if (protocol < USBLP_FIRST_PROTOCOL || protocol > USBLP_LAST_PROTOCOL)
 		return -EINVAL;
 
+	alts = usblp->protocol[protocol].alt_setting;
+	if (alts < 0)
+		return -EINVAL;
+
 	/* Don't unnecessarily set the interface if there's a single alt. */
 	if (usblp->intf->num_altsetting > 1) {
-		alts = usblp->protocol[protocol].alt_setting;
-		if (alts < 0)
-			return -EINVAL;
 		r = usb_set_interface(usblp->dev, usblp->ifnum, alts);
 		if (r < 0) {
 			printk(KERN_ERR "usblp: can't set desired altsetting %d on interface %d\n",


