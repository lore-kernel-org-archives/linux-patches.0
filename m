Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E28F14884C;
	Wed,  5 Mar 2025 18:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198568; cv=none; b=ZseWEGeq1FF6C1gKi2KczKzxJ9MmkEQdPOPfrJVgArDa2wG515srtYWguAlLpbskZRpBgzonWwb1QXtU0QkgcjkI4ca1jFdyRz6UbUyufR8dUKVvoNJVOs2XTh2xQ+SatNNCHAA5mAmN39gDUZAlhOu1/DJJXPQzfs3/rE5lVho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198568; c=relaxed/simple;
	bh=U6x84X3n2erLTyAk7BuqdbTYKeGQPDGlcBLychMmojw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSoU3Lrx6s0RLRloRHnoCqGbOft3d5v/ai7fFIRWtsdFjDORje/YcBJ/o22Xd8gTExZZT4pgdJx7oNqLSjiOWscP2M1RpCMoWTe/U9gI1MBnEfthQf+Ks7UrycgtGR6OYXAOVNadpq9VYpD4xNzyxvfEN4H7AE0Z87uM9xG2rGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1ojvgLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1ojvgLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC71C4CED1;
	Wed,  5 Mar 2025 18:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198567;
	bh=U6x84X3n2erLTyAk7BuqdbTYKeGQPDGlcBLychMmojw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1ojvgLUmTGHsogVqF5CUmOggSdMVOKmVGxy46Ozr51Xv5XicdJGul1EKjTxnjsZU
	 A14E634LAXwDgb0lwegqKGIH1jNgfbfp9+gqoybcRGGYx20T4bDr5v6rDW7WsL7Lv2
	 hrV92oaEVfzhcfGz8YZmXVbUo0vshHHzVK+22nco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 073/157] uprobes: Remove too strict lockdep_assert() condition in hprobe_expire()
Date: Wed,  5 Mar 2025 18:48:29 +0100
Message-ID: <20250305174508.236236402@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit f8c857238a392f21d5726d07966f6061007c8d4f ]

hprobe_expire() is used to atomically switch pending uretprobe instance
(struct return_instance) from being SRCU protected to be refcounted.
This can be done from background timer thread, or synchronously within
current thread when task is forked.

In the former case, return_instance has to be protected through RCU read
lock, and that's what hprobe_expire() used to check with
lockdep_assert(rcu_read_lock_held()).

But in the latter case (hprobe_expire() called from dup_utask()) there
is no RCU lock being held, and it's both unnecessary and incovenient.
Inconvenient due to the intervening memory allocations inside
dup_return_instance()'s loop. Unnecessary because dup_utask() is called
synchronously in current thread, and no uretprobe can run at that point,
so return_instance can't be freed either.

So drop rcu_read_lock_held() condition, and expand corresponding comment
to explain necessary lifetime guarantees. lockdep_assert()-detected
issue is a false positive.

Fixes: dd1a7567784e ("uprobes: SRCU-protect uretprobe lifetime (with timeout)")
Reported-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20250225223214.2970740-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/uprobes.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index e11e2df50a3ee..3c34761c9ae73 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -767,10 +767,14 @@ static struct uprobe *hprobe_expire(struct hprobe *hprobe, bool get)
 	enum hprobe_state hstate;
 
 	/*
-	 * return_instance's hprobe is protected by RCU.
-	 * Underlying uprobe is itself protected from reuse by SRCU.
+	 * Caller should guarantee that return_instance is not going to be
+	 * freed from under us. This can be achieved either through holding
+	 * rcu_read_lock() or by owning return_instance in the first place.
+	 *
+	 * Underlying uprobe is itself protected from reuse by SRCU, so ensure
+	 * SRCU lock is held properly.
 	 */
-	lockdep_assert(rcu_read_lock_held() && srcu_read_lock_held(&uretprobes_srcu));
+	lockdep_assert(srcu_read_lock_held(&uretprobes_srcu));
 
 	hstate = READ_ONCE(hprobe->state);
 	switch (hstate) {
-- 
2.39.5



