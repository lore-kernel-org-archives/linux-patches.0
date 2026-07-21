Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EE644AB73;
	Tue, 21 Jul 2026 22:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671797; cv=none; b=H4qXioY29Bcp1/FxfimiMbi2d0ntVXEQZyaH/E+iymVu/V3RhtCd8KLwY4Tixo+/vKeCY3VjRNj+Dv7iUktmSFmQUJBPPRZnGOeWqhfcsrj7U+9E8iDQqTrk94jrdgrfh/lHogmNVCdkt6krSeO1+RqdDEcPLP7v3QWi8Wbx6wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671797; c=relaxed/simple;
	bh=I7GYU6Zht0VAaga4LQ1tFP9S6vTedcPLStk0PMckKiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2lAkf05FaVB/+umGuzpKMHgn1iqFzO/Wr30dTJe+i296q93HpALKSXCq63nSS2FliXIhLBNT4EzuMiyl18+mp1KA9fiznrhni/j60dSbk5bMHa5jgFjt1s/RXB6LpyYVEA6PqCStcFErWppGsCY3D7NP1pa+ftX1MFUMg9r/ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AyJdaiy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AyJdaiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C407C1F000E9;
	Tue, 21 Jul 2026 22:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671796;
	bh=XiupUL3aFIlcy9yTKU1oxFX57aVREZPvbsff/HEGv8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0AyJdaiyP1qnIjREGC+CjMOTGOrarsT6bUZ59u/NiKqDznCkcbmFDWIh4JBLwEtyl
	 ecDRlMlPty7+h1eSo1Bfi3zRp15lsYOEAY83pDjUE/pYhL6LQA3kYaAC8nX410nt1+
	 jiEEDN9bBRuJQmEc3YHRwl3EtukdBjDZzLyZuefU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 382/843] usb: host: max3421: Reject hub port requests for non-existent ports
Date: Tue, 21 Jul 2026 17:20:17 +0200
Message-ID: <20260721152414.630523873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index 5bdd95e5e1eb44..4e80e8be6f56af 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1694,6 +1694,8 @@ max3421_hub_control(struct usb_hcd *hcd, u16 type_req, u16 value, u16 index,
 	case ClearHubFeature:
 		break;
 	case ClearPortFeature:
+		if (index != 1)
+			goto error;
 		switch (value) {
 		case USB_PORT_FEAT_SUSPEND:
 			break;
@@ -1737,6 +1739,8 @@ max3421_hub_control(struct usb_hcd *hcd, u16 type_req, u16 value, u16 index,
 		break;
 
 	case SetPortFeature:
+		if (index != 1)
+			goto error;
 		switch (value) {
 		case USB_PORT_FEAT_LINK_STATE:
 		case USB_PORT_FEAT_U1_TIMEOUT:
-- 
2.53.0



