Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441E92144C1;
	Wed,  7 May 2025 19:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645044; cv=none; b=PzdzbvW21GhpctaFG6qL4SX2v2kIX0Wujj4NY4QlBEKoHk4pseCrJJlTQmkIL8YxXd3TnG4S2YfUpU44zrmJeaseptRuFmQPpLpcmbpWX5wS69xlUXl9iOhscP913Vj60OQTnHwHyZn233NB0KSV4JjrMpMQBTxi0NENHYSzpUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645044; c=relaxed/simple;
	bh=bVW+ZBkEgJ5bC3rHqKA7x65hGC5tPMaOGgiSwfK4tfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEdRRSP5weQFvjWX1BCeJpMtRE4adY3X/4FpokB9ujACvavTYju46Cf/d5q8d2pOfnlxmHOxCPHAcsNIDPuf3pn9V3NqHo75MP9GIme2LPYV+XfMk1yQHAJk8F7qQ8fA9gH38xMw+RvS5tjEGeOe8Mij2cM3SH3etpZ5203L+dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnBB/86o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnBB/86o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5112AC4CEE2;
	Wed,  7 May 2025 19:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645042;
	bh=bVW+ZBkEgJ5bC3rHqKA7x65hGC5tPMaOGgiSwfK4tfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnBB/86oQuF0Gl+dtF9vQED1SMOS88rj2u+jewFOvAeX1cMWyNxGBn20xpXr68d+e
	 uOdk88IlH4Snt/jbr4Z3cz6hQKUhIi2N/IfOJMmzOT42lL/GndZjalDUwB5r3I0SSt
	 h/CfquZjjyqwdgDXenDWErq1owhFfkyvsLC5d69s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhankaran Singh Ajravat <dhankaran@meta.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/129] nvme-pci: fix queue unquiesce check on slot_reset
Date: Wed,  7 May 2025 20:40:10 +0200
Message-ID: <20250507183816.516476670@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit a75401227eeb827b1a162df1aa9d5b33da921c43 ]

A zero return means the reset was successfully scheduled. We don't want
to unquiesce the queues while the reset_work is pending, as that will
just flush out requeued requests to a failed completion.

Fixes: 71a5bb153be104 ("nvme: ensure disabling pairs with unquiesce")
Reported-by: Dhankaran Singh Ajravat <dhankaran@meta.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index a763df0200ab4..fdde38903ebcd 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3377,7 +3377,7 @@ static pci_ers_result_t nvme_slot_reset(struct pci_dev *pdev)
 
 	dev_info(dev->ctrl.device, "restart after slot reset\n");
 	pci_restore_state(pdev);
-	if (!nvme_try_sched_reset(&dev->ctrl))
+	if (nvme_try_sched_reset(&dev->ctrl))
 		nvme_unquiesce_io_queues(&dev->ctrl);
 	return PCI_ERS_RESULT_RECOVERED;
 }
-- 
2.39.5



