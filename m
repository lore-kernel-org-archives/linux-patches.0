Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705677;
	b=Sb5C4TP+4DBOwUOa2gesRajgFNZ3BC3iiOucKFxtBw4kCKLRw28gcCQep4uRxmkqiubU
	 gqvZl1IG8HaxF/jRdkkiqeW5H8e71V2WsDwFV/NAjTV/kXx28amZ/j71j5IrYyn84yoZp
	 IDHsaZweOj42josmdZiqMOcYsp8LozxKstvYPxr/CDSmIpEi28gSOFj7eYnBhl+pWsp/O
	 SIU2/898rJCtXykjyBlUfsSsOcl3hj0R3jKw/+Sdl8JXOOyIN/Gd9qz7nL8ZYLKRdC8a2
	 PIdnA8wurhKlCHKJT2cYGSgu8Onft7VQhPEPR+xlVqTWA+IbVL3FZmpj2tSJaBiw0sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xCNfmS7YHJVXAkKjbtXC8eajYsMF960vrR7YzTVK/5M=;
	b=aD2J8rEu8PRaoS5r2R9pI0dtBZcY6m8dK7pV3vaHZs6LItsO1H0537mAyHxpfvhnYhAq
	 fO1HwX3J29CqwdU2U/cNS+pSHGMQiYWwCDJHJGOYgBSFIbXivJJgQXsSp3vDjTlXrBENk
	 c7SK8zTNAsKALkEmFC1Mw96Qyo/M6821yjr3uaIO2ZOTvl4cwOdotOoKw9jkZbqsPBrvp
	 wgn8vuHK3CxlJqfxT4ElX+wALV5lFfvF9DRRSTqfFBCZXgk19t1qZ8DACLzoP2dgc8TLr
	 ZMLvKidZlgK6W0X4yWFR/N1RqRP1ganBHxQZyqbd28mlcLfFRhhT10IapWsSpdtw8CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmaKgH+w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B79F606A321;
	Thu, 26 Nov 2026 15:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmaKgH+w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BEC1F000C0;
	Thu, 26 Nov 2026 15:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705676;
	bh=xCNfmS7YHJVXAkKjbtXC8eajYsMF960vrR7YzTVK/5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmaKgH+wVtSafP9mmPplzQlxDIWr/7y776LIisSxRzoJf+zMkDQz7EFi+DK74xSCB
	 N6BKCl/wXJ6/XRXpA7uvZsTr7ywRRMSyAyKCGiJBdSMvX8A2CqFka4LRdtqeTeUArA
	 5g+6qZ5+TqY9GA2oJMRHCDoxlatHkeimmo6rIu/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 279/319] usb: dwc3: gadget: Recover from End Transfer timeout
Date: Thu, 26 Nov 2026 15:40:47 +0100
Message-ID: <20261126144013.050584373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 61575534fb05d52d36979f38976ece74649f091a upstream.

If the End Transfer command times out, the endpoint resource is never
released and every subsequent Start Transfer to the endpoint fails with
"No Resource". Schedule an error recovery to reset the controller.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/7523e9a11303a33acd0b92a092fb0e8218d509d2.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1670,6 +1670,8 @@ static int __dwc3_gadget_get_frame(struc
 	return DWC3_DSTS_SOFFN(reg);
 }
 
+static void dwc3_schedule_err_recovery(struct dwc3 *dwc);
+
 /**
  * __dwc3_stop_active_transfer - stop the current active transfer
  * @dep: isoc endpoint
@@ -1709,6 +1711,9 @@ static int __dwc3_stop_active_transfer(s
 		dev_err_ratelimited(dep->dwc->dev,
 				"end transfer failed: %d\n", ret);
 
+	if (ret == -ETIMEDOUT && dep->dwc->err_state == DWC3_ERR_NONE)
+		dwc3_schedule_err_recovery(dep->dwc);
+
 	dep->resource_index = 0;
 
 	if (!interrupt) {


