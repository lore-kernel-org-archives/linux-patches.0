Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6660F32255A;
	Mon, 18 Aug 2025 13:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523918; cv=none; b=ArDe+ZXXzTpfgSaYU6EgtZrlod/Y74RgXeN+jvBBAzg0UMMuoLdDYhX6Uj6WpKQVijK4Dx+ye38NYIFFA1OqPuP2/5B0jaSKWWyY1k10b05B11+smDmqqgBDe+CEhjwyyyi+TIS3hU0h3c0aDYpYSvQovO4TR/tbZNl95GFyFKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523918; c=relaxed/simple;
	bh=yf0dmLD81oWilAUUsvgK/fpGotnLKBaQXTy7Ut3dvEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVeXwLMNE9uYtv7WJsYdZjYHi6bFy1X+RhD0pnAYV8n4etPwGr+G5iHyhgmcF/mTb2otZCzSuL7DLWyw0VffLRdIQt9boHtWkYx0IE4zfN4fIMfxvuxH5RbEibpw2WZSlVGtc5rf5l0B15Uct4BSWhfLoFFeYBubjXZDXXwTFDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7FcUfaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7FcUfaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB562C113D0;
	Mon, 18 Aug 2025 13:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523918;
	bh=yf0dmLD81oWilAUUsvgK/fpGotnLKBaQXTy7Ut3dvEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7FcUfaKXVp/0mLI9jK1KoqlYYpBjL/TCG+ie+0ohrtoaxugEsMG4ZqyaqbWPcYsF
	 L8qgqSpnD1OZCUYtxXoydzR2WWf+/tgetC7jxg7ttXMMwPBwvS245vu7KtS0XPD7+j
	 OtUxzyj/KRMCgaHzsNgwntMwZoYILVRmmfBM+pw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Simon Horman <horms@kernel.org>,
	Joe Damato <joe@dama.to>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 312/515] ionic: clean dbpage in de-init
Date: Mon, 18 Aug 2025 14:44:58 +0200
Message-ID: <20250818124510.445753768@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



