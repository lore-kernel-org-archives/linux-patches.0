Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D727E1D1F6B;
	Wed,  2 Oct 2024 14:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879679; cv=none; b=K0ygz6xtROnQnCu6DcrEJDVDThSoHmkAMcSVM3YXXHCl6ateSd7sv6bfaXweDWFgc3ma64Z4W1fv0h6EFkAWJVJMnsw1G65L5Rf+mtmEpUdLF2DGwhB0vuoaHFND+5kEbl5J/PAefLuSYm9fNfPPsblJdA1GgzTyoNz+CELxAH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879679; c=relaxed/simple;
	bh=iuNCcPNSwFTqqw1roogt3KJk+dSCgXaJpUdF1mdn3bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+s4ALl7pfJbPdAhAfviOndBguNrJLdguFji8u6WRg9lKzSU40CKjyuRR8PzD3Zix437M9u6gYpkGbP02JEpkPoN64zthZxnUF1SW7nTXXjzSef/CeyC/YvMBdHyJM3hGX8Cypa3EhM+LbKltRhVb36bUa5oOlHIt0/MLfCIEUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHys47HN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHys47HN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECA4C4CEC2;
	Wed,  2 Oct 2024 14:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879679;
	bh=iuNCcPNSwFTqqw1roogt3KJk+dSCgXaJpUdF1mdn3bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHys47HNUsbK9F44TWds5ex+DqEO9jT7lxZnHl5wo5U2WfIhCbh7CRe7SdOppOC0n
	 OqmzOwtU5OPc3IvJasnwld8IX23hwcGouZA5sJ+SIN0MT5XRMsrF6bKKkZarNmRD4O
	 3TCnI/LQkroHpJw+kPuV7rFsGkUvmJ0ajmy+/FGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Lypak <vladimir.lypak@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/538] drm/msm/a5xx: properly clear preemption records on resume
Date: Wed,  2 Oct 2024 14:56:39 +0200
Message-ID: <20241002125758.569972819@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f58dd564d122b..67a8ef4adf6b6 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
@@ -204,6 +204,8 @@ void a5xx_preempt_hw_init(struct msm_gpu *gpu)
 		return;
 
 	for (i = 0; i < gpu->nr_rings; i++) {
+		a5xx_gpu->preempt[i]->data = 0;
+		a5xx_gpu->preempt[i]->info = 0;
 		a5xx_gpu->preempt[i]->wptr = 0;
 		a5xx_gpu->preempt[i]->rptr = 0;
 		a5xx_gpu->preempt[i]->rbase = gpu->rb[i]->iova;
-- 
2.43.0



