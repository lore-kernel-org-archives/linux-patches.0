Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19C71DA24
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2ljgfny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C39C433C7;
	Wed,  4 Oct 2023 18:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444114;
	bh=a2TpzGfLYFmvR+HMEEr5rT1PYRjsRUL8HEIfad1e1Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2ljgfny704XJheX2EILgZbyWuwCh0opWkKEIXEQ+DB3B2f4L+nCtR7Xac5KxnsyL
	 WLMvkwcypsRQYirRRBKM9+3ppPJtcva1y5kzLkHOUoUdDm+H31Q7Dhdq4CRNo9nenT
	 QynZwuum08ji30wuhVM795/QPsLaeRmuHPopdNtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	ChiYuan Huang <cy_huang@richtek.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 135/321] power: supply: rt9467: Fix rt9467_run_aicl()
Date: Wed,  4 Oct 2023 19:54:40 +0200
Message-ID: <20231004175235.492518904@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit cba320408d631422fef0ad8407954fb9d6f8f650 ]

It is spurious to bail-out on a wait_for_completion_timeout() call that
does NOT timeout.

Reverse the logic to return -ETIMEDOUT instead, in case of tiemout.

Fixes: 6f7f70e3a8dd ("power: supply: rt9467: Add Richtek RT9467 charger driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://lore.kernel.org/r/2ed01020fa8a135c36dbaa871095ded47d926507.1676464968.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9467-charger.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/rt9467-charger.c b/drivers/power/supply/rt9467-charger.c
index 683adb18253dd..fdfdc83ab0458 100644
--- a/drivers/power/supply/rt9467-charger.c
+++ b/drivers/power/supply/rt9467-charger.c
@@ -598,8 +598,8 @@ static int rt9467_run_aicl(struct rt9467_chg_data *data)
 
 	reinit_completion(&data->aicl_done);
 	ret = wait_for_completion_timeout(&data->aicl_done, msecs_to_jiffies(3500));
-	if (ret)
-		return ret;
+	if (ret == 0)
+		return -ETIMEDOUT;
 
 	ret = rt9467_get_value_from_ranges(data, F_IAICR, RT9467_RANGE_IAICR, &aicr_get);
 	if (ret) {
-- 
2.40.1



