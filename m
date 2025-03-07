Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38E618BC36;
	Fri,  7 Mar 2025 22:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387983; cv=none; b=KfXt1opBJYbJwUh0bR2s0dvMpqx8P6hwtiRK7rHM4NYRGZiYeYF5iPZ2yS05SZz+x5kaw2xahvqmmVZ83fx1paZzp2kPgJfH1YN1uKyDmK+lmmwhMoq535JK6mx5I17IkPXG9Czp6k+RK1KnCLcLeW/9uVE4LcJ8OcCXsQRw5VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387983; c=relaxed/simple;
	bh=I2MaiCgt05a6qDe538wG2PQbour3gsaWrsx67ih+qc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AJpHBTFGz47dht7L3qQDzH3Ga7AZKpevBR9xcaA6KaWuvdYxygGE0BbbetpsoQle/K7vmDXktpvqhEQhZodBhjuPp56fr3Eb0wQFdlLGQyVvI5OIEjD1FchyHZwf+gabf+R8D8H3uYoCNtu8l/u9AchPOwKI+b1FFS8q25ECUjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PuWs2Hwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PuWs2Hwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33D0C4CED1;
	Fri,  7 Mar 2025 22:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387982;
	bh=I2MaiCgt05a6qDe538wG2PQbour3gsaWrsx67ih+qc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuWs2HwxbcHPttEFa4vQwWxAhzol5XEYztky3Dlh810tg/fN4gMJwWCOHVKUQirrD
	 jqyohR9KP/SQsrLGRcrVCAeQQxr5q4ixic6UxWTxdq9RqoWgHAE2ukr0iu2luXGGKZ
	 3MuRUaKYA9rlS8idZ9NMmSygSUdN/GyMw091e7ZBjKgh58/A1elgEYP7oUowqDu/fA
	 t8Ku6+Cca5SnrqoGXV6R4wTvOEvqmayVbgcF8MkpOkyTNn/aH9V2DcJL4M07674rRs
	 tHu+WVdnm7cg6frVk+r4/vcz5PJ7x40yC61/ZvetWEh8K9ThG+pSIPDcZRYJK3pE6p
	 A8GHzb1++rq7A==
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
Subject: [PATCH 6.12.y 54/60] drm/panic: allow verbose boolean for clarity
Date: Fri,  7 Mar 2025 23:50:01 +0100
Message-ID: <20250307225008.779961-55-ojeda@kernel.org>
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

commit 27aef8a52e4b7f120ce47cd638d9d83065b759d2 upstream.

Clippy complains about a non-minimal boolean expression with
`nonminimal_bool`:

    error: this boolean expression can be simplified
       --> drivers/gpu/drm/drm_panic_qr.rs:722:9
        |
    722 |         (x < 8 && y < 8) || (x < 8 && y >= end) || (x >= end && y < 8)
        |         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#nonminimal_bool
        = note: `-D clippy::nonminimal-bool` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::nonminimal_bool)]`
    help: try
        |
    722 |         !(x >= 8 || y >= 8 && y < end) || (x >= end && y < 8)
        |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    722 |         (y >= end || y < 8) && x < 8 || (x >= end && y < 8)
        |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While this can be useful in a lot of cases, it isn't here because the
line expresses clearly what the intention is. Simplifying the expression
means losing clarity, so opt-out of this lint for the offending line.

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1123
Signed-off-by: Thomas Böhler <witcher@wiredspace.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20241019084048.22336-7-witcher@wiredspace.de
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index ed87954176e3..4671a4fb99da 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -719,7 +719,10 @@ fn draw_finders(&mut self) {
 
     fn is_finder(&self, x: u8, y: u8) -> bool {
         let end = self.width - 8;
-        (x < 8 && y < 8) || (x < 8 && y >= end) || (x >= end && y < 8)
+        #[expect(clippy::nonminimal_bool)]
+        {
+            (x < 8 && y < 8) || (x < 8 && y >= end) || (x >= end && y < 8)
+        }
     }
 
     // Alignment pattern: 5x5 squares in a grid.
-- 
2.48.1

