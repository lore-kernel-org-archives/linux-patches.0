Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6021ADC86;
	Sat,  1 Mar 2025 23:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740871058; cv=none; b=aifZuAR0XM5YULazkD0UL1Cucn3wHgH2YtZUyed2AXgFkKbX5gpF4nx45vMLySv+/TbioN1N5UPYvtRj7+CClq6ILfxcoto1EHM5CgArc3+m8DM9srtFvQMcgQCdXvy3wzT95agr+flW4sTxeTcdfBo3X0M99baSX+D1QIg4l6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740871058; c=relaxed/simple;
	bh=GhbeATzCXl+lMmnbqB+zXHJ3ZcWvW3mX2kTV/3tkedM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i+o8zjVjy0L4ub+O9dHv9JZ1aOw7Q7YRNGdYsdqU3hS8qbHQ0ypEtUrIn2UBO2UOmVC1W0uwZ2KNspnXEQbEzlwRjXzfpsAF2TZEfoZuq9AV0wW5GgLD2xa/tnkS9MJ59dddaNB66UzxjwHrcMap0L1XCL46+WdeddTbYn0QASg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDyu2F3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDyu2F3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B32C4CEDD;
	Sat,  1 Mar 2025 23:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740871058;
	bh=GhbeATzCXl+lMmnbqB+zXHJ3ZcWvW3mX2kTV/3tkedM=;
	h=From:To:Cc:Subject:Date:From;
	b=kDyu2F3xfqwJ+zBTUWwQdm0HaXMy7TpxSqHGkgBAm1vqD8jnPzf+r0ISkzxcTNBQC
	 GIagU5WrvTeVuqgvJACZJ+Sub0iC1ydudzCId/ticfN8pIvnJt2lhGlLdPLs4FYcuZ
	 9jnu6Ytq4HQqTwB1IAl7n48mJ4LO7fZj57Wz8jaTjzBR7/gUdXSNYynXMnhMv4YeYj
	 e0X1yqIpUdNtkTu+gAuzYsib7WAg0X4mM/DNxdEIRDfily+Zmc0bnykvPV2E14Ewhg
	 fU41iUdECVpNhyhPp3vGSVgT24qkkpRzE1CUDHAqQEcmy1Pga4aRVmUTEA6G8visYy
	 wCRbTiuD3F6sw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Jocelyn Falempe <jfalempe@redhat.com>,
	=?UTF-8?q?Thomas=20B=C3=B6hler?= <witcher@wiredspace.de>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/2] drm/panic: use `div_ceil` to clean Clippy warning
Date: Sun,  2 Mar 2025 00:16:01 +0100
Message-ID: <20250301231602.917580-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with the upcoming Rust 1.86.0 (to be released 2025-04-03),
Clippy warns:

    error: manually reimplementing `div_ceil`
       --> drivers/gpu/drm/drm_panic_qr.rs:548:26
        |
    548 |         let pad_offset = (offset + 7) / 8;
        |                          ^^^^^^^^^^^^^^^^ help: consider using `.div_ceil()`: `offset.div_ceil(8)`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#manual_div_ceil

And similarly for `stride`. Thus apply the suggestion to both.

The behavior (and thus codegen) is not exactly equivalent [1][2], since
`div_ceil()` returns the right value for the values that currently
would overflow.

Link: https://github.com/rust-lang/rust-clippy/issues/14333 [1]
Link: https://godbolt.org/z/dPq6nGnv3 [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index bcf248f69252..8bb5e52d75cc 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -545,7 +545,7 @@ fn add_segments(&mut self, segments: &[&Segment<'_>]) {
         }
         self.push(&mut offset, (MODE_STOP, 4));
 
-        let pad_offset = (offset + 7) / 8;
+        let pad_offset = offset.div_ceil(8);
         for i in pad_offset..self.version.max_data() {
             self.data[i] = PADDING[(i & 1) ^ (pad_offset & 1)];
         }
@@ -659,7 +659,7 @@ struct QrImage<'a> {
 impl QrImage<'_> {
     fn new<'a, 'b>(em: &'b EncodedMsg<'b>, qrdata: &'a mut [u8]) -> QrImage<'a> {
         let width = em.version.width();
-        let stride = (width + 7) / 8;
+        let stride = width.div_ceil(8);
         let data = qrdata;
 
         let mut qr_image = QrImage {

base-commit: d082ecbc71e9e0bf49883ee4afd435a77a5101b6
-- 
2.48.1

