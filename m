Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35CD4ABBBD;
	Thu, 17 Sep 2026 15:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660128; cv=none; b=ULIbfsj7swfosqPeW1SDBnI1sYunOGgFbRN1Blh9QAk9XPasknULmBZrGnQ2J343UzPlaRRNfFPtMwveCBlgFfEB4WtabLXmfQl1fnzzK9Dfd8MCsZFj8jWLyhFg2EaiqtGinzaa9W5K7Q3iGE5fEzfDOUbpfxRrGTEGJSKxmQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660128; c=relaxed/simple;
	bh=+t+gz+Er2PqczRlNywxZAbyAgxhGnIL1rfvJIxX0MJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhlcJ+I1xD8CBlLSU6hC6ibW3UUI3dk5p1NFpVEDUaztkQI8nJ31P4Z7ikjX5kij5HHElKJhEXu38+H8AxHuvY1CUvK9PLouR0kKXjeR+Hdq8Ds1qrqDbTxy1n4A2/zBpWcM8HexSAqhWEpr6Hsi0WWOKtuJwF0tS0O7w+V+axE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2enC0qe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2enC0qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE91C1F00893;
	Thu, 17 Sep 2026 15:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660115;
	bh=S9zz7oSXxfIYVwkpbkNnLTbwqQ/yNbeos9N0crdAOos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2enC0qeHYNLmcEIdB5lQIWLe5m1ZJgx9B3Zq3lfGmKUuj1wBn2qHwL5xkx0Vx7Q4
	 rmueUXqzvA7YSsLVJKTxPnFvQZuYu85mqCPT+oIWufB8TNSDU34uIRn3nDQfni/mm/
	 S2o/VchNuuIDA0oIb5v4bnEgeAj6KrvvIfSXnZ+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 483/733] ALSA: usbusx2y: validate URB actual_length in interrupt callback
Date: Thu, 17 Sep 2026 16:13:11 +0100
Message-ID: <20260917151404.065406012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit 8f5ef203abda9dd36b2af473c7b737d544f807bd upstream.

i_usx2y_in04_int() processes the interrupt URB data without checking
urb->actual_length.  A short transfer from a malfunctioning device
would cause the handler to process uninitialized heap data from the
kmalloc-allocated in04_buf, which is then copied to the mmap-accessible
ctl_snapshot[] array.

Fix by using kzalloc() for in04_buf to zero-initialize the buffer,
and adding an actual_length check to skip processing on short
transfers while still resubmitting the URB.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Link: https://patch.msgid.link/20260904205826.4071119-2-tristmd@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/usx2y/usbusx2y.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -189,6 +189,9 @@ static void i_usx2y_in04_int(struct urb
 		return;
 	}
 
+	if (urb->actual_length < USX2Y_IN04_SIZE)
+		goto resubmit;
+
 	if (us428ctls) {
 		diff = -1;
 		if (us428ctls->ctl_snapshot_last == -2) {
@@ -253,6 +256,7 @@ static void i_usx2y_in04_int(struct urb
 	if (err)
 		dev_err(&urb->dev->dev, "in04_int() usb_submit_urb err=%i\n", err);
 
+resubmit:
 	urb->dev = usx2y->dev;
 	usb_submit_urb(urb, GFP_ATOMIC);
 }
@@ -305,7 +309,7 @@ int usx2y_in04_init(struct usx2ydev *usx
 		goto error;
 	}
 
-	usx2y->in04_buf = kmalloc(USX2Y_IN04_SIZE, GFP_KERNEL);
+	usx2y->in04_buf = kzalloc(USX2Y_IN04_SIZE, GFP_KERNEL);
 	if (!usx2y->in04_buf) {
 		err = -ENOMEM;
 		goto error;


