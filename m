Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A66DDA9;
	Tue, 20 May 2025 13:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749494; cv=none; b=A9cUbTm2vMHPf+ApkVAlM1zEwj1JCJDuNgOG8+QqYUW7Ko6BX4YlafII/6y4nYeisTEhxVaF9o4JsUVJhaVjsdqap+iFWPltDEzJaSX0B2tgPwZAot9jOs3pclxToADeFyM2aN9YQp736aJ3bMyYYJIHNJOvaQPWkspX7T84rpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749494; c=relaxed/simple;
	bh=Uyjsjr2zu2LrV9Fl1eOR/Sux/ESPFCYfexwEd61eafk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWar9NP5rNG/xzIWRAVkqTR+1szGAsKTMpDCVpx52Fe5W301qB98QF0lSSij9wg8vDIf6boz6zhww4ZQ154aDlmq7AzV6wTilNpulTvcV3JdA+IfF45j9YEsU1OLJ2FvjWpMVcWVHvzacu4QVieePbad0470+DHA2+139HCfDV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ji19dwcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ji19dwcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DE0C4CEE9;
	Tue, 20 May 2025 13:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749494;
	bh=Uyjsjr2zu2LrV9Fl1eOR/Sux/ESPFCYfexwEd61eafk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ji19dwcv99Fya/PZ62+GP2WQLlWOzPhjTNX9TS5tj3t1PIWcIp9uZYGPVFKrVurxj
	 jKnZ8jsoinGUa//ekQk/LIXrlL6HmNnYAVz+TW4QIS0rTr8yPPbKAHmg1AMEYWpjR/
	 qXIEXUR/60byLVIQQ8G0Zr4ljEw0Jfpkr+ShAMg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Daniel Wagner <wagi@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/97] nvme-pci: acquire cq_poll_lock in nvme_poll_irqdisable
Date: Tue, 20 May 2025 15:49:57 +0200
Message-ID: <20250520125801.916683627@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 3d8932133dcecbd9bef1559533c1089601006f45 ]

We need to lock this queue for that condition because the timeout work
executes per-namespace and can poll the poll CQ.

Reported-by: Hannes Reinecke <hare@kernel.org>
Closes: https://lore.kernel.org/all/20240902130728.1999-1-hare@kernel.org/
Fixes: a0fa9647a54e ("NVMe: add blk polling support")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 553e6bb461b39..49a3cb8f1f105 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1154,7 +1154,9 @@ static void nvme_poll_irqdisable(struct nvme_queue *nvmeq)
 	WARN_ON_ONCE(test_bit(NVMEQ_POLLED, &nvmeq->flags));
 
 	disable_irq(pci_irq_vector(pdev, nvmeq->cq_vector));
+	spin_lock(&nvmeq->cq_poll_lock);
 	nvme_poll_cq(nvmeq, NULL);
+	spin_unlock(&nvmeq->cq_poll_lock);
 	enable_irq(pci_irq_vector(pdev, nvmeq->cq_vector));
 }
 
-- 
2.39.5



