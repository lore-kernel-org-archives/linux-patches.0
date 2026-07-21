Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619F1476CC1;
	Tue, 21 Jul 2026 20:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667462; cv=none; b=pGue61OSmBamsRxfvY+xw4YVDcWh2OWB9rZB2hE316i+zDt3cOp87OAZszVCRj4YKqHUMLXE7gUm/9xcs7lhTbTL5LNDFjuxUpVobqQ6qvQxqv7sjIZ3qKGxRpTdIV7Dh1Emafn7AGu38YlJ3TfpsNHwIxab0Ov+Dm+Z0n4UbL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667462; c=relaxed/simple;
	bh=KhYmEGNVaddGZGrjjiaSTUepbuKsxFzJHzZkJ14zRUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqZsxhZe+l2eqNvfumNyAWGhQTAy7FRXgefP4FbdSw/xyRzOk9UBiUlXXjV3WMuzKcz968+s4fPiuAW8sMAfC0DWEPSM4fANpvWm6dG7oc+Ba01PYtYPoYlAGq3DW7W7stt3i/jUzgyw4hFNsMrSbIK7mwzz07Cfdj/PV9lbcCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwjSHa9L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwjSHa9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF181F00A3D;
	Tue, 21 Jul 2026 20:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667458;
	bh=w6QmaCxfZl/w+lhYySoejEqNEjhe9wV5cXVsj7sXXno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwjSHa9LAAljdx3M7JkzUOgKmTfQHICMMkibS0ZfPpcBLKxxfPRCoqAMCQRBy/B1p
	 w/AHjZVOYIFegaYSJyG+iKDVAqIo3kPuQa0As4QSATG4kxSYKNkl2TOvdJi+33gv4m
	 PjmU2YepXPXTWd9ZhSn+UYneioCsJZGVqlR8SKRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 1070/1266] Input: ims-pcu - fix out-of-bounds read in ims_pcu_irq() debug logging
Date: Tue, 21 Jul 2026 17:25:07 +0200
Message-ID: <20260721152505.762554074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


