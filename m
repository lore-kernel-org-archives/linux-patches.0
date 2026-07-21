Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382CC39BFFE;
	Tue, 21 Jul 2026 18:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660204; cv=none; b=pCUYoua2lD77MLigfgh9Aca9qty5ucTPBKagVCzsizE49jMT7ECF3W+UcZ8xZDzHLpzxl3O6R/3g8tAYodtDCMT7ruW4WKvDGjEdZx5MMSW36ZZ6vVUr8oN4uyaTneWcHzjWedaBiGdBO7z2vWjZxmdZ/dGPOgyJ6BOOfjq0IJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660204; c=relaxed/simple;
	bh=K44NqLgoAZShHJcPD3y7nCO6oDHoeOsdSVCDpRQwbvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mf5gjzCS96J+eiVE7npj7bUPKFPGWJaqSS4Wj4MgrVE3HRHlq3ByO+dmnxEKnn1nMe+89XKLcdSOo0rsk2S+nIQemJ+cqUbYSsSkkK3VjqYDA4VETieKKtoRib3bVyG2cnj3O32Rv8F+LEbLwQo7J8TEAk5wFBaoYgRVWPO6baw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaQUS11M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaQUS11M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945951F000E9;
	Tue, 21 Jul 2026 18:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660203;
	bh=UREgphIFvzD0E8U3K9njtli+79/a8eh/nXrU7jwsxlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UaQUS11MkHtm1bjgxBBmH+kOBr/tN1sjfcGlJ3TSdjdkjn6Y9qwybTDuSM/8HIaNZ
	 mNW4jpVJHVjPGKI5H4NYXNiMOX9jhK422H5e+wE+SZGBJizSal9vl1TSz3bULpQJvW
	 OBcdk4uNhbPKCf3necUKQw7env6K+S2GiazydyBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0891/2077] usb: host: max3421: Reject hub port requests for non-existent ports
Date: Tue, 21 Jul 2026 17:09:24 +0200
Message-ID: <20260721152613.832555278@linuxfoundation.org>
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

From: Seungjin Bae <eeodqql09@gmail.com>

[ Upstream commit 11b5c101e2fd206104b05bc92554d356989423a8 ]

The `max3421_hub_control()` function handles USB hub class requests
to the virtual root hub. The `GetPortStatus` case correctly rejects
requests with `index != 1`, since the virtual root hub has only a
single port. However, the `ClearPortFeature` and `SetPortFeature`
cases lack the same check.

Fix this by extending the `index != 1` rejection to both cases,
matching the existing behavior of `GetPortStatus`.

Fixes: 2d53139f3162 ("Add support for using a MAX3421E chip as a host driver.")
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
Link: https://patch.msgid.link/20260518224901.1887013-3-eeodqql09@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/max3421-hcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 3d6b351dcb1a28..73e76d0e697385 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1685,6 +1685,8 @@ max3421_hub_control(struct usb_hcd *hcd, u16 type_req, u16 value, u16 index,
 	case ClearHubFeature:
 		break;
 	case ClearPortFeature:
+		if (index != 1)
+			goto error;
 		switch (value) {
 		case USB_PORT_FEAT_SUSPEND:
 			break;
@@ -1728,6 +1730,8 @@ max3421_hub_control(struct usb_hcd *hcd, u16 type_req, u16 value, u16 index,
 		break;
 
 	case SetPortFeature:
+		if (index != 1)
+			goto error;
 		switch (value) {
 		case USB_PORT_FEAT_LINK_STATE:
 		case USB_PORT_FEAT_U1_TIMEOUT:
-- 
2.53.0



