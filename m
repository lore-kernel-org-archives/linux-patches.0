Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116C9367;
	Tue, 27 May 2025 17:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366010; cv=none; b=ekHnkJ6FqK91F+mCQAy+k06Y4+QEzLxweu+dzhRwQ0B1aJN6sjIeXkeaO0NcajhU8yPNjYZ6lYwwBFPaN/ysLLybM4la8tedToV74nRnfcMrEkkxc09WPmPfb22a4CniCV8VppRUXkfFJWaF8aLiws5IH2cmOlOonQ7PAvkem10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366010; c=relaxed/simple;
	bh=BXeYjt+ndfJrgK/SIQMfDE0m/BgA5s22IhQ3bxAZc+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbCXHZEXN6F3/katGxjilSPyK4aUf4EUUSUSxRTEAqGwmsLVRHLa23C6we7qoc/WQd04iT7aH0LAr9Q4ylJ7KQTReGueZuW/hgQNAQzEOr54WitLC7Frg+MvbZS0U/pQdCFcHgzbUtn9e6bhcaGpEQzrbFP2TynFnhnLG+xHEFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZkG0kJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZkG0kJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A795C4CEE9;
	Tue, 27 May 2025 17:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366009;
	bh=BXeYjt+ndfJrgK/SIQMfDE0m/BgA5s22IhQ3bxAZc+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZkG0kJFGUPGOr07bHx6IpaAHMQB/InkH9Ne3N8SFWjvEXqNzkCULtzkWyjw1+y2m
	 1pff8MymRTWga8/kLPbGtjvjb5bXE0rGgLgKHQU7qZDgiug+lNMi3GIB/RN6mFJWRg
	 KTxEZCsFptYjhqeZTyWVcsONk4zNA52IbUO8QvuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 544/626] dmaengine: idxd: Fix ->poll() return value
Date: Tue, 27 May 2025 18:27:17 +0200
Message-ID: <20250527162507.090523678@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index 928b8ab8499a7..22aa2bab3693c 100644
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



