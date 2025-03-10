Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3C222D799;
	Mon, 10 Mar 2025 17:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627272; cv=none; b=eQrdp7kgs9Xp1NAvSL0ug5qEu9Msy3Mrpja7ArgHbZyGfzhTsls7Pin3k29dTKuqLYAHVXYlCDMdcNl3z1oExfq5fssXBl/AgFoDhpnhPDPwuSRINpii/DEhLyyoTl8P9yWf0BlUvZmy0ZjmXUOEjkyBAPRXr8FENXn/5zT/shY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627272; c=relaxed/simple;
	bh=8fsXcnz0IrFQreGsAWF7yVwcbpUzoeM/6l5+3e4ejpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hfu3Vk8XH+JH2IxNXAhyH6Q6TqHw1PpSoksHVE1PaljpYYfxZSQzNINMkzS8IClkcZ7DDyaFGZsMP2C0xJ89beJPKSpYKS14ok0nAjZNuc9mfHH1e4H4nRlUTBcHmmROktVwht5R9M0VEQQ24oqJu50Q3yKP6rTXxxXz3xuZ5fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5ZTPix7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5ZTPix7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DE6C4CEE5;
	Mon, 10 Mar 2025 17:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627272;
	bh=8fsXcnz0IrFQreGsAWF7yVwcbpUzoeM/6l5+3e4ejpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5ZTPix7bvjYbNlPbES47anGFTBuBytpol6vW3ZAs1xKXq//ELH6LIycjLOer8A1t
	 cUwCUD/7wyp1bQCOVogooycP0wbaXt/aNLMm9rclAEPVU6rpGe/n9yPs5re4Y7ylio
	 iIUmjACxouc2KsiwK0TZn49iyj02AGfUZortEpm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Asahi Lina <lina@asahilina.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 071/269] rust: alloc: Fix `ArrayLayout` allocations
Date: Mon, 10 Mar 2025 18:03:44 +0100
Message-ID: <20250310170500.560529012@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc/layout.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/alloc/layout.rs
+++ b/rust/kernel/alloc/layout.rs
@@ -45,7 +45,7 @@ impl<T> ArrayLayout<T> {
     /// When `len * size_of::<T>()` overflows or when `len * size_of::<T>() > isize::MAX`.
     pub const fn new(len: usize) -> Result<Self, LayoutError> {
         match len.checked_mul(core::mem::size_of::<T>()) {
-            Some(len) if len <= ISIZE_MAX => {
+            Some(size) if size <= ISIZE_MAX => {
                 // INVARIANT: We checked above that `len * size_of::<T>() <= isize::MAX`.
                 Ok(Self {
                     len,


