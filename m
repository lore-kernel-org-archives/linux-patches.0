Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B732AF1D;
	Wed, 30 Sep 2026 16:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787284; cv=none; b=s93wKrXDtsfEGcOhVTerF9JBKnAJS8b+w7DIJQxfICzhec91gkSmiwajJE+gUchwlSnUN5Dyos6mzXN+4izLaD7+w3J9QE3r/ru3XXJpS3tm2oM7ige9OQSFuHtfxRsZu4C7izeRsByu33+AewwOcMAUcRDtjrU9iWeBxf8JaoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787284; c=relaxed/simple;
	bh=Q/6N/5kZhR4W+WkVk2DfZd4UChayLRoShb1Cy0urCrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJrs5D+lsyYxp8uBtl6iBskcZSFe1zIwQbIFT7EJQNAyZ8D1Sq+zY7kv3ujRQYiwlUJm8V0Uxtb93b6AvWB+LLMsd4vMKK7X1CkGVeclqxbb5cjbAx/yTaLAf5Fw6PBi5kUOgvRHkQn4LabLZjCD8t9ULKafduBHnmIPPvIhmxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FepTk5u6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FepTk5u6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AAA1F000FF;
	Wed, 30 Sep 2026 16:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787283;
	bh=3oLfZypFg6a0SkF6Zmz6tjQM0mInxN0kiS6x4ESSpqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FepTk5u6CI8MR9eRG41wkJ62xYoM0DB2NS1HNuHmodmgLmFp2T6tiQ80vIQCu4sQH
	 kqsEoncnGI0kIQ0InGXSUwItnqXzYxsqqPY/A7okthbC5WyilViFMO+PxULO5MK3oa
	 TNpu+BTBzZFlr3K/VeTPXinyIEwybK1JT8MhGwT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 176/457] nfc: st21nfca: validate ISO15693 inventory length
Date: Wed, 30 Sep 2026 17:24:41 +0200
Message-ID: <20260930152349.852929164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index fd39a05c96222..34d797a29d21b 100644
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



