Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CBC187323;
	Mon, 12 Aug 2024 16:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479247; cv=none; b=p8pyDpGdBQ6I9krYAyaxZiF84PshllNNSfJhn4qSbZmPMNV//66aNkfj2u3adBTgOVijpjqPS+bWtFxlXJ2MpXlEfCWlnS9kF9TFUwf+OPKZ/WC9LZV2N0zhNnYr2LPC21ak5oKSMdHshndk9Z13OzBv+7hCdvYrM9XBokLp1Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479247; c=relaxed/simple;
	bh=C76p53QaRjvpEU8kpelVpEtR21kJug7JTBktBkA78ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOpt20juYWHuphgCMQH130IYcECYH0Nvot0heHsO9BxjIWUuw2K6Jrr7licUIGLahgQxfcGtnPToqRCzjdj9Q3Kr5WP0XMafJmFIzvmBcJXnt/r75Kd8WX4db3fsj2np3BXXOqyi/7YRDkT5PZRpKtkFCHZNYacIMjIoBcaoHLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKDxr7lR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKDxr7lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1ECC32782;
	Mon, 12 Aug 2024 16:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479247;
	bh=C76p53QaRjvpEU8kpelVpEtR21kJug7JTBktBkA78ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKDxr7lRknCehHe4e3otva0SfUrAI82SrECCd+f0qtBJ47jQNqDR3vt1fGUoXiiDi
	 Z16ddsEMy93tufT7rGvDTRz46Z/Q9E/Wm4hZIVQ/i3byeoD32/vUohlM6i9d6m3mBQ
	 i120Koy9oQmqIyvT/UpJoWOwmPi8blrB+pVngq6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/189] jump_label: Fix the fix, brown paper bags galore
Date: Mon, 12 Aug 2024 18:01:01 +0200
Message-ID: <20240812160132.347026389@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index eec802175ccc6..1ed269b2c4035 100644
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



