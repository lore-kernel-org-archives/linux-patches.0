Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69BC2F39C6;
	Mon, 22 Sep 2025 19:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570022; cv=none; b=LiYjMlRr335KTSRKuYVl8ldAz3S/kTCitBJs8t2V/KAJ0/kLnj0MrHEoV4tFMTHJoB2ozoKACGkBvWkt9kJUL0rLJi5BRCqKI7PzhXx4Kck0wMXp+47bx9K1M4oD4W/ufFWtMF94Bki44NH89zXo8oQD+A5vKbbOadP4ZoG5nDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570022; c=relaxed/simple;
	bh=WTNK9kaSFh/U1n4Wa6SJmUHLwYevIz6bnNAhUppBsew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4PyXYLfB1YJXXNvo06Uw4PJofUi4BGUg/Y9whAOcMRenDu/sjQug2/ZsvRjZ8ykR9hE3dvwWm5l40vPr+uRNizhI92/wyRxFboFr6vCDXIL2WZhu7oT+h0Iq5FInHdxp6P2mzmkSVmtBUH6p4imIVHrGHwgvn6bS87k2OPN6RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1arcHxRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1arcHxRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F834C4CEF0;
	Mon, 22 Sep 2025 19:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570022;
	bh=WTNK9kaSFh/U1n4Wa6SJmUHLwYevIz6bnNAhUppBsew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1arcHxRevMXvAaTzszAYjju5/pJKVShxh4sSJMfAWEmlVu2Bkdm8P3cytU+w7mSlR
	 28Ft+PS3IixfickT+hfYRsKUtUZdaltmKDIJCO/9KwopKt4pxsteRXU58Vwicb5G1D
	 yEl4SCf71fj7RBwNR2ka+9uZ9k1rfetU5CgrWUCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/105] drm/xe: Fix a NULL vs IS_ERR() in xe_vm_add_compute_exec_queue()
Date: Mon, 22 Sep 2025 21:30:02 +0200
Message-ID: <20250922192410.964543868@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a4845d4213b00..fc5f0e1351932 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -239,8 +239,8 @@ int xe_vm_add_compute_exec_queue(struct xe_vm *vm, struct xe_exec_queue *q)
 
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



