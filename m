Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEAB134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2470AC433C0;
	Mon, 26 Jun 2023 18:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803592;
	bh=hhEiur+hRRcMVfgVgFHDp3d7Ojq3kO+TaFm1uCZoSYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0zSJk56BjzBiuK3UhmtDIwv+x1MH8Iu37018Iz6z4xkNBnmEx/dJH6ZxqtAv8BRR
	 geJTTR5JX80zM7kH3lxEGhj3aietVQfslmsR4xM/JdQyFVmu8hkth70IEx22PKHc1E
	 09Aw0uRVHNiSsmvulct3xtztPiaaMemdmag4FINY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <stefan.wahren@i2se.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 113/199] net: qca_spi: Avoid high load if QCA7000 is not available
Date: Mon, 26 Jun 2023 20:10:19 +0200
Message-ID: <20230626180810.608016615@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
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
index c865a4be05eec..4a1b94e5a8ea9 100644
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



