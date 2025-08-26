Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3BA1A00F0;
	Tue, 26 Aug 2025 12:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213053; cv=none; b=djeiq+zcI2ggaNCzJr7qiTNccv4/HQ6Y1kBbu5xHHFDwv3s9E02otZfvWPg4buNjWtQ9SQqLQjGWDa/3VOEnMN/W+sjPep23fGKaxPUXvOWZPRWv37FZZqtSdGfDseSiJBOD9ec5+46sRX7fQ3LhIO/pAQNwAahCKGbBCWhJF9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213053; c=relaxed/simple;
	bh=toJlEI3bikvCzxaUonCSBshVx9kEJpahWa7hkmbFVSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sl0OIX5TeNq0DENMOs5sYwhOZGVa1E2j+e/SS4Db+8HGShuj7fjJhBME81f89JgmWAhlqshgtRiUTjwH5Hywxb9q3njuOSL/Y+UD8OLd+IsJMKhTeZyH2j4rLVJwVOqVGqXkyFA568Xar89Stm4y00gPEBh47V3LRVXBeuIku5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thKXoBH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thKXoBH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB17C4CEF1;
	Tue, 26 Aug 2025 12:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213053;
	bh=toJlEI3bikvCzxaUonCSBshVx9kEJpahWa7hkmbFVSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thKXoBH+Z4cy2gNNXwwYlkL1Cebe8JYwRcLIjcDQHM+CUrmfkSNmgJnkBE2RkVReA
	 ekJ9SWHJgiiq63izog7qMp9hSYQJ186Moe9+mcu5WCT63K5OrhUqzKN3wf2E04O3Mp
	 t2AYevUtvpdyvtXbQMaI1CGhce+mLdylRQE418hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Simon Horman <horms@kernel.org>,
	Joe Damato <joe@dama.to>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 204/587] ionic: clean dbpage in de-init
Date: Tue, 26 Aug 2025 13:05:53 +0200
Message-ID: <20250826110958.128091806@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit c9080abea1e69b8b1408ec7dec0acdfdc577a3e2 ]

Since the kern_dbpage gets set up in ionic_lif_init() and that
function's error path will clean it if needed, the kern_dbpage
on teardown should be cleaned in ionic_lif_deinit(), not in
ionic_lif_free().  As it is currently we get a double call
to iounmap() on kern_dbpage if the PCI ionic fails setting up
the lif.  One example of this is when firmware isn't responding
to AdminQ requests and ionic's first AdminQ call fails to
setup the NotifyQ.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Joe Damato <joe@dama.to>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index bc7c5cd38596..1ac7a40fcc43 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3394,10 +3394,6 @@ void ionic_lif_free(struct ionic_lif *lif)
 	lif->info = NULL;
 	lif->info_pa = 0;
 
-	/* unmap doorbell page */
-	ionic_bus_unmap_dbpage(lif->ionic, lif->kern_dbpage);
-	lif->kern_dbpage = NULL;
-
 	mutex_destroy(&lif->config_lock);
 	mutex_destroy(&lif->queue_lock);
 
@@ -3423,6 +3419,9 @@ void ionic_lif_deinit(struct ionic_lif *lif)
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
 
+	ionic_bus_unmap_dbpage(lif->ionic, lif->kern_dbpage);
+	lif->kern_dbpage = NULL;
+
 	ionic_lif_reset(lif);
 }
 
-- 
2.39.5



