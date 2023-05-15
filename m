Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F424DF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0077C433D2;
	Mon, 15 May 2023 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168816;
	bh=jn/KJPtko9C4vM80ZJrD0xZOWj4M0n48uYm3g9CACgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMSU5zaZ8XYRz2mMes0j7cYeZXSq0S/w1rPaSoIxIbvrMjyje/EcUJeUB8ANUwbOI
	 xln98Pp3F1qilD4oFNnfzMoWrnoI/DcCtNXN+vmz9kIVQbV7Lvp13XXb5rEjn2MTA7
	 XHty0aXNj8566wCvryI1IZbgnyQdUIZmQCDUH2sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 050/191] wifi: ath5k: fix an off by one check in ath5k_eeprom_read_freq_list()
Date: Mon, 15 May 2023 18:24:47 +0200
Message-Id: <20230515161709.021662887@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
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
index 01163b3339451..92f5c8e830901 100644
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



