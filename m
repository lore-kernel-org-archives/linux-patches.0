Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D29A43CEF9;
	Tue, 21 Jul 2026 22:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674392; cv=none; b=P+55FXsMoP3qO8MsPeFs7Tzy0N8duVSJIfVkhMmyaoTNWmV+KMw27KRZSniuz3VIx3UZtcQZ+X/Rk2gfLxpYeJRLssxCmYrCB/LDH7r3esO05STcLOUEKb2hNigIjS0ocgz1NPRPZHuKM8KSZMRxdJS/56PXmG9vEpvWC+dZlMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674392; c=relaxed/simple;
	bh=tzzsvLIyNU+EUxfQTq0jw8bBPaERKei6YlXLoz6rCjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8fA2iOAgIgNOvJL/jutt7RNybgBYX1tgFroDV2jPjcIo3NknttvctpRqDEJeCO7eIrQsjcB4ogcAz0ioR2WczyRMzx5t4+s4JRZmDh9G+k7ehbZhpKAZpnysuOAhp5adFvvjNMhesBZjHEFgM9a37ERT5NEfOuiVmlhQOVW7yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5qPp3UU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5qPp3UU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A111F000E9;
	Tue, 21 Jul 2026 22:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674389;
	bh=QYUp7O7/PTSLT/5474fqOZd+oTOTIRZg4uo9DFp0hwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5qPp3UUJnEqX9EIkj6cySWnBp8AjWE+aG2bXPCkBZd/VbrZV9WCeH/HV7KXs2u8Z
	 GAnRV5f/Edrll+TSfkVpt6hdEQiefc64OUzr7juEvmPeV9RFMUWVSYWO2rsQelgKpd
	 2L/kEiX5O9i98oemizSEuVe7yyLML1ZOWATmNgpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 523/699] Input: ims-pcu - fix out-of-bounds read in ims_pcu_irq() debug logging
Date: Tue, 21 Jul 2026 17:24:42 +0200
Message-ID: <20260721152407.493104977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 403b0a6970b1084bb27907c0f8225801fdd0fe1d upstream.

The debug logging in ims_pcu_irq() unconditionally prints data from
pcu->urb_in_buf. However, if the interrupt fired for pcu->urb_ctrl, the
actual data resides in pcu->urb_ctrl_buf. If urb->actual_length for the
control URB exceeds pcu->max_in_size, this leads to an out-of-bounds
read.

Fix this by printing from the correct buffer associated with the URB.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1547,7 +1547,7 @@ static void ims_pcu_irq(struct urb *urb)
 	}
 
 	dev_dbg(pcu->dev, "%s: received %d: %*ph\n", __func__,
-		urb->actual_length, urb->actual_length, pcu->urb_in_buf);
+		urb->actual_length, urb->actual_length, urb->transfer_buffer);
 
 	if (urb == pcu->urb_in)
 		ims_pcu_process_data(pcu, urb);


