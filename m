Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702102DE717
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301115; cv=none; b=K8NSd0+SggQofvQLzU9a0brPmt7pXNPwy5JwqEWE6KuGd6rUIg+wF71jZYThIaubhaguJO+Cl/nYyVkA6A9baTysVZsN1T18DjCUewzvqMEZ/Tn1B7W3UKvKTv7mpOInTnBw9g3tm7PHQzvf58RkQA2RRWGlJkTOvZwP2OPxBuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301115; c=relaxed/simple;
	bh=x9Bj61pNc6SucUAx4PuODOuyXJ985GgdupFBJKjIoDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkWST8qVCcRiQ7x0HSl+S+NMCGCsSL9wDDt1Y8qtCSo3Ai0v/N+Ucw/OGG8RoZY2VNb2iDMHOGIJaxQ/fLwCmzXgt+EZYkcOLXiSOe8DzYhJy9GhJ4fDYRWNM5YkeGkzqXh/39/HthPxwF+1QGlsqyApC4jtigVxRVB5sjx96Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeLb1CBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeLb1CBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A19C2BC87;
	Sat, 28 Feb 2026 17:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301115;
	bh=x9Bj61pNc6SucUAx4PuODOuyXJ985GgdupFBJKjIoDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeLb1CBrxmY/6dD5TfX0lPyWmm/qPszT4mi2wtvZPoaUrABLg/fjFEseKN5VT8QFy
	 pZGhYvsBeEQBv4L/JiXIMblCbO37YmFAL3zZwkynDxvjqBa37u3XFephinAZUgH+zx
	 pCP8YXYbfLb216xQijDKEfQgUHWeKFDEPegtzS5guKDdPqIuEU3fyTOpCr5P/F5aCY
	 ro4QANgyp1T8YFKq7pGVqq4sQunVzTqQlsDJm1ympFffVutHhtixy6WhQa4pvvBWqP
	 B7O9LkdygyRVlTr0jU4Jfc1K1CXyALgBfMOAK0dIoLiQ1O11inCsyQR0gx3fu/3aCl
	 PrLvFAJ0V57sw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 271/752] wifi: rtw89: pci: validate release report content before using for RTL8922DE
Date: Sat, 28 Feb 2026 12:39:42 -0500
Message-ID: <20260228174750.1542406-271-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 5f93d611b33a05bd03d6843c8efe8cb6a1992620 ]

The commit 957eda596c76
("wifi: rtw89: pci: validate sequence number of TX release report")
does validation on existing chips, which somehow a release report of SKB
becomes malformed. As no clear cause found, add rules ahead for RTL8922DE
to avoid crash if it happens.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260123013957.16418-11-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 6395c53b3e170..f7be5e7e0a37c 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -604,8 +604,10 @@ static void rtw89_pci_release_rpp(struct rtw89_dev *rtwdev, void *rpp)
 
 	info->parse_rpp(rtwdev, rpp, &rpp_info);
 
-	if (unlikely(rpp_info.txch == RTW89_TXCH_CH12)) {
-		rtw89_warn(rtwdev, "should no fwcmd release report\n");
+	if (unlikely(rpp_info.txch >= RTW89_TXCH_NUM ||
+		     info->tx_dma_ch_mask & BIT(rpp_info.txch))) {
+		rtw89_warn(rtwdev, "should no release report on txch %d\n",
+			   rpp_info.txch);
 		return;
 	}
 
-- 
2.51.0

