Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4928937325
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60873C433EF;
	Wed,  7 Jun 2023 20:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170840;
	bh=1gHrGw5o8xpsvZU9kheSjgjtAMjYM4s74H91KO94IsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aus1aGwD8A9csBzg9rSWMy6tr83dXPGm2FUqb34S1Gr9qcabi0ilUj+oNAtJeCBtc
	 Epfm2VqwykSgB2z8yZ1bTNitxCBqmvtj1VziKDolx+zfvqzBq8SP6tF4imz9uhg8aw
	 zYMXkoB4d8dHF0FYOPJDR9QqOi6IPHr1C8d9MQh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Jaswinder Singh <jassisinghbrar@gmail.com>,
	Boojin Kim <boojin.kim@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Vinod Koul <vkoul@kernel.org>,
	dmaengine@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/120] dmaengine: pl330: rename _start to prevent build error
Date: Wed,  7 Jun 2023 22:15:28 +0200
Message-ID: <20230607200901.304221767@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
References: <20230607200900.915613242@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit a1a5f2c887252dec161c1e12e04303ca9ba56fa9 ]

"_start" is used in several arches and proably should be reserved
for ARCH usage. Using it in a driver for a private symbol can cause
a build error when it conflicts with ARCH usage of the same symbol.

Therefore rename pl330's "_start" to "pl330_start_thread" so that there
is no conflict and no build error.

drivers/dma/pl330.c:1053:13: error: '_start' redeclared as different kind of symbol
 1053 | static bool _start(struct pl330_thread *thrd)
      |             ^~~~~~
In file included from ../include/linux/interrupt.h:21,
                 from ../drivers/dma/pl330.c:18:
arch/riscv/include/asm/sections.h:11:13: note: previous declaration of '_start' with type 'char[]'
   11 | extern char _start[];
      |             ^~~~~~

Fixes: b7d861d93945 ("DMA: PL330: Merge PL330 driver into drivers/dma/")
Fixes: ae43b3289186 ("ARM: 8202/1: dmaengine: pl330: Add runtime Power Management support v12")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jaswinder Singh <jassisinghbrar@gmail.com>
Cc: Boojin Kim <boojin.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Cc: linux-riscv@lists.infradead.org
Link: https://lore.kernel.org/r/20230524045310.27923-1-rdunlap@infradead.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pl330.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 5bbae99f2d34e..6f697b3f2c184 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1050,7 +1050,7 @@ static bool _trigger(struct pl330_thread *thrd)
 	return true;
 }
 
-static bool _start(struct pl330_thread *thrd)
+static bool pl330_start_thread(struct pl330_thread *thrd)
 {
 	switch (_state(thrd)) {
 	case PL330_STATE_FAULT_COMPLETING:
@@ -1704,7 +1704,7 @@ static int pl330_update(struct pl330_dmac *pl330)
 			thrd->req_running = -1;
 
 			/* Get going again ASAP */
-			_start(thrd);
+			pl330_start_thread(thrd);
 
 			/* For now, just make a list of callbacks to be done */
 			list_add_tail(&descdone->rqd, &pl330->req_done);
@@ -2091,7 +2091,7 @@ static void pl330_tasklet(struct tasklet_struct *t)
 	} else {
 		/* Make sure the PL330 Channel thread is active */
 		spin_lock(&pch->thread->dmac->lock);
-		_start(pch->thread);
+		pl330_start_thread(pch->thread);
 		spin_unlock(&pch->thread->dmac->lock);
 	}
 
@@ -2109,7 +2109,7 @@ static void pl330_tasklet(struct tasklet_struct *t)
 			if (power_down) {
 				pch->active = true;
 				spin_lock(&pch->thread->dmac->lock);
-				_start(pch->thread);
+				pl330_start_thread(pch->thread);
 				spin_unlock(&pch->thread->dmac->lock);
 				power_down = false;
 			}
-- 
2.39.2



