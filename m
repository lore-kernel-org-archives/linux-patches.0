Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18EE407CCF;
	Tue, 21 Jul 2026 18:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659074; cv=none; b=bWJmmI5hDXBAzQ0KL5Wl/Ijp8SI6cW8CDzUS4uyunphxvkTCyCAB7OKZYYEiA5y9egv7T/xLyMgNFrOj5SDPqUufLmAZs+/6MFuap29gXNrxQDKw1y+YWpooQce2AqMvUEZuDF8bsdpLbIKJZhSfDsdZLOGy/bIUm1mr4w+NEss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659074; c=relaxed/simple;
	bh=3kbBaDOsHXAeZmr9F4v4pMAyEQZd8vieYtKY+2SisY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhrJ4fSst5WgSOrongELFSEKibC/diCz4TLdow0TXc64wQOfMLZbs/0qaPqLjcwfZqYkCX4drGPumiuSu8xef7ecdZo85sKW9gZrbw2Jm32/hI1Pw2Ed4DEsqNcLOGsN5hw2nJmLOi0n5ITjVbHFdCVTQuw/gx5WgGJrn6H2IrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1gQgb0e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1gQgb0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E201F00A3A;
	Tue, 21 Jul 2026 18:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659070;
	bh=Yysvhwap8pkB7VFbpN89GKSEdsuwJvk3k5Fyr3k5g/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1gQgb0eLu0ajc547AODmp6/Wd4WMC4iMOZMHki1pMe/h9i+ntb5NWyENJ9v/Hoag
	 7nOKz6FINA17DaQu4WPEZv2LGio/N0SqmJ2MFxg2ccK326qiVkDQ9NfizlCm/E+j2Z
	 F4qe16cm8RlhvG4yt9ajkL8mhEvsIuWfCVoaQx5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 1381/1611] Input: ims-pcu - fix out-of-bounds read in ims_pcu_irq() debug logging
Date: Tue, 21 Jul 2026 17:24:57 +0200
Message-ID: <20260721152546.505644930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1559,7 +1559,7 @@ static void ims_pcu_irq(struct urb *urb)
 	}
 
 	dev_dbg(pcu->dev, "%s: received %d: %*ph\n", __func__,
-		urb->actual_length, urb->actual_length, pcu->urb_in_buf);
+		urb->actual_length, urb->actual_length, urb->transfer_buffer);
 
 	if (urb == pcu->urb_in)
 		ims_pcu_process_data(pcu, urb);


