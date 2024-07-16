Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7562A1DDCE;
	Tue, 16 Jul 2024 16:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146034; cv=none; b=idsWCTqgaDYQFNcgqfepKm8cZRqDOKJjfOTo7HICxYRL9T5aM8qEnY79pPRQCwMp+fj6BIuWCpq+2K4fGRh1CZb6sEM8QeLjn2ZK1YeOUEy/0vlI9+9A38hd7XvkkPeUE6Fv0OlYDPK9HRiKUS1CVeFQk2byMBeEW0DC5qcftXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146034; c=relaxed/simple;
	bh=SZ3I3k8Qz8jZshaTVNrC4fpjq8pTD0wqaAMoNTmlrtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bKnSxqShT3+p0Ik16pN1VaecJw3jo5DMIpB4Kx7VJDKIGwWiOnVQsucKA2VuiAcWHH+BUY/XwPf6GFpxAgMRH3gwNVVqCLaDyRrQxcoOoBYLMNOuCW3sFlesUYsbpqS8A8jn6Oj7i4qPyuEHvRLPiJbFrYLtrJxkRUS7VKG9xug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZg48C9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZg48C9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE36BC116B1;
	Tue, 16 Jul 2024 16:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146034;
	bh=SZ3I3k8Qz8jZshaTVNrC4fpjq8pTD0wqaAMoNTmlrtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZg48C9CJMlbWzMy1yuXSXgyGU2akdCCyMv/KiDdw/WO2W2DotgWq3sqCwI74Fwrf
	 ty53kG+JRRKqr1zWlw0Fpe8tg6tzuQ2WZYSS2/YHKfXmRWgnJXG+YXiItocIC/H/pE
	 cH25/sZ+whKEfYQU/iLhkOX3/n4dSFRCZ4M5JM64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozef Hopko <jozef.hopko@altana.com>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Ajay Singh <ajay.kathat@microchip.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/144] wifi: wilc1000: fix ies_len type in connect path
Date: Tue, 16 Jul 2024 17:31:45 +0200
Message-ID: <20240716152753.930600713@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozef Hopko <jozef.hopko@altana.com>

[ Upstream commit 39ab8fff623053a50951b659e5f6b72343d7d78c ]

Commit 205c50306acf ("wifi: wilc1000: fix RCU usage in connect path")
made sure that the IEs data was manipulated under the relevant RCU section.
Unfortunately, while doing so, the commit brought a faulty implicit cast
from int to u8 on the ies_len variable, making the parsing fail to be
performed correctly if the IEs block is larger than 255 bytes. This failure
can be observed with Access Points appending a lot of IEs TLVs in their
beacon frames (reproduced with a Pixel phone acting as an Access Point,
which brough 273 bytes of IE data in my testing environment).

Fix IEs parsing by removing this undesired implicit cast.

Fixes: 205c50306acf ("wifi: wilc1000: fix RCU usage in connect path")
Signed-off-by: Jozef Hopko <jozef.hopko@altana.com>
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Acked-by: Ajay Singh <ajay.kathat@microchip.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240701-wilc_fix_ies_data-v1-1-7486cbacf98a@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/hif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/hif.c b/drivers/net/wireless/microchip/wilc1000/hif.c
index fe95a6201a679..3d6877acff3a0 100644
--- a/drivers/net/wireless/microchip/wilc1000/hif.c
+++ b/drivers/net/wireless/microchip/wilc1000/hif.c
@@ -364,7 +364,8 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 	struct ieee80211_p2p_noa_attr noa_attr;
 	const struct cfg80211_bss_ies *ies;
 	struct wilc_join_bss_param *param;
-	u8 rates_len = 0, ies_len;
+	u8 rates_len = 0;
+	int ies_len;
 	int ret;
 
 	param = kzalloc(sizeof(*param), GFP_KERNEL);
-- 
2.43.0



