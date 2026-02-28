Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF563451A7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301747; cv=none; b=FtCV8JQqp05jIcDsjX7DPtcdkuJvrWMdKQuxq61G2QxHs7HxRebAsuO3S8exDEOmUmCu7DSxhkoNDJe8CNSVTZ7XpFlqD2RuoIawnjjjMgMy+VgvPYU/yXEhX+Umf739/jVQNosXrLuohRxv8ligbwqdpY3KwFTTaR9uX8lVs1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301747; c=relaxed/simple;
	bh=o8kgWcVdcYcnSjRWJaeWuVN67QZzESu3IbTqgu9Doco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JamlbeDTeSNB9l4j5iVbyBa6JpxlErbWvui7AYTGdc7LdVJlUIt2cBaetYXLmLPCG+fKtuOHY3DKpV8fIGPYIDo4ruog08Lou01HgoSfOZ6/0pqPN9zMneGaFEDHc8EE/IMgUOerc5YXQ024H4nE+gM+KFv/IbX+J1ydt73pvBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9GPA2sH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9GPA2sH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08562C116D0;
	Sat, 28 Feb 2026 18:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301746;
	bh=o8kgWcVdcYcnSjRWJaeWuVN67QZzESu3IbTqgu9Doco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9GPA2sH3fmtjF+n4FKUHaFILdYTRO2Os7mhrd9GsFMfpI8jEbiGODAdJ1b3mA5fz
	 kWmej6M92rYw477myc9ma1amDQRuVcdJ1WhVQRm+Q4Ul0HalhIPETMFDz1bikjwUuT
	 ofCKlUaLXEfrzoE5b4xQ/QAU4kRnQJwor1XoVXzpkA4jAbonCPZamUMzIwHRH3YFOt
	 EDxjq8OelqTAkOGbybqHN2vPuFGm07JtFm+KXVZAL6XGs996WzEvgSzNB5FfRRz0+Z
	 YAQDqcD5JUQP6JlwImvEE3byfjjTIHdLwjGXdqvUcXm+rjjT0v8uGbTJiFdKL3IS4i
	 hv3Er3XSCb2/Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Gang BA <Gang.Ba@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/385] drm/amdkfd: Fix signal_eviction_fence() bool return value
Date: Sat, 28 Feb 2026 12:56:11 -0500
Message-ID: <20260228180011.1568201-149-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 31dc58adda9874420ab8fa5a2f9c43377745753a ]

signal_eviction_fence() is declared to return bool, but returns -EINVAL
when no eviction fence is present.  This makes the "no fence" or "the
NULL-fence" path evaluate to true and triggers a Smatch warning.

v2: Return true instead to explicitly indicate that there is no eviction
fence to signal and that eviction is already complete. This matches the
existing caller logic where a NULL fence means "nothing to do" and
allows restore handling to proceed normally. (Christian)

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_process.c:2099 signal_eviction_fence()
warn: '(-22)' is not bool

drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_process.c
    2090 static bool signal_eviction_fence(struct kfd_process *p)
                ^^^^

    2091 {
    2092         struct dma_fence *ef;
    2093         bool ret;
    2094
    2095         rcu_read_lock();
    2096         ef = dma_fence_get_rcu_safe(&p->ef);
    2097         rcu_read_unlock();
    2098         if (!ef)
--> 2099                 return -EINVAL;

		This should be either true or false.
		Probably true because presumably
		it has been tested?

    2100
    2101         ret = dma_fence_check_and_signal(ef);
    2102         dma_fence_put(ef);
    2103
    2104         return ret;
    2105 }

Fixes: 37865e02e6cc ("drm/amdkfd: Fix eviction fence handling")
Reported by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Philip Yang <Philip.Yang@amd.com>
Cc: Gang BA <Gang.Ba@amd.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 45923da7709fd..64f3a0687f8a2 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1970,7 +1970,7 @@ static int signal_eviction_fence(struct kfd_process *p)
 	ef = dma_fence_get_rcu_safe(&p->ef);
 	rcu_read_unlock();
 	if (!ef)
-		return -EINVAL;
+		return true;
 
 	ret = dma_fence_signal(ef);
 	dma_fence_put(ef);
-- 
2.51.0

