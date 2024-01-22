Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D26954BD2;
	Tue, 23 Jan 2024 00:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970614; cv=none; b=iRSnwfoFPOD8t7sy/WF2FLzLMyem05iF6ePZKDWwDYGquJrWW4FCTzkPRtcK++vQdcdwWb2XRHy+Xqr54C0xUuNsMa7JAtGMJobliVP2JqTyZC9mwZwYtAqlOS0WldMnrKqij+ZDrujLtKVCJCrwt/6qU6QsJSfR4ETe9660FqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970614; c=relaxed/simple;
	bh=qU4R3fnziwOtK6ccxH8nsBLJyK00c6IW+wFXDc3+tp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+00DMsbqxRhwLZ2MKLK5ErswbQcBOwEF6rRvIwW6u2L8Hi+yIJWHRcGTc9F/d3aizLJNqjuowT5ULTTSklPkdNmiIEgo7jl0NEkL1etsAJndaB45cMIf6vIRgTP0P+tpCb4zP6+4eC5AA3Fyoyr5bbachh4Y+uvac4+v6vAK54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNlGgSoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNlGgSoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908CDC43390;
	Tue, 23 Jan 2024 00:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970614;
	bh=qU4R3fnziwOtK6ccxH8nsBLJyK00c6IW+wFXDc3+tp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNlGgSoP3WZtWBCNgdI1FZEaTNpDJS4i8Ym1uDer9lkY1RlTupALJuwsF36uPF9dJ
	 x3toJr6w7Nl4qAhERq4FVvmtAESG4rhHmtJb8qWYOJ2CVppc5XsuhENVSDdTVkiUaQ
	 QvvgymE+TPTVpI19vfPAOOaNq91179Rg0dNYaw7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/417] wifi: plfxlc: check for allocation failure in plfxlc_usb_wreq_async()
Date: Mon, 22 Jan 2024 15:53:56 -0800
Message-ID: <20240122235754.060905860@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 40018a8fa9aa63ca5b26e803502138158fb0ff96 ]

Check for if the usb_alloc_urb() failed.

Fixes: 68d57a07bfe5 ("wireless: add plfxlc driver for pureLiFi X, XL, XC devices")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/e8d4a19a-f251-4101-a89b-607345e938cb@moroto.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/purelifi/plfxlc/usb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
index 76d0a778636a..311676c1ece0 100644
--- a/drivers/net/wireless/purelifi/plfxlc/usb.c
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -493,9 +493,12 @@ int plfxlc_usb_wreq_async(struct plfxlc_usb *usb, const u8 *buffer,
 			  void *context)
 {
 	struct usb_device *udev = interface_to_usbdev(usb->ez_usb);
-	struct urb *urb = usb_alloc_urb(0, GFP_ATOMIC);
+	struct urb *urb;
 	int r;
 
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!urb)
+		return -ENOMEM;
 	usb_fill_bulk_urb(urb, udev, usb_sndbulkpipe(udev, EP_DATA_OUT),
 			  (void *)buffer, buffer_len, complete_fn, context);
 
-- 
2.43.0



