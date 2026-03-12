Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03D6359A8B;
	Thu, 12 Mar 2026 20:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346826; cv=none; b=NdvfGcQRCS0eDVSvu1YcGhnYm0YIR1IUqP7INXjbTL6tVOkp4z1rBSVBGcjQ9xM9r9Mv6sMxtMKfRaFhNczMui/G0QG3OMDT6Caysknzorbhi9N2z+7PlfNrBvT3f7w2fu4gvawepeXy7kQ0u0T/Qo75YENeveaJF7+ozzcwaGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346826; c=relaxed/simple;
	bh=vBcQyfpwyj3Tb6nUDfWtLY+VI7YMxcpDG20ZA8lMhxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImrSoTDMdsHD8oewbSjP/75xVieEJj6IKtki+C5tmYA3C3R1xbtd5P4wYgijPDRJHiJyVm5CkDxr9E5/KNVkbPnXJB2H9C7DLzPU64fASIK/2mf3moOejZwLHp8rc4OL0mkfeL79LqMu1n/9AsadVQGWThrWPr9z1Mh6pee9in4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZ7A6Ejq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZ7A6Ejq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE1FC4CEF7;
	Thu, 12 Mar 2026 20:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346826;
	bh=vBcQyfpwyj3Tb6nUDfWtLY+VI7YMxcpDG20ZA8lMhxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZ7A6EjqJZlX2E6jGD/GyETnAp9SVAcrSEoOrFDIC4uWlCIKg/PRP7Qb6RHbLWJ8u
	 5DwJ/eKe/ZnPeJMnatJFSCWOTgtS0tRMjLNMpq0HOQuUdR+cQEQgd24yOn/gN3aTzU
	 7YwLFiufz3oQEw+2f4cL7aAudzup9fqbnxSvB7ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.12 135/265] can: ucan: Fix infinite loop from zero-length messages
Date: Thu, 12 Mar 2026 21:08:42 +0100
Message-ID: <20260312201023.129965355@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 1e446fd0582ad8be9f6dafb115fc2e7245f9bea7 upstream.

If a broken ucan device gets a message with the message length field set
to 0, then the driver will loop for forever in
ucan_read_bulk_callback(), hanging the system.  If the length is 0, just
skip the message and go on to the next one.

This has been fixed in the kvaser_usb driver in the past in commit
0c73772cd2b8 ("can: kvaser_usb: leaf: Fix potential infinite loop in
command parsers"), so there must be some broken devices out there like
this somewhere.

Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022319-huff-absurd-6a18@gregkh
Fixes: 9f2d3eae88d2 ("can: ucan: add driver for Theobroma Systems UCAN devices")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ucan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -749,7 +749,7 @@ static void ucan_read_bulk_callback(stru
 		len = le16_to_cpu(m->len);
 
 		/* check sanity (length of content) */
-		if (urb->actual_length - pos < len) {
+		if ((len == 0) || (urb->actual_length - pos < len)) {
 			netdev_warn(up->netdev,
 				    "invalid message (short; no data; l:%d)\n",
 				    urb->actual_length);


