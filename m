Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B3C18BC36;
	Fri,  7 Mar 2025 22:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387977; cv=none; b=mzm5o3txHVqYe+EQeW6nALhJD39KXp+bTgW9tpyvfXhKF5aKVGEbDYPEpq6m1I7dkYsXXTa3HwyONDQiykBsyUcW+f006kxG9CGgjILRhWxjq7kxQuF/Foq/SCmr4F+v6+r4Uve9E1QZ++gKnI5V7VBj4OxF/SA6XhrP56JnKYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387977; c=relaxed/simple;
	bh=Me2so8xCVMyVWCnQSHzhaMtip4WBU5gUV6Gzmd7tfV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O/YqRyWu7KRJ7tgj9+yhTQnF187rvEfvBVHPaL0gzYTuLJOxK+4gGE2Lm6IiYvXLrhm7LUHTu0+VYvhpmXrf9dAQ8Z2HsAGnxPG1zy742SA91zdDVkYa/afHqDatLZ7N90FD96eML0HYbQYxpdis2saXLzGZlZ/h3VOr7oloKCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qa0PVjQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qa0PVjQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F6DC4CEE3;
	Fri,  7 Mar 2025 22:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387977;
	bh=Me2so8xCVMyVWCnQSHzhaMtip4WBU5gUV6Gzmd7tfV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qa0PVjQ+JXH2YwW0E5e0O6GOYzT4CvjgVhk/nwTrjLZwQc46Mqgvpfz/nkdF/+mOq
	 LeS5MSsUWNppV7atWLtevsLzDklMofPNpmbh9AeMKBROc+Mt+r1XDwVAA1Jt/xB/Ch
	 P81jcL/39FZ0Onq2MkAFbs9ZpHnvoOnBJs9xY5KEDQWhYkIG+2Tim8Qqvy4p5cz67K
	 awwNo5Roi3l3Hv/82PHNblLc9B1uuJT0G2h/3BpNN5ytcCEZd/8rw6I/umxg8OQmee
	 PzbXz/vGu/2/nSGkxwm26pwqE4jXnWz4U3lYewN45dPjXpJ6Ld6X2S2E+LaBh43lol
	 wKkvyiv6SUw1A==
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
Subject: [PATCH 6.12.y 52/60] drm/panic: remove redundant field when assigning value
Date: Fri,  7 Mar 2025 23:49:59 +0100
Message-ID: <20250307225008.779961-53-ojeda@kernel.org>
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

commit da13129a3f2a75d49469e1d6f7dcefac2d11d205 upstream.

Rust allows initializing fields of a struct without specifying the
attribute that is assigned if the variable has the same name. In this
instance this is done for all other attributes of the struct except for
`data`. Clippy notes the redundant field name:

    error: redundant field names in struct initialization
    --> drivers/gpu/drm/drm_panic_qr.rs:495:13
        |
    495 |             data: data,
        |             ^^^^^^^^^^ help: replace it with: `data`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#redundant_field_names
        = note: `-D clippy::redundant-field-names` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::redundant_field_names)]`

Remove the redundant `data` in the assignment to be consistent.

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1123
Signed-off-by: Thomas Böhler <witcher@wiredspace.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20241019084048.22336-5-witcher@wiredspace.de
[ Reworded to add Clippy warning like it is done in the rest of the
  series. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index f7e224ad340d..c0f9fd69d6cf 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -489,7 +489,7 @@ fn new<'a>(segments: &[&Segment<'_>], data: &'a mut [u8]) -> Option<EncodedMsg<'
         data.fill(0);
 
         let mut em = EncodedMsg {
-            data: data,
+            data,
             ec_size,
             g1_blocks,
             g2_blocks,
-- 
2.48.1

