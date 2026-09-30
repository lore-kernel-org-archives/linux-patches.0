Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E324E66AD;
	Wed, 30 Sep 2026 15:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783811; cv=none; b=j1pP0wevqQWDkXDD9Ud6jN9F1h50HrJ4hgzQJl5wIbFSwS1AeugvlqVdcHPuYzGgnsLs3X3kx9U1itU7MYeUwZu3brOOhEdPoAb1RfWYSNQD8k3pPkLER2RCf4y0B0teDL6dNpR9Ksi9rGP84KfA+F946EusG/n166UNpZpnJNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783811; c=relaxed/simple;
	bh=e1RdF/urNDOKHa2n+6Mh/Hrv7Xq/AROIQj0M7rtIAlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhHZVpH1JcUMQJVZ0Tu+AggMorprVzcIgfKD3l4er6Eaon482gey5S9OEYl5n3aIwu9wVnJHZQzl7U4kxMO5btShqoIoZV31stR0+1P+QgXW+04ttWPzMhZ5MnMtl31egiW1Sp6tSoMhXk/3juhVCY19VbOAad557GA9Mltxrjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3rfWm1v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3rfWm1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A651F0089A;
	Wed, 30 Sep 2026 15:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783804;
	bh=URDLCdK4AXRY4EHSi2NPwZmHjHLXuWwxuvsxjp57CQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3rfWm1vJUwVPyQl8EnK3c1WpuE+RXwAyaWeKTjrsZ75+tOryyGuHFSLTxkApFGfo
	 iN3qbPdn5NzCQrTZ5Z3AfhARAaJgCe08xBng3DUyI6RMncNCDvXwc5Ex/PeZQ4Ku0J
	 ta9FFa+KaoGIkH/6qjaMSnUil6fYg/24OJsc6atQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 527/595] nfc: st21nfca: validate ISO15693 inventory length
Date: Wed, 30 Sep 2026 17:27:00 +0200
Message-ID: <20260930152359.040605776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6ca0d2f56b18d..befd66fd7a72d 100644
--- a/drivers/nfc/st21nfca/core.c
+++ b/drivers/nfc/st21nfca/core.c
@@ -578,9 +578,7 @@ static int st21nfca_get_iso15693_inventory(struct nfc_hci_dev *hdev,
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



