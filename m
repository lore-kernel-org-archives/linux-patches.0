Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B690B5326CD;
	Wed, 23 Sep 2026 14:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173584; cv=none; b=A0yPdb6pWKDo4/4aQj4VW3nKVQ92vqm0v+Utg6k/T39XBS2kD4N4NqQPeAq+F/PzXdsTgd6I90Yq7UTvxZfB4hKbvSVx85BoWOYBxFXrAN5vTLJQNbJNuhHBw9vG8r9e3NQNhoeTJuCaz1J5E2a6wZYbGoVp3qubFEeDH9XpEdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173584; c=relaxed/simple;
	bh=vWEdQNMkK5ZaCmas/HJ4hyAsJqJp1+aKAFHtX9tn0Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DSIIJt7s47WGUkvG7dmejealtx9y/t5U6OpboSoS9kvxDtL+LHB1Saxwm20EQXRqBqPR36W+L/2cgfyQhfO4zywu/aDz9Q2bZdrof+eKSy6f6dAvFyJA9REgykU91xPpmI0SbrgzbPJXVeMSXGZh0zYOt0610Zo8Y6Ln7JhWP+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjOS5IYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjOS5IYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C2E1F000FF;
	Wed, 23 Sep 2026 14:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173582;
	bh=zAKaVqJ6YH8IBRlLxa+v9PBhEviplVKkrgkTj2BX7Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjOS5IYVVWLTt6b02Gm5adZFEPKWy/LgGb+Z7SfXzQoW3afvSMCB3J2xlRG+i99Iv
	 Se7fK9ysutOyJwHE0txUHtPbavVYrPZ1Qz1pVJbEHmKOUiUQLEktOiVwKag0OzCI3j
	 hzI7E6tHXIg1SVdx54LIl/4uckoi1Kk427aLlyHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Jonghyuk Kim(MalHyuk)" <malhyuk97@gmail.com>,
	Philipp Stanner <phasta@kernel.org>
Subject: [PATCH 7.2 291/438] dma-buf/dma-fence: fix checking signaling bit for timeline and driver name v3
Date: Wed, 23 Sep 2026 16:05:12 +0200
Message-ID: <20260923140652.320774198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 3ed11c671ff7ec58c8fd96410233c677df23f407 upstream.

The patch "dma-buf: dma-fence: Fix potential NULL pointer dereference"
changed the check to test for the ops pointer instead of the signaled
bit to avoid a potential NULL dereference when the ops pointer has been
cleared.

The problem is now that the ops pointer is cleared only when neither the
release nor the wait callback is implemented and this isn't true for a lot
of dma_fence implementations yet. So those implementations lost the RCU
protection after signaling of the returned string resulting in potential
use after free.

Add the signaling check additional to the ops pointer check so that we
have both the protection against NULL dereference as well as the RCU
protection after signaling for the returned string.

v2: improve comments to note RCU protection and explain why we check
    both signaling state and ops pointer
v3: some comment improvements suggested by Philip

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: 035219a760ed ("dma-buf: dma-fence: Fix potential NULL pointer dereference")
CC: stable@vger.kernel.org # 7.2+
Reported-by: Jonghyuk Kim(MalHyuk) <malhyuk97@gmail.com>
Tested-by: Jonghyuk Kim(MalHyuk) <malhyuk97@gmail.com>
Reviewed-by: Philipp Stanner <phasta@kernel.org>
Link: https://lore.kernel.org/r/20260914182740.1587-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-fence.c |   14 ++++++++++++--
 include/linux/dma-fence.h   |    6 ++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -1168,7 +1168,12 @@ const char __rcu *dma_fence_driver_name(
 
 	/* RCU protection is required for safe access to returned string */
 	ops = rcu_dereference(fence->ops);
-	if (ops)
+
+	/*
+	 * Make load ordering irrelevant by checking both signaled state and ops
+	 * pointer and ops pointer is only set to NULL on newer implementations.
+	 */
+	if (!dma_fence_test_signaled_flag(fence) && ops)
 		return (const char __rcu *)ops->get_driver_name(fence);
 	else
 		return (const char __rcu *)"detached-driver";
@@ -1201,7 +1206,12 @@ const char __rcu *dma_fence_timeline_nam
 
 	/* RCU protection is required for safe access to returned string */
 	ops = rcu_dereference(fence->ops);
-	if (ops)
+
+	/*
+	 * Make load ordering irrelevant by checking both signaled state and ops
+	 * pointer and ops pointer is only set to NULL on newer implementations.
+	 */
+	if (!dma_fence_test_signaled_flag(fence) && ops)
 		return (const char __rcu *)ops->get_timeline_name(fence);
 	else
 		return (const char __rcu *)"signaled-timeline";
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -141,6 +141,9 @@ struct dma_fence_ops {
 	 * compute the name at runtime, without having it to store permanently
 	 * for each fence, or build a cache of some sort.
 	 *
+	 * The returned string is RCU protected and can be freed after the fence
+	 * signaled and a RCU grace period passed.
+	 *
 	 * This callback is mandatory.
 	 */
 	const char * (*get_driver_name)(struct dma_fence *fence);
@@ -153,6 +156,9 @@ struct dma_fence_ops {
 	 * having it to store permanently for each fence, or build a cache of
 	 * some sort.
 	 *
+	 * The returned string is RCU protected and can be freed after the fence
+	 * signaled and a RCU grace period passed.
+	 *
 	 * This callback is mandatory.
 	 */
 	const char * (*get_timeline_name)(struct dma_fence *fence);


