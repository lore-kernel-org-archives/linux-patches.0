Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5BE47D931;
	Thu, 20 Aug 2026 16:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243251; cv=none; b=naV8Vig1USu9uvBB7wlRuVYym5TizvbdxAtKJc3GnYhNa5/CTMd7azExllFmf8m32gHvgecxLdeb39bCGxD9F611IEY9FFZNB8KMIhfxC5aKcYEo6htyEr9sZli5q8miWhAeeDdPJOS9lLH//ddB4E98/TbD+yQ0PLnsObnOMtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243251; c=relaxed/simple;
	bh=bbKv5QnMEdD8PeoYuBsinMH2a5WQqHU+5BlxdAHBp9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqjQfY4I5WD76gVe4hDdMKIRMTpJSfTbOd8U9rzoKLdlEfrlujNlaeTAD9GVwXtR39EVehhTN/uMices/FsqANb14TSYUJ5mIJLKIsHov3vp55yiFzE1h8FyX9GzGfwGGb4k0XMIZs5CnkjOfH+4bGuOpqIvTIF+/99DVecjvVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2yYQpTK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2yYQpTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA8E1F00A3A;
	Thu, 20 Aug 2026 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243249;
	bh=wQXBJRTTi8IT/7hmq6YSFTA/TS3AD/oEx3xncP1rEhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2yYQpTKq7+Fs9axKWdrOFN/7ySi3wvAWadNlLkHHzP4F1aJAX2PMpTir3SJmGCCZ
	 /Wi6QAHllspwutYF0eQw44DFI0lOFKoEnZmxY6jQppClOKSeoq5Ei4z4xoy0YM9GhK
	 TgZBws2qjckMnSvpHrYI3za+/OKlK2if/VtUSwxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 029/272] Input: sur40 - fix V4L error path cleanup
Date: Thu, 20 Aug 2026 16:53:33 +0200
Message-ID: <20260820145232.105694809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 062dc4693e2c10d77de06f61e6f3faf37c0a8383 upstream.

In sur40_probe(), if video_register_device() fails, the error path jumps to
err_unreg_video. This incorrectly attempts to unregister a video device
that was never successfully registered, and fails to free the V4L2 control
handler (v4l2_ctrl_handler_free) that was initialized immediately prior.

Fix this by introducing an err_free_ctrl label to properly free the V4L2
control handler and bypass video_unregister_device() when video device
registration fails.

Reported-by: sashiko-bot@kernel.org
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Link: https://patch.msgid.link/20260616051235.1549517-2-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/sur40.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -787,7 +787,7 @@ static int sur40_probe(struct usb_interf
 	if (error) {
 		dev_err(&interface->dev,
 			"Unable to register video subdevice.");
-		goto err_unreg_video;
+		goto err_free_ctrl;
 	}
 
 	/* register the polled input device */
@@ -806,6 +806,8 @@ static int sur40_probe(struct usb_interf
 
 err_unreg_video:
 	video_unregister_device(&sur40->vdev);
+err_free_ctrl:
+	v4l2_ctrl_handler_free(&sur40->hdl);
 err_unreg_v4l2:
 	v4l2_device_unregister(&sur40->v4l2);
 err_free_buffer:


