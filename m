Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14503F39FD;
	Wed, 20 May 2026 16:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294481; cv=none; b=EKHOBbfXRT0nGZPCBuKQE14zMt6x8L/ixLIJuG38DIf+m2CO7mfzPzETAg2PGFP8Atbx2Y5tMvm12oK0XsWbZRQOod4aINGzzP3+GqNggCqPVtYGFqV1inGA2vFpiZTb50ZKBlg+H2n8Z+y46Ewryfpc061X4TQsci6WpHigh6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294481; c=relaxed/simple;
	bh=9nMTLHidfKI7t/XbUeS3oDUKlEzu6xQJPiivE8vud/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnZqJexNlegHq1KnHCUpCJd4jr3rGMy+FGfPt9hVMTAcXfGlp6ELqfnoChmw+oQxW6g3fdB9ZBh7nacVCRYxMt2cLH/RhuUP1wc6DnA5gXp+DRTMheyIeIT9j8r/EURRA2W4vpw+3xWGLRZr1OumwbfRkO7DHpdPYpJFdzDfcmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBLYc33O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBLYc33O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B981F000E9;
	Wed, 20 May 2026 16:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294479;
	bh=5bYRtLvvKcEOr85NXg+MGFPA3qcURwFpVKGSGOTjI3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBLYc33OGGqEbLa5c2G9Y7Z1hUG4llY5z6rHHT9cBMNGEmu1J9pf4yUEALkotsJyI
	 zysyLcs0/HPkTyWhElxBy2ccfeCBSVHTQBNypBUxHnkjUNe5E9XL+tr/VvpF8SA9GG
	 gVzpep2QY8D2nveiIS0AbhGGuI/+VIAl1HRz2OnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0055/1146] rust: sync: atomic: Remove bound `T: Sync` for `Atomic::from_ptr()`
Date: Wed, 20 May 2026 18:05:05 +0200
Message-ID: <20260520162149.616906700@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 4aebeacb961a2..296b25e83bbb9 100644
--- a/rust/kernel/sync/atomic.rs
+++ b/rust/kernel/sync/atomic.rs
@@ -204,10 +204,7 @@ impl<T: AtomicType> Atomic<T> {
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



