Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7796134AC;
	Mon, 12 Aug 2024 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479847; cv=none; b=paYdgy1YOyzEm81q2Us+kpthNdo3dHJABjRwp0Gr0uqrVySbVIg4UKuh7g8nOo5qrSyaZOh5XHC1+QBJ9FesJHZ7B8j272NiheRKxIfXBB/m2pyMXSqSZJ3JSFS5JNyE/A/H1iijjbF60vZbEU1EGnjwAhsLdXZ4Syz30gVS9WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479847; c=relaxed/simple;
	bh=nhNeedRHJvhKazGGFdXM/uxCOoTmt1HGzcxqIOcmMvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dy3p4TNfUWjaAcTZuC08iyXJD9anwq82BZkDYZdHfraRPJsRWSrIBZNQwR9nxd/RvM/GSApyyOyZYCVe9MZ/sfRRTji9jXGpUdJsKLaSS61jFN4JyiSVwPVmacf+0qE0jN3F6aXd6fl/qkXOrnXdv1z57ZigALQfCNII2nbe3h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17u1gJOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17u1gJOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41062C4AF11;
	Mon, 12 Aug 2024 16:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479847;
	bh=nhNeedRHJvhKazGGFdXM/uxCOoTmt1HGzcxqIOcmMvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17u1gJOEwjUPw2UarE4uRvD54Pp756uD4Zt+5huW30v2xsWvXX461NIJH6wP/sr5W
	 wL0qJtJIaJDn5IPv48KQI+DE46IOs77ji40e/hBc7sK2LkEYbIRC87hiH1HJJocpv1
	 pKxEdE7FP1bXDCmFkohTuicFlFqVfP1mFp/zUjGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 009/263] jump_label: Fix the fix, brown paper bags galore
Date: Mon, 12 Aug 2024 18:00:10 +0200
Message-ID: <20240812160146.884239903@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 224fa3552029a3d14bec7acf72ded8171d551b88 ]

Per the example of:

  !atomic_cmpxchg(&key->enabled, 0, 1)

the inverse was written as:

  atomic_cmpxchg(&key->enabled, 1, 0)

except of course, that while !old is only true for old == 0, old is
true for everything except old == 0.

Fix it to read:

  atomic_cmpxchg(&key->enabled, 1, 0) == 1

such that only the 1->0 transition returns true and goes on to disable
the keys.

Fixes: 83ab38ef0a0b ("jump_label: Fix concurrency issues in static_key_slow_dec()")
Reported-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lkml.kernel.org/r/20240731105557.GY33588@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/jump_label.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 1f05a19918f47..c6ac0d0377d72 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -231,7 +231,7 @@ void static_key_disable_cpuslocked(struct static_key *key)
 	}
 
 	jump_label_lock();
-	if (atomic_cmpxchg(&key->enabled, 1, 0))
+	if (atomic_cmpxchg(&key->enabled, 1, 0) == 1)
 		jump_label_update(key);
 	jump_label_unlock();
 }
@@ -284,7 +284,7 @@ static void __static_key_slow_dec_cpuslocked(struct static_key *key)
 		return;
 
 	guard(mutex)(&jump_label_mutex);
-	if (atomic_cmpxchg(&key->enabled, 1, 0))
+	if (atomic_cmpxchg(&key->enabled, 1, 0) == 1)
 		jump_label_update(key);
 	else
 		WARN_ON_ONCE(!static_key_slow_try_dec(key));
-- 
2.43.0



