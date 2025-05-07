Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3972116E9;
	Wed,  7 May 2025 18:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644073; cv=none; b=O1e7/rTJ7wYU0g2DQW342b6HbqL0atNWSzMPIpaFxf1+PjZA1lcO5JmdQ9x0FesfvHHwoiGTAfWZMBNLz2nuoNLt7aP1VxOb/WA9tt4SmqfLYvvfgWoW6cdYvggH5GJ5SrewpDwY4ZMfIqDhfQJPtrbwWHW3ue0Hjl1p1fFmGss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644073; c=relaxed/simple;
	bh=u1I1pGbWduTDLtO+xO9tuK6N11GmdYuNNra1v+p8zu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZsGboyx2i4259s54asmwe3SrxPuaz2SplFyjFT2+7CND1Y94jT9I0V5Jpl5bT5i0XhGdyhFtUwcQd4Nc2/2ZdYHo17cXid1MkVJzsmS8vPVD5+ky16ApxN4/jqSsk7GUQWbKUCIId70tAWL54HMSiDqReQFICG7e6tmn5lxxqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+waLzGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+waLzGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C138CC4CEE2;
	Wed,  7 May 2025 18:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644073;
	bh=u1I1pGbWduTDLtO+xO9tuK6N11GmdYuNNra1v+p8zu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+waLzGAUj8QonJMYaWqq1T1gNk5ZociyLRQEvLySupF9gYGzBaQFEh0HP/HXi1x+
	 CcqNOe9DUQk9CcbtiDnwZxyVHkNAfv/jG1E5cjikltqEWnxsirc1Mar6K/llgUJeoR
	 g+NIoRs5hm3y2o/9SSkL+PrFo3x2l4dn/A+QPwL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhankaran Singh Ajravat <dhankaran@meta.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 109/183] nvme-pci: fix queue unquiesce check on slot_reset
Date: Wed,  7 May 2025 20:39:14 +0200
Message-ID: <20250507183829.244979805@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 1dc12784efafc..d49b69565d04c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3578,7 +3578,7 @@ static pci_ers_result_t nvme_slot_reset(struct pci_dev *pdev)
 
 	dev_info(dev->ctrl.device, "restart after slot reset\n");
 	pci_restore_state(pdev);
-	if (!nvme_try_sched_reset(&dev->ctrl))
+	if (nvme_try_sched_reset(&dev->ctrl))
 		nvme_unquiesce_io_queues(&dev->ctrl);
 	return PCI_ERS_RESULT_RECOVERED;
 }
-- 
2.39.5



