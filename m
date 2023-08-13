Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D0D9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58733C433C8;
	Sun, 13 Aug 2023 21:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961817;
	bh=xxKfQWsqnILrqaaNrVkxhRX6dIs193bUgRXg6XZDEsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrmP2+dK1+jCq9dXH8OklgeeZHRE5OvXHjxpFhVldsmCkDrYMYJikJik+tj4wsppA
	 pHPgUwFOfTllVfvsfQkuJlhdYaHWCatvMCL2FwVu6vU3xfUvwEiFQhHdX8V2AMr2JC
	 D/BD15sl0s27dWqX6VErJHmeG7JZsQ8SbDMo9MeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damian B <bronecki.damian@gmail.com>,
	Stable@vger.kernel.org,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.4 010/206] wifi: rtw89: fix 8852AE disconnection caused by RX full flags
Date: Sun, 13 Aug 2023 23:16:20 +0200
Message-ID: <20230813211725.270005969@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ping-Ke Shih <pkshih@realtek.com>

commit b74bb07cdab6859e1a3fc9fe7351052176322ddf upstream.

RX full flags are raised if certain types of RX FIFO are full, and then
drop all following MPDU of AMPDU. In order to resume to receive MPDU
when RX FIFO becomes available, we clear the register bits by the
commit a0d99ebb3ecd ("wifi: rtw89: initialize DMA of CMAC"). But, 8852AE
needs more settings to support this. To quickly fix disconnection problem,
revert the behavior as before.

Fixes: a0d99ebb3ecd ("wifi: rtw89: initialize DMA of CMAC")
Reported-by: Damian B <bronecki.damian@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217710
Cc: <Stable@vger.kernel.org>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Tested-by: Damian B <bronecki.damian@gmail.com>
Link: https://lore.kernel.org/r/20230808005426.5327-1-pkshih@realtek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -2484,7 +2484,7 @@ static int cmac_dma_init(struct rtw89_de
 	u32 reg;
 	int ret;
 
-	if (chip_id != RTL8852A && chip_id != RTL8852B)
+	if (chip_id != RTL8852B)
 		return 0;
 
 	ret = rtw89_mac_check_mac_en(rtwdev, mac_idx, RTW89_CMAC_SEL);


