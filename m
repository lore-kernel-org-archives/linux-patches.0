Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CF9101D4;
	Mon, 18 Dec 2023 13:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kYR29Cyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953C2C433C7;
	Mon, 18 Dec 2023 13:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907632;
	bh=BIirHJTe92mZizehvn8xgRsLkdUXsTGxUMuFdLKMrnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYR29CyzaNChits+5C5Q7RVmIpP+KOnVBVgG+5tkmSGBTwMuVeqD0glghKrvyDGa8
	 H2movBLhQHFNClWlzYb76Mo5TKkl7Eao8j3T1A1A8fn+Hfria9cScBugN3E+kYOXBT
	 mSGLukTOiDbk8ZK4+LNpVhrMoVZIoY2Ssr/TkpJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/36] asm-generic: qspinlock: fix queued_spin_value_unlocked() implementation
Date: Mon, 18 Dec 2023 14:51:36 +0100
Message-ID: <20231218135042.773759064@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135041.876499958@linuxfoundation.org>
References: <20231218135041.876499958@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 125b0bb95dd6bec81b806b997a4ccb026eeecf8f ]

We really don't want to do atomic_read() or anything like that, since we
already have the value, not the lock.  The whole point of this is that
we've loaded the lock from memory, and we want to check whether the
value we loaded was a locked one or not.

The main use of this is the lockref code, which loads both the lock and
the reference count in one atomic operation, and then works on that
combined value.  With the atomic_read(), the compiler would pointlessly
spill the value to the stack, in order to then be able to read it back
"atomically".

This is the qspinlock version of commit c6f4a9002252 ("asm-generic:
ticket-lock: Optimize arch_spin_value_unlocked()") which fixed this same
bug for ticket locks.

Cc: Guo Ren <guoren@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/all/CAHk-=whNRv0v6kQiV5QO6DJhjH4KEL36vWQ6Re8Csrnh4zbRkQ@mail.gmail.com/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/qspinlock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
index 9cc457597ddf8..1a688e5b8b0b5 100644
--- a/include/asm-generic/qspinlock.h
+++ b/include/asm-generic/qspinlock.h
@@ -47,7 +47,7 @@ static __always_inline int queued_spin_is_locked(struct qspinlock *lock)
  */
 static __always_inline int queued_spin_value_unlocked(struct qspinlock lock)
 {
-	return !atomic_read(&lock.val);
+	return !lock.val.counter;
 }
 
 /**
-- 
2.43.0



