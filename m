Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F760168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC5BC433EF;
	Mon,  8 May 2023 10:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542070;
	bh=JBS+rpUjd6bZ6hDQarSh10y84oUhkEUGJaaU1qQ1ycM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEMZI+60Iqms3v3yepvJop//mH/wEg1iQ7VWapKYnbd+ZGxqP34Y2VU+LqR5+3umY
	 6am2nCdKjupEK3uTp3EShn+ULSn7yBRf35xaT5faFKfqP4xL55CNIiUVPlmf9KsHww
	 NoFn//RlRBaaCnpyU1rqth3FTL4/qgEkf5TUsOHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 284/663] wifi: ath5k: fix an off by one check in ath5k_eeprom_read_freq_list()
Date: Mon,  8 May 2023 11:41:50 +0200
Message-Id: <20230508094437.431997268@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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



