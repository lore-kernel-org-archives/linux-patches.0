Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41D1183CD4;
	Mon, 12 Aug 2024 16:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480174; cv=none; b=S0riKi9pz3hvmIw5nkgkz4IwysFiOcvWqzCt1SmZYiDHA+REjD6FuGPos11XdZxSbhsKdfzFLPL0hv1RFo2pR3zQohd0D/jqRayexi+qIqGh9wm5JkTdYHhQdSWdEl/wZ2VBSournXU4wYZe0pLnUKMHcjgOH1AXU0dQzDMccsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480174; c=relaxed/simple;
	bh=fTlSqPwJb52zIWx80+VwJ0P+D6U44CPNn7zloYJ7LS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7c1obH8bFEk2YAAH82HLBqX+3bHAyIhzsA/2jntFdw/ifKwCyWEOyVKzkH/w3pC/xKw52xKPraHU9SD/RsbVGc0wBTKiutO233CJfSLMqbwYSMfkbHU+JW7jlLhv4cSuZwiUuz/eD3jxKnI7uh+It/FlIcT/iT8eyHDl3SlLHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7GfpvMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7GfpvMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF27C32782;
	Mon, 12 Aug 2024 16:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480174;
	bh=fTlSqPwJb52zIWx80+VwJ0P+D6U44CPNn7zloYJ7LS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7GfpvMS5YMD2rYZ/ggryzve7AF/FgMrFK0dnT0a632A6fiVfncofUluxG7DtllsR
	 s98FMMAO+siHUcLdAGw6X+Bd6u5njlPA9h3fyn6NfcmB1D9F8+KQSP7z64aR7CxNHV
	 Kxb3Dt0q6LyhI/RQVEt75yVvYeEjH18E2T9zeY2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 086/263] drm/xe/preempt_fence: enlarge the fence critical section
Date: Mon, 12 Aug 2024 18:01:27 +0200
Message-ID: <20240812160149.838597831@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 3cd1585e57908b6efcd967465ef7685f40b2a294 ]

It is really easy to introduce subtle deadlocks in
preempt_fence_work_func() since we operate on single global ordered-wq
for signalling our preempt fences behind the scenes, so even though we
signal a particular fence, everything in the callback should be in the
fence critical section, since blocking in the callback will prevent
other published fences from signalling. If we enlarge the fence critical
section to cover the entire callback, then lockdep should be able to
understand this better, and complain if we grab a sensitive lock like
vm->lock, which is also held when waiting on preempt fences.

Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240418144630.299531-2-matthew.auld@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_preempt_fence.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_preempt_fence.c b/drivers/gpu/drm/xe/xe_preempt_fence.c
index 7d50c6e89d8e7..5b243b7feb59d 100644
--- a/drivers/gpu/drm/xe/xe_preempt_fence.c
+++ b/drivers/gpu/drm/xe/xe_preempt_fence.c
@@ -23,11 +23,19 @@ static void preempt_fence_work_func(struct work_struct *w)
 		q->ops->suspend_wait(q);
 
 	dma_fence_signal(&pfence->base);
-	dma_fence_end_signalling(cookie);
-
+	/*
+	 * Opt for keep everything in the fence critical section. This looks really strange since we
+	 * have just signalled the fence, however the preempt fences are all signalled via single
+	 * global ordered-wq, therefore anything that happens in this callback can easily block
+	 * progress on the entire wq, which itself may prevent other published preempt fences from
+	 * ever signalling.  Therefore try to keep everything here in the callback in the fence
+	 * critical section. For example if something below grabs a scary lock like vm->lock,
+	 * lockdep should complain since we also hold that lock whilst waiting on preempt fences to
+	 * complete.
+	 */
 	xe_vm_queue_rebind_worker(q->vm);
-
 	xe_exec_queue_put(q);
+	dma_fence_end_signalling(cookie);
 }
 
 static const char *
-- 
2.43.0



