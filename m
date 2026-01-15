Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717903B530F;
	Thu, 15 Jan 2026 17:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498597; cv=none; b=qJowN/GLHMxuHndOCUChZmEF+ffX8fYazZsZyAvsq4lFqjRokpU8HhiF1VOeYdGcBp7UAsnQtmKE7eNKwKyZD/hLtuYQinbYxdINnWAT0UpLoSmsUrttQEgQvGmueXH0CxhhOHxHhySfzf82W1SPYx5r9v6VHTfUqDC1kzinQUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498597; c=relaxed/simple;
	bh=ASv9ZcMfgvHLHUxaxKE4/0FC7gH9z26tEJ4tLu4dT2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+8KTCIWKb1KYV7Rw+GD9iq1WVN7BIVA5jSnGTd90H6+q3ToT6QYNn5UZl8sse/PEFolNlk8SV2e8s+2dWsHGP3R/B/oVw5AzhPCSfX/zZ37aT4EoStKEsn8ar++nybS6nCP+0Qha35eoNOgH/pVv9I0fxC8VaoGfXjs0TA58cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KAqR+AR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KAqR+AR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1910C116D0;
	Thu, 15 Jan 2026 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498597;
	bh=ASv9ZcMfgvHLHUxaxKE4/0FC7gH9z26tEJ4tLu4dT2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAqR+AR4wD0tilK8yNPmMHeg8DO0gP/VhBP/cp1I0UMB4+zNq8YE7fJqFrH8S5Fr3
	 1/szZuHrzKsESE5Qhwm9r8BS1PQmmEEP7cj3PsOU/2dCVn7cecofz1T1Ul0lF2sW6E
	 a6WpE6IDdmACd5zRnFwUAQhwEvoBcROnGRPg2Hes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+b63d677d63bcac06cf90@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 5.15 486/554] HID: core: Harden s32ton() against conversion to 0 bits
Date: Thu, 15 Jan 2026 17:49:12 +0100
Message-ID: <20260115164303.904225253@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1349,7 +1349,12 @@ EXPORT_SYMBOL_GPL(hid_snto32);
 
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


