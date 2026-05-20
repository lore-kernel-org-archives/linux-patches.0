Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AAD30BF68;
	Wed, 20 May 2026 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297562; cv=none; b=jr/vJkDGa7DQlZh3tvRcPEjj2AJDu53ywHVun18tIJtUWBqjMTBtiXZplZz/Djxbqmdm++PfDzK4sw/69VmZWap9YNOoXUFxqLoOW/ksU6l7V8v/uzpCbtglI1x9FqDM6qbphbKgjk1/MV8gBXl+oja42lvFo+RmoxwCgamDl/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297562; c=relaxed/simple;
	bh=dTlof50b+p/OqpeBaRZOlfeCwu9rk/Yko0/UGG1EU6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wl77Sh0RfJOMaMWOJ9DrsMY1xTUKC0jR/KWVoPCv4TrTYl5+D+nesRUuCOQREpmmnAIBJT6KW2LXzOh+wsYP2S8Vx4a92MOlGb1NvpvP0zrz/q71FJcQ2brVUrHCQnnD1PFR+ttWPjVNFGLdqKFlxJWAGGwD7D0to4LGvbtCZ3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKYcLnWs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKYcLnWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96E41F000E9;
	Wed, 20 May 2026 17:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297561;
	bh=WvpeBNlIJi9o7/mA58wlqQqDfK6che3Mt5/ECyevy9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKYcLnWsiU3a0sPvxLhjqEQVMxiF9vnBDSm7d5JbSAE38NRi1IIpW5Dy2kjjGKY7h
	 cy+MYSXYVy3/axA+E17y9TYEIAxYR+D6677JlLos6SlU4xhRNK/yBw9oVIRlbIzGrD
	 FiFVniTnaudHKSfjOASaDP/m6j76noxYs8EXH7r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/957] rust: sync: atomic: Remove bound `T: Sync` for `Atomic::from_ptr()`
Date: Wed, 20 May 2026 18:08:44 +0200
Message-ID: <20260520162135.450126279@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Boqun Feng <boqun.feng@gmail.com>

[ Upstream commit 4a5dc632e0b603ec1cbbf87b78de86b4b6359cff ]

Originally, `Atomic::from_ptr()` requires `T` being a `Sync` because I
thought having the ability to do `from_ptr()` meant multiplle
`&Atomic<T>`s shared by different threads, which was identical (or
similar) to multiple `&T`s shared by different threads. Hence `T` was
required to be `Sync`. However this is not true, since `&Atomic<T>` is
not the same at `&T`. Moreover, having this bound makes `Atomic::<*mut
T>::from_ptr()` impossible, which is definitely not intended. Therefore
remove the `T: Sync` bound.

[boqun: Fix title typo spotted by Alice & Gary]

Fixes: 29c32c405e53 ("rust: sync: atomic: Add generic atomics")
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260120115207.55318-2-boqun.feng@gmail.com
Link: https://patch.msgid.link/20260303201701.12204-2-boqun@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/sync/atomic.rs | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/rust/kernel/sync/atomic.rs b/rust/kernel/sync/atomic.rs
index 016a6bcaf0807..43229f0320e92 100644
--- a/rust/kernel/sync/atomic.rs
+++ b/rust/kernel/sync/atomic.rs
@@ -202,10 +202,7 @@ impl<T: AtomicType> Atomic<T> {
     /// // no data race.
     /// unsafe { Atomic::from_ptr(foo_a_ptr) }.store(2, Release);
     /// ```
-    pub unsafe fn from_ptr<'a>(ptr: *mut T) -> &'a Self
-    where
-        T: Sync,
-    {
+    pub unsafe fn from_ptr<'a>(ptr: *mut T) -> &'a Self {
         // CAST: `T` and `Atomic<T>` have the same size, alignment and bit validity.
         // SAFETY: Per function safety requirement, `ptr` is a valid pointer and the object will
         // live long enough. It's safe to return a `&Atomic<T>` because function safety requirement
-- 
2.53.0



