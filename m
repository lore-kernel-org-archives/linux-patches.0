Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E9623BCFD;
	Mon,  2 Jun 2025 14:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874124; cv=none; b=ZoHCyDb1M976hRd+Zq2BUqlvLmOmdtH9sq6U55qLNDoY78QJpZ8+YsFkgyPXscCQoAfFvHi69Hx9AAbg1oC8zT5maEkqd2DC6dIJ44EnUoU+MlEsiq2f4Lw34AR09Qbq1W89gTV8a5jaQqqDAZ9fOUsrG7XDHhVFiRrABGh5U2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874124; c=relaxed/simple;
	bh=ARGdWd9W1MYoECJRfEHRq2DOlFj9E0fy0UoCyWZBRyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eF3hMf6Rl3Q2F1R0TD2SDsph1dXESUNcbBUKU5Aa01GYM8LY0j7SNXXiGPADyEYHx67jBvx8cJ1e/Ge3z8NfL8QAU+Utq+9JE/RW/XHkbtRl72KN5S0Gf8+h4FOJFLBBEEd1ZIhHQRaslH3pahGzfERSy+ea16f2wdtSN+5/pAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaWN2Hrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaWN2Hrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E2EC4CEF0;
	Mon,  2 Jun 2025 14:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874124;
	bh=ARGdWd9W1MYoECJRfEHRq2DOlFj9E0fy0UoCyWZBRyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DaWN2HrzTgRjByIyHtBEK96IxSa+cwiUm3haKi4ejlMqgRkNdTlXF9X11yRzAP7fI
	 r1mWd7ZRNf6LxvLAsjXWTxONhBQ3r+vVd6NJQYfGwp1pvAyCnzJ9Y1TYJNSb40B3KI
	 8JetcgiQPx6f6u0qBvsdf50cNHCMPaOQb/NA+NGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 338/444] dmaengine: idxd: Fix ->poll() return value
Date: Mon,  2 Jun 2025 15:46:42 +0200
Message-ID: <20250602134354.645512681@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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
index ba53675ced55a..6cfcef3cf4cd1 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -505,7 +505,7 @@ static __poll_t idxd_cdev_poll(struct file *filp,
 	__poll_t out = 0;
 
 	if (current->mm != ctx->mm)
-		return -EPERM;
+		return POLLNVAL;
 
 	poll_wait(filp, &wq->err_queue, wait);
 	spin_lock(&idxd->dev_lock);
-- 
2.39.5



