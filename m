Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8D6320CAD;
	Sat, 30 May 2026 17:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163930; cv=none; b=WMiX+Uu3A/Uhoke36rWfesUAkn8zUfaJGxJp28S+8pwJa04h1o9bM3ptt7/UYMZnnl1mLo0ypbPpOWCk3sF4fxNko7MS0Bo5rmEnXPUIsiNs85dv9XlWehM6jTfwJli0NCTt6w+jhsxF9lTaAcFY5aJ5nBL9HJdO4O3lCfB//aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163930; c=relaxed/simple;
	bh=mRt7a+paphobVn1FH3wcC+HY9wFTWxf06f9Aq/vYA7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMYKSFi/aPOUTa0X5vCVqFJOcfEFk2zXuSAwDDaPJDeENTSQX96zMxJdFqz/CubOy9UAnjw4NXttlNdxm4CdZz+MuxFOpYa9OxTr37wf2yU4F7Rm5F76au+dpKQwUfGXl/SzSgwyKqFrVpizzM4MG8eUge7VJoxnp+SG4lM8SfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9/4LxyE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9/4LxyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D98A1F00893;
	Sat, 30 May 2026 17:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163929;
	bh=2Mz0jSvwAsRpfyN9g5xc4Viyks606fL/3gTPo/wAD20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T9/4LxyEb0HKYzhmYc12gTy8PDa0MjvuegCf8YbFEkv4byzV83iLElq61KweSZaM2
	 xydAkBkyrXPn7aOEPXQjyg8UfX5JBo/1awnjeOo8ByI9gmN8re14lannPa7GYYEEDr
	 +ZxU/bzjPOIEDyeLNx8pw2V0DHALYygX/U/NCCEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih Kai Hsu <hsu.chih.kai@realtek.com>,
	Hayes Wang <hayeswang@realtek.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 405/776] r8152: fix incorrect register write to USB_UPHY_XTAL
Date: Sat, 30 May 2026 18:01:59 +0200
Message-ID: <20260530160250.966972895@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
index 59baa673738b6..2837688535268 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3741,7 +3741,7 @@ static void r8156_ups_en(struct r8152 *tp, bool enable)
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



