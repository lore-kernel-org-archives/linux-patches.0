Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B6E252917;
	Mon, 29 Dec 2025 16:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025442; cv=none; b=buw3kYqQ/gw/c+HIjxAnCwqq3bxY2B1IuXKD16ScCE6bZ1HCAph5wNsQ59c/0XjdToKJhZb/uWbs3yI+1yD2uDBQGAl5NUEk+NvSU1BD/WAq/MZdgdhcum+Te+9YxncTDZnk3DzhZgGAF+gwylsd2ex9i6PRhj6x+kH3DbJxGWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025442; c=relaxed/simple;
	bh=wUEk8rZ0RKJg/gqASDp7Gv7bc3k89woTvrp8beV5MEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpYeORSn4MPwSuclJCdFxM4YRYuDMHh64tIxvRNQw2QYzTn8sO+w8WpapM6WxqXo7YYqXHihkzdhkjHgrC9r/ouNL346/FRUvRJ69PKponWTadYKk9mDaX5CM3GjAyQnCgQj/YLsvGJ+6dvYIMxV2O0PgsQhvz45egNWV8Y7SQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNx0n78R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNx0n78R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56475C116C6;
	Mon, 29 Dec 2025 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025440;
	bh=wUEk8rZ0RKJg/gqASDp7Gv7bc3k89woTvrp8beV5MEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNx0n78RLO0lbTDZSTrh6cNr8yx56p6GumSSHFQsUlVvtxQRYbokHU+i51nhPHt70
	 frqoosONgBYZLU1KFDBqoT+N7/sPIlPGS57zBUzKmZEhFxEsHbpRsLZIFCXoPHIqgr
	 2cXML/rBlfk/ohrbo81di2rZMmqLyNBWKSH6HIbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 215/430] drm/msm/a6xx: move preempt_prepare_postamble after error check
Date: Mon, 29 Dec 2025 17:10:17 +0100
Message-ID: <20251229160732.264751055@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit ef3b04091fd8bc737dc45312375df8625b8318e2 ]

Move the call to preempt_prepare_postamble() after verifying that
preempt_postamble_ptr is valid. If preempt_postamble_ptr is NULL,
dereferencing it in preempt_prepare_postamble() would lead to a crash.

This change avoids calling the preparation function when the
postamble allocation has failed, preventing potential NULL pointer
dereference and ensuring proper error handling.

Fixes: 50117cad0c50 ("drm/msm/a6xx: Use posamble to reset counters on preemption")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Patchwork: https://patchwork.freedesktop.org/patch/687659/
Message-ID: <20251113082839.3821867-1-alok.a.tiwari@oracle.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_preempt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_preempt.c b/drivers/gpu/drm/msm/adreno/a6xx_preempt.c
index afc5f4aa3b17..747a22afad9f 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_preempt.c
@@ -454,11 +454,11 @@ void a6xx_preempt_init(struct msm_gpu *gpu)
 			gpu->vm, &a6xx_gpu->preempt_postamble_bo,
 			&a6xx_gpu->preempt_postamble_iova);
 
-	preempt_prepare_postamble(a6xx_gpu);
-
 	if (IS_ERR(a6xx_gpu->preempt_postamble_ptr))
 		goto fail;
 
+	preempt_prepare_postamble(a6xx_gpu);
+
 	timer_setup(&a6xx_gpu->preempt_timer, a6xx_preempt_timer, 0);
 
 	return;
-- 
2.51.0



