Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FC8296BD2;
	Wed, 25 Feb 2026 01:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983857; cv=none; b=oaYB5NtmQCs7KdF6EhdSdjMg6CStlvgQHYofVh+833jmyp0TrIjvtcNHVaebSU9tC01WM2MSzvcBs5Yag8raYNYcv4sB8TI1a3xxXEqllfrJJmh1Yc/Ho28EESWIBi+4bmXzopLCdb6UXzmtA8nwNUW9nqSmopr18MZvZehDoss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983857; c=relaxed/simple;
	bh=gUF6TomCb+r9f99kLAlmsQeXJWujt3kw/ykO0fYwGMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHQcvnnA96euyw5y95Bwg/zew32Trwc2VRteL4ZNfvnXD0j0d8h/qhZ+ROC/wceLksjLAli+gPswyg0o2svJ/IVYuJn6mqD/zSyAMZ0rabn+4KCH1IfTopl/lLUpv7Bm6vwq6C2H4zzgq8Exici/+RE0D4NO6jiycJLv02XI89Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdI5Jr5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdI5Jr5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1820C116D0;
	Wed, 25 Feb 2026 01:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983857;
	bh=gUF6TomCb+r9f99kLAlmsQeXJWujt3kw/ykO0fYwGMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdI5Jr5bSL4YZvmt8OX8ds3VNlnDCaVfIAaiM9QBGszXlwWlj3Iv79qV6Uo49wPjo
	 f7DGBGH0E9DejIbi+UqqKhQtg0KtYnxkIDiZpEzUCwlWuukF8MsX4sIbNyWZkioqY9
	 FmNEaMyd2b+gsy18j10BPQ9jJMm6wg/USH+If4UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amery Hung <ameryhung@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 092/641] rqspinlock: Fix TAS fallback lock entry creation
Date: Tue, 24 Feb 2026 17:16:58 -0800
Message-ID: <20260225012351.328251591@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 82f3b142c99cf44c7b1e70b7720169c646b9760f ]

The TAS fallback can be invoked directly when queued spin locks are
disabled, and through the slow path when paravirt is enabled for queued
spin locks. In the latter case, the res_spin_lock macro will attempt the
fast path and already hold the entry when entering the slow path. This
will lead to creation of extraneous entries that are not released, which
may cause false positives for deadlock detection.

Fix this by always preceding invocation of the TAS fallback in every
case with the grabbing of the held lock entry, and add a comment to make
note of this.

Fixes: c9102a68c070 ("rqspinlock: Add a test-and-set fallback")
Reported-by: Amery Hung <ameryhung@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Tested-by: Amery Hung <ameryhung@gmail.com>
Link: https://lore.kernel.org/r/20260122115911.3668985-1-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/rqspinlock.h | 2 +-
 kernel/bpf/rqspinlock.c          | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/rqspinlock.h b/include/asm-generic/rqspinlock.h
index 0f2dcbbfee2f0..5c5cf2f7fc395 100644
--- a/include/asm-generic/rqspinlock.h
+++ b/include/asm-generic/rqspinlock.h
@@ -191,7 +191,7 @@ static __always_inline int res_spin_lock(rqspinlock_t *lock)
 
 #else
 
-#define res_spin_lock(lock) resilient_tas_spin_lock(lock)
+#define res_spin_lock(lock) ({ grab_held_lock_entry(lock); resilient_tas_spin_lock(lock); })
 
 #endif /* CONFIG_QUEUED_SPINLOCKS */
 
diff --git a/kernel/bpf/rqspinlock.c b/kernel/bpf/rqspinlock.c
index 3faf9cbd6c753..c0c93a0f5af63 100644
--- a/kernel/bpf/rqspinlock.c
+++ b/kernel/bpf/rqspinlock.c
@@ -276,10 +276,11 @@ int __lockfunc resilient_tas_spin_lock(rqspinlock_t *lock)
 
 	RES_INIT_TIMEOUT(ts);
 	/*
-	 * The fast path is not invoked for the TAS fallback, so we must grab
-	 * the deadlock detection entry here.
+	 * We are either called directly from res_spin_lock after grabbing the
+	 * deadlock detection entry when queued spinlocks are disabled, or from
+	 * resilient_queued_spin_lock_slowpath after grabbing the deadlock
+	 * detection entry. No need to obtain it here.
 	 */
-	grab_held_lock_entry(lock);
 
 	/*
 	 * Since the waiting loop's time is dependent on the amount of
-- 
2.51.0



