Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B036142A144;
	Thu, 16 Jul 2026 14:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211107; cv=none; b=QkPHITQvnPsHG7kyCPBxZPcgzkBz1DKm8uPv8TC0CM3xZuUESNMjhxzDnhN+4LQA+vZw74S/6ASAZzcWuueOAFjK/eKnjRMiyIjJr0nI6PDXHS6Zt7HhkOEGErO9w/eaehFAXeJKwNDVf+AFOKXAKso/zxEOoqxd+vLiCEgVh80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211107; c=relaxed/simple;
	bh=JO2Nu+hiDCYVdSoLw/gqEYcP4tJKBlxp0ZyfqiBZ/uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tySkZXTjRbZwZ9sfcl0ssE+KdHO1vXC2CFrv7MbJ5KscP2O8VULGIFb1FGGPP47ISL5i4O+slX9l2Ck5A9MkBZbICl1y4q5K3BFm7ouJO1jZS8Yk7pQix4V6VjytgQYTRM/7gPKr93dRPt8r5kyogXM2tV/NzR1mmlISL9mB1Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wp/oB5VP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wp/oB5VP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2203A1F000E9;
	Thu, 16 Jul 2026 14:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211106;
	bh=qH+GO3IdsoUWaVIkXFI7SGKzhkHK7u9fwXr6vXrP7Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wp/oB5VPXgWhVjJCPbqLwP3GFSCayHnQsMJX2fffoHdSgbl08vgZsQIy/e2MjXvi/
	 sqmiwRQV5arjyJaHo/AFZJFQpKLD0M6VxA7MDztJDxNBWbiIvU5kEWdXuj4WRSS7xS
	 z2C8PBL34bC3IxkJfhgeJdvIXRAETbIBSowodd0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 302/480] USB: serial: keyspan_pda: fix information leak
Date: Thu, 16 Jul 2026 15:30:49 +0200
Message-ID: <20260716133051.349977442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 6bfc8d01ac4068eced509f8fc74d0cd205e4dcec upstream.

The write() callback is supposed to return the number of characters
accepted or a negative errno. Since the addition of write fifo support
the keyspan_pda implementation will however return the number characters
submitted to the device if the write urb is not already in use. If this
number is larger than the number of characters passed to write(), the
line discipline continues writing data from beyond the tty write buffer.

Fix the information leak by making sure that keyspan_pda_write_start()
returns zero on success as intended.

Fixes: 034e38e8f687 ("USB: serial: keyspan_pda: add write-fifo support")
Cc: stable@vger.kernel.org	# 5.11
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan_pda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -518,7 +518,7 @@ static int keyspan_pda_write_start(struc
 	if (count == room)
 		schedule_work(&priv->unthrottle_work);
 
-	return count;
+	return 0;
 }
 
 static void keyspan_pda_write_bulk_callback(struct urb *urb)


