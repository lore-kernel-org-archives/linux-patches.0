Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA793624BA;
	Wed,  3 Dec 2025 17:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781255; cv=none; b=VYhq4oeSTpWIIeTpVXuXuSeedvJOy7wep66hnNZL1TlU1i2WKXQQCILLjqtAlsYG8PNHbvTiAfn4t8Mnb/H7Wy5mk0AyYTJgmSR9+/bDDiAx0I++e2i4jYeaB+4ERjLiLS8gh/ZiALbz2nc3CC7+VtIHP8SRvf4PgLIzWE/yjp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781255; c=relaxed/simple;
	bh=fQi+K4M2tFEp4RQAHn+0ez3BEDsnqP7pApL96Z9bYBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6c3gDhpLltkz8FtMFgkplCep9M+ssjE+h4kmXwjAZVuH2DXgWpxYFKqib28qoXsVLIG3OLNdwExgE/HYji238dFLXgEAtEn8A9tOkL85fv4ab1+hiEWluR/nPzoNTLwwuWCV4A0EkTMFjV/9EcifWmcuA82i38JDOZz2rjhIIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFBRitmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFBRitmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FEDC4CEF5;
	Wed,  3 Dec 2025 17:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781255;
	bh=fQi+K4M2tFEp4RQAHn+0ez3BEDsnqP7pApL96Z9bYBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFBRitmCuADJfibMN3M0M+PVINTyQSQvK/JYuqA74iaI6emQ4bYndOBjfV9+ynMVw
	 TxP3TLyvELpsYCI4daLua7L73eLwiHM/8wDdGcQNsl4zPnvvgSnA/EFKgDbGOVKq5q
	 iYmnIDcczELmNlM5BFfurUDU4vWn3/gWBw+Agz3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+b63d677d63bcac06cf90@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 6.6 93/93] HID: core: Harden s32ton() against conversion to 0 bits
Date: Wed,  3 Dec 2025 16:30:26 +0100
Message-ID: <20251203152340.001378871@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit a6b87bfc2ab5bccb7ad953693c85d9062aef3fdd ]

Testing by the syzbot fuzzer showed that the HID core gets a
shift-out-of-bounds exception when it tries to convert a 32-bit
quantity to a 0-bit quantity.  Ideally this should never occur, but
there are buggy devices and some might have a report field with size
set to zero; we shouldn't reject the report or the device just because
of that.

Instead, harden the s32ton() routine so that it returns a reasonable
result instead of crashing when it is called with the number of bits
set to 0 -- the same as what snto32() does.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: syzbot+b63d677d63bcac06cf90@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/68753a08.050a0220.33d347.0008.GAE@google.com/
Tested-by: syzbot+b63d677d63bcac06cf90@syzkaller.appspotmail.com
Fixes: dde5845a529f ("[PATCH] Generic HID layer - code split")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/613a66cd-4309-4bce-a4f7-2905f9bce0c9@rowland.harvard.edu
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
[ s32ton() was moved by c653ffc28340 ("HID: stop exporting hid_snto32()").
  Minor context change fixed. ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1351,7 +1351,12 @@ EXPORT_SYMBOL_GPL(hid_snto32);
 
 static u32 s32ton(__s32 value, unsigned n)
 {
-	s32 a = value >> (n - 1);
+	s32 a;
+
+	if (!value || !n)
+		return 0;
+
+	a = value >> (n - 1);
 	if (a && a != -1)
 		return value < 0 ? 1 << (n - 1) : (1 << (n - 1)) - 1;
 	return value & ((1 << n) - 1);


