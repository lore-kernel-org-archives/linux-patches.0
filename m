Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBE236A352;
	Wed, 20 May 2026 16:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294705; cv=none; b=NXVT9kc3xsMc/gs8rxmD5yEiuECMyny9jXmUgdSHLYAZTPWEwAY8h6xBIUl87NNoxvjKCbZ1sQCxWI/yUbHqMGK0Qo5qKpI+PstmT6D7GXn+FVRibUr6HekpWajLH0STkVUKi+r8hRNfrcTtaBIzVWsCWAC+Ojxh59vabQaONOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294705; c=relaxed/simple;
	bh=+PyMmiUs8W/w4iDud4bsZyQTcMOmE2E3m73GmLFmoKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnyLwwHQfQ8rb54xMzJA1VDDot+4ZPtvYaUsyCQf5F0a/Gb1W2ajzoEravH+ldgyfzQe3zAWfMGp5r2aFAOOpAGvFO1hdr+KOw7ToRpPVRhJQKj+2ImGn3qZTbkuQieD1Gje7CFb8yxeyft/9xG1F8jvsiXc6e/Ji+EW+G2qd9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUnzZVNH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUnzZVNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2A41F000E9;
	Wed, 20 May 2026 16:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294700;
	bh=sEY758YV2dLHGoRlz0BDJncxH0ooefaupnyq22G5/As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RUnzZVNHeK2AZsgC/Oaj31V4pTHOF9sOCBzrguK9BSmQKRCk1q3h7zSpm7V30jGUJ
	 Z13ov0mVfcdjIDY2uVdAuloNN74g3uUGYi5XUd8ds7bbnVJ90+f5CaCoHCnS5HSrMk
	 qsprV7Krq3H9tuapT7lt1i6RoWB/Wb6j0dd5EExo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih Kai Hsu <hsu.chih.kai@realtek.com>,
	Hayes Wang <hayeswang@realtek.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0140/1146] r8152: fix incorrect register write to USB_UPHY_XTAL
Date: Wed, 20 May 2026 18:06:30 +0200
Message-ID: <20260520162151.482511830@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 0c83bbbea2e7c..f69e7e1ab7788 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3890,7 +3890,7 @@ static void r8156_ups_en(struct r8152 *tp, bool enable)
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



