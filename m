Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B63266581;
	Tue, 31 Mar 2026 16:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974633; cv=none; b=Kn+fPztRJ8SMpEiFc8hcglLwAWAbQsJK1P3GVBhD5I5O2ExK3VFFU8MkHCC7s6+iXHA23pBXtkxLxRrgBnwhwVIwxaia6tVP4yWhjf+rtSnY8a7wAC5Snd+DOdhuYFs7i30Xf2gwYVs1wiiT2UhZDMmLyUmC+GcrwMaaAzVjLNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974633; c=relaxed/simple;
	bh=6dkGKJxu97Gt3xGy7nLJLFb/o+gVdYZalma8zh33wEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8qGq/xtm8rkTZnA7hyI8alCoO9ESD+f/ttS2xT9VajrMQGL0pN0YrnS2mfn7f05U5vy7u11OTZSdWtPahTGEEp3QuUPxqe7qwK33sSlF8m5kI+iFz9ijRY5s2OK1eKKk39X2OZPYs8YB5YpV7n+RVeBIw4Q8VJXmrSF8IlAhMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9bfj2ke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9bfj2ke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E29C19423;
	Tue, 31 Mar 2026 16:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974633;
	bh=6dkGKJxu97Gt3xGy7nLJLFb/o+gVdYZalma8zh33wEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9bfj2keMyOu5AlddoWvSy+K7a/mN7QY+dTlDPCgfGgYUqENzPHERk6SqjswPKjHA
	 fONIV2FG1qVLam4tyIMrHOtgNNpat7X0PkD8vHpoQDQRKIDBON1u4ivxT9OBdqvtI1
	 oOsvX86IVTe0618Bpqc9iR9wwwuBAYyrqKiokhEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/175] dmaengine: idxd: Fix memory leak when a wq is reset
Date: Tue, 31 Mar 2026 18:22:25 +0200
Message-ID: <20260331161735.713054568@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit d9cfb5193a047a92a4d3c0e91ea4cc87c8f7c478 ]

idxd_wq_disable_cleanup() which is called from the reset path for a
workqueue, sets the wq type to NONE, which for other parts of the
driver mean that the wq is empty (all its resources were released).

Only set the wq type to NONE after its resources are released.

Fixes: da32b28c95a7 ("dmaengine: idxd: cleanup workqueue config after disabling")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-8-7ed70658a9d1@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 542d340552dd7..44bbeb3acd14e 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -173,6 +173,7 @@ void idxd_wq_free_resources(struct idxd_wq *wq)
 	free_descs(wq);
 	dma_free_coherent(dev, wq->compls_size, wq->compls, wq->compls_addr);
 	sbitmap_queue_free(&wq->sbq);
+	wq->type = IDXD_WQT_NONE;
 }
 
 int idxd_wq_enable(struct idxd_wq *wq)
@@ -365,7 +366,6 @@ static void idxd_wq_disable_cleanup(struct idxd_wq *wq)
 	lockdep_assert_held(&wq->wq_lock);
 	wq->state = IDXD_WQ_DISABLED;
 	memset(wq->wqcfg, 0, idxd->wqcfg_size);
-	wq->type = IDXD_WQT_NONE;
 	wq->threshold = 0;
 	wq->priority = 0;
 	wq->enqcmds_retries = IDXD_ENQCMDS_RETRIES;
@@ -1507,7 +1507,6 @@ void drv_disable_wq(struct idxd_wq *wq)
 	idxd_wq_reset(wq);
 	idxd_wq_free_resources(wq);
 	percpu_ref_exit(&wq->wq_active);
-	wq->type = IDXD_WQT_NONE;
 	wq->client_count = 0;
 }
 
-- 
2.53.0



