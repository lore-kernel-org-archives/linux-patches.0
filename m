Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1273CBE8B;
	Sat, 17 Oct 2026 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260615; cv=none; b=hzW/wif79UhzLPfWHcAK0KOuUFWd/IVe751bFJDjBg/iDCVRxDDePzsNv3M3ph6od0A8L2NEjKXXiYif/HB+aW7hCF0eIH+Z53y0A7EAgb2B9GOjNRHS6c4SK7xQytV9zqwse2NZuHkRUlVVXWUphl85fch3otq1PKfvCzwdKBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260615; c=relaxed/simple;
	bh=gFFKR6nXQx0sSkURRND8xFPippsXVLeMS8SF2WhJjaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkeFjMFFHvNbFCKOpSkbP6dv4B61WTG054Ow9nsYpdoNpyK4Loc6fzPUNUPfuPaCAdfuF6UpNfSNgX6CGu0JhegWPVVS9WWhX6cClAWrSAiZcLwtGc8F7MF6Jx544l2pME4P2/miyheWh9NvNgZGs65gdCy4MXt2Qs4Td03HrAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPqggmgi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPqggmgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC4C1F000C4;
	Sat, 17 Oct 2026 18:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260613;
	bh=ausVuksK53Uu58dmjWOpR3Vq1ARA+AHRf0on43VObg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPqggmgiPhHB2cUNDvnYPM00E1xPN+Upuhg8z/Pd1fY7moCbDL5cLWeZFPpNMLEn2
	 1xYr7nZzDoZgIzEOETJwOQsmsMoXlRLlWFybYAgkZKGjG0MhRp/QzmX68x5EpbzB3d
	 GIFMFOn/sMNfi/Wps7UkvCbGrbZg1qztRHkaLERI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1603/1674] ALSA: usbusx2y: validate URB actual_length in interrupt callback
Date: Sat, 17 Oct 2026 18:04:35 +0200
Message-ID: <20261017160512.233534645@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 8f5ef203abda9dd36b2af473c7b737d544f807bd ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usbusx2y.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index 6832eac95cf15..1ccb01bf85f37 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -189,6 +189,9 @@ static void i_usx2y_in04_int(struct urb *urb)
 		return;
 	}
 
+	if (urb->actual_length < USX2Y_IN04_SIZE)
+		goto resubmit;
+
 	if (us428ctls) {
 		diff = -1;
 		if (us428ctls->ctl_snapshot_last == -2) {
@@ -253,6 +256,7 @@ static void i_usx2y_in04_int(struct urb *urb)
 	if (err)
 		dev_err(&urb->dev->dev, "in04_int() usb_submit_urb err=%i\n", err);
 
+resubmit:
 	urb->dev = usx2y->dev;
 	usb_submit_urb(urb, GFP_ATOMIC);
 }
@@ -305,7 +309,7 @@ int usx2y_in04_init(struct usx2ydev *usx2y)
 		goto error;
 	}
 
-	usx2y->in04_buf = kmalloc(USX2Y_IN04_SIZE, GFP_KERNEL);
+	usx2y->in04_buf = kzalloc(USX2Y_IN04_SIZE, GFP_KERNEL);
 	if (!usx2y->in04_buf) {
 		err = -ENOMEM;
 		goto error;
-- 
2.53.0



