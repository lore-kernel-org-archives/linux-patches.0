Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80001A08CB;
	Thu, 15 Aug 2024 13:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729978; cv=none; b=tYbpL6qsmNCGGwz+8eRxad1eMSOYLQwxJgaGyxIiW7kf7ZvdU8usYIQyqR5aD+ym9SHsx1Qa8e0i+DKS+aze+PUHrwNx8lJmLEzQjFsrpNlc+ZuEz67GRFdCfm46YjqwbgHaBv8ITccynkTHa/h5/JRHScsYE4XajKsmccHsLOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729978; c=relaxed/simple;
	bh=mFMF1TEx8+RKdztRi8ZqSUeajBPcqPfbhHr7MeagixA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxLAAnjOj4dvOu3x90s/xnSKCDL3efa4AOHf5iAVDMUzYVUWe2u7xfVlmRUoeknC+feTqEsgHXwV+OCEP42Tt6Wd3QRtJWQBvoVE+X9WBN+ErTPSqChlNRz3SsKbXglIQXAbKVMdPwEHWqzdXrag1fdHOuvCS16pZjTRDPUW6zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+kySxdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+kySxdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9A2C32786;
	Thu, 15 Aug 2024 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729978;
	bh=mFMF1TEx8+RKdztRi8ZqSUeajBPcqPfbhHr7MeagixA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+kySxdJJ4X90kicWdB9dGy3OBv1XChGz/3x35SQ8SA4aYspZNdFbM8zRtyQ9JjWA
	 6dgUu6ak9Udw3+TIjCResL0zpnEKN0jCUlONNTQBsidQEjCzhLHL23V1sktRlgmkAv
	 36zsRTpofr4CPxy4d3rQT2GyNR3yJRcptUc3TbVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@intel.com>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Chris Wilson <chris.p.wilson@linux.intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 5.15 235/484] drm/i915/gt: Do not consider preemption during execlists_dequeue for gen8
Date: Thu, 15 Aug 2024 15:21:33 +0200
Message-ID: <20240815131950.482530323@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Gote <nitin.r.gote@intel.com>

commit 65564157ae64cec0f527583f96e32f484f730f92 upstream.

We're seeing a GPU hang issue on a CHV platform, which was caused by commit
bac24f59f454 ("drm/i915/execlists: Enable coarse preemption boundaries for
Gen8").

The Gen8 platform only supports timeslicing and doesn't have a preemption
mechanism, as its engines do not have a preemption timer.

Commit 751f82b353a6 ("drm/i915/gt: Only disable preemption on Gen8 render
engines") addressed this issue only for render engines. This patch extends
that fix by ensuring that preemption is not considered for all engines on
Gen8 platforms.

v4:
 - Use the correct Fixes tag (Rodrigo Vivi)
 - Reworded commit log (Andi Shyti)

v3:
 - Inside need_preempt(), condition of can_preempt() is not required
   as simplified can_preempt() is enough. (Chris Wilson)

v2: Simplify can_preempt() function (Tvrtko Ursulin)

Fixes: 751f82b353a6 ("drm/i915/gt: Only disable preemption on gen8 render engines")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/11396
Suggested-by: Andi Shyti <andi.shyti@intel.com>
Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
Cc: Chris Wilson <chris.p.wilson@linux.intel.com>
CC: <stable@vger.kernel.org> # v5.12+
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240711163208.1355736-1-nitin.r.gote@intel.com
(cherry picked from commit 7df0be6e6280c6fca01d039864bb123e5e36604b)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_execlists_submission.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -3231,11 +3231,7 @@ static void remove_from_engine(struct i9
 
 static bool can_preempt(struct intel_engine_cs *engine)
 {
-	if (GRAPHICS_VER(engine->i915) > 8)
-		return true;
-
-	/* GPGPU on bdw requires extra w/a; not implemented */
-	return engine->class != RENDER_CLASS;
+	return GRAPHICS_VER(engine->i915) > 8;
 }
 
 static void kick_execlists(const struct i915_request *rq, int prio)


