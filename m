Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE9D39FC3;
	Fri, 24 Nov 2023 18:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNaP8k28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0D9C433CA;
	Fri, 24 Nov 2023 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850414;
	bh=atqGYbNOBw5H0ZfSnn0aLkCd9qwsDVo6WrSSJ80Oe/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNaP8k285WNkuH1BteFlNRfnKRVhEWI2thhF6a5UxcI8sI+nouysWpfM5txLJkY10
	 MWmSBc5Hf9NikMmIqC2S71E3pamK33Rgnngamb1XwZADfuMnFDxADOqpmGrnhwNV9K
	 TbfvW3qmhqUBxTUrHb7mFZEXrthp+tSTAW+XkQgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 040/491] tsnep: Fix tsnep_request_irq() format-overflow warning
Date: Fri, 24 Nov 2023 17:44:36 +0000
Message-ID: <20231124172025.894620685@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerhard Engleder <gerhard@engleder-embedded.com>

[ Upstream commit 00e984cb986b31e9313745e51daceaa1e1eb7351 ]

Compiler warns about a possible format-overflow in tsnep_request_irq():
drivers/net/ethernet/engleder/tsnep_main.c:884:55: warning: 'sprintf' may write a terminating nul past the end of the destination [-Wformat-overflow=]
                         sprintf(queue->name, "%s-rx-%d", name,
                                                       ^
drivers/net/ethernet/engleder/tsnep_main.c:881:55: warning: 'sprintf' may write a terminating nul past the end of the destination [-Wformat-overflow=]
                         sprintf(queue->name, "%s-tx-%d", name,
                                                       ^
drivers/net/ethernet/engleder/tsnep_main.c:878:49: warning: '-txrx-' directive writing 6 bytes into a region of size between 5 and 25 [-Wformat-overflow=]
                         sprintf(queue->name, "%s-txrx-%d", name,
                                                 ^~~~~~

Actually overflow cannot happen. Name is limited to IFNAMSIZ, because
netdev_name() is called during ndo_open(). queue_index is single char,
because less than 10 queues are supported.

Fix warning with snprintf(). Additionally increase buffer to 32 bytes,
because those 7 additional bytes were unused anyway.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310182028.vmDthIUa-lkp@intel.com/
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20231023183856.58373-1-gerhard@engleder-embedded.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/engleder/tsnep.h      |  2 +-
 drivers/net/ethernet/engleder/tsnep_main.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 11b29f56aaf9c..b91abe9efb517 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -142,7 +142,7 @@ struct tsnep_rx {
 
 struct tsnep_queue {
 	struct tsnep_adapter *adapter;
-	char name[IFNAMSIZ + 9];
+	char name[IFNAMSIZ + 16];
 
 	struct tsnep_tx *tx;
 	struct tsnep_rx *rx;
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 479156576bc8a..e3fc894fa3f6f 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1778,14 +1778,14 @@ static int tsnep_request_irq(struct tsnep_queue *queue, bool first)
 		dev = queue->adapter;
 	} else {
 		if (queue->tx && queue->rx)
-			sprintf(queue->name, "%s-txrx-%d", name,
-				queue->rx->queue_index);
+			snprintf(queue->name, sizeof(queue->name), "%s-txrx-%d",
+				 name, queue->rx->queue_index);
 		else if (queue->tx)
-			sprintf(queue->name, "%s-tx-%d", name,
-				queue->tx->queue_index);
+			snprintf(queue->name, sizeof(queue->name), "%s-tx-%d",
+				 name, queue->tx->queue_index);
 		else
-			sprintf(queue->name, "%s-rx-%d", name,
-				queue->rx->queue_index);
+			snprintf(queue->name, sizeof(queue->name), "%s-rx-%d",
+				 name, queue->rx->queue_index);
 		handler = tsnep_irq_txrx;
 		dev = queue;
 	}
-- 
2.42.0



