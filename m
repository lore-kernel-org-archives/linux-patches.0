Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9DC11CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2ECC433C0;
	Mon, 26 Jun 2023 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804806;
	bh=gGRvOFc4QXcFRkg2TOWgBOgEafW48dnYOcSpMaleMkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BENFX+36kNqjE3BC1l5Rnf+lZXkt7Jnj5quNLiu/BvTTDx5EhentkPyIphGRffxkj
	 A57YUTa6vppqJ00MJWshAB3+L79Fj7JbQoH8MykTUTgGpLDL3gKDndVHj73K/5NwZC
	 EEz0c9x1bgM8HZfFxLkjPe4fhTt8edW7vh/t8yjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <stefan.wahren@i2se.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 48/96] net: qca_spi: Avoid high load if QCA7000 is not available
Date: Mon, 26 Jun 2023 20:12:03 +0200
Message-ID: <20230626180748.975793165@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
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
index 8427fe1b8fd1c..2205bb437e680 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -582,8 +582,7 @@ qcaspi_spi_thread(void *data)
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



