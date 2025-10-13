Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38444311940;
	Mon, 13 Oct 2025 15:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369996; cv=none; b=bM2DIdYsMHNqrIyMjeZ+Vmb5oTKx/iCnwS02rGadxpiB8Y0QR01TviaI2J6+3BbHDj18fHa75eZBcukEcPU4J3okc0HvlOrquR2t5sTlEf03mFN7j9d09svfitt1cWdqr5QdCLz7Gz6NjbCl8BVWTbqOy3PZwWmcZDENyZtg5J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369996; c=relaxed/simple;
	bh=8ErQAwAjixy4b9XxK2bcxDh/sUQOmy8eRjxQC8XyjAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pN/UEmdHj1FNv6oH8E0bNsKU38UotUGsrKGmkb5qh/cJ2qWmicy//gabwsuYxlBxejBBJQq1FpDswkxjTfb0tQheahGt+lB171183d9NJ9snQo1aQLxLCzGVWOgJcN8hTKu5EKBT0rQ6qvjnMYqCPB51Y4of8vsKC68sqotbUN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iI2UODiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iI2UODiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D1EC16AAE;
	Mon, 13 Oct 2025 15:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369995;
	bh=8ErQAwAjixy4b9XxK2bcxDh/sUQOmy8eRjxQC8XyjAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iI2UODiAIalKYwhdATB0p09mttVkDyUZDAj40cIz5yf0U6gTT2uxtGcRsstU+uVtD
	 Ltk4GCDc2/7dGtcRNHgPQPs/cO+1xuN8O0Fu2kaUFMWmi8V0JSxQsbY7g5yQ+GvnMA
	 iBgVHrJ4FAZVEIRW2+19fxjz6tvCGNuzRIZfg3BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 414/563] wifi: rtw89: fix leak in rtw89_core_send_nullfunc()
Date: Mon, 13 Oct 2025 16:44:35 +0200
Message-ID: <20251013144426.286547089@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit a9f0064f4716b0fd97085015ea1dd398bdfdc946 ]

If there is no rtwsta_link found in rtw89_core_send_nullfunc(), allocated
skb is leaked.  Free it on the error handling path.

Found by Linux Verification Center (linuxtesting.org).

Fixes: a8ba4acab7db ("wifi: rtw89: send nullfunc based on the given link")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250919210852.823912-4-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index b9c2224dde4a3..1837f17239ab6 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -3456,6 +3456,7 @@ int rtw89_core_send_nullfunc(struct rtw89_dev *rtwdev, struct rtw89_vif_link *rt
 	rtwsta_link = rtwsta->links[rtwvif_link->link_id];
 	if (unlikely(!rtwsta_link)) {
 		ret = -ENOLINK;
+		dev_kfree_skb_any(skb);
 		goto out;
 	}
 
-- 
2.51.0



