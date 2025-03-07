Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0774020CCCD;
	Fri,  7 Mar 2025 22:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387972; cv=none; b=aKkxFnt2WgC2v2baeWhQ00OSl6oKYNB3rHCvYR+Iw1QyPtH5GkzMIi3PkvZsyDc9SKfUd47xo+vP0PvAP3LSS5HZnCmyDHPmeLjjIeRlXtDyTJkYU0U5+rQvJQPc40SNq2FJDj8OXjv8Juc3WU5TwsIpDluPOnE3WX5nO8b5jX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387972; c=relaxed/simple;
	bh=C+5NrqxsKV9bZJJpZEMZ6HNHyCknCbTZwPyzduYBexc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cSvAdGZmMXjg9/CRAcDjLHkgA9+m6z9WeN+/aBSj/C8tJM21AMNXU7gMbRq7uCchgp1yGv2AI5A3qEIzXRHwWUaKTcnAV2I8bd7MC1LKoMcSlGnOwyBNrcq1ZlCC3seVUGeJg/hZRXQNP8AhmrwSqvDJPHRIdYU5GkBRbDpKzZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tZv8plED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tZv8plED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB706C4CEE8;
	Fri,  7 Mar 2025 22:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387971;
	bh=C+5NrqxsKV9bZJJpZEMZ6HNHyCknCbTZwPyzduYBexc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZv8plED3XGLafNqj8LkSwOSYugLF3BJqXJIKA8mwA+LrNOCZBXDfP+Q8FOzKFrYq
	 h3tZtfZBfXRtHDivQdKW7tw3RqKVtaCLxuom2xrzMH8L0U6ca6ZGpN4tZNYzVQI8lE
	 yZ2Zib/UJiDa4AXSZx0UWU9V/Nfr3Dzbov6zVybwrfu2d/8SZQ7H7w0qRdjW064z4E
	 m5ZiXKv5roGcn/lao7dS3VP8og+1b1iTZyO/XHIkMJ0861rRc2x6BbTmTSVPHTFxCD
	 8CTBaB8saKaZ1mzqQb+8ACcc3qy8SDYvyA0ZZA9KJTTzcZeD6qEuIUQcS+3PJnwvO5
	 zpOxF/Ukqg/cw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 50/60] drm/panic: remove unnecessary borrow in alignment_pattern
Date: Fri,  7 Mar 2025 23:49:57 +0100
Message-ID: <20250307225008.779961-51-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Böhler <witcher@wiredspace.de>

commit 7b6de57e0b2d1e62becfa3aac063c4c58d2c2c42 upstream.

The function `alignment_pattern` returns a static reference to a `u8`
slice. The borrow of the returned element in `ALIGNMENT_PATTERNS` is
already a reference as defined in the array definition above so this
borrow is unnecessary and removed by the compiler. Clippy notes this in
`needless_borrow`:

    error: this expression creates a reference which is immediately dereferenced by the compiler
       --> drivers/gpu/drm/drm_panic_qr.rs:245:9
        |
    245 |         &ALIGNMENT_PATTERNS[self.0 - 1]
        |         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ help: change this to: `ALIGNMENT_PATTERNS[self.0 - 1]`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#needless_borrow
        = note: `-D clippy::needless-borrow` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::needless_borrow)]`

Remove the unnecessary borrow.

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1123
Signed-off-by: Thomas Böhler <witcher@wiredspace.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20241019084048.22336-3-witcher@wiredspace.de
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index 25edc69f8e22..ce245d6b9b91 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -239,7 +239,7 @@ fn g1_blk_size(&self) -> usize {
     }
 
     fn alignment_pattern(&self) -> &'static [u8] {
-        &ALIGNMENT_PATTERNS[self.0 - 1]
+        ALIGNMENT_PATTERNS[self.0 - 1]
     }
 
     fn poly(&self) -> &'static [u8] {
-- 
2.48.1

