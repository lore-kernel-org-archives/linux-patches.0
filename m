Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FD717A2F0;
	Tue, 15 Jul 2025 13:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586621; cv=none; b=c9p7hHByojaxWFoonmf1DQ+zhmx/qvR+q7Ra7HAcOd7QEUnye4fs9NLKA7+PN2r8GrktwwizDTvZaXZ6cf+x9tVZOg0sal2R/lkUQsssQl9l7qr4JX0MuMAvU0xcLgwA7d0j1ocQVMjB2/fPVqYnr0QUw+DW0mV3SESlqbKSveo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586621; c=relaxed/simple;
	bh=OuCRXtKyatBJVJNYG+m+1euWRcbGkRX7RvalsP8sNQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YwP0gMONM2ahWNPpwiZ1ET9nMatRZBB796OqkpZPvLFNTSbm9xbxSId9ZsBup5eAw5uCUBmPP6UoO6x5k3ecggca2oRMMWzw9vp72I1RUkXM13/OGj594vb3VlXmxFsFGc8tkdpN/k5Wk3ZHCFxYhofETZSf19XdqjWyUp2jwpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbZCr/v4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbZCr/v4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870F4C4CEE3;
	Tue, 15 Jul 2025 13:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586620;
	bh=OuCRXtKyatBJVJNYG+m+1euWRcbGkRX7RvalsP8sNQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbZCr/v4tjMtnlirSLc7Mk0mwnsR7KRSuRlP85JJ1D+8KtY6+BaPBRLL+s0bXkANY
	 ouJ9LY4bPikodgelDg2b9uvK1U9AQGzjRnpbstpywJb59A3WTGop2ma203JSArF36j
	 rSzaruOgbPbmqwAOcyZob1biFNF+2BymJcS3au3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 133/148] dma-buf: fix timeout handling in dma_resv_wait_timeout v2
Date: Tue, 15 Jul 2025 15:14:15 +0200
Message-ID: <20250715130805.615602153@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 2b95a7db6e0f75587bffddbb490399cbb87e4985 ]

Even the kerneldoc says that with a zero timeout the function should not
wait for anything, but still return 1 to indicate that the fences are
signaled now.

Unfortunately that isn't what was implemented, instead of only returning
1 we also waited for at least one jiffies.

Fix that by adjusting the handling to what the function is actually
documented to do.

v2: improve code readability

Reported-by: Marek Olšák <marek.olsak@amd.com>
Reported-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20250129105841.1806-1-christian.koenig@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-resv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-resv.c b/drivers/dma-buf/dma-resv.c
index 242a9ec295cf8..f00ecbaa7868b 100644
--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -558,10 +558,13 @@ long dma_resv_wait_timeout_rcu(struct dma_resv *obj,
 			goto retry;
 		}
 
-		ret = dma_fence_wait_timeout(fence, intr, ret);
+		ret = dma_fence_wait_timeout(fence, intr, timeout);
 		dma_fence_put(fence);
 		if (ret > 0 && wait_all && (i + 1 < shared_count))
 			goto retry;
+		/* Even for zero timeout the return value is 1 */
+		if (ret > 0 && timeout == 0)
+			ret = 1;
 	}
 	return ret;
 
-- 
2.39.5



