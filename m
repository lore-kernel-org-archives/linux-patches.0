Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90081D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTV3A60h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AF5C433CA;
	Wed,  4 Oct 2023 18:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443548;
	bh=uzcVI1YMNbpUuL1ORaiG6QunW4/i63BKUwLHOjLcqhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTV3A60hOEwYXJJL7X0Nny9ixknc2gUzx+zkJHIvXlBirBQUZTvXMx+SnwdehsmMq
	 K7xnzo3K3hz4lOGWOh8sFOMHwXJKYAirnEGd1iku/xbctsNG8dAFO71qdsKwaftinv
	 4oVTSNRx+L3XfaLYFVo4bTgPU23QCWZ1jVSKMlPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/259] tsnep: Fix NAPI polling with budget 0
Date: Wed,  4 Oct 2023 19:56:09 +0200
Message-ID: <20231004175226.269608428@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerhard Engleder <gerhard@engleder-embedded.com>

[ Upstream commit 46589db3817bd8b523701274885984b5a5dda7d1 ]

According to the NAPI documentation networking/napi.rst, Rx specific
APIs like page pool and XDP cannot be used at all when budget is 0.
skb Tx processing should happen regardless of the budget.

Stop NAPI polling after Tx processing and skip Rx processing if budget
is 0.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 00436a6f785e8..2be518db04270 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -930,6 +930,10 @@ static int tsnep_poll(struct napi_struct *napi, int budget)
 	if (queue->tx)
 		complete = tsnep_tx_poll(queue->tx, budget);
 
+	/* handle case where we are called by netpoll with a budget of 0 */
+	if (unlikely(budget <= 0))
+		return budget;
+
 	if (queue->rx) {
 		done = tsnep_rx_poll(queue->rx, napi, budget);
 		if (done >= budget)
-- 
2.40.1



