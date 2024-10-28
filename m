Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED4418E368;
	Mon, 28 Oct 2024 06:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098160; cv=none; b=iTVDfPkQu27tAAu15CRfp/Y2w2SoaNQAbyLzCMttPHYFiWqXSHR1c+H2U4QmrXW2j0pfxowACjwnaE+5OtH6ReWG8hMixEVKs+50AFcMspOfNvXlxJe9Hxv0/poiNYsjSd7zL1oHikn6yS/ca2RbsNokkg3sKqklhWE4tAG4bng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098160; c=relaxed/simple;
	bh=uMdTrMAmAacO/ZFV+XIz80fDnj3L/BPrb+miaxZ77SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOkzCXJ1bMD5DAEPco9MzszwKerCptwX7bG8vRvOsXYfqQhbXuhRwldpAoDEkgD8+ixsoHjKPFA1nKmp0hBeYS0CbLkWNnFKmK8sn/Ow+riM0YTu/hUa3ffpguVVyYR5PpzKmGUlkapoZjaCy7Xpn2/Kxvw33tXkSyfmKsTnqlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDZrXqh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDZrXqh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16CAC4CEC3;
	Mon, 28 Oct 2024 06:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098160;
	bh=uMdTrMAmAacO/ZFV+XIz80fDnj3L/BPrb+miaxZ77SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDZrXqh51+aenqmtGkQASks7H80VykPiZN9/gCKl853UBNCxrFVNGZk/jO/+4u6Wj
	 EizKNdyNCW8CzjfuzeGZMgmZD8TxzAGJx0q7d6bOjMOyrPoibP8HhbC6lcGEMRrMpS
	 VmIssqg+OyJhxgp2VQ8ZFuET7goXB8HFnOWAFHsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 056/261] drm/msm: Allocate memory for disp snapshot with kvzalloc()
Date: Mon, 28 Oct 2024 07:23:18 +0100
Message-ID: <20241028062313.422204265@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit e4a45582db1b792c57bdb52c45958264f7fcfbdc ]

With the "drm/msm: add a display mmu fault handler" series [1] we saw
issues in the field where memory allocation was failing when
allocating space for registers in msm_disp_state_dump_regs().
Specifically we were seeing an order 5 allocation fail. It's not
surprising that order 5 allocations will sometimes fail after the
system has been up and running for a while.

There's no need here for contiguous memory. Change the allocation to
kvzalloc() which should make it much less likely to fail.

[1] https://lore.kernel.org/r/20240628214848.4075651-1-quic_abhinavk@quicinc.com/

Fixes: 98659487b845 ("drm/msm: add support to take dpu snapshot")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/619658/
Link: https://lore.kernel.org/r/20241014093605.2.I72441365ffe91f3dceb17db0a8ec976af8139590@changeid
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c b/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
index bb149281d31fa..4d55e3cf570f0 100644
--- a/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
+++ b/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
@@ -26,7 +26,7 @@ static void msm_disp_state_dump_regs(u32 **reg, u32 aligned_len, void __iomem *b
 	end_addr = base_addr + aligned_len;
 
 	if (!(*reg))
-		*reg = kzalloc(len_padded, GFP_KERNEL);
+		*reg = kvzalloc(len_padded, GFP_KERNEL);
 
 	if (*reg)
 		dump_addr = *reg;
@@ -162,7 +162,7 @@ void msm_disp_state_free(void *data)
 
 	list_for_each_entry_safe(block, tmp, &disp_state->blocks, node) {
 		list_del(&block->node);
-		kfree(block->state);
+		kvfree(block->state);
 		kfree(block);
 	}
 
-- 
2.43.0



