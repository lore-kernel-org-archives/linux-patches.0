Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E522D5A19;
	Mon, 13 Apr 2026 16:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098354; cv=none; b=HK5cdE7qurqUhid3QVDsW8ye2/DnOPsizWbTSopc8j3amhQI56ADw4wuKs7HzjsTcfFPUp6IqU18Dp8FPJr15B2OMJrzhhBygOQq453DczquaqzV3AYUieRzBjMPZ3j/6g7i8wSSMSyUjOp4+Yf6JEcx8gYBxMyW60Vg9afbxmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098354; c=relaxed/simple;
	bh=jd5WFXs1ISXMDiDGZ/wVX5Fd4BzvM7qArDYtsPLA/8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsVT2gJjE/os/XDhVs4IzmcY5QUATQ1X6fiPqC4WN2l/GmQvrxpTHRfei4CGO6SdzDgBOXQISpqQJmqSgVGedZaUVfgXV77YRDT7kji0EIX8fRXSdhpSY6TQEYyuFWZFuUshihx9ODCamDk7CRNzTxGNtwZDnnvVUYtQ56hrhoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHmDJJvj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHmDJJvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9EDC2BCAF;
	Mon, 13 Apr 2026 16:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098354;
	bh=jd5WFXs1ISXMDiDGZ/wVX5Fd4BzvM7qArDYtsPLA/8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHmDJJvjNPoxGUQ+5ZrEA0RGdAhGSsrpNJRZV7hxlIV0Xy/ZAJp6vsvIYHL9ZHfOB
	 NvyKpuA05W0+I7UkCbXiOsKUg4/0+FE9loavkiMZTJ0mnPIbVWjd9MRVx3fGtOua8J
	 fZFTjiWkvzl9iO98xFoMDBaqGEUfOGOZfF+VyTHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Ruohan Lan <ruohanlan@aliyun.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 492/570] can: gs_usb: gs_usb_receive_bulk_callback(): fix URB memory leak
Date: Mon, 13 Apr 2026 18:00:23 +0200
Message-ID: <20260413155848.889606614@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 7352e1d5932a0e777e39fa4b619801191f57e603 ]

In gs_can_open(), the URBs for USB-in transfers are allocated, added to the
parent->rx_submitted anchor and submitted. In the complete callback
gs_usb_receive_bulk_callback(), the URB is processed and resubmitted. In
gs_can_close() the URBs are freed by calling
usb_kill_anchored_urbs(parent->rx_submitted).

However, this does not take into account that the USB framework unanchors
the URB before the complete function is called. This means that once an
in-URB has been completed, it is no longer anchored and is ultimately not
released in gs_can_close().

Fix the memory leak by anchoring the URB in the
gs_usb_receive_bulk_callback() to the parent->rx_submitted anchor.

[ The variable usbcan was renamed to parent in
commit b6980ad3a90c ("can: gs_usb: uniformly use "parent" as variable name for struct gs_usb")
introduced in v6.6. To backport to v5.15, replace parent with usbcan. ]

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260105-gs_usb-fix-memory-leak-v2-1-cc6ed6438034@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ruohan Lan <ruohanlan@aliyun.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index ffa2a4d92d010..acffe11a0ae13 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -402,6 +402,8 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 			  usbcan
 			  );
 
+	usb_anchor_urb(urb, &usbcan->rx_submitted);
+
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
 
 	/* USB failure take down all interfaces */
-- 
2.53.0



