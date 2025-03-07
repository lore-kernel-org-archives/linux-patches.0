Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1A623FC68;
	Fri,  7 Mar 2025 22:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387969; cv=none; b=Fip66fFk6GSrL86OoQsvmqt1crWs0ea2awZiWajIOBprWenWNSeRlud179qLcTOPJ5Wjub72zBcU2o7tp95dElvD/GpamT+KIfeB7QjNQm9rUmFTeKLzXbsIu/zqr336Y7gXscwgJRgOsthzj3bEiPmEx+E4ctpR3UT62P1jWfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387969; c=relaxed/simple;
	bh=BQda0t4cVd3xWoXoNqCpm43t3hYwHmRA8AT+X6E7AfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P/eEvRbC2PgbHYgE5AoIgMfdPkih5g+j24TQY8fHynu03eK8qUxcJ6A7JRq2HfePm14YNLNcoCWf+IuN5/L1k2jZKri0dEG7rQM8rlrueqJn1p4By5vCiqXRad0SALliVQQN0EwLiCmthai6dDPXhWnMXJpN2SYzCjTakZBCRz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sXZkloQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sXZkloQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D05AC4CED1;
	Fri,  7 Mar 2025 22:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387969;
	bh=BQda0t4cVd3xWoXoNqCpm43t3hYwHmRA8AT+X6E7AfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXZkloQgQydG5K92HhxbWLAz8Z+3Oy5x8cKZuOZTMUZt2gPS5Jhe6p8BkWkvyWgub
	 tGboi/HposaVZsWQy/spKQ1he5ETjQ5Twdd0X7TAl62ZVdMrfGADu3ovGScCR+J1Jp
	 4610KNAQEkdMKZ8OLM8hRqF8bAf8JLCkwK/C60bhsLNclRJ+oHnhkVcrqyp4JrVq0O
	 7eRMDK13ZeFNpMerZcIMaGCRYYhK8IzZW9VvseBNpr6Rn0ss8Fg3FbBkdjwentbRr7
	 KD1vH3xntvx54GE4f4TUSQMD+d52Dt7tBCm2Y+QHnergOUXMbjUusZnAiZxNnDF7XB
	 5B91NNcK6XmRQ==
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
Subject: [PATCH 6.12.y 49/60] drm/panic: avoid reimplementing Iterator::find
Date: Fri,  7 Mar 2025 23:49:56 +0100
Message-ID: <20250307225008.779961-50-ojeda@kernel.org>
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

commit c408dd81678bb0a957eae96962c913c242e069f7 upstream.

Rust's standard library's `std::iter::Iterator` trait provides a function
`find` that finds the first element that satisfies a predicate.
The function `Version::from_segments` is doing the same thing but is
implementing the same logic itself.

Clippy complains about this in the `manual_find` lint:

    error: manual implementation of `Iterator::find`
       --> drivers/gpu/drm/drm_panic_qr.rs:212:9
        |
    212 | /         for v in (1..=40).map(|k| Version(k)) {
    213 | |             if v.max_data() * 8 >= segments.iter().map(|s| s.total_size_bits(v)).sum() {
    214 | |                 return Some(v);
    215 | |             }
    216 | |         }
    217 | |         None
        | |____________^ help: replace with an iterator: `(1..=40).map(|k| Version(k)).find(|&v| v.max_data() * 8 >= segments.iter().map(|s| s.total_size_bits(v)).sum())`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#manual_find
        = note: `-D clippy::manual-find` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::manual_find)]`

Use `Iterator::find` instead to make the intention clearer.

At the same time, clean up the redundant closure that Clippy warns
about too:

    error: redundant closure
    --> drivers/gpu/drm/drm_panic_qr.rs:212:31
        |
    212 |         for v in (1..=40).map(|k| Version(k)) {
        |                               ^^^^^^^^^^^^^^ help: replace the closure with the function itself: `Version`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#redundant_closure
        = note: `-D clippy::redundant-closure` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::redundant_closure)]`

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1123
Signed-off-by: Thomas Böhler <witcher@wiredspace.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20241019084048.22336-2-witcher@wiredspace.de
[ Reworded to mention the redundant closure cleanup too. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index 447740d79d3d..25edc69f8e22 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -209,12 +209,9 @@
 impl Version {
     /// Returns the smallest QR version than can hold these segments.
     fn from_segments(segments: &[&Segment<'_>]) -> Option<Version> {
-        for v in (1..=40).map(|k| Version(k)) {
-            if v.max_data() * 8 >= segments.iter().map(|s| s.total_size_bits(v)).sum() {
-                return Some(v);
-            }
-        }
-        None
+        (1..=40)
+            .map(Version)
+            .find(|&v| v.max_data() * 8 >= segments.iter().map(|s| s.total_size_bits(v)).sum())
     }
 
     fn width(&self) -> u8 {
-- 
2.48.1

