Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AEC2E7BD8;
	Tue, 15 Jul 2025 13:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587905; cv=none; b=Kyyx7AAM6fUDbOjlnuN+o7yH8ys9/Nvyces3J5/JmeJbBz8+dgVTupwwP4dWeIYbl98jPyGoU3YPk4g3BvXeyBZMvkS+2sJ/wkdnvDfjb9pBuMHcH38biwNtk6z/YwKaujjwbqqW7D5Ua8CGcnQaDgDjF410/vaBfqcSm/iqEsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587905; c=relaxed/simple;
	bh=/eCMuKI9Gz43dhc+SqjpQSeHKd9qMDggWiLPVmyQmQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dPjmve4IsYQUeip4IHhWXLuItnL6ve7nIhq1ycr6NCdGoSTO/0Rrv5ath0oCA4r54Lop5iM8GA9qKBUB+BdPsG3bmLFs/uH/an6YHq89daLVZjNH9tRQJSQhavRAtJ1k3xPA7qK1CtNzQHVNZ83uRqr3Xb3i0y1unQTjFa5A70c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrQgHJiR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrQgHJiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021C6C4AF0B;
	Tue, 15 Jul 2025 13:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587904;
	bh=/eCMuKI9Gz43dhc+SqjpQSeHKd9qMDggWiLPVmyQmQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrQgHJiRO0Pur1ZRRwzZW8qtWf2bi/ve42gY7wUGwXjpmmSzhIm01bdx+B3ILl3md
	 kH2bbCYr4om28hukJv/DFlyHsgsXtxze+NrEaorUDb2ySpnKa33vchDtOzNIpDFdle
	 J4dcXZtdNDXVuJQz208ZN8guImvBqkfD95x3dHYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/208] dma-buf: fix timeout handling in dma_resv_wait_timeout v2
Date: Tue, 15 Jul 2025 15:14:55 +0200
Message-ID: <20250715130818.402874491@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/dma-buf/dma-resv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-resv.c b/drivers/dma-buf/dma-resv.c
index 1187e5e80eded..539cb4e043386 100644
--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -591,7 +591,7 @@ long dma_resv_wait_timeout_rcu(struct dma_resv *obj,
 			goto retry;
 		}
 
-		ret = dma_fence_wait_timeout(fence, intr, ret);
+		ret = dma_fence_wait_timeout(fence, intr, timeout);
 		dma_fence_put(fence);
 		if (ret > 0 && wait_all && (i + 1 < shared_count))
 			goto retry;
-- 
2.39.5



