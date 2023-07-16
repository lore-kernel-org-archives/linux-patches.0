Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828A59442
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0404BC433C8;
	Sun, 16 Jul 2023 19:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537594;
	bh=MadIgmNYIgoiNF38A9g8sWRuWgD1M5IN5qDNF2STTOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTgio9jF1tzj9QNB8vOQknaODxHtEiRnnlqmIS6X7I9sqaa2VUuXg5AYIZIV8rlWi
	 3l4kx2ZAra9uPRRUX9uBxkl3IE9droTzDS9/MJ8ACPyh2S53fsoGVicKxBRMkqIF5w
	 54z/1BgUblxfj7bDQTr8Z1l/KR9RCz/52XsSLSq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 112/800] wifi: rtw89: fix rtw89_read_chip_ver() for RTL8852B and RTL8851B
Date: Sun, 16 Jul 2023 21:39:25 +0200
Message-ID: <20230716194951.712514935@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 9d4f491b860ea6d04471c3342093b86a46eee63e ]

The if statement is reversed so it will not record the chip version.
This was detected using Smatch:

    drivers/net/wireless/realtek/rtw89/core.c:3593 rtw89_read_chip_ver()
    error: uninitialized symbol 'val'.

Fixes: a6fb2bb84654 ("wifi: rtw89: read version of analog hardware")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/e4d912a2-37f8-4068-8861-7b9494ae731b@kili.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index bad864d56bd5c..5423f8ae187f1 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -3584,7 +3584,7 @@ static void rtw89_read_chip_ver(struct rtw89_dev *rtwdev)
 
 	if (chip->chip_id == RTL8852B || chip->chip_id == RTL8851B) {
 		ret = rtw89_mac_read_xtal_si(rtwdev, XTAL_SI_CV, &val);
-		if (!ret)
+		if (ret)
 			return;
 
 		rtwdev->hal.acv = u8_get_bits(val, XTAL_SI_ACV_MASK);
-- 
2.39.2



