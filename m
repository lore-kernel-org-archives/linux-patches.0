Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C082FA62D;
	Tue, 17 Jun 2025 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178889; cv=none; b=SCY1CD2eeBQtG6e0Z26hVVBu2ksJSDSWI64C6NNBOp3+MBzNdVT+zn5MUYNaUnLzU5qWigvS2eZD+hP+hxpVRofiyAgf9i+ATna4yHblvA4FQ8zAo8Sd/ImiRrXAsY0SOSy7JrVIJHwwSxQ1OM+/CfdDAdRofOm6RvudNx78cWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178889; c=relaxed/simple;
	bh=MC4OzRkOhPXrNIyLlgruuD7j1foQqyxhYn+i1ePrr+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REU8XBkZD1Y9Z57ofF+vAUkjupo0t66j8j8+65M8GXwjPrCRNwyVagxWVauxwFdHsgTqlfHh36bQTPwUdGfQMx+/N8TwYFUzn3pFudbr0FRea5mq2880u7gwtTN46tK2gF/h/f6ks2fWLRWqAxPJ1/ZYxZNUs7Mv1+fDidqCADo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJ7/4DRK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJ7/4DRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FB4C4CEE3;
	Tue, 17 Jun 2025 16:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178889;
	bh=MC4OzRkOhPXrNIyLlgruuD7j1foQqyxhYn+i1ePrr+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJ7/4DRKBFmZ3BGpxAgT1dMYUGPmF4jXX9rd13tCN8zhVfuXSgXAnGBQqeEwcjL66
	 4Lk2Mwoif7IN+HHMcdUH1C7BTFQ49eDN/X31Vbo/mJEmAj2tobp3WdlDLcqc2H3zn3
	 +8mVhcmo6jZ4MO4OrRrMytfn7JDqTT57H3/xrFqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesus Narvaez <jesus.narvaez@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	Anshuman Gupta <anshuman.gupta@intel.com>,
	Mousumi Jana <mousumi.jana@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 584/780] drm/i915/guc: Handle race condition where wakeref count drops below 0
Date: Tue, 17 Jun 2025 17:24:52 +0200
Message-ID: <20250617152515.266262114@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesus Narvaez <jesus.narvaez@intel.com>

[ Upstream commit 0323a5127e7c534cfc88efe0f850a0cb777e938b ]

There is a rare race condition when preparing for a reset where
guc_lrc_desc_unpin() could be in the process of deregistering a context
while a different thread is scrubbing outstanding contexts and it alters
the context state and does a wakeref put. Then, if there is a failure
with deregister_context(), a second wakeref put could occur. As a result
the wakeref count could drop below 0 and fail an INTEL_WAKEREF_BUG_ON()
check.

Therefore if there is a failure with deregister_context(), undo the
context state changes and do a wakeref put only if the context was set
to be destroyed earlier.

v2: Expand comment to better explain change. (Daniele)
v3: Removed addition to the original comment. (Daniele)

Fixes: 2f2cc53b5fe7 ("drm/i915/guc: Close deregister-context race against CT-loss")
Signed-off-by: Jesus Narvaez <jesus.narvaez@intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: Anshuman Gupta <anshuman.gupta@intel.com>
Cc: Mousumi Jana <mousumi.jana@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://lore.kernel.org/r/20250528230551.1855177-1-jesus.narvaez@intel.com
(cherry picked from commit f36a75aba1c3176d177964bca76f86a075d2943a)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c   | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 108331a699958..127316d2c8aa9 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -3443,18 +3443,29 @@ static inline int guc_lrc_desc_unpin(struct intel_context *ce)
 	 * GuC is active, lets destroy this context, but at this point we can still be racing
 	 * with suspend, so we undo everything if the H2G fails in deregister_context so
 	 * that GuC reset will find this context during clean up.
+	 *
+	 * There is a race condition where the reset code could have altered
+	 * this context's state and done a wakeref put before we try to
+	 * deregister it here. So check if the context is still set to be
+	 * destroyed before undoing earlier changes, to avoid two wakeref puts
+	 * on the same context.
 	 */
 	ret = deregister_context(ce, ce->guc_id.id);
 	if (ret) {
+		bool pending_destroyed;
 		spin_lock_irqsave(&ce->guc_state.lock, flags);
-		set_context_registered(ce);
-		clr_context_destroyed(ce);
+		pending_destroyed = context_destroyed(ce);
+		if (pending_destroyed) {
+			set_context_registered(ce);
+			clr_context_destroyed(ce);
+		}
 		spin_unlock_irqrestore(&ce->guc_state.lock, flags);
 		/*
 		 * As gt-pm is awake at function entry, intel_wakeref_put_async merely decrements
 		 * the wakeref immediately but per function spec usage call this after unlock.
 		 */
-		intel_wakeref_put_async(&gt->wakeref);
+		if (pending_destroyed)
+			intel_wakeref_put_async(&gt->wakeref);
 	}
 
 	return ret;
-- 
2.39.5



