Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C892F1F757F;
	Tue, 21 Jan 2025 18:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482976; cv=none; b=Uoq2ggB34TKg34aES30Ir49Hy9BXaCyhN8zYc3XuptaLamRZe7Dqlz0R9M/EhpbjI+FdpBwcY2NvQZGuHMcOiBSW5sU2dwCme5Zr09/SFJrUHxU101HDOLqolgQKYeCtoTbgPDSiel521xAZJTPpSNJQfdB3vrYNMc1KZEb1bk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482976; c=relaxed/simple;
	bh=M3sN1nyfYDdSRnZKPGB9gEEcZFvdZPw/FwYhYQxnOiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G67RMzWDA4VGicFQ/Z0GagZSUg8UERR7zhGX4Hkb2mf8odPaXsEPSb1nfumWZg1txx2syuHjjlowVoQ1kgLom/Tw7wDiK73iRPoJzCl3OV4S7+Ad5t+m1RXWjjv++t8M2coPiqpd60rz/ZQJVtjldmIkKuNQtBhj6bwhEWgqO7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPZr+fWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPZr+fWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4666EC4CEDF;
	Tue, 21 Jan 2025 18:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482976;
	bh=M3sN1nyfYDdSRnZKPGB9gEEcZFvdZPw/FwYhYQxnOiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPZr+fWh3ZY/miw6FN/cmRtHTANgbKHFMOWR0e5TmruKEQ1MiUbK7p7eSZTSVfTL4
	 F+bJ45s98IrMU9BpBjgZBRXn/AOfn/6gwRi/t35tuRAX0nOK2w0bXaNPgqo4xpI5eo
	 6FTpdHM56YfDxTbn1dKBmsSc31bjAE94DblygVcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 043/127] usb-storage: Add max sectors quirk for Nokia 208
Date: Tue, 21 Jan 2025 18:51:55 +0100
Message-ID: <20250121174531.337069541@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lubomir Rintel <lrintel@redhat.com>

commit cdef30e0774802df2f87024d68a9d86c3b99ca2a upstream.

This fixes data corruption when accessing the internal SD card in mass
storage mode.

I am actually not too sure why. I didn't figure a straightforward way to
reproduce the issue, but i seem to get garbage when issuing a lot (over 50)
of large reads (over 120 sectors) are done in a quick succession. That is,
time seems to matter here -- larger reads are fine if they are done with
some delay between them.

But I'm not great at understanding this sort of things, so I'll assume
the issue other, smarter, folks were seeing with similar phones is the
same problem and I'll just put my quirk next to theirs.

The "Software details" screen on the phone is as follows:

  V 04.06
  07-08-13
  RM-849
  (c) Nokia

TL;DR version of the device descriptor:

  idVendor           0x0421 Nokia Mobile Phones
  idProduct          0x06c2
  bcdDevice            4.06
  iManufacturer           1 Nokia
  iProduct                2 Nokia 208

The patch assumes older firmwares are broken too (I'm unable to test, but
no biggie if they aren't I guess), and I have no idea if newer firmware
exists.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: stable <stable@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20250101212206.2386207-1-lkundrak@v3.sk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -255,6 +255,13 @@ UNUSUAL_DEV(  0x0421, 0x06aa, 0x1110, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64 ),
 
+/* Added by Lubomir Rintel <lkundrak@v3.sk>, a very fine chap */
+UNUSUAL_DEV(  0x0421, 0x06c2, 0x0000, 0x0406,
+		"Nokia",
+		"Nokia 208",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64 ),
+
 #ifdef NO_SDDR09
 UNUSUAL_DEV(  0x0436, 0x0005, 0x0100, 0x0100,
 		"Microtech",


