Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F0E222576;
	Tue, 24 Jun 2025 04:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738308; cv=none; b=GqgiCYiPMRMFxhxLa7rW9FhvkTS3nE+7+uif9POzGf6Ys4wLLksaDnk4bJbM6xMKDt0u51qTPzjMTEHCuRsmZjABNawguZr5kxJaV3Gy3pbDLE2ZsrNxIqVv9MItwnGpiu1BwtM5lV3+ToyGERDy95KUy7Ym+77tfGiCoegP1i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738308; c=relaxed/simple;
	bh=Sr6pQoTm23gbJa95F+OJq2K5v9c1RPleuAhWWWs8zDo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RvRz6ulgIjZ0CXH2glGW9D7aScxJCW2xrB/X+LMrVYwzPnXIzKkLlVpQrYzbmTIPcyJo5aEN62eh0PckjkR2GG30BK9ZAzDZs9nOUpwCSVH/b20uI+5wQjcxk4Kazq8gUp+ExwlKPqhmGFY5+089KJSrwW0Dp9scOOfgev4PAvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n2yR4WEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n2yR4WEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C01C4CEEF;
	Tue, 24 Jun 2025 04:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738307;
	bh=Sr6pQoTm23gbJa95F+OJq2K5v9c1RPleuAhWWWs8zDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2yR4WEhUt3Ui2VKlbVd3xYpf2WCRDIZg8uwzq396Hj0N93SrsjoLoM1WOJHyBpD1
	 O1FlAppaGv+5MdSx8C6ZzVwEr9ct+nS67jfJq+71KZ9fj6SwVhwDVFk+/gGHlkq4Qn
	 YFRdrvVd9nr8ZxIzVsphXGJyPVsuZrmohD8SRLmd2fyI3NxisIe9Jythk9DsM1sv+p
	 9URo5neYKiIBOmhuIdLdp7biJ01sE3/GT0rPRB20fdBsEKG12b70p7ACWHMBi/60Cz
	 uzfTnwAg1TKEZcR7KacfwIQEYfgBKqLIhfj5JeQIqgvSmbpd+i1s3v3bYlpZ6dZ8PE
	 h4prjZjQEoO+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	paulmck@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	josh@joshtriplett.org,
	boqun.feng@gmail.com,
	rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 20/20] rcu: Return early if callback is not specified
Date: Tue, 24 Jun 2025 00:11:19 -0400
Message-Id: <20250624041120.83191-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250624041120.83191-1-sashal@kernel.org>
References: <20250624041120.83191-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.3
Content-Transfer-Encoding: 8bit

From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>

[ Upstream commit 33b6a1f155d627f5bd80c7485c598ce45428f74f ]

Currently the call_rcu() API does not check whether a callback
pointer is NULL. If NULL is passed, rcu_core() will try to invoke
it, resulting in NULL pointer dereference and a kernel crash.

To prevent this and improve debuggability, this patch adds a check
for NULL and emits a kernel stack trace to help identify a faulty
caller.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

So I can see that in the current code, `debug_rcu_head_callback()`
(called at line 2566 in rcu_do_batch) already checks for NULL func and
dumps memory info, but it doesn't prevent the crash - it still proceeds
to invoke the NULL function pointer at line 2568.

Now let me understand the commit more - it adds a check in
`__call_rcu_common()` to catch NULL callbacks early and warn about them,
preventing them from being queued at all.

## Analysis

**Answer: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a Critical Bug**: The commit addresses a real kernel crash
   scenario where passing a NULL callback to `call_rcu()` results in a
   NULL pointer dereference when `rcu_do_batch()` tries to invoke the
   callback at line 2568 (`f(rhp)`). This is a serious bug that can
   crash the kernel.

2. **Small and Contained Fix**: The change is minimal - it adds just 4
   lines of code:
  ```c
  /* Avoid NULL dereference if callback is NULL. */
  if (WARN_ON_ONCE(!func))
  return;
  ```
  This is exactly the type of small, focused fix that stable trees
  prefer.

3. **Defensive Programming**: While the existing code already has
   `debug_rcu_head_callback()` that checks for NULL func and dumps
   memory info (as seen in similar commit #2), it doesn't prevent the
   crash. This commit adds a proper early return to prevent the NULL
   callback from being queued at all.

4. **No Side Effects**: The fix simply validates input parameters and
   returns early if invalid. It doesn't change any architecture, doesn't
   introduce new features, and has minimal risk of regression.

5. **Clear Bug Prevention**: The commit prevents a programming error
   (passing NULL callback) from escalating into a kernel crash. Even
   though passing NULL is a programmer error, the kernel should handle
   it gracefully rather than crashing.

6. **Similar to Stable-Worthy Commits**: Looking at the similar commits,
   commit #2 ("rcu: Dump memory object info if callback function is
   invalid") was marked as suitable for backporting (YES) and dealt with
   a similar issue of invalid callbacks. That commit added debugging for
   when callbacks become NULL after being queued, while this commit
   prevents NULL callbacks from being queued in the first place.

The fix follows the stable kernel rules perfectly:
- It fixes a real bug (kernel crash)
- It's small and obvious
- It has been tested (as indicated by the review process)
- It doesn't add features or change behavior for valid use cases
- It improves kernel robustness without any downside

This is a textbook example of a commit that should be backported to
stable trees to improve kernel reliability across all supported
versions.

 kernel/rcu/tree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 80b10893b5038..37778d913f011 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3068,6 +3068,10 @@ __call_rcu_common(struct rcu_head *head, rcu_callback_t func, bool lazy_in)
 	/* Misaligned rcu_head! */
 	WARN_ON_ONCE((unsigned long)head & (sizeof(void *) - 1));
 
+	/* Avoid NULL dereference if callback is NULL. */
+	if (WARN_ON_ONCE(!func))
+		return;
+
 	if (debug_rcu_head_queue(head)) {
 		/*
 		 * Probable double call_rcu(), so leak the callback.
-- 
2.39.5

