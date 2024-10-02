Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0489E1D1F72;
	Wed,  2 Oct 2024 14:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879259; cv=none; b=W2MlfU2JUWzT6shwO/4HBKjtfDC+kLaKMWpI4m5vKK/mjf95JNXZ6JoNbC3FtTPBIPx4z5KLhPc/l/J7G4to2lMPjLaLe3bJNpfArONwiBthL4AC2JEB+TVzeRP1B8Pwu2HtEfPdUq9qnH5Fc64lm5oMGuQU4oIDky3qvEqcqow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879259; c=relaxed/simple;
	bh=mOr6Q3nqcziNYK6eFYbknqu5dJLWCsMOWyKDWxVvOvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnXzHjnuN6skKkd7veXJqzP8/+EUHqKhB9sRBko5SGyxdI0EUk7z0yNbOTggg2mRcC2Hi0zwzL/NCIqqVRRGbURy4cAyheymlYg2uOZyrMtoISkzFPc87/nhg71ouwLdUMxEdSpyh28dAq7ixJ6uD2+zOtpZEy03yWA6D1OKpi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ig4wNJaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ig4wNJaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8541BC4CEC2;
	Wed,  2 Oct 2024 14:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879258;
	bh=mOr6Q3nqcziNYK6eFYbknqu5dJLWCsMOWyKDWxVvOvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ig4wNJaGkiYL59FYbA3iqUPWNrIheu8d0v4J3ZiiyGlVXBkmCKxpaj/f8hCjHUOog
	 YGsmW+/4mptwBFnnnokePeguc98kUD5nzODwfoJ6ciKPPb20/OBuYnCOc+pmycNvWQ
	 wP4ggT932CtWi6RXm1uN4jA9mHgZdSg32p3OohWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/538] wifi: mt76: mt7915: fix rx filter setting for bfee functionality
Date: Wed,  2 Oct 2024 14:54:55 +0200
Message-ID: <20241002125754.412097749@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 6ac80fce713e875a316a58975b830720a3e27721 ]

Fix rx filter setting to prevent dropping NDPA frames. Without this
change, bfee functionality may behave abnormally.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Link: https://patch.msgid.link/20240827093011.18621-21-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 260fe00d7dc6d..27655dcb79142 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -557,8 +557,7 @@ static void mt7915_configure_filter(struct ieee80211_hw *hw,
 
 	MT76_FILTER(CONTROL, MT_WF_RFCR_DROP_CTS |
 			     MT_WF_RFCR_DROP_RTS |
-			     MT_WF_RFCR_DROP_CTL_RSV |
-			     MT_WF_RFCR_DROP_NDPA);
+			     MT_WF_RFCR_DROP_CTL_RSV);
 
 	*total_flags = flags;
 	mt76_wr(dev, MT_WF_RFCR(band), phy->rxfilter);
-- 
2.43.0



