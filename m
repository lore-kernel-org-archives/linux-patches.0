Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23F93B7B72;
	Sat, 30 May 2026 18:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164588; cv=none; b=qLvgyGOGJUzeneE47QtKW8dysdnrJHNF7f5yafzHtKs45aRNXuSP2X2acxVk/MvpTYPxGdTW3YimlrHc6WgBFsIBvAFmkeEXO3BOP1SnOABvPDP2lyPlVhSHUHfTRff2vatbzmpOfdShnlMjDukE14EU368jm1MihYda9gDl57U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164588; c=relaxed/simple;
	bh=eAbD9M12A1tLLXqn5g4D4ArZKF3GF9A1pHp1y/knmIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEtXCWHE7e1vIs+8mgG5qTMlFoqXMTIuR2rpxtSIukb5/yN+Y8Scxo0c8NMpqBYYjsuer6hiCFF6XYIagBIiXv1PdzTflqg18pcAXjaJ3BdEdz+3nYZeB70NOlqxcZO1KcU2ctMJmnq1fKwGdHIdc6ZtIwD3X5fWSKZ8mcxPiwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBt9Ts5B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBt9Ts5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429541F00893;
	Sat, 30 May 2026 18:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164587;
	bh=CEiLlfUB6VrQFn8YDW29kg/3xgt19NhPIX+MrSf0J0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CBt9Ts5Bgl/f5nNA4BSfNMpgaraX1FNKP3ljWyMpmO/Njb+yxp0+8ZbR79PkpXazg
	 X972pn7rvKi7DALEQdoqi9L3WBIJ/l6cyKA3ldTX3rIz7km/WGFYiCrrzkefdRUm/4
	 tckvMjlB27K+VomU2AIi6S87iOjxR1kMuzapAROU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 600/776] mailbox: mailbox-test: dont free the reused channel
Date: Sat, 30 May 2026 18:05:14 +0200
Message-ID: <20260530160255.540711354@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 88ebadbf0deefdaccdab868b44ff70a0a257f473 ]

The RX channel can be aliased to the TX channel if it has a different
MMIO. This special case needs to be handled when freeing the channels
otherwise a double-free occurs.

Fixes: 8ea4484d0c2b ("mailbox: Add generic mechanism for testing Mailbox Controllers")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/mailbox-test.c b/drivers/mailbox/mailbox-test.c
index 1d546cae922ce..247e83af060e3 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -423,7 +423,7 @@ static int mbox_test_probe(struct platform_device *pdev)
 err_free_chans:
 	if (tdev->tx_channel)
 		mbox_free_channel(tdev->tx_channel);
-	if (tdev->rx_channel)
+	if (tdev->rx_channel && tdev->rx_channel != tdev->tx_channel)
 		mbox_free_channel(tdev->rx_channel);
 	return ret;
 }
@@ -436,7 +436,7 @@ static int mbox_test_remove(struct platform_device *pdev)
 
 	if (tdev->tx_channel)
 		mbox_free_channel(tdev->tx_channel);
-	if (tdev->rx_channel)
+	if (tdev->rx_channel && tdev->rx_channel != tdev->tx_channel)
 		mbox_free_channel(tdev->rx_channel);
 
 	return 0;
-- 
2.53.0



