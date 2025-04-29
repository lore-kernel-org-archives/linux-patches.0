Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AB722A4F4;
	Tue, 29 Apr 2025 17:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948059; cv=none; b=Jvgz7+0Ncn9HqBvSNiqb79/4+a23Z+Cq6C1ZLW+c8eUpswcF9BTBZduuTUdKVM8oiU2zLVg2uB6IwWrDXq1TI1abd8O8apea6Vdio0PANGTmqlQlHruT9rQkzbdUOQ0juz1AcJrre2aBltzQUpIUlf71grZenX7L+rZVa61lc4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948059; c=relaxed/simple;
	bh=Nl2zxHvNWzAPsl5fT0F0CUmqzywIAhm4rCqFjg4Z9zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHb6RAHjwuHV7LAtOAQa3uQNyYkLeZOl1hhadZfhoMcTywosqpK2r+ihkcv/YEtCnzjawpyTIAAkF/41UYEA9IqhHS25SNYHkZx7PILkG9KSbP2KL6twugRAumKxjZ1n6u29lq8RKM7QN7fpNN+75L7nKI8G4LKWiaHKeiD57rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJ7TH/OI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJ7TH/OI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838A5C4CEEA;
	Tue, 29 Apr 2025 17:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948058;
	bh=Nl2zxHvNWzAPsl5fT0F0CUmqzywIAhm4rCqFjg4Z9zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJ7TH/OICYOC8RQ1weTrOUsMrHlqazBJ4yqMps0MeeRCWJWIc8KKYZt9TS+vyF14L
	 2o+K0v0dktRwGq0oFAyp0zljD2fCZyVfxq8yrJeQJEiakx9vnp3GNSrqEsmAi9+cp8
	 0wbfnHCboeqym4BtsKdK7drj0NNNRL26w8a+sQFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/280] dmaengine: dmatest: Fix dmatest waiting less when interrupted
Date: Tue, 29 Apr 2025 18:42:01 +0200
Message-ID: <20250429161122.473300288@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit e87ca16e99118ab4e130a41bdf12abbf6a87656c ]

Change the "wait for operation finish" logic to take interrupts into
account.

When using dmatest with idxd DMA engine, it's possible that during
longer tests, the interrupt notifying the finish of an operation
happens during wait_event_freezable_timeout(), which causes dmatest to
cleanup all the resources, some of which might still be in use.

This fix ensures that the wait logic correctly handles interrupts,
preventing premature cleanup of resources.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202502171134.8c403348-lkp@intel.com
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20250305230007.590178-1-vinicius.gomes@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmatest.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 91b2fbc0b8647..d891dfca358e2 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -841,9 +841,9 @@ static int dmatest_func(void *data)
 		} else {
 			dma_async_issue_pending(chan);
 
-			wait_event_freezable_timeout(thread->done_wait,
-					done->done,
-					msecs_to_jiffies(params->timeout));
+			wait_event_timeout(thread->done_wait,
+					   done->done,
+					   msecs_to_jiffies(params->timeout));
 
 			status = dma_async_is_tx_complete(chan, cookie, NULL,
 							  NULL);
-- 
2.39.5



