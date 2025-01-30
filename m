Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22731BEF85;
	Thu, 30 Jan 2025 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245579; cv=none; b=tPyHxbHhatKWUz9ubW3TZOY9LA5XvMVPkhsuqfYKkxV4zrPSUQoWwNCs284w0S7rQXcdCNwXc4QsEJt4rs9Xrt5ex0Ws5QXouVaFuI9nzgS5K5huPEgdS1A7tupGzux4SMNdKxsaSyKOR/WTxY4XplD8TTnV4kJ9mmj+9iP9iiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245579; c=relaxed/simple;
	bh=7w9xN2YnAthjeOrGloTz/DMTRLnZljQnTTc9kZb9mas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxJM+OUZWBhvJsVFkPkRddPwa2HoM3fCUPEcSF5DEblW+inUKThOVE1wwn1+g5LQQPxlkrvbmC0IFSvVHyVANsEoRdZS/mUgDK2Cus+TZioI0JQoBu/IYOyQVbQ4A5FDfi1NxnlP9nxkJdUbj7eUVPXXPuP5BYV49RXG4+1M98M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ND98tvCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ND98tvCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AED1C4CED2;
	Thu, 30 Jan 2025 13:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245579;
	bh=7w9xN2YnAthjeOrGloTz/DMTRLnZljQnTTc9kZb9mas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ND98tvCFugit4CgUwoS2g99ntXbmz3ReB7LKcjqzA6zH+M5k9ffjlY9vVG9xGrf7o
	 U3ezIwNsboUCGtWMvO+ZVnjpj/F+A9QmyXJ+bA1Bn6BacKIXbzqhsJCfNRdWOpkUyG
	 BEOhSpmBRT0vgbvDdpEDOpP0cGy9Db266nSt+Rmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.13 15/25] ALSA: usb-audio: Add delay quirk for USB Audio Device
Date: Thu, 30 Jan 2025 14:59:01 +0100
Message-ID: <20250130133457.555009268@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lianqin Hu <hulianqin@vivo.com>

commit ad5b205f9e022b407d91f952faddd05718be2866 upstream.

Audio control requests that sets sampling frequency sometimes fail on
this card. Adding delay between control messages eliminates that problem.

usb 1-1: New USB device found, idVendor=0d8c, idProduct=0014
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: USB Audio Device
usb 1-1: Manufacturer: C-Media Electronics Inc.

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/TYUPR06MB6217E94D922B9BF422A73F32D2192@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2239,6 +2239,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x0c45, 0x6340, /* Sonix HD USB Camera */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x0d8c, 0x0014, /* USB Audio Device */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */


