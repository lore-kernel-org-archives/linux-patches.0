Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B02433E63;
	Thu, 30 Jul 2026 15:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423834; cv=none; b=nQtasYL3z0lvNf2NTF7xr5xvC/4385xuYCoBi/IQDzwmdcjJanP21XoUgoEac2BP5SmNWQDf/Ne5vzAGFp37EW9XLAI1vZq0TVshCjDctMXA/Uw9wk5I88Z5zqfE66Wtmx6wbcmjBXQGmZWcTW4ziUC5N8RxywQKnkX4WU2zM08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423834; c=relaxed/simple;
	bh=lGBIlg9rzG9G9YjL/1IUD396S6u3LfCnMOwyMRnGtsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aw0NQogqe4g11WwyG69VXxVwq/H/3dB2L3DhdmarBonWGJg6l3Mx+dCKM0arXonMvkjI7LEBgOgDKr0VdEk/vPNffA2/bErH76Tw6OJFnizLJFJEX1WKzsiwgjwU06ID7uf5z24oZvg60suPMYVCwGWMIM6/ET2T/4U7Yz1LZgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZr3OJwo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZr3OJwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9902B1F000E9;
	Thu, 30 Jul 2026 15:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423833;
	bh=TNY4lRmvP7ZfN6kQ8fxtnNyUC3QohZwlWxcVNc5E6Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZr3OJwo2+NYWnJk5rjyFbeWtHBqYhZC46/iJUs8Kb9Hfl1rQa4+Q40RwN7uPdMY+
	 umGfTg/E0lx0RMIqW0C1vy8QB+s9GL8hnHkIIy1TLgnMUIfqfCLR6zCHopSxjDIXV/
	 2I9IR5+zCbOafm72dCnv3LIKPr0grR3uvtnIKvY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 183/675] wifi: carl9170: fix buffer overflow in rx_stream failover path
Date: Thu, 30 Jul 2026 16:08:33 +0200
Message-ID: <20260730141449.031253518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit a1a21995c2e1cc2ca6b2226cfe4f5f018370182a ]

The failover continuation in carl9170_rx_stream() copies the full tlen
from the second USB transfer instead of capping at rx_failover_missing
bytes. When both transfers are near maximum size, the total exceeds the
65535-byte failover SKB, triggering skb_over_panic.

Limit the copy size to the missing byte count.

Fixes: a84fab3cbfdc ("carl9170: 802.11 rx/tx processing and usb backend")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=5c1ca6ccaa1215781cac
Link: https://patch.msgid.link/20260421134929.325662-4-tristmd@gmail.com
[Fix checkpatch CHECK:PARENTHESIS_ALIGNMENT]
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/carl9170/rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index f6855efc05c0f1..0383d5c9698bfa 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -918,7 +918,9 @@ static void carl9170_rx_stream(struct ar9170 *ar, void *buf, unsigned int len)
 				}
 			}
 
-			skb_put_data(ar->rx_failover, tbuf, tlen);
+			skb_put_data(ar->rx_failover, tbuf,
+				     min_t(unsigned int, tlen,
+					   ar->rx_failover_missing));
 			ar->rx_failover_missing -= tlen;
 
 			if (ar->rx_failover_missing <= 0) {
-- 
2.53.0



