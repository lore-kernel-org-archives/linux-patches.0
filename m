Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F62A4CF49B;
	Sat, 17 Oct 2026 16:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256194; cv=none; b=bfxKIi45yJQnrBr0jY3elDRNmBUxEelQPA9d2mLAwDMTEtW2JFBGedoGydj1bJFv1/nxKDqcmr4DQwF9lWDi38y8444N9gEI/DJ/LkqkWS3KvwA+bdc09c3ar0UqH7RKR4mX/nc6V4KHQfcd5soLYed2jxV3CFzfsjevw1kAT/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256194; c=relaxed/simple;
	bh=p+PQGn7pkg9o/xbMkcUIgE5HwaM0rnHis8DZSqHj+y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6aAAnNK8Usx4brbDXfdizPZyHsFpKUMUDeJq6FDnbXswOm0vdmPZ3yP4eG2IF2+oeyu6q7H2MUnOc3wY3SIpwYLIdJVaxSa5wsP4HvdnUPEFTcn+XkMce0Zwzbrd8P+wAlPZdyMTdgEqsMS+wF+eaPl2THg3abH5TDrSd2uhvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GB4oIhij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GB4oIhij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6F51F000C4;
	Sat, 17 Oct 2026 16:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256192;
	bh=n4qU41N+jCl0smBih9/MfqK8h9VkoAbHKlktS03FIHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GB4oIhijCvVBqh7hg4XKUB4FtCED6pFqw+q8diK8+Gt7TgBXyfiWSAdrSSh+9pnQY
	 Lf9eVFa2ZyQg4U8Wk/EtsnUSoP7CLdipHh11SBDHncYoguNuuadV4VMZ1weBSOuCsG
	 SV/jiM6LUCHHkA+ficPHgo/3JmgQ8yZ5ugYzIreA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0118/1674] wifi: wcn36xx: Fix potential use-after-free in TX ack timer teardown
Date: Sat, 17 Oct 2026 17:39:50 +0200
Message-ID: <20261017160434.177798174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit d9be5e75530772fc31637070d51e5717d6aeaa2a ]

wcn36xx_dxe_deinit() tears down the TX ack timer with timer_delete(),
which only dequeues the timer and does not wait for a callback that is
already executing; the preceding free_irq() calls synchronize the
interrupt handlers only. The callback, wcn36xx_dxe_tx_timer(), can
therefore be running past the teardown and use the wcn freed along
with the ieee80211_hw in wcn36xx_remove(): it takes wcn->dxe_lock,
reads wcn->tx_ack_skb and passes wcn->hw to
ieee80211_tx_status_irqsafe().

Fix this by using timer_shutdown_sync(), which waits for a running
callback and also prevents the timer from being rearmed again. The
timer is set up again by wcn36xx_dxe_init() on the next start, so the
start/stop cycle is unaffected.

This issue was found by an in-house static analysis tool.

Fixes: fdf21cc37149 ("wcn36xx: Add TX ack support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260910020907.3353-1-fanwu01@zju.edu.cn
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
[ Adapted the patch to replace del_timer() instead of timer_delete(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 9013f056eecb4..02e66839ab3ac 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -1055,7 +1055,7 @@ void wcn36xx_dxe_deinit(struct wcn36xx *wcn)
 
 	free_irq(wcn->tx_irq, wcn);
 	free_irq(wcn->rx_irq, wcn);
-	del_timer(&wcn->tx_ack_timer);
+	timer_shutdown_sync(&wcn->tx_ack_timer);
 
 	if (wcn->tx_ack_skb) {
 		ieee80211_tx_status_irqsafe(wcn->hw, wcn->tx_ack_skb);
-- 
2.53.0



