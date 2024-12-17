Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7C11F75B5;
	Tue, 17 Dec 2024 17:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455578; cv=none; b=BS+YuVtBrLJIvMazdVvxNs0S4LxFoV3X3QwsASdSPgHEj9ENA0gJYLvgtucC4l+8S3COYKkpBy7r77+WcBXfsVSkwrI4VsopRgt7k55qHJTSqpBeM/o9klWGvKug1cS+9NfjSNxSPiqbKUVURbgS3QN/2sxnF6kZdlo/j3ELwDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455578; c=relaxed/simple;
	bh=R2GdWe1nnYYw10XjBxRy4QEln66khI6ueZXelvqZXWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKYYCfMgZZ9rVsK+5iN3DFCpf7LQKyErLQCVniKEtoZ0qPzkA4I9ybRXFYBN++BxJ56qx/KtN1h+q1YR3EtQQQ5tQOqwweBMwY2s/A1dPIFq1yzhnnj4VBXiG0REO/rjtYrjJlpC8dy4JW3TKdamVcVlb8sNYS8d83cxkYd+HB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sh+eeNek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sh+eeNek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B057C4CED3;
	Tue, 17 Dec 2024 17:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455578;
	bh=R2GdWe1nnYYw10XjBxRy4QEln66khI6ueZXelvqZXWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sh+eeNekSjsROnK5tNAdVHsAw+EI4Fcl9nm8y+GALcrq1y9A/xXl91Dovp7UE7Vxo
	 xPtLtectuQGpPwk2pyDQuV6w/zXVf4LPywv1YI4zCRB25Kw0akwgGf8GlrCz+vs62n
	 ejp8vuBhqFdbG4anHGnEyOZ3IA1PPMzBpAYsKXbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Subject: [PATCH 5.15 03/51] usb: host: max3421-hcd: Correctly abort a USB request.
Date: Tue, 17 Dec 2024 18:06:56 +0100
Message-ID: <20241217170520.448427686@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

commit 0d2ada05227881f3d0722ca2364e3f7a860a301f upstream.

If the current USB request was aborted, the spi thread would not respond
to any further requests. This is because the "curr_urb" pointer would
not become NULL, so no further requests would be taken off the queue.
The solution here is to set the "urb_done" flag, as this will cause the
correct handling of the URB. Also clear interrupts that should only be
expected if an URB is in progress.

Fixes: 2d53139f3162 ("Add support for using a MAX3421E chip as a host driver.")
Cc: stable <stable@kernel.org>
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20241124221430.1106080-1-mark.tomlinson@alliedtelesis.co.nz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/max3421-hcd.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -785,11 +785,17 @@ max3421_check_unlink(struct usb_hcd *hcd
 				retval = 1;
 				dev_dbg(&spi->dev, "%s: URB %p unlinked=%d",
 					__func__, urb, urb->unlinked);
-				usb_hcd_unlink_urb_from_ep(hcd, urb);
-				spin_unlock_irqrestore(&max3421_hcd->lock,
-						       flags);
-				usb_hcd_giveback_urb(hcd, urb, 0);
-				spin_lock_irqsave(&max3421_hcd->lock, flags);
+				if (urb == max3421_hcd->curr_urb) {
+					max3421_hcd->urb_done = 1;
+					max3421_hcd->hien &= ~(BIT(MAX3421_HI_HXFRDN_BIT) |
+							       BIT(MAX3421_HI_RCVDAV_BIT));
+				} else {
+					usb_hcd_unlink_urb_from_ep(hcd, urb);
+					spin_unlock_irqrestore(&max3421_hcd->lock,
+							       flags);
+					usb_hcd_giveback_urb(hcd, urb, 0);
+					spin_lock_irqsave(&max3421_hcd->lock, flags);
+				}
 			}
 		}
 	}


