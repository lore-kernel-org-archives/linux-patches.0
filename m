Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B121C07C4;
	Tue, 15 Oct 2024 13:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997240; cv=none; b=tWrBsjpFUb4Nlkyo5Pq+GXLwYrM8fvMLjJhM9+/FFkHR06Bn17UxUsawJ2+pyVW5I+0MX7f6v/u/tgcWs4beamS88QTmCW3qfCedjCWr3TTjIi15rZ8AluoGGEB7St2dBs205AqlLRcfHFrrTc9WzUqyAfFtW1ZmXvR+aXt5Hlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997240; c=relaxed/simple;
	bh=OvAQIZV8iwVxUUBHYzlriFZmXD1DCwooqhTrwFMOuaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMq86Vps1Ti/TgMR/NrPhutLSLmKry6768XXRVjo3Cdm/ukmfm3xNMH3hz1TXRgdfMyA6bx8Ay2yakRnM9eH1XQ24/03QOHMuVZCwsRbhSGSp7PzxzxjLvnuZ5elsjtAkH9zlxcy/527pjAhJK9sqdGxvyWrJhYsXdFX8NAmbsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYxYDv9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYxYDv9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A45C4CEC6;
	Tue, 15 Oct 2024 13:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997239;
	bh=OvAQIZV8iwVxUUBHYzlriFZmXD1DCwooqhTrwFMOuaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYxYDv9aKy2WR2dKOy59ZqRn7AExc4MVS2jTcnv75idkaw+wAEy4LCTuprcnidxPQ
	 SKUXly/80XXNhBOiTlR3QMlYvZBzbxsns/P2ZR9/rSDyN8IZBs3uDTEXTtQApZYODr
	 r0uAP99Ww+kCNEBA00s1wIlG4w/9t5doTSoONmcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Lypak <vladimir.lypak@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/518] drm/msm/a5xx: properly clear preemption records on resume
Date: Tue, 15 Oct 2024 14:40:29 +0200
Message-ID: <20241015123921.820698967@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Vladimir Lypak <vladimir.lypak@gmail.com>

[ Upstream commit 64fd6d01a52904bdbda0ce810a45a428c995a4ca ]

Two fields of preempt_record which are used by CP aren't reset on
resume: "data" and "info". This is the reason behind faults which happen
when we try to switch to the ring that was active last before suspend.
In addition those faults can't be recovered from because we use suspend
and resume to do so (keeping values of those fields again).

Fixes: b1fc2839d2f9 ("drm/msm: Implement preemption for A5XX targets")
Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/612043/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
index b8e71ad6f8d8a..ad72aeb7041b4 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
@@ -207,6 +207,8 @@ void a5xx_preempt_hw_init(struct msm_gpu *gpu)
 		return;
 
 	for (i = 0; i < gpu->nr_rings; i++) {
+		a5xx_gpu->preempt[i]->data = 0;
+		a5xx_gpu->preempt[i]->info = 0;
 		a5xx_gpu->preempt[i]->wptr = 0;
 		a5xx_gpu->preempt[i]->rptr = 0;
 		a5xx_gpu->preempt[i]->rbase = gpu->rb[i]->iova;
-- 
2.43.0



