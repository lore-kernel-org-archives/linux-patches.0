Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F266212FBE;
	Sun,  8 Jun 2025 12:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749387334; cv=none; b=rDJuOJViwyAKqb1/jRphWLiegyuds2ESebQXI/+LHSjWEnH76jpT3RKcSN51ql1uvRmKTbauNhpjSpRP4dvC8nTKxlFq4rPfrrYlsjNfu/RPDQirF8XNl2jrBJzkUZvcX952b5iY1j5ddVDO5oOZ9o4NumNwv1LZQX54YoI9TfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749387334; c=relaxed/simple;
	bh=mTWEQBwuOQ+8xfDc0wtqzj6a+fA2sKBAoHyMcP06/pY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X6guLPq125pDFoPrOtEMd13vwQ/SHKOk1aCJMX1NeI2llqWmrTI6ioQVA0I63iY1oQrLB96+xjyay58FC/yxlG5m2clAxmW/r9IOzKxjrqgtugQLBTWXz7k5ri4O3tacUJHW6sPBmHQJLgqOKePZ47GI3bx09hs/AifdYH+1+8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qIouFK0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qIouFK0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178BAC4CEEF;
	Sun,  8 Jun 2025 12:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749387333;
	bh=mTWEQBwuOQ+8xfDc0wtqzj6a+fA2sKBAoHyMcP06/pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIouFK0ZOcjSgIRtfoVeZYL7GuStrANCzzxLLnyTSQJpcROrRs2R0qiqse2vW7D80
	 jLrObBtUjZofu8i8NFjJ/xmELocw++2C6GbBx3IU0ybRH4NNWO1oJD7Umng9Y/4pPi
	 9knvXP2KufnahVOsx+8Ub4/lamms3BJkwwHRgee7/iq9KzB21ja+GRbaH2AMCN8nXs
	 mGH+V8SMsDFFda4ZCyP6eGY3OUfpNKD+GnuaFAEXR9cadszsTkYUpF5316WA2wby4L
	 B9rH6b4l/v12vsamD1hCXXOcAu7C3mNOeCyITxHRb6Q9jXDPAgcsmnuKXczn3TaGiw
	 gTlScqddtv6VA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	alex.gaynor@gmail.com,
	lossin@kernel.org,
	aliceryhl@google.com,
	gregkh@linuxfoundation.org,
	dakr@kernel.org,
	trintaeoitogc@gmail.com,
	gary@garyguo.net,
	igor.korotin.linux@gmail.com,
	walmeida@microsoft.com,
	anisse@astier.eu,
	rust-for-linux@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 3/8] rust: module: place cleanup_module() in .exit.text section
Date: Sun,  8 Jun 2025 08:55:22 -0400
Message-Id: <20250608125527.934264-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250608125527.934264-1-sashal@kernel.org>
References: <20250608125527.934264-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.93
Content-Transfer-Encoding: 8bit

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

[ Upstream commit 249c3a0e53acefc2b06d3b3e1fc28fb2081f878d ]

Place cleanup_module() in .exit.text section. Currently,
cleanup_module() is likely placed in the .text section. It's
inconsistent with the layout of C modules, where cleanup_module() is
placed in .exit.text.

[ Boqun asked for an example of how the section changed to be
  put in the log. Tomonori provided the following examples:

    C module:

      $ objdump -t ~/build/x86/drivers/block/loop.o|grep clean
      0000000000000000 l     O .exit.data    0000000000000008 __UNIQUE_ID___addressable_cleanup_module412
      0000000000000000 g     F .exit.text    000000000000009c cleanup_module

    Rust module without this patch:

      $ objdump -t ~/build/x86/samples/rust/rust_minimal.o|grep clean
      00000000000002b0 g     F .text         00000000000000c6 cleanup_module
      0000000000000000 g     O .exit.data    0000000000000008 _R...___UNIQUE_ID___addressable_cleanup_module

    Rust module with this patch:

      $ objdump -t ~/build/x86/samples/rust/rust_minimal.o|grep clean
      0000000000000000 g     F .exit.text    00000000000000c6 cleanup_module
      0000000000000000 g     O .exit.data    0000000000000008 _R...___UNIQUE_ID___addressable_cleanup_module

  - Miguel ]

Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20250308044506.14458-1-fujita.tomonori@gmail.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees.

**Analysis:**

This commit adds a single line `#[link_section = ".exit.text"]` to the
`cleanup_module()` function in `rust/macros/module.rs`, making Rust
modules consistent with C modules by placing cleanup code in the
`.exit.text` section instead of the default `.text` section.

**Key factors supporting backporting:**

1. **Consistency fix**: The commit aligns Rust module behavior with
   established C module conventions. From examining
   `/home/sasha/linux/include/linux/init.h:56`, C modules use `#define
   __exit __section(".exit.text")` to place cleanup functions in
   `.exit.text`.

2. **Minimal and contained**: This is an extremely small change - adding
   just one line to specify the link section. The risk of regression is
   essentially zero.

3. **Follows established pattern**: This commit mirrors Similar Commit
   #1 which was marked "YES" for backporting. That commit placed
   `init_module()` in `.init.text` for consistency with C modules, and
   this commit does the same for `cleanup_module()` with `.exit.text`.

4. **Correctness improvement**: The current code places
   `cleanup_module()` in `.text` while the corresponding C code uses
   `.exit.text`. This inconsistency could affect tools that rely on
   standard kernel module section layouts.

5. **Low risk, clear benefit**: The change has no functional impact on
   module operation but improves kernel consistency and correctness. The
   commit message includes clear examples showing the section placement
   before and after the fix.

The commit follows the stable tree criteria of being an important
correctness fix with minimal risk, similar to the approved Similar
Commit #1 that addressed the same inconsistency for `init_module()`.

 rust/macros/module.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/macros/module.rs b/rust/macros/module.rs
index 7dee348ef0cc8..7614a7198ce20 100644
--- a/rust/macros/module.rs
+++ b/rust/macros/module.rs
@@ -249,6 +249,7 @@ mod __module_init {{
                     #[cfg(MODULE)]
                     #[doc(hidden)]
                     #[no_mangle]
+                    #[link_section = \".exit.text\"]
                     pub extern \"C\" fn cleanup_module() {{
                         // SAFETY:
                         // - This function is inaccessible to the outside due to the double
-- 
2.39.5

