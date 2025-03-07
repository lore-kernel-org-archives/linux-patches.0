Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152EE20CCCD;
	Fri,  7 Mar 2025 22:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387987; cv=none; b=RSJ7qgB8lTW9MqgH9I9cQ9RlvcSaXWA9YnDPr11t+zuUinqbL2Js+i2AUm8BoJuQHFpwaUcmlZ/S4ZPpoKav0rCOID7MBq75siyXdvP0c5x7xpqNFIHn10ay2UQpw07Eckze+5GiCdx7mS1moAeLnohdWrxgNZYBdfrY7Tz8lZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387987; c=relaxed/simple;
	bh=s3dYXQaOOA4UdT6sQvHoJvQnhj+E2bnywjPWWxcpVAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EbqL7Cz9VMt6uF5Dlibzp1srfOVOJ1lDB0stxlaNJ0ADaDo5DZsv7HDRt7xHoi0z8ZR4AadZHXqPfEHBqbamR2/+8pwJljlk2AuVdtgSpXwiJlPmkvxd89RXLgamQHPxmikBzJfrTtJXb5H/xGBXP9xEKg3jvzN8sdHTe95da8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m95upjTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m95upjTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F42C4CEE3;
	Fri,  7 Mar 2025 22:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387985;
	bh=s3dYXQaOOA4UdT6sQvHoJvQnhj+E2bnywjPWWxcpVAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m95upjTokQAlyeY//gAdciSjRgwILUGinidJS/iwKK/P3W3CHEb75nSVpfAn3vPfx
	 Pp94c5+GU1gj9O4qJBVRDAGWy2sx5YFacdCyN4Zcy+ylPKJzDoFiMJNx0VtMVFkVyH
	 XA2GICt2gUSxaTAWAhMFQTfwfN7qEoeBXmySJ30Zv3kJ01i6jVmLpHbO6lNtclJFyT
	 WTpTszIXVBQB2semcIsMQ0AMxjYKup/rxOm9pMFeIWKThW3GqAdMZjWl+1G2TA9W8C
	 1OOHuqdHZ3Pou/yzCaxxV+Z/Ti5HBaWNmAMfrEPQjWo6lRrol6u4VSdt3nWQvY+hOy
	 C4yAVi701ewIw==
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
Subject: [PATCH 6.12.y 55/60] drm/panic: allow verbose version check
Date: Fri,  7 Mar 2025 23:50:02 +0100
Message-ID: <20250307225008.779961-56-ojeda@kernel.org>
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

commit 06b919e3fedf4798a1f0f60e0b67caa192f724a7 upstream.

Clippy warns about a reimplementation of `RangeInclusive::contains`:

    error: manual `!RangeInclusive::contains` implementation
       --> drivers/gpu/drm/drm_panic_qr.rs:986:8
        |
    986 |     if version < 1 || version > 40 {
        |        ^^^^^^^^^^^^^^^^^^^^^^^^^^^ help: use: `!(1..=40).contains(&version)`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#manual_range_contains
        = note: `-D clippy::manual-range-contains` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::manual_range_contains)]`

Ignore this and keep the current implementation as that makes it easier
to read.

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1123
Signed-off-by: Thomas Böhler <witcher@wiredspace.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20241019084048.22336-8-witcher@wiredspace.de
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index 4671a4fb99da..ef2d490965ba 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -982,6 +982,7 @@ fn draw_all(&mut self, data: impl Iterator<Item = u8>) {
 /// * If `url_len` = 0, only removes 3 bytes for 1 binary segment.
 #[no_mangle]
 pub extern "C" fn drm_panic_qr_max_data_size(version: u8, url_len: usize) -> usize {
+    #[expect(clippy::manual_range_contains)]
     if version < 1 || version > 40 {
         return 0;
     }
-- 
2.48.1

