Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB76221D92;
	Tue, 29 Apr 2025 18:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949957; cv=none; b=j2JE+CtIKm4pLYb2JM4U1fnwwN6Kv2Vlr0U0M7WpzrLsx4qtjTchuKMlexlgwpdbC7/Xqg2ww3i99N/NcnJ3jcDFXSndmumcR+GP8gwPco59ylyEP//5MbOTQ3AQZNwGKmvfctg/+Slpeng2PhcYenUoQkDRAIGUUaQBygidVJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949957; c=relaxed/simple;
	bh=F9+rMlMUH+OqLAm/erUko+c5HmiY4cEwWSxnOsUT/2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/KMrXfkbQTaxeGJ/6+3J0ZhrpgwZOCHna5r8/KCxZ1xCoo8QBImHTLU2jDTvMYI0gs981QqDBaqBaTZ8fP3lQawPChOWhJvN/4n1GwssJKvOy2dpqn1cEnuDTnjFk8ejgFKNnJEumyhjPcIUOTaIPrZFkhMZBWCsm3cLZkVpbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfae1Lut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfae1Lut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34812C4CEE3;
	Tue, 29 Apr 2025 18:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949956;
	bh=F9+rMlMUH+OqLAm/erUko+c5HmiY4cEwWSxnOsUT/2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfae1LuthvMWXGsHw7JNpOQt7Bu5P5pu5FQvz33KbcDh+6q2ZecY8iY0EFr9zltZO
	 ln4VKJEvYiO/l+dN7WFpfdQo9Q+mqic4G8teDANqsD4Pskk2dAc7eIN4Z916LDvC1e
	 fokP7MnZF488ywtm8i3xOdi2+OIUUhrelBBXXz1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/167] dmaengine: dmatest: Fix dmatest waiting less when interrupted
Date: Tue, 29 Apr 2025 18:43:38 +0200
Message-ID: <20250429161056.191282131@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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
index ffe621695e472..78b8a97b23637 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -827,9 +827,9 @@ static int dmatest_func(void *data)
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



