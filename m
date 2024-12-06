Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA38647F53;
	Fri,  6 Dec 2024 14:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496509; cv=none; b=AqCalxcvuWnDT4GBPDM3CXXs8pd1gcRoN6TPbaHH4PBeuY58b/CvlRcecmJGrAqjP46+aZe/OHH9cc2kO1h5FxEZAfeCVy8Ef599Ochz13gRMIKXgxKTSP6PaBU5DZ6TMCBgZKC+WQsIwYjVtO4U1X7Twwdl9EQUNiVrvUP806E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496509; c=relaxed/simple;
	bh=UYloqaEZoQGQsnKvT1+XVX2P85//DStXk3674NWFBoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mq/r+33jMMU7tg8Bj6wZsUpAJE6lvOjMhxzK4fUiJYPDoPiTVeU+jR5ywWYXnRzk2E+YpdPJAfmMDjZo0Dkhp66Sjte3OXsbqLH0wtjaUq6eq4JJOKXSeL6i4eOKWKMkG+KePR898/zW48UMcEL/SfP7i5Lw6wCJqJAS4WMVEWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VIlgKSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VIlgKSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615D8C4CED1;
	Fri,  6 Dec 2024 14:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496509;
	bh=UYloqaEZoQGQsnKvT1+XVX2P85//DStXk3674NWFBoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VIlgKSVZZG2lMddHFG99ptJVZ+b43P12Uosdvikt9uqk31CKFacDXc2S0IhlplMR
	 gTmTcgDuCaDtHqyrZhCWUvDajNrDzjqr/694chPKvOwfWU23q10lwAKFfAefq5p9WK
	 wQh4NlETsgFu4vvbUjqKUdH7nYwwgbgomOr30Uuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/676] ASoC: stm: Prevent potential division by zero in stm32_sai_mclk_round_rate()
Date: Fri,  6 Dec 2024 15:27:24 +0100
Message-ID: <20241206143654.342594640@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Luo Yifan <luoyifan@cmss.chinamobile.com>

[ Upstream commit 63c1c87993e0e5bb11bced3d8224446a2bc62338 ]

This patch checks if div is less than or equal to zero (div <= 0). If
div is zero or negative, the function returns -EINVAL, ensuring the
division operation (*prate / div) is safe to perform.

Signed-off-by: Luo Yifan <luoyifan@cmss.chinamobile.com>
Link: https://patch.msgid.link/20241106014654.206860-1-luoyifan@cmss.chinamobile.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index 0acc848c1f004..1b61110cb9174 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -378,8 +378,8 @@ static long stm32_sai_mclk_round_rate(struct clk_hw *hw, unsigned long rate,
 	int div;
 
 	div = stm32_sai_get_clk_div(sai, *prate, rate);
-	if (div < 0)
-		return div;
+	if (div <= 0)
+		return -EINVAL;
 
 	mclk->freq = *prate / div;
 
-- 
2.43.0



