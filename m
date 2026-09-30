Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7871B4CC63A;
	Wed, 30 Sep 2026 18:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793142; cv=none; b=Iy5/+CrtuF65yq2oKY1rFtRiCSzUDNtpfN3JfZu5jdV1R5ryssSKyWETWU+CSrRPbq2P2cnlJDwNlF3j1LvFjG2xCKOtyWcTEXCgfSNKsP4Ft+8PMvSOQHB1kvrs22HUziUfKU/4Yj9qGC0H9HBtVrYN2P/148GYwdRtpBQGytg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793142; c=relaxed/simple;
	bh=524i3T5kdvze0w1Qo7bV9ZQpkBwsPAoNw8xX6qBR/A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYRUH+1hGsQ19uTbK3I52rjP7ED7HvHBKyctEsEDx+/RATMTsYnCbouAT0kUlcaaa4y9EZt/M9y64RpjQPsinKZaNRkUq/ZTqEYPeWSiCwRQ5a5+F3/+stRgMsPYnnuBEZx3Zqqntrp4EUdakbnOFzloYZldpu1U0a+nQg7HNjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IheWkINQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IheWkINQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FD01F000FF;
	Wed, 30 Sep 2026 18:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793141;
	bh=YLazN16i19pZI2bQvtaFGJFc/VB3R0oglac3dIKsQiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IheWkINQkcgk96ArROsjlLIXf0UYpFa74nuPMIDWfncBbn2yWMyVTBtwhSGGFcay7
	 Y5K91xHQO234AMFGB8S/mcPzAn+Or0c+PCAijhhIlt9knlKRlkr9HKx/ygvQARLz5D
	 J7juehihzTKHIokr3++C7ycERY9wqFlUDRkQUZaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 150/395] nfc: st21nfca: validate ISO15693 inventory length
Date: Wed, 30 Sep 2026 17:26:52 +0200
Message-ID: <20260930152343.898465413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7f2ea5ed588c03d481f0301e6c3d4240132383fb ]

The ISO15693 inventory helper removes a two-byte prefix without checking
that it exists, then accepts a one-byte remainder before reading data[1] as
the DSFID.

Require the prefix and at least two remaining bytes before copying the UID
data and reading the DSFID.

Fixes: 7974728094d3 ("NFC: st21nfca: Add ISO15693 Reader/Writer support")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260830132958.6397-1-pengpeng@iscas.ac.cn
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st21nfca/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nfc/st21nfca/core.c b/drivers/nfc/st21nfca/core.c
index bec6f607c32c9..f0a451fe525a5 100644
--- a/drivers/nfc/st21nfca/core.c
+++ b/drivers/nfc/st21nfca/core.c
@@ -577,9 +577,7 @@ static int st21nfca_get_iso15693_inventory(struct nfc_hci_dev *hdev,
 	if (r < 0)
 		goto exit;
 
-	skb_pull(inventory_skb, 2);
-
-	if (inventory_skb->len == 0 ||
+	if (!skb_pull(inventory_skb, 2) || inventory_skb->len < 2 ||
 	    inventory_skb->len > NFC_ISO15693_UID_MAXSIZE) {
 		r = -EPROTO;
 		goto exit;
-- 
2.53.0



