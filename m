Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BB518BC36;
	Fri,  7 Mar 2025 22:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387980; cv=none; b=gH1hx9RcbmbHf61yEw85Lun1NwD56QDjvnCFgQqY/ajZ5lRspwywp2yOloXOousebURR5rEgO6zs0nbbTjtN2KmpfEw6gVJIak+bblTl5YOyw14jHdqVsphMyytKhvxFk0wsKOqruEG2HOe0nSdQkMKoFXC81/Q2oR3FVi43h3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387980; c=relaxed/simple;
	bh=aIv2MxLnVjO4DsmNacPVTK86YHQ68VTr7r/f2BHvTQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EHjzn1QG2Xm3C0LeT+H9aREuipfor0kUMW1oZdQ4YM4YKewF/9waXbqIsbkoXDjEuHZoiUAOlTxtM1Ow7PUUi5S/8Wwpt1Pe0VaXkf7IsJ3/U5XbAp9G4fIgn9Hm1/LwqHWgNKp8q7jVr21kJktvzRMkq5RAGzhBuddUTFMXvzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFPi0RMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFPi0RMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BEEC4CED1;
	Fri,  7 Mar 2025 22:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387980;
	bh=aIv2MxLnVjO4DsmNacPVTK86YHQ68VTr7r/f2BHvTQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFPi0RMoQRWL9vbq/W/1NNXStWA/NhKbkYbvZk9+UCkfZcVWqFxlPtWejsP7tvf9x
	 bQJXIVgs+A5djccQRd2zbXpe3v07s5xq44uUJ9Eg8M6NmpQFnEL+3PlqLqEPuI2L/V
	 QiOtGk4REoevu09FIQYJ4jT6DJnE9cDrIUUryn3J3gzFzQivCS2us9r7fdAjfRgv9m
	 rsnORzAnllNVe4SjD8NsIftGBBWuI0YfgZxcdTzkX5KMLBJeSvGoqjJLOGwsyomqbV
	 gm5nnHedcMjemv64XVKD4UqcagDWf8ZYqzIV01uh9uv4XtYRAaR5pC4G5e5WLKF62w
	 CvJNVUvO/qAjg==
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
Subject: [PATCH 6.12.y 53/60] drm/panic: correctly indent continuation of line in list item
Date: Fri,  7 Mar 2025 23:50:00 +0100
Message-ID: <20250307225008.779961-54-ojeda@kernel.org>
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

commit 5bb698e6fc514ddd9e23b6649b29a0934d8d8586 upstream.

It is common practice in Rust to indent the next line the same amount of
space as the previous one if both belong to the same list item. Clippy
checks for this with the lint `doc_lazy_continuation`.

    error: doc list item without indentation
    --> drivers/gpu/drm/drm_panic_qr.rs:979:5
        |
    979 | /// conversion to numeric segments.
        |     ^
        |
        = help: if this is supposed to be its own paragraph, add a blank line
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#doc_lazy_continuation
        = note: `-D clippy::doc-lazy-continuation` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::doc_lazy_continuation)]`
    help: indent this line
        |
    979 | ///   conversion to numeric segments.
        |     ++

Indent the offending line by 2 more spaces to remove this Clippy error.

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1123
Signed-off-by: Thomas Böhler <witcher@wiredspace.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20241019084048.22336-6-witcher@wiredspace.de
[ Reworded to indent Clippy's message. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index c0f9fd69d6cf..ed87954176e3 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -975,7 +975,7 @@ fn draw_all(&mut self, data: impl Iterator<Item = u8>) {
 /// * `url_len`: Length of the URL.
 ///
 /// * If `url_len` > 0, remove the 2 segments header/length and also count the
-/// conversion to numeric segments.
+///   conversion to numeric segments.
 /// * If `url_len` = 0, only removes 3 bytes for 1 binary segment.
 #[no_mangle]
 pub extern "C" fn drm_panic_qr_max_data_size(version: u8, url_len: usize) -> usize {
-- 
2.48.1

