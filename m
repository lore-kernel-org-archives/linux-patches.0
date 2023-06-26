Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAC3134CE
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F001C433C8;
	Mon, 26 Jun 2023 18:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803903;
	bh=dbMyz+fBb1s2KaT/mOcSRnsqPF33KYePagxTmZA6CXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uj6yR3ppAmYmD1qCVzr9nrzCpFFwcbyQjCsbLOk6ZrQaVB3wbOSaTeVwQnopAsdev
	 R8VmKR1W/nEOo2+S8R/6q5QBOQhSn9+EF4C1SZKL7zGkiIc+2pwjMu/6lO/BuT/s5P
	 GIRXp+Dyg/X9yTW9qXXJxxdhRA8I9WMTy5H0xrrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <stefan.wahren@i2se.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/41] net: qca_spi: Avoid high load if QCA7000 is not available
Date: Mon, 26 Jun 2023 20:11:40 +0200
Message-ID: <20230626180736.955380133@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180736.243379844@linuxfoundation.org>
References: <20230626180736.243379844@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 92717c2356cb62c89e8a3dc37cbbab2502562524 ]

In case the QCA7000 is not available via SPI (e.g. in reset),
the driver will cause a high load. The reason for this is
that the synchronization is never finished and schedule()
is never called. Since the synchronization is not timing
critical, it's safe to drop this from the scheduling condition.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/qca_spi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index afd49c7fd87fe..3e6095f0cb5f5 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -553,8 +553,7 @@ qcaspi_spi_thread(void *data)
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if ((qca->intr_req == qca->intr_svc) &&
-		    (qca->txr.skb[qca->txr.head] == NULL) &&
-		    (qca->sync == QCASPI_SYNC_READY))
+		    !qca->txr.skb[qca->txr.head])
 			schedule();
 
 		set_current_state(TASK_RUNNING);
-- 
2.39.2



