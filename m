Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896EC20B1F5;
	Tue,  2 Sep 2025 13:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819940; cv=none; b=Ea/SRuxvcgy/NGBejqlcosu9ttb2V77LQglrJE2tuF3QBv52S2XpD1I1Nol4j3yIt2YzBZFdF001avOTxnP2dfVE7tykK4v9ZpE6H7NBWIRH9BbeqCojHqd2EZKfG2PWQOt5p+oLuxWkqDktjSXsL7Eij9vKuSLAK2xRA3rAea4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819940; c=relaxed/simple;
	bh=DramH946b+HnCYp/OABAhPXL/+raneG6xDzTXZ7nBiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=muqepYS8odjZvzirWh8k7zG/w8F0kjTp0dR5xbuSg2txrw54Ko/Df3ibX3R2Bnfk2TZ69eCnUfJNvGPvwOp3kyi9CvSwkzmyZPe011hNKByUNWbwtSoJ8K3exWxyhRv0/bytr9bIQU3TJgD92gLU5lzoBfrltaAX1HiklnVPZCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EU7sgDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EU7sgDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95CDC4CEED;
	Tue,  2 Sep 2025 13:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819940;
	bh=DramH946b+HnCYp/OABAhPXL/+raneG6xDzTXZ7nBiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EU7sgDpAT9HMHnzvXFlpZ1x5ISWCnrjnjuXAJpjn2H5+FAZonQJeBK6jKY7V70Rs
	 BQ2FXMJsxlaCbPUFUfLbB+X53JbnzaopHg4U7dl0r8if2Hch7ZpgRpEM2ODoZRhzL8
	 O5mWTFY4vAMLaM4HLMQ6oEAexruJDJwypm9mpBX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 43/95] drm/xe: Dont trigger rebind on initial dma-buf validation
Date: Tue,  2 Sep 2025 15:20:19 +0200
Message-ID: <20250902131941.256977350@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 16ca06aa2c2218cb21907c0c45a746958c944def ]

On the first validate of an imported dma-buf (initial bind), the device
has no GPU mappings, so a rebind is unnecessary. Rebinding here is
harmful in multi-GPU setups and for VMs using preempt-fence mode, as it
would evict in-flight GPU work.

v2:
 - Drop dma_buf_validated, check for XE_PL_SYSTEM (Thomas)

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://lore.kernel.org/r/20250825152841.3837378-1-matthew.brost@intel.com
(cherry picked from commit ffdf968762e4fb3cdae54e811ec3525e67440a60)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 5f745d9ed6cc2..445bbe0299b08 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -671,7 +671,8 @@ static int xe_bo_move(struct ttm_buffer_object *ttm_bo, bool evict,
 	}
 
 	if (ttm_bo->type == ttm_bo_type_sg) {
-		ret = xe_bo_move_notify(bo, ctx);
+		if (new_mem->mem_type == XE_PL_SYSTEM)
+			ret = xe_bo_move_notify(bo, ctx);
 		if (!ret)
 			ret = xe_bo_move_dmabuf(ttm_bo, new_mem);
 		return ret;
-- 
2.50.1



