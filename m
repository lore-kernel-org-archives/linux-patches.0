Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFF3258ED7;
	Mon, 18 Aug 2025 13:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522349; cv=none; b=BvXbGNvd6Zq823uFdjjeNVZGNaB27avZWZMGVY2xYt+MbBA4Gq4BvIzSkH7hFNsGpxBoZrKUSI8KAci0vfq3l3c8oZ4Bf3sSZPxIQyYgBaQIJQBGgSU6gUs3SlI72HZhLKuiWQOzUnaVPqOBJGBKUQjF7DoWF0LUzcqozBENtbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522349; c=relaxed/simple;
	bh=FQz3ce+8Rrdwgayoc4R165FiGXJJe2Ozy1Pv5OxlNgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAZHuVfgE0VsJrRRCY3zHEqFOepfZTkI0Iod7uNBh36BAVqkldCdTV5+ebIcLt5HFy1Vv8MZEK/8tzGY2nRLUZm0tGKKj4CSBAtNdbdlDAHngM9fYPSehKzW5FZKU+UfRWSukeN24SLxlDsQRMDKPuBLw/MVlOwvO8bjKj4e7tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3WTVMpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3WTVMpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9E2C4CEEB;
	Mon, 18 Aug 2025 13:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522348;
	bh=FQz3ce+8Rrdwgayoc4R165FiGXJJe2Ozy1Pv5OxlNgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3WTVMpb8cPi0vW3OjVxqSJZcDk0F+Q0OmMQ7+gA2zGsf13GiCPKxkDzopJOXc+u0
	 6NU/UJ9e/AMI2rB3f/78f1Xuyu/5iEvS8//1jA1X9lw+ipoc7VGJ0vgMVXp+NfIQBu
	 ovAEuxRHXpar/PR/Sr0xJTbDFgMOrSg95aOZijoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Simon Horman <horms@kernel.org>,
	Joe Damato <joe@dama.to>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 257/444] ionic: clean dbpage in de-init
Date: Mon, 18 Aug 2025 14:44:43 +0200
Message-ID: <20250818124458.469910171@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3d3f936779f7..d6bea7152805 100644
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



