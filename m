Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706AC2417DE;
	Thu, 17 Sep 2026 18:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670916; cv=none; b=L4UJDXK0e+uKjqE1ryP8nkHgQVi+9sJECUiKVh0CdZHAFJ20gl6arEZ30frq/EMdxqd7rct+cUtFTglzKSYMn/My4zTfQGdBILxTEINY/PZUVxTndAaAh0BqH6HTwbRlAEMf6vjyQS8M8Gtt8km3gmpZEx4VuaA3Rpf5WYnOmpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670916; c=relaxed/simple;
	bh=UJX+jhrAuTabaqn5aKs6lm1HKxvKq5ARqf2OOC5bROU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOfo5OowIckhYMjwv3UbPAukBG5GLGF7wzfmWoL1FKcLJ+BSouseUtxFP4P4LorDeODNMBdipLdFR2RccAxt5fyFEGKOO/LhKO78gduqYchcAgplAdi8aAZq+HEMyjUu8cfy4BOq5ef4c4+tMb1XIzwtZBKm2A8FzVPO1kgLJKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZAbtQQD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZAbtQQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1D11F000FF;
	Thu, 17 Sep 2026 18:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670915;
	bh=JmrpD/y+JiyGBsV6wxhXKTnSylK4yE9vK+jufDM0ML0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZAbtQQDqEZLkBXyMlW6Iw0X5Ru4+BUTneftApfd1C5QH7MaE5GAjMQBtvTO9bpwz
	 U+V49cLXrhCQqMUi47jArby5U+zPTK+KuapPphOoXlWrM+vsHJIR6JeFFgLDGRXzLV
	 ImcXFBasjC7OKL7qZBWFjmUw4icr2DX1EKn2j3FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 0812/1102] ALSA: usbusx2y: validate URB actual_length in interrupt callback
Date: Thu, 17 Sep 2026 16:12:35 +0100
Message-ID: <20260917151600.880560457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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


