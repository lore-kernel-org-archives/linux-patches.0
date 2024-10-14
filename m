Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3544E1AB503;
	Mon, 14 Oct 2024 14:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917467; cv=none; b=LRoAyJDYsLxpRh88u0tBAOGRtroKhAh2+aWET7I388rIz0Ly4cM5prjOv0Si6/jdhgqXeaeDH0hphqeAmLrGY3XHJC2ePqC38rwsIt2oiU23Oo1irrRI2iGOaKtCCnQKvR87gku2I5vecUxqB1RA0L8AMXj+EzKC5BgqQLIuLts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917467; c=relaxed/simple;
	bh=Cl5vA4QhmxJMO6it8LbFRoeujODDdfcjZIqJ5YbRDT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5lMg/0qBVSZ4rS7WxvXhrpcHFaeFzlf8CU2ytnXiCKWxFZ8LMm3O65XYLNLEB/tVMGlItVci3thfKDAiXh3YwhrNWeTpOOVpoW7FJc1SAhHeDkijsf/MdFTsFehzDysuEyCh6+VhhDjlKnnC6W1cJpFPwZZQAyqejynFYgjdJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdG4/3U3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdG4/3U3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A12C4CEC3;
	Mon, 14 Oct 2024 14:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917467;
	bh=Cl5vA4QhmxJMO6it8LbFRoeujODDdfcjZIqJ5YbRDT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdG4/3U39MUL02EKfopd8LwPUeXeF8cqtXSoewzPnaPP073kKFArxnnTu0HYxHnbl
	 JC064sVVm76wjwoozRgkLqHBAYnnFBmsdjklVb3t+NrZb5cwVLz5viS5IrFoddlF93
	 b6NpiZKZ5EPumJluerblcU+m8eWMhPoy4K8kajw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/798] wifi: mt76: mt7915: fix rx filter setting for bfee functionality
Date: Mon, 14 Oct 2024 16:09:57 +0200
Message-ID: <20241014141219.634582882@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3280843ea8566..e3cfed419f18e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -540,8 +540,7 @@ static void mt7915_configure_filter(struct ieee80211_hw *hw,
 
 	MT76_FILTER(CONTROL, MT_WF_RFCR_DROP_CTS |
 			     MT_WF_RFCR_DROP_RTS |
-			     MT_WF_RFCR_DROP_CTL_RSV |
-			     MT_WF_RFCR_DROP_NDPA);
+			     MT_WF_RFCR_DROP_CTL_RSV);
 
 	*total_flags = flags;
 	mt76_wr(dev, MT_WF_RFCR(band), phy->rxfilter);
-- 
2.43.0



