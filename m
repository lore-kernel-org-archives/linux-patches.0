Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0EA85C65;
	Tue, 14 May 2024 11:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687184; cv=none; b=Oo1NzvkIHIfhy/L72w4uL0OZycVeJXpJjH0iNlj+UERnVSjCbEV8qMpyFNFfdIAoW62UtahScwHBMhR3eT68iGMs98NQMoWlV8xl2WtHTf8ZN2ptOFOL3KNEU06i5HjJjTm7emf2eXlWX8l8PRAQDWVOxJFluekQzkE5zucv4Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687184; c=relaxed/simple;
	bh=6RuABS4oIpkm/gIyyLXEkwzypYFPJUDUr2IWcNcqkQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9FiyCxtg9MbPSLM2x6ouezG+kfhUGDWnuerkpkpk6yiKWMHAAQtonW0068K77HUI1CzkWaUs3/SmVWaNohlDdk49shR1YTK2RffjNRqYh5JrkYaBokSS2W597+c/0ULGh1+WqRD6UJ67QJ+y3dbRi7Xt1S1U2Kvuw/EwA3mg5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUbK+uAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUbK+uAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E078BC2BD10;
	Tue, 14 May 2024 11:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687184;
	bh=6RuABS4oIpkm/gIyyLXEkwzypYFPJUDUr2IWcNcqkQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUbK+uAn1iQpdgdqZZOeg5WtYRWrcRlMO3L90QMy6n9Z/yP2y8kwuxAkaajdA0llX
	 1gBVsqfUtDr9+OkQIvHAqbJg4keDsRfZWecP3ODpx2K4w5t8t5gB8yoBmU1VsLRDUq
	 Jl9S8uLMsPGgGP+PaN+yHlgMiPNTn+zirCh/kFCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bumyong Lee <bumyong.lee@samsung.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/111] dmaengine: pl330: issue_pending waits until WFP state
Date: Tue, 14 May 2024 12:18:59 +0200
Message-ID: <20240514100957.174837993@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bumyong Lee <bumyong.lee@samsung.com>

[ Upstream commit 22a9d9585812440211b0b34a6bc02ade62314be4 ]

According to DMA-330 errata notice[1] 71930, DMAKILL
cannot clear internal signal, named pipeline_req_active.
it makes that pl330 would wait forever in WFP state
although dma already send dma request if pl330 gets
dma request before entering WFP state.

The errata suggests that polling until entering WFP state
as workaround and then peripherals allows to issue dma request.

[1]: https://developer.arm.com/documentation/genc008428/latest

Signed-off-by: Bumyong Lee <bumyong.lee@samsung.com>
Link: https://lore.kernel.org/r/20231219055026.118695-1-bumyong.lee@samsung.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: afc89870ea67 ("dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP state"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pl330.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 627aa9e9bc12a..c71b5c8255217 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1053,6 +1053,9 @@ static bool _trigger(struct pl330_thread *thrd)
 
 	thrd->req_running = idx;
 
+	if (desc->rqtype == DMA_MEM_TO_DEV || desc->rqtype == DMA_DEV_TO_MEM)
+		UNTIL(thrd, PL330_STATE_WFP);
+
 	return true;
 }
 
-- 
2.43.0



