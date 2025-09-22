Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63107136351;
	Mon, 22 Sep 2025 19:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570367; cv=none; b=nCU3JTwnwdNchszNxxQ0VMxuDcP0f6GhfYpUnuTxUIcEAWVrkBj8TvEv57BC2GfGNSynHYEBgkfUxvuK3hmFVa7WcJMET1EwEZ2qf8q3vNFtsQ4MYa3EiqlItlCvcrodgCu0o2ycsxcnk9iJ9DeTDulsaxs5XvaD9Y4isHtP5lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570367; c=relaxed/simple;
	bh=qhh2n9+Ou5ylrj4q/dsKsEVHFSr37UyLRE6SM43DyAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxCmxiAHOizc8HD3UOtibqfq8Vv/Gs5wFGpkOsojD+vqNtONbx5IJ4qs+2PvmC/8unGvAzRBVvjqYLFZnfuA8qkWKziFCLFaJ6SuVNxKPky+cOr7n3d/kXe7rx/jDup/58+9b7gQUjKimW6kFJQk3COnNel2foaSCt1gCJL6XCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywbB7Nyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywbB7Nyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05B5C4CEF0;
	Mon, 22 Sep 2025 19:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570367;
	bh=qhh2n9+Ou5ylrj4q/dsKsEVHFSr37UyLRE6SM43DyAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywbB7Nyz/XoIL+VRxOkTwf6Yt3eowo65l1zZ9IBvUKBvRgOf2uT7VmnQ4eEFe/zgW
	 u6RU1M/CvQmyleTBzRkUtPrxTrS4vDzOtD1qj1fHGtOyGhkWMbiLQ0kGNY6ppHz8ZQ
	 JZJm9WIYP06ZGSF2N1nC6sqS+SbeXnafDUpVCX/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 121/149] drm/xe: Fix a NULL vs IS_ERR() in xe_vm_add_compute_exec_queue()
Date: Mon, 22 Sep 2025 21:30:21 +0200
Message-ID: <20250922192415.927019629@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit cbc7f3b4f6ca19320e2eacf8fc1403d6f331ce14 ]

The xe_preempt_fence_create() function returns error pointers.  It
never returns NULL.  Update the error checking to match.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/aJTMBdX97cof_009@stanley.mountain
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 75cc23ffe5b422bc3cbd5cf0956b8b86e4b0e162)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 84052b98002d1..92ce7374a79ce 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -240,8 +240,8 @@ int xe_vm_add_compute_exec_queue(struct xe_vm *vm, struct xe_exec_queue *q)
 
 	pfence = xe_preempt_fence_create(q, q->lr.context,
 					 ++q->lr.seqno);
-	if (!pfence) {
-		err = -ENOMEM;
+	if (IS_ERR(pfence)) {
+		err = PTR_ERR(pfence);
 		goto out_fini;
 	}
 
-- 
2.51.0



