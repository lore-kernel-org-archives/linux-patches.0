Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298AF46D091;
	Tue, 21 Jul 2026 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654928; cv=none; b=Gp/7BqmMvl3upbpO/DSKDYnd8Zt0s4cxIKHHWCUmXN94Vik3mhIVKgxxLpo2TIv8HXlAcGCWOdYOf03csH3fihGgLoKc0sxlEsRrptaDbKr2l1OInl3sccXJNjA5WGxqYVqbWsFBH62ch6YWndt0veH52Sdxg+dvOjY5MW4Wj5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654928; c=relaxed/simple;
	bh=5Az3JgKAoj5lPd4Mww2vEN/MFLzefDeW5ZjUMvOpE1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ee9T0WQSWXjAEJfsTehGYR1xtOvbuU/PXoL6Ex2k9zjA6FMMFxLj88JArfz6eIfE3DOgIlpBVB4dNHUN22R+pUYapiRGB7eMfj1SoB9GIoZMVvOQmU4taKGz9yHNRHcUuXqlWz1fM5dooSYzXPiGTmtFME/TJ7ZKZEa/RM4qN2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NphZrvsk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NphZrvsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B40E1F00A3A;
	Tue, 21 Jul 2026 17:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654926;
	bh=hbururRcLoncy5R3d+lDyiSQ6o/mTue1BpyLDWhXvIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NphZrvskRaj6Dt8GOilMB2gD195THIifaPQj7nJS/hDwnZEeFn4QYsWIXWQE+tgOS
	 E8cG9ioA/Mvy3NIywehBX4MCMUHK7a8fs+hKXRe6oBraje6fbb+tCE+dbDm00um1XI
	 F/PQXOAsHOtKVdFEEAWhzNziWjAqikLmR26KyB+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 1888/2077] Input: ims-pcu - fix out-of-bounds read in ims_pcu_irq() debug logging
Date: Tue, 21 Jul 2026 17:26:01 +0200
Message-ID: <20260721152637.251704054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1579,7 +1579,7 @@ static void ims_pcu_irq(struct urb *urb)
 	}
 
 	dev_dbg(pcu->dev, "%s: received %d: %*ph\n", __func__,
-		urb->actual_length, urb->actual_length, pcu->urb_in_buf);
+		urb->actual_length, urb->actual_length, urb->transfer_buffer);
 
 	if (urb == pcu->urb_in)
 		ims_pcu_process_data(pcu, urb);


