Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFCD2E62B7;
	Tue, 17 Mar 2026 16:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766257; cv=none; b=aGe47HF6HuDrg/OTFloz9pr9SS66iIRv8qwv+lX0Kkb2UbktZ6z5HB8xQ2+QAqLr2xC2LpUXbeBWUe7bIFaDrmFDzVqZBy7jy7Gxt2DsylSOpQiks9eXVf3ebj6JkRXrLUKFPK6N2tY2At76tLcvBUs2EdYv5q37rB/xCX5Clco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766257; c=relaxed/simple;
	bh=WrRG++S6pZBImlQ6p1gmqlusHvf4YMWAKgaRfFC6qHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxuwPYTxRht/f/rCsdKZ4DNwZ8Np7gSquHq7t3IrGpO1zdf/pJeiQpI5huMcsW421dOuKMWBF+exVbXWnycQrCKeC8Npt7xgDhluRvvUbJb9cfa58+3CaUf3vKWkgRKlDTnCaYPviHonUV8esGQJqmPkpN4X+79kd/oYt9Y7ygk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUcp8k8L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUcp8k8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C724C4CEF7;
	Tue, 17 Mar 2026 16:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766257;
	bh=WrRG++S6pZBImlQ6p1gmqlusHvf4YMWAKgaRfFC6qHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUcp8k8LGcm6bmTNYcHpeNFhQZiv9IFvWanWfEUi1pxc5T9k4cZeZvbykTdil+QcV
	 NRJ5xi36u/tPPo5pMALatrBsnZYlR9gnO1sLaJgxvtCqoFPyipvj2oZb82Z8xxk2hk
	 Qlafe/DfzBB3hVNBSjeMDJUH9SR/Z0JXdvQk/FZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Junzhong Pan <panjunzhong@linux.spacemit.com>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.19 162/378] usb: gadget: uvc: fix interval_duration calculation
Date: Tue, 17 Mar 2026 17:31:59 +0100
Message-ID: <20260317163012.971848780@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junzhong Pan <panjunzhong@linux.spacemit.com>

commit 56135c0c60b07729401af9d329fa9c0eded845a6 upstream.

To correctly convert bInterval as interval_duration:
  interval_duration = 2^(bInterval-1) * frame_interval

Current code uses a wrong left shift operand, computing 2^bInterval
instead of 2^(bInterval-1).

Fixes: 010dc57cb516 ("usb: gadget: uvc: fix interval_duration calculation")
Cc: stable <stable@kernel.org>
Signed-off-by: Junzhong Pan <panjunzhong@linux.spacemit.com>
Reviewed-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20260306-fix-uvc-interval-v1-1-9a2df6859859@linux.spacemit.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -513,7 +513,7 @@ uvc_video_prep_requests(struct uvc_video
 		return;
 	}
 
-	interval_duration = 2 << (video->ep->desc->bInterval - 1);
+	interval_duration = 1 << (video->ep->desc->bInterval - 1);
 	if (cdev->gadget->speed < USB_SPEED_HIGH)
 		interval_duration *= 10000;
 	else


