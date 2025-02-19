Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DFA1EFFA7;
	Wed, 19 Feb 2025 08:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954275; cv=none; b=h04wSSeRD7eAILQ+3WuibFCsSl6jnEBq0pp3plxNNPiRo5H+5Pu4YVTye8eMvIvOklcSbIb0IaIJYhJARg+hv5wMRRy0OOSml2Lf83FYQqtU5OOSbi3Hf++sMzYMBnmqD1pfVfh0g+cnu+vftKzBP78g2Gz4ZJ5QopDKR0yp4bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954275; c=relaxed/simple;
	bh=vcN8eP1K7QYbQUw9alxjL4DJPwYMyovGEVXcH0deyB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYVKsibuZfrmjK7dY3V8N9/QFOl434XtayXFG7u1HFigjnHQrqQFKqGwnofMWidwjL1w9qh9wRRsuHXIwj2E39PraWpoT2bufRcV2b2sp58uLx7DpFhjQuoKTHbo4oyMNhNYrNr34DoYAnIFKQ5ENTZNK9MYR9gWHaYlmXqBig0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uu9XRjPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uu9XRjPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99C2C4CED1;
	Wed, 19 Feb 2025 08:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954275;
	bh=vcN8eP1K7QYbQUw9alxjL4DJPwYMyovGEVXcH0deyB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uu9XRjPDqXfpB+N1W42rNx5gO87Sltd3x/ntjwrrmWo4AifTsWu7NrVoywrl2YCaA
	 E0p0Vc5b7IS5XO9lNcxWI+JLi+gfrAc46jasiNAT3PeN1mVUWmphVogDN5i+EBj6Qc
	 FScJFlLROjQ21XSC/zeN84TCzx/kpcbA7lzb0dZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yan kang <kangyan91@outlook.com>,
	yue sun <samsun1006219@gmail.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.13 153/274] can: etas_es58x: fix potential NULL pointer dereference on udev->serial
Date: Wed, 19 Feb 2025 09:26:47 +0100
Message-ID: <20250219082615.585635014@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

commit a1ad2109ce41c9e3912dadd07ad8a9c640064ffb upstream.

The driver assumed that es58x_dev->udev->serial could never be NULL.
While this is true on commercially available devices, an attacker
could spoof the device identity providing a NULL USB serial number.
That would trigger a NULL pointer dereference.

Add a check on es58x_dev->udev->serial before accessing it.

Reported-by: yan kang <kangyan91@outlook.com>
Reported-by: yue sun <samsun1006219@gmail.com>
Closes: https://lore.kernel.org/linux-can/SY8P300MB0421E0013C0EBD2AA46BA709A1F42@SY8P300MB0421.AUSP300.PROD.OUTLOOK.COM/
Fixes: 9f06631c3f1f ("can: etas_es58x: export product information through devlink_ops::info_get()")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250204154859.9797-2-mailhol.vincent@wanadoo.fr
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/etas_es58x/es58x_devlink.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/etas_es58x/es58x_devlink.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_devlink.c
@@ -248,7 +248,11 @@ static int es58x_devlink_info_get(struct
 			return ret;
 	}
 
-	return devlink_info_serial_number_put(req, es58x_dev->udev->serial);
+	if (es58x_dev->udev->serial)
+		ret = devlink_info_serial_number_put(req,
+						     es58x_dev->udev->serial);
+
+	return ret;
 }
 
 const struct devlink_ops es58x_dl_ops = {


