Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD22B3F23CC;
	Tue, 17 Mar 2026 16:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766059; cv=none; b=DweUJY4Mn/E61nLgZpEjfrGN/n7TabnEGwPbWqX1E8jimHpeUoJStD3rxDkzo+2CDVpyzN/tRJbIR2JoZjd2dfZEogzoetFWZcC9/ZNKOOiL3ln1EKMZHuhHlsACm0FeGrWPMBEV5s3x1ZR5IEL+M3nxm6Nnuej/SNciupyoN7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766059; c=relaxed/simple;
	bh=U90FjWCZBfaLmgBmdPjSRKA33gkTL30vjCIoy9IEj/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQlEme5p5y3dPY3d2DuFvYnC6vXdfeSkX1Ny512//KGsM1tr6vPMKlbWGZt/CTGmk8eQgHlKZRK1baOAfSSlspdyMmt6GNll0j90e/YH4ljUDrCbC6sa16Od1o45age9YKcTVusvzZ7LzVqO/1kIu+pwkV1T7BIgFFdkLJDp6YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTk3ZIfx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTk3ZIfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536F1C19424;
	Tue, 17 Mar 2026 16:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766059;
	bh=U90FjWCZBfaLmgBmdPjSRKA33gkTL30vjCIoy9IEj/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTk3ZIfxxhPFEraMgdIZzBctfhrnFMdzXWxEi5bmeiiYHJtRd6bKXGpGW6dLcSfYm
	 dKQzK381f4iFv+gA3lG/HhxssCBYTwkJmypxWGoYcnynN3XZVmDF1NSNKfjwxRVq/r
	 NZEDonSxf6SU6zCueCHLaA+Yejx8CJYoRTcO4J4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	John Keeping <jkeeping@inmusicbrands.com>,
	Peter Korsgaard <peter@korsgaard.com>
Subject: [PATCH 6.19 160/378] usb: gadget: f_hid: fix SuperSpeed descriptors
Date: Tue, 17 Mar 2026 17:31:57 +0100
Message-ID: <20260317163012.898956537@linuxfoundation.org>
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

From: John Keeping <jkeeping@inmusicbrands.com>

commit 7f58b4148ef5d8ee0fb7d8113dcc38ff5374babc upstream.

When adding dynamic configuration for bInterval, the value was removed
from the static SuperSpeed endpoint descriptors but was not set from the
configured value in hidg_bind().  Thus at SuperSpeed the interrupt
endpoints have bInterval as zero which is not valid per the USB
specification.

Add the missing setting for SuperSpeed endpoints.

Fixes: ea34925f5b2ee ("usb: gadget: hid: allow dynamic interval configuration via configfs")
Cc: stable <stable@kernel.org>
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Link: https://patch.msgid.link/20260227111540.431521-1-jkeeping@inmusicbrands.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_hid.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -1207,9 +1207,11 @@ static int hidg_bind(struct usb_configur
 	if (!hidg->interval_user_set) {
 		hidg_fs_in_ep_desc.bInterval = 10;
 		hidg_hs_in_ep_desc.bInterval = 4;
+		hidg_ss_in_ep_desc.bInterval = 4;
 	} else {
 		hidg_fs_in_ep_desc.bInterval = hidg->interval;
 		hidg_hs_in_ep_desc.bInterval = hidg->interval;
+		hidg_ss_in_ep_desc.bInterval = hidg->interval;
 	}
 
 	hidg_ss_out_comp_desc.wBytesPerInterval =
@@ -1239,9 +1241,11 @@ static int hidg_bind(struct usb_configur
 		if (!hidg->interval_user_set) {
 			hidg_fs_out_ep_desc.bInterval = 10;
 			hidg_hs_out_ep_desc.bInterval = 4;
+			hidg_ss_out_ep_desc.bInterval = 4;
 		} else {
 			hidg_fs_out_ep_desc.bInterval = hidg->interval;
 			hidg_hs_out_ep_desc.bInterval = hidg->interval;
+			hidg_ss_out_ep_desc.bInterval = hidg->interval;
 		}
 		status = usb_assign_descriptors(f,
 			    hidg_fs_descriptors_intout,


