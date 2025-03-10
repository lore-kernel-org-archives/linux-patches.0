Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ECA22154C;
	Mon, 10 Mar 2025 17:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627235; cv=none; b=gRHGTouTVqImv2HJkN5pnUy3W58kX03OY3KxP5IH5gfz9uBM4J8Bzd9Q/oS2R1JYLmH4+wkCPxW2vR0F8aCZ4qusIyIpoqwMYPa6QMc9sI5vTwwYUpqTsdsBExJZqeBR9eAuWlPBKZEnteQ3k00mVhdJwP5QckpI2KsfHKF/Fhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627235; c=relaxed/simple;
	bh=Y6gXfZRQPsEcy+KUdPK90rzujrW+JG0eTwNImFQ0K2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FHD3H3DxwB/vNvldRHbeFdFhWNL3YurFqsz1DhQKBwBm4rWsHmK/CFf2QYIipSOiSnYFf7KZyPWkykWfNNb0o3v3EfReI9iHKFMj9Qh0E/dpacsoKLDSdY62JP6f/DiibznJrjsn5MPsrx1ymOdzh+lp3le5XHWfFNcvgeD2fDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmqYkqT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmqYkqT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E04C4CEE5;
	Mon, 10 Mar 2025 17:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627234;
	bh=Y6gXfZRQPsEcy+KUdPK90rzujrW+JG0eTwNImFQ0K2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmqYkqT/FPkuzubNCNLZhUh9wv+/PQx69ozPDUpN/nSL8J7rNDKAM26sk9rjrstQE
	 hcyH1Fn1Wdr7yzWyl6cXYt/Skp2ORowMRooE1+i/ONFCfwiHmccOBbCvpIXgmjrXc+
	 m8AlhkfdCUsF1QiLM4IZaYUalx/zemLFoadW4T7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	=?UTF-8?q?Thomas=20B=C3=B6hler?= <witcher@wiredspace.de>,
	Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH 6.12 060/269] drm/panic: avoid reimplementing Iterator::find
Date: Mon, 10 Mar 2025 18:03:33 +0100
Message-ID: <20250310170500.120409662@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panic_qr.rs |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -209,12 +209,9 @@ const FORMAT_INFOS_QR_L: [u16; 8] = [
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


