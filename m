Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2201BC5B;
	Sat,  3 Feb 2024 04:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933783; cv=none; b=B0sa9GWoiRsAAu0v5LsacI9FCfXqfsZiH+pofu6Kr2B6hzf/OtLRbxEnpa2xnUn2g8iwjz2xR89gJVOaPj+/IJ6T3TwRnX/XhCYgCDh7YbNv2fCLURb01LPfqCsNIMbwHKXP50ME8LJnyKauHSKO+bWoPoldIbMO60XrYHADHdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933783; c=relaxed/simple;
	bh=I9B7VYif1vcikhtRN7wF+g9djqPXfIRfIiP/XKpxqkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2sV6IvhDLEjTN0g1X1n9lL1HXbHKiQdy1WigP6YnU1UsKzG/OcHZfeWF+qgH/Uraw+4BUOXkB4pYeCRihHm+WSYzeRUvc3BxGgzWF2l8hzbAMgw/cmscW2xHLplcxToy8w1MZ7rz5Jq1VhcxtNm6uPpAObhinttweHJDqZeUfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ED9ckMeh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ED9ckMeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5B2C43390;
	Sat,  3 Feb 2024 04:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933782;
	bh=I9B7VYif1vcikhtRN7wF+g9djqPXfIRfIiP/XKpxqkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ED9ckMehJkov7yCSQNwtAZISIMFtsfcfRJynqXHSD6WvEmxGA66INgytfdbN5yMRQ
	 9c0dybho0SeWh5aiX6Tkb8WYVV6e3P7Oy/7mc2KMfLUGGDqsez7B7Kd4JFsNZepaKv
	 +E0zII6URQH+ddRMxrcHE6Rkb1Bw6HkkvyT9V3eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 063/353] wifi: rtw89: fix timeout calculation in rtw89_roc_end()
Date: Fri,  2 Feb 2024 20:03:01 -0800
Message-ID: <20240203035405.808181514@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit e416514e309f7e25e577fee45a65f246f67b2261 ]

Since 'rtw89_core_tx_kick_off_and_wait()' assumes timeout
(actually RTW89_ROC_TX_TIMEOUT) in milliseconds, I suppose
that RTW89_ROC_IDLE_TIMEOUT is in milliseconds as well. If
so, 'msecs_to_jiffies()' should be used in a call to
'ieee80211_queue_delayed_work()' from 'rtw89_roc_end()'.
Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20231024143137.30393-1-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 3d75165e48be..a3624ebf01b7 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2886,7 +2886,7 @@ void rtw89_roc_end(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 
 	if (hw->conf.flags & IEEE80211_CONF_IDLE)
 		ieee80211_queue_delayed_work(hw, &roc->roc_work,
-					     RTW89_ROC_IDLE_TIMEOUT);
+					     msecs_to_jiffies(RTW89_ROC_IDLE_TIMEOUT));
 }
 
 void rtw89_roc_work(struct work_struct *work)
-- 
2.43.0



