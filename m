Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0C818BC36;
	Fri,  7 Mar 2025 22:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387999; cv=none; b=myY73SfrWik/tprzIcnkQQOulbzqyE7Ggg8n4w5wfpMnC37T/crlDVEyeZh9cmGn6whzFQJYTn4ZE+qaDAGiT/V+QJARsLgRdrL+eCimjNGI57ayePBWPs7lAo0x+5Leo6qeerTG2+55kWc1liYb6/ePjQU/fO6zlZMcHrgPb/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387999; c=relaxed/simple;
	bh=4Qc6fD7vAa4od4D0L4vhyxptn78VumlHS11kr7lXXGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7CJOuF53ymQ3ug0+CMyyz4qFCFSOHayxvogDu0SHN+naUyHQ5HPGOy3iKOfJopJ8sXyPMdp1g0blL/RuhSFg5cMYVx7M1N2oUOZmTwhXj7jM3w3HZh6oA7bwMO5otPuHjk6CUYf9RWtbRlk7V9cS3LR2+IDygwN+xREk60OCBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4xn7Fbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4xn7Fbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAADC4CEE5;
	Fri,  7 Mar 2025 22:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387999;
	bh=4Qc6fD7vAa4od4D0L4vhyxptn78VumlHS11kr7lXXGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4xn7Fbg/fl3TuPLwhaxdPJBBTiQosXmLBWKR6c3tiNZMbbIq/rVTgZcht4BcuxfM
	 yalEFsiQ1SvK/PptXOY7h2Hy5iRdA/1zLkQ/s9Opm9INnHW56ywk2gFeN6JvZgkBti
	 6aGfBNyIvT7w4qDh4j73M+YF99qV2hZqrd8S/Zy8tlAb0fMVYCU3SFyC1YxGZtKhWu
	 +arEqrw6/63EWjb10kU7w7+z/0sUibriZ12nVAHnu2sm15Dcs+E+F2u2bVXX6UKrrH
	 zccXi8QJeDY0txqOzsArfbYNagNUgaR+JrrWxzqg23RAA+lkm/PvYe7FBNXAXbGg/l
	 P5EWqqzfLGBjg==
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
Subject: [PATCH 6.12.y 60/60] rust: alloc: Fix `ArrayLayout` allocations
Date: Fri,  7 Mar 2025 23:50:07 +0100
Message-ID: <20250307225008.779961-61-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Asahi Lina <lina@asahilina.net>

commit b7ed2b6f4e8d7f64649795e76ee9db67300de8eb upstream.

We were accidentally allocating a layout for the *square* of the object
size due to a variable shadowing mishap.

Fixes memory bloat and page allocation failures in drm/asahi.

Reported-by: Janne Grunau <j@jannau.net>
Fixes: 9e7bbfa18276 ("rust: alloc: introduce `ArrayLayout`")
Signed-off-by: Asahi Lina <lina@asahilina.net>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Link: https://lore.kernel.org/r/20241123-rust-fix-arraylayout-v1-1-197e64c95bd4@asahilina.net
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc/layout.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/alloc/layout.rs b/rust/kernel/alloc/layout.rs
index 7e0c2f46157b..4b3cd7fdc816 100644
--- a/rust/kernel/alloc/layout.rs
+++ b/rust/kernel/alloc/layout.rs
@@ -45,7 +45,7 @@ pub const fn empty() -> Self {
     /// When `len * size_of::<T>()` overflows or when `len * size_of::<T>() > isize::MAX`.
     pub const fn new(len: usize) -> Result<Self, LayoutError> {
         match len.checked_mul(core::mem::size_of::<T>()) {
-            Some(len) if len <= ISIZE_MAX => {
+            Some(size) if size <= ISIZE_MAX => {
                 // INVARIANT: We checked above that `len * size_of::<T>() <= isize::MAX`.
                 Ok(Self {
                     len,
-- 
2.48.1

