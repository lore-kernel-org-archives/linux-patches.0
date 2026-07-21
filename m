Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E9547044D;
	Tue, 21 Jul 2026 20:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664176; cv=none; b=lKICLpd6SKVJSTuTsTGspdfYUISHUTEYdXRPkvYseMm03edJNd0/pwVqFCCYgpDZSxYU2NB2oPVTF1fBmQt8nDowKBK6vHudLdTGOZf3VBcTWFmD0FSkJSZZFixTgASMEp/LfAFD0L3tbWgKvuWMnUye9TzhgAt+081DTqTcB/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664176; c=relaxed/simple;
	bh=81uVUIk+NtjVETagzHrpAtE0jYVnFV9QRAkWrbdK7y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWp1a2c3FyCKvF5P/vCWpjL2o8/dveb1+Mg94rWWmXbCPVFy4n9u3QwaYxndiW/T2XvmaCaWWrpAY8SrgbtwLlHWjrwqi8Gy1epi9n0m8fcQVxvHXr0atqxIF6RwpHvS2+h68Rsx/PhLbpZUxhYKv1mO4a72lhB44ZFPqBgby6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zd7vBnjZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zd7vBnjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354E81F000E9;
	Tue, 21 Jul 2026 20:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664175;
	bh=C0zGTwdUvOwoKm0qiJxGj0bu0iCweu2/Yk4dmrrU4Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zd7vBnjZtxU/W61L59TGMF9Wcu+PqL/X4/xf32MkWaFpayoBdadXyPLK4mtCe0D6b
	 daljh6i6lmSCiR6CQQ5XLKH3qoZbLDKRnqB0F3/SOx3CRxXF7z3Zd7xchYsfDjhxV4
	 5bU+6odUmZaWptMeem0p8UrYXrQVlADJa3hzghrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1064/1276] rust: block: `allow(deprecated)` for `fetch_update` for Rust >= 1.99.0
Date: Tue, 21 Jul 2026 17:25:07 +0200
Message-ID: <20260721152509.796996174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

Starting with Rust 1.99.0 (expected 2026-10-01), the
`Atomic*::fetch_update` method is deprecated, with the compiler suggesting
the `try_update` alias instead:

    error: use of deprecated method `core::sync::atomic::Atomic::<u64>::fetch_update`: renamed to `try_update` for consistency
       --> rust/kernel/block/mq/request.rs:206:22
        |
    206 |     let old = target.fetch_update(Ordering::Relaxed, Ordering::Relaxed, |x| Some(op(x)));
        |                      ^^^^^^^^^^^^
        |
        = note: `-D deprecated` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(deprecated)]`
    help: replace the use of the deprecated method
        |
    206 -     let old = target.fetch_update(Ordering::Relaxed, Ordering::Relaxed, |x| Some(op(x)));
    206 +     let old = target.try_update(Ordering::Relaxed, Ordering::Relaxed, |x| Some(op(x)));
        |

The deprecation was added in Rust 1.95.0 [1], but only triggers starting
with Rust 1.99.0.

However, we cannot use the alias since our minimum in 6.12.y is Rust
1.78.0 -- `try_update` was added in Rust 1.86.0 [2].

Thus just allow the lint.

Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Link: https://github.com/rust-lang/rust/pull/148590 [1]
Link: https://github.com/rust-lang/rust/pull/133829 [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/block/mq/request.rs | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 7943f43b957532..1c793765354260 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -203,6 +203,7 @@ unsafe impl<T: Operations> Sync for Request<T> {}
 /// Store the result of `op(target.load())` in target, returning new value of
 /// target.
 fn atomic_relaxed_op_return(target: &AtomicU64, op: impl Fn(u64) -> u64) -> u64 {
+    #[allow(deprecated)]
     let old = target.fetch_update(Ordering::Relaxed, Ordering::Relaxed, |x| Some(op(x)));
 
     // SAFETY: Because the operation passed to `fetch_update` above always
@@ -215,6 +216,7 @@ fn atomic_relaxed_op_return(target: &AtomicU64, op: impl Fn(u64) -> u64) -> u64
 /// Store the result of `op(target.load)` in `target` if `target.load() !=
 /// pred`, returning [`true`] if the target was updated.
 fn atomic_relaxed_op_unless(target: &AtomicU64, op: impl Fn(u64) -> u64, pred: u64) -> bool {
+    #[allow(deprecated)]
     target
         .fetch_update(Ordering::Relaxed, Ordering::Relaxed, |x| {
             if x == pred {
-- 
2.53.0



