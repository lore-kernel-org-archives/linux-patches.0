Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522D02F2C52;
	Tue, 17 Jun 2025 16:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177334; cv=none; b=FQmcHR9Tbo0MnYJqT6Ldpukhaejy+XQ/oYDNvl3VtG/xxcidUmR5wN9VqMmdZMpHl6L4wTL2aY8txrLZQ4ghVTR2F93EV66pFAh3M/YctMNKf4jofM6gJ5d9YGfgUaFGlDE83WN1hhb0fPZk2nV2sRrhka0qHnzOvvRK3dyMerY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177334; c=relaxed/simple;
	bh=rQioJYMAbRgRFFeF6nVFfKT86PcM1wEtWeQ1q3bMVDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFiBElWj5N4LjvByomtKgLa0SaJbLcUaFOU3hMZ55T80LPQoZa2s7KRANSggT2wlShg/KwP/Z2AJQYe70ovQFPB2N7EIn2lmaHsDN5vUMg9hwwYkv67fWmihjaeUvgD4TrZpdnxhVjrbmXp0AUdwuYb1S5dGLsiM7OtmUs7jyQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDozvkwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDozvkwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA863C4CEE3;
	Tue, 17 Jun 2025 16:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177334;
	bh=rQioJYMAbRgRFFeF6nVFfKT86PcM1wEtWeQ1q3bMVDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDozvkwGMezM4VnkBGqvkFEGlfpXE3DMHd/0ApEG47yG4ZwSJ0En1wBqEdevpo05H
	 Cx0BiLhIrMJKEULLapiBY59uC0LuS1jZA5r4I5TLOgujiwPWmEFEJ+7OXPGdFvhTL4
	 mXbCUhRb7edARPqWOF/PvhHF1dV2k4BUG8/PeokA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qasim Ijaz <qasdev00@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 291/780] wifi: mt76: mt7996: avoid NULL pointer dereference in mt7996_set_monitor()
Date: Tue, 17 Jun 2025 17:19:59 +0200
Message-ID: <20250617152503.318706112@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

[ Upstream commit cb423ddad0f6e6f55b1700422ab777b25597cc83 ]

The function mt7996_set_monitor() dereferences phy before
the NULL sanity check.

Fix this to avoid NULL pointer dereference by moving the
dereference after the check.

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Link: https://patch.msgid.link/20250421112544.13430-1-qasdev00@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 70823bbb165c7..5ec4f97932865 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -414,11 +414,13 @@ static void mt7996_phy_set_rxfilter(struct mt7996_phy *phy)
 
 static void mt7996_set_monitor(struct mt7996_phy *phy, bool enabled)
 {
-	struct mt7996_dev *dev = phy->dev;
+	struct mt7996_dev *dev;
 
 	if (!phy)
 		return;
 
+	dev = phy->dev;
+
 	if (enabled == !(phy->rxfilter & MT_WF_RFCR_DROP_OTHER_UC))
 		return;
 
-- 
2.39.5



