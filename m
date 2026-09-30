Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4227851CF7C;
	Wed, 30 Sep 2026 17:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789245; cv=none; b=Mu0wgLEV/CaRByvdKAeObJ/JtP1tTCHNFXzspAydckmebfIUagTOJzk1zGskyxDmfwB25nqzpPtUyI9YAuHKe1HcF1hTOHkM4l6V+Y/ueQUfO/3LmaNHvTA25bbc+VPLV2KAM5m0ho3Aji7I9qVzmjLHrmg3uBKeZnYSNSrFy5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789245; c=relaxed/simple;
	bh=lPzi9yfO+WC5BDev2MCK2zC5ruoxkKias2ZGz2+Dl30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMd/ZuJfUNyr8qYrCNS+yXh4sLV3TH7aqD2c2dFrD+NMsxgTvNPv85ErVS49DQADz5/+Zu7A4imcyyRms6fk/12hYufmFLE4GwQ8T8Pd0urKCC2cx1/W0kSp/XMZc2Kvhn1iqKB8Hm/QoQYkcstfVSqItNeuGc12Y3uU2j9Lgjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLGAGTSU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLGAGTSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EA31F000FF;
	Wed, 30 Sep 2026 17:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789244;
	bh=RBEb+fB9Sm/wzmfCNPz52iVdrPL+/WRPJHf+7cyijPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bLGAGTSUwYw8vZsuEww+dAWkxneOSGoPWvk85tBuPOhy+Gqtal66t5OKTdhDTY/UZ
	 G7V4hEhS1x+D7uosk1Tcvc41GcfuUdUNqQVR8Wj2bfqhI6M2/T6bmZ2XGs+LwYycEj
	 qSK8nPwT7hZHmkT0vNNuOfb44cXkNKWXnWmLo2kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 410/877] nfc: st21nfca: validate ISO15693 inventory length
Date: Wed, 30 Sep 2026 17:22:01 +0200
Message-ID: <20260930152423.541800099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 161caf2675cfc..7eb5e5f0686be 100644
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



