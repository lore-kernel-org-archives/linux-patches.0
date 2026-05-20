Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E1E3F789B;
	Wed, 20 May 2026 18:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300136; cv=none; b=oVnvZJaWzQLvvlYpN6dHdSY0+g5rxR5vI/mDy/KyUdtVUX55deyMF4wIWORvut9rhqJt8eV/KraMwCweRaQ51SxqDPsdYer78wKyao5B6jiETLNIpXQ1Jkl3j8S/rGCnrtA1sZbC49apKETh2fsvyRo+VARNnAWc/RGgoVwZWro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300136; c=relaxed/simple;
	bh=LhesVR2EKtNly4oFEEZNNi9GANZDMUCTABdMx+HYcrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b43WpjD6XIrH9WWcG8E3uPq8GX+PBp4Jum8HBwnKQQ1lK3H+KnJkvxDdj5qDo2bsgdB5t8QBGAZauQgywCTkNkBYxSUMxcBJ4qr/8iTWFzYq5D6KxT3bV2ht9ZWBzIaHB6x9RfC20BwTLbgb5feA8u1cVMwHHRP/llT43BDKwV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLt+ep/m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLt+ep/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AA21F000E9;
	Wed, 20 May 2026 18:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300134;
	bh=BvUgZkG6TwCYQ97n+mWTHkuqUtAjAreJzeTuHwjoAyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLt+ep/m4d9X1NC9Nd7F9q2fF+F52yfcOkz3ROZluWRuw4lbhNNKntlQqph5mNhlv
	 TPa+m3c3jjiGsj0nrwpe9Go6xTFh86N9xWO81yp/Vwef2E+Zu6rIke4vyGIrjsb70K
	 hearSKDVY3yBbAptRAv5RaThC9H9I9p6b2jmWAv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih Kai Hsu <hsu.chih.kai@realtek.com>,
	Hayes Wang <hayeswang@realtek.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/666] r8152: fix incorrect register write to USB_UPHY_XTAL
Date: Wed, 20 May 2026 18:14:30 +0200
Message-ID: <20260520162112.514178391@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chih Kai Hsu <hsu.chih.kai@realtek.com>

[ Upstream commit 48afd5124fd6129c46fd12cb06155384b1c4a0c4 ]

The old code used ocp_write_byte() to clear the OOBS_POLLING bit
(BIT(8)) in the USB_UPHY_XTAL register, but this doesn't correctly
clear a bit in the upper byte of the 16-bit register.

Fix this by using ocp_write_word() instead.

Fixes: 195aae321c82 ("r8152: support new chips")
Signed-off-by: Chih Kai Hsu <hsu.chih.kai@realtek.com>
Reviewed-by: Hayes Wang <hayeswang@realtek.com>
Link: https://patch.msgid.link/20260326073925.32976-454-nic_swsd@realtek.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 6ce25673e4cc8..1c36816405f13 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3894,7 +3894,7 @@ static void r8156_ups_en(struct r8152 *tp, bool enable)
 		case RTL_VER_15:
 			ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_UPHY_XTAL);
 			ocp_data &= ~OOBS_POLLING;
-			ocp_write_byte(tp, MCU_TYPE_USB, USB_UPHY_XTAL, ocp_data);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_UPHY_XTAL, ocp_data);
 			break;
 		default:
 			break;
-- 
2.53.0



