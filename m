Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8EC101FD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75FDC433D2;
	Mon,  8 May 2023 10:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540192;
	bh=JBS+rpUjd6bZ6hDQarSh10y84oUhkEUGJaaU1qQ1ycM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pd3OQselFtxMJWkeduXE1U8ya2siTBXwTPhQK0b3r8d33RYXsFwegDFo6L8lX4Z+1
	 MAfww+rP7aPq78yPEXW0nor1xnHdpUDrFeHOemJzo78BK+wk2Od8wtf8xO0hYaeUd/
	 pGe9IRRF3UL2cVOwI2Jo7K3kmgJjcv/9pB3r3f6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 270/611] wifi: ath5k: fix an off by one check in ath5k_eeprom_read_freq_list()
Date: Mon,  8 May 2023 11:41:52 +0200
Message-Id: <20230508094431.161617438@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 4c856ee12df85aabd437c3836ed9f68d94268358 ]

This loop checks that i < max at the start of loop but then it does
i++ which could put it past the end of the array.  It's harmless to
check again and prevent a potential out of bounds.

Fixes: 1048643ea94d ("ath5k: Clean up eeprom parsing and add missing calibration data")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/Y+D9hPQrHfWBJhXz@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath5k/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index d444b3d70ba2e..58d3e86f6256d 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -529,7 +529,7 @@ ath5k_eeprom_read_freq_list(struct ath5k_hw *ah, int *offset, int max,
 		ee->ee_n_piers[mode]++;
 
 		freq2 = (val >> 8) & 0xff;
-		if (!freq2)
+		if (!freq2 || i >= max)
 			break;
 
 		pc[i++].freq = ath5k_eeprom_bin2freq(ee,
-- 
2.39.2



