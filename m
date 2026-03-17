Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F40228B7DB;
	Tue, 17 Mar 2026 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767867; cv=none; b=Xi/lsc2wXCZsb6hIBvAQE8d1zDZS0+OXcJIt85scgYP6KN12PdbTV+XzXRhwmugXsRlXn8IE7Ca6KCPaw+oDRFC22aedNtRDJdJL9G2t6DPuXJE3LaaRVcahUdXWS0bXYWq9t0q5Oozw0AiAJ8dBfr88h/D1lAFmLR2zlw80Sfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767867; c=relaxed/simple;
	bh=QJDIQRk0axnreDgPKZDc4O99XPPOf6qPjzB9OE7LF0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c802v0v2OQntQyHR3lnq/dkyQO5+bLJOvm6z7TcakCj1MHYDX29Tu/DDPmChHHC8sFhweQwOiCKnsh76pbjk+tHe4bbEziNo3wcVLT4GCmhj5wK6EU7buK/NOo+LFZMVX3Gr0zIegpmbSdWiVRD5rsWPBnDSM32BeB7b5WkdqD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hO7M14bC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hO7M14bC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86BCC4CEF7;
	Tue, 17 Mar 2026 17:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767867;
	bh=QJDIQRk0axnreDgPKZDc4O99XPPOf6qPjzB9OE7LF0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hO7M14bC+QjflrqT1aA3AZt17rn3gi71X20RuG8NLwhd6CH35Ft9hhRS8gNJ4cUNk
	 1hOs9SRijorPCTYEfrJuw0trt6MeKijdedDYbXWqp77Oyxud/XKYUI19rMgtQvCqO8
	 HtMUDlzuPoz1iYjcnAvVolTVo4IL4pNrvnZVT+D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	John Keeping <jkeeping@inmusicbrands.com>,
	Peter Korsgaard <peter@korsgaard.com>
Subject: [PATCH 6.18 143/333] usb: gadget: f_hid: fix SuperSpeed descriptors
Date: Tue, 17 Mar 2026 17:32:52 +0100
Message-ID: <20260317163004.663566937@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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


