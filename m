Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963423A3833;
	Wed, 20 May 2026 17:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297662; cv=none; b=Vs/z1D9Nn0k2mT8gO5pmwkeurTUojPOVI1+GU1hHw72BzcLzP3i6TqnVJJzAj//7tgJO8gqdY8pSSlmaZqUqQJFFJA+cAd+6D3KK72cTc/if3EhUNFlhWHdXDtLilQ0E1nHvh6hFimbJLz2lCo9ZGNf/PqVWwnYZ3jF+//6eawc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297662; c=relaxed/simple;
	bh=0cXroyIsqXPmrLAvMrjIg2Ng8cjW/P74j3jOhP8vTy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAeZSVszlG5F8WF1MKwMz9wJqN0Hzgxks8sDuJEyGqRjAJGeV+X3/8I3m1uMRjmA2/H1Yvklj/mE+nMjEB1iGg4WD2bKSY+N4hl9KnwtRwnB9BVG4afTKC+gAKsjCC55umiQ1nY2LNzHj3Jc1IzVXFN3/LJcPP5q/+9Qx5+nUnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAj7l3V4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAj7l3V4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047D21F00896;
	Wed, 20 May 2026 17:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297661;
	bh=M8ojpxKSqfcL5BpaA2lhjb1g5In+OtGUOIaozHEOPJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAj7l3V41A1ou4En5xWX6grHl27cZ2sYggeyTu01PjN3Tc6QIVcRrzZqqRXG9Ubt9
	 AI7rOKtymkMcsr7r5AuF/2hS7g5xbjvS8U3tFxNKDv6SeTNrL0mRWmM4mBjwKFtoH+
	 ZWrbmdEV6mR8czSlKTT3e0RgfMNc/CcPRVIA7b5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih Kai Hsu <hsu.chih.kai@realtek.com>,
	Hayes Wang <hayeswang@realtek.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 115/957] r8152: fix incorrect register write to USB_UPHY_XTAL
Date: Wed, 20 May 2026 18:09:58 +0200
Message-ID: <20260520162137.052855004@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 357f5c733d0b5..d610741782794 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3896,7 +3896,7 @@ static void r8156_ups_en(struct r8152 *tp, bool enable)
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



