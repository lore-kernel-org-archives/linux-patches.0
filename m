Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1616380C02;
	Mon, 23 Dec 2024 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969741; cv=none; b=PEUQ+NCUG0oDfetXQeSjdIRo4dj7rV1f0gbzHVsdL0WbtR0dU3gjHpZLO4+nLO2TkG1dq5u4VD99BCKqp2XQYcqMkul/TYD325sYmDrTxYoEe8YC8TApy+ZxDg+8XHQwQLmAM85KUxDGcqf9buLZdKM3qnurCSEoH3A2pMeVMok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969741; c=relaxed/simple;
	bh=3adDSsdXE+W/TNoMGgyw7dwr1Gxb3JR49CIzTC0l01Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9wktMigt5IHTmescZY2ahLCi1ND2F0iCKRL5JaNzhXc7nLmLf3J4NhMtvKMnLfPU552C32ySBl7SD1sKFDaf30Rki/5AlVuhtX+rjannOyVk+SOAQDYiBBOMKpOMNI9gswFlyiISb4VPI6KKnhyl1kt4H3V/3IbvaP89TgM2/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0+sDBUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0+sDBUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E98C4CED3;
	Mon, 23 Dec 2024 16:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969741;
	bh=3adDSsdXE+W/TNoMGgyw7dwr1Gxb3JR49CIzTC0l01Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0+sDBUPXQU3JPZlyKc4yTXSpMvzKyDWlVYhV7LEfTqBNSAdJNQEtCdvcQDAMZAZI
	 m1BBuKoFaWHYZgmeeW+vdR3Cy7pO7ZSOyWzHN8FajyvAhSCB/LVYqVpQYl/ucQZ5Rr
	 1ykFTixWDpSdqstv9nsFF+1yiWbjEG1lqq48vJCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/160] ionic: Fix netdev notifier unregister on failure
Date: Mon, 23 Dec 2024 16:57:31 +0100
Message-ID: <20241223155410.221208833@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 9590d32e090ea2751e131ae5273859ca22f5ac14 ]

If register_netdev() fails, then the driver leaks the netdev notifier.
Fix this by calling ionic_lif_unregister() on register_netdev()
failure. This will also call ionic_lif_unregister_phc() if it has
already been registered.

Fixes: 30b87ab4c0b3 ("ionic: remove lif list concept")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20241212213157.12212-2-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 40496587b2b3..3d3f936779f7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3869,8 +3869,8 @@ int ionic_lif_register(struct ionic_lif *lif)
 	/* only register LIF0 for now */
 	err = register_netdev(lif->netdev);
 	if (err) {
-		dev_err(lif->ionic->dev, "Cannot register net device, aborting\n");
-		ionic_lif_unregister_phc(lif);
+		dev_err(lif->ionic->dev, "Cannot register net device: %d, aborting\n", err);
+		ionic_lif_unregister(lif);
 		return err;
 	}
 
-- 
2.39.5



