Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108C630CD94;
	Mon, 13 Oct 2025 15:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369936; cv=none; b=j4XTxTgwzN4Emb6xSnUBw1JJavmZcvVwnCjsDqQlllzGXbBQHZqxdlCgmVXh7BkJc6eo0et5S5Utk0Ga/nJE5GG1+y7elcPywWYWjhYAEvsv9wGN0olpAmCoKM/hnzPDfAZ9a5tXwWH19d3PuIs1tZgZ60t1M2DnXeO2jBQdQYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369936; c=relaxed/simple;
	bh=85uLi1UiTRJxKkeiHXwZmNQOxs4VJZ98v10Jqwe7Q7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rl1UbTcFIpz4Sz1kZ7uQmYVaH/D3pRxQsobe2ps1D7rzPG76LuaOeuHfNqgdyRklb0xi4TNm+wklal3xNp4gL8r+FNwX+NACMhqqJWwMSL745rKNHvvQDUv7Mi4CbHhNvGCE7dYb3Byaey5f1Z+cgIUCDWm+zBBS+St3vHS2rqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lchHA1J+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lchHA1J+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFC2C4CEE7;
	Mon, 13 Oct 2025 15:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369935;
	bh=85uLi1UiTRJxKkeiHXwZmNQOxs4VJZ98v10Jqwe7Q7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lchHA1J+EuaRzhL1K5Y5cqNnotwrRJpBHZcKdZZB6Hzlw/E7Zyt5wIWYJVe45E16w
	 /mvnnbY6HPZ0AxbnGbuXUrfio2wujEeFfmjMOPcU2NsWOnA2zIVQlaxWj07uCGjcB1
	 JVidEBpTCS5Wraf3F3C9eveEgP0ZIkUhI1dP9ccM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 421/563] wifi: cfg80211: fix width unit in cfg80211_radio_chandef_valid()
Date: Mon, 13 Oct 2025 16:44:42 +0200
Message-ID: <20251013144426.540661740@linuxfoundation.org>
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

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 17f34ab55a8518ecbd5dcacec48e6ee903f7c1d0 ]

The original code used nl80211_chan_width_to_mhz(), which returns the width in MHz.
However, the expected unit is KHz.

Fixes: 510dba80ed66 ("wifi: cfg80211: add helper for checking if a chandef is valid on a radio")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Link: https://patch.msgid.link/df54294e6c4ed0f3ceff6e818b710478ddfc62c0.1758579480.git.Ryder%20Lee%20ryder.lee@mediatek.com/
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 240c68baa3d1f..341dbf642181b 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -2992,7 +2992,7 @@ bool cfg80211_radio_chandef_valid(const struct wiphy_radio *radio,
 	u32 freq, width;
 
 	freq = ieee80211_chandef_to_khz(chandef);
-	width = cfg80211_chandef_get_width(chandef);
+	width = MHZ_TO_KHZ(cfg80211_chandef_get_width(chandef));
 	if (!ieee80211_radio_freq_range_valid(radio, freq, width))
 		return false;
 
-- 
2.51.0



