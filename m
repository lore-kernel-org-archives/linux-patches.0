Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035721FDA;
	Mon,  1 Dec 2025 00:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764547809; cv=none; b=HQvN/G6qMBZuhtn1Bgjr0ogTktiPd4xUISoqPCOcpeU6jh5bxpe5Lo3P6ttEhtODo+EqTZ3Y2pvA8WsNheDBpZQsa3DfQaDmDrKRIdLbSg5l194RQ3aN5JpLc1vovo5zxqO/2sbfh1T9wjAV+vUj05/guC91ghKNn7kzXDj7DL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764547809; c=relaxed/simple;
	bh=2lybd92g6xfgfkv2TqIttJVFPUxz3Gu/4bCw+O7bgMc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xp7ipbY+FooYZDa7SRYVATaAKwUiO0qhyuGwNNR/wT6pYgIQdVnsWXzL6pZo/LdpvRpW92lDPSBDqKaqo6KgsyYZYBzHsNg+zCYxVFxvn0mVNC4vSeq4+45rzGslLHaWCoKdkfuPjvYCyakWLLOv2s075QnqjcFNGu/bpktJVAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DkU3YG16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DkU3YG16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1545BC113D0;
	Mon,  1 Dec 2025 00:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764547807;
	bh=2lybd92g6xfgfkv2TqIttJVFPUxz3Gu/4bCw+O7bgMc=;
	h=From:To:Cc:Subject:Date:From;
	b=DkU3YG16CWHLHobT+0bjJOrCE8sNKJZMd8aEClkaIcMItwb1AM5BAKn488uPr1lii
	 IRFxHTi1jQjM5jWUCmHTEv59nrcPzVVQ/cyVutpcJx9XErjYF5XiuhFpryaz19dOYT
	 m+CujKROyiF8Kq3LnCZkBv2c97/yeFSdJ8HQv5WqQ6qqBpq4I4OFVSeU7Ln50POTJA
	 OTCntHy1nVxPL48BMcs4Nn0CnxsooiIepmvvv8fBqJ3WXTEJhEqYzkAfjz+mptkN1B
	 a1Dxrho3DEw7VIzwYuHvbQ9LznXyUOtXP2VTCHnErzQqgKTzGg4EqdmmXF2SIiiBQS
	 TzivJQdc3vp3g==
From: Miguel Ojeda <ojeda@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>,
	Burak Emir <bqe@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Yury Norov <yury.norov@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: id_pool: fix example
Date: Mon,  1 Dec 2025 01:09:49 +0100
Message-ID: <20251201000949.1626363-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building with KUnit doctests enabled, `rustc` reports:

    error[E0599]: no method named `acquire_next_id` found for struct `IdPool` in the current scope
        --> rust/doctests_kernel_generated.rs:6722:24
         |
    6722 |     assert_eq!(i, pool.acquire_next_id(i).ok_or(ENOSPC)?);
         |                        ^^^^^^^^^^^^^^^ method not found in `IdPool`

Thus fix it.

Fixes: a5726454470c ("rust: id_pool: do not immediately acquire new ids")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
I saw this in -next.

 rust/kernel/id_pool.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/id_pool.rs b/rust/kernel/id_pool.rs
index 73a952d7dd83..384753fe0e44 100644
--- a/rust/kernel/id_pool.rs
+++ b/rust/kernel/id_pool.rs
@@ -28,7 +28,7 @@
 ///
 /// let mut pool = IdPool::with_capacity(64, GFP_KERNEL)?;
 /// for i in 0..64 {
-///     assert_eq!(i, pool.acquire_next_id(i).ok_or(ENOSPC)?);
+///     assert_eq!(i, pool.find_unused_id(i).ok_or(ENOSPC)?.acquire());
 /// }
 ///
 /// pool.release_id(23);

base-commit: 00c5ce039598e692e1dd4bf2b3ad5bc08bdf3270
--
2.52.0
