Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D61408634;
	Tue, 21 Jul 2026 19:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662020; cv=none; b=DHc/1D/dCmjXo8HvnWgKprcGsByEa4MgXDB7ASCFHEeDdMwWokr4bfrE+nsV/58n65JgptHGqEai04/eAPXHdatDlwJ6gO/IjjexIj2ck67rpHh7QoRk38i7aWHHKvlCG8ZcIjlcLdADDl+c6oTL59RsUAEav65kizqm80tH4uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662020; c=relaxed/simple;
	bh=SV9D6DtBruTaQnEzTkTVANmWj8pCjdS8Bzw/P5gCRHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtt1kZRweHnkgZZK19TAJ06Ky2LS1z6hxcwOnhnfQ3ni6OHRcukIaLK6nx6ZKWchZg4Un3ZKe/B8L3b6ke9ZsJp7agwU5rUAG5kR9/s12KH18fYrn0ULhuhWgxvTmT98zvYLVUanreGhQlVLL0d+lVUIVT8ImMZPCWTXR8KYdVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cr6DMPji; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cr6DMPji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F311F00A3A;
	Tue, 21 Jul 2026 19:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662019;
	bh=W8c/Lk+Eo0ayQPC0uPd/xCNADXefw1Q4oB+Y3PK0WZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cr6DMPjiMl7dJgraXuBh53u+mu146Bojq4dQQWNGwfKYoC8JMftr9fXrKKI5sdD7a
	 gsdeqZ43lKiRjJmv1xUhmzchY39RPoKnjE2epAuaesDdjx96zvpny4ifdEJdMB1Q0q
	 ilY8YznQ1tqjxV30mYe3MsKJDTh9PpA7AwtuAZPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0287/1276] wifi: mt76: mt7925: fix potential tx_retries underflow
Date: Tue, 21 Jul 2026 17:12:10 +0200
Message-ID: <20260721152452.505935444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 1e1fd84571e62a2961cea44c053340ec5c99b2cb ]

When FIELD_GET returns 0 for the retry count, subtracting 1 causes
an unsigned integer underflow, resulting in tx_retries becoming a
very large value (0xFFFFFFFF for u32).

Fix by checking if count is non-zero before subtracting 1.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Link: https://patch.msgid.link/20260605113306.3485554-3-ryder.lee@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 7351079f30bb4f..f01dbca6e9b9ca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1150,8 +1150,9 @@ mt7925_mac_tx_free(struct mt792x_dev *dev, void *data, int len)
 
 		if (info & MT_TXFREE_INFO_HEADER) {
 			if (wcid) {
-				wcid->stats.tx_retries +=
-					FIELD_GET(MT_TXFREE_INFO_COUNT, info) - 1;
+				u32 count = FIELD_GET(MT_TXFREE_INFO_COUNT, info);
+
+				wcid->stats.tx_retries += count ? count - 1 : 0;
 				wcid->stats.tx_failed +=
 					!!FIELD_GET(MT_TXFREE_INFO_STAT, info);
 			}
-- 
2.53.0



