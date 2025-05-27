Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEC1263F5E;
	Tue, 27 May 2025 17:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368388; cv=none; b=LV7q8IfBEGRBOS7D2TKXKrlWRovZu/7rekTw96C13GftiPMt4cOvywx4jiIb3Doy81fHiNFL6GKU1+N+JKiLaVRJW51HMvrXxqSts2O0AfIPOmFjoS2ocurUPO6HIpRCJdnX6iGL1dM3H+vghpB7a8HdsFzwEDCOBi3YFoPqYTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368388; c=relaxed/simple;
	bh=i3yrREdgNENkIYk+9qUtvEJKNzr6r8L2azmd7yLMs8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F77VYGWEEwngxk43GkNKrZF4o0DLXE2U9HKJ0mSiNtOp5UHPDd6UG7hQyQWxCAj0onypJ2J+LiO9D3RADBTvVrvgvezMMArE1DNOyF0cw6lUVNF/DeQAU9tdZOyJE2jPB+0jiD0dSgv2cd2V6P1Z9wTXNp+81L0cMypp4HznbDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mwi0Ij6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mwi0Ij6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4AFC4CEE9;
	Tue, 27 May 2025 17:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368387;
	bh=i3yrREdgNENkIYk+9qUtvEJKNzr6r8L2azmd7yLMs8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mwi0Ij6x5/4vWsXzXw+cx6uQC+cNDlvygYiCjkC4r3sJgMET3AnsPm494qo8ec3vh
	 rYNkdJUCukTnI/DYWTffqef4Spl2sFTIf0BHeV1Ow8s8nS5J0hUiehYEbBWX8xAA9w
	 42umH1v7y2T0Um+k3wSklLOJOKDEbtkX7FWQ7BRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 691/783] dmaengine: idxd: Fix ->poll() return value
Date: Tue, 27 May 2025 18:28:08 +0200
Message-ID: <20250527162541.272874877@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit ae74cd15ade833adc289279b5c6f12e78f64d4d7 ]

The fix to block access from different address space did not return a
correct value for ->poll() change.  kernel test bot reported that a
return value of type __poll_t is expected rather than int. Fix to return
POLLNVAL to indicate invalid request.

Fixes: 8dfa57aabff6 ("dmaengine: idxd: Fix allowing write() from different address spaces")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505081851.rwD7jVxg-lkp@intel.com/
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20250508170548.2747425-1-dave.jiang@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index b847b74949f19..cd57067e82180 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -500,7 +500,7 @@ static __poll_t idxd_cdev_poll(struct file *filp,
 	__poll_t out = 0;
 
 	if (current->mm != ctx->mm)
-		return -EPERM;
+		return POLLNVAL;
 
 	poll_wait(filp, &wq->err_queue, wait);
 	spin_lock(&idxd->dev_lock);
-- 
2.39.5



