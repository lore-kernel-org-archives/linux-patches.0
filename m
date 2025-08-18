Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30BC31E0FE;
	Mon, 18 Aug 2025 14:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525838; cv=none; b=bYMTFLwkncvhM1Y2ZqG+1PqIjVEqWdHhYrl2Xa09KAb/O6VYquqw3iI33vTip6DMLgezfw9OU1hiccbzJ+/XOhw9sKLP5eaZOmIYJ/kL0yLeImyxjdbwtbaGHJ9QuMpGRhMLzBHl7ZpZxgErfFSWtHbKmCAHcq+uSbudofvpw8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525838; c=relaxed/simple;
	bh=ylf7zLL9oiF0fCOLlxWf3JqZ9qgELC4ZyYM9MnMxvX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzG7LXEl1M+JTGhESeMFANsy0di+R3MT++rW0ESkvLKJLWW8XKhLwV6QnHLrWvpvLCfmzLAacfTGGBBXHgRv7qfWX3mhlyoN5UjWm3rImMIiEUpd5VJalTZCCT27jOijfGAZTVVvGt0ryMqacQH3hBU9wt4CvHKabjwKsXkT6Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVRNHWrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVRNHWrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F65FC4CEEB;
	Mon, 18 Aug 2025 14:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525838;
	bh=ylf7zLL9oiF0fCOLlxWf3JqZ9qgELC4ZyYM9MnMxvX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVRNHWrEh7DFAleDzeoc/dmbJJ6+O/02LIkJmQ2ly5g2x7tXKnJaqoYiV5Ldut4kK
	 /qCYVIny2fqRNThtmC+EBnKRtLLB433vAIp9E9NWZJ7H1X9Wux1aOqdIAgZkPpforl
	 NMXflrzIq1TCLE49LcI6XHvDtA/b6fkDLowSGL34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Simon Horman <horms@kernel.org>,
	Joe Damato <joe@dama.to>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 339/570] ionic: clean dbpage in de-init
Date: Mon, 18 Aug 2025 14:45:26 +0200
Message-ID: <20250818124518.914282916@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 7707a9e53c43..48cb5d30b5f6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3526,10 +3526,6 @@ void ionic_lif_free(struct ionic_lif *lif)
 	lif->info = NULL;
 	lif->info_pa = 0;
 
-	/* unmap doorbell page */
-	ionic_bus_unmap_dbpage(lif->ionic, lif->kern_dbpage);
-	lif->kern_dbpage = NULL;
-
 	mutex_destroy(&lif->config_lock);
 	mutex_destroy(&lif->queue_lock);
 
@@ -3555,6 +3551,9 @@ void ionic_lif_deinit(struct ionic_lif *lif)
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
 
+	ionic_bus_unmap_dbpage(lif->ionic, lif->kern_dbpage);
+	lif->kern_dbpage = NULL;
+
 	ionic_lif_reset(lif);
 }
 
-- 
2.39.5



