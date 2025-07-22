Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C522D9EE2;
	Tue, 22 Jul 2025 14:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193380; cv=none; b=PP2IOdOkjEnNyAvugk0p+q+HzmUrnJRLx4jWlIDQiXZnvSUaKmh7TNfzgsRwC62vYzX+KrUhG5xgBXRCTAXVWo39MTds1t2cxpUK6mjeSDLu8dVtXZmMWuyXC0RgfjquNVyfRTuS3SxREoIOUCTncjS1Rj/OCgaM3MywvNYdo+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193380; c=relaxed/simple;
	bh=6Y4ChGAvnOAGedA0gnu8KuAfWL7uEpU7zTBgM+F63JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufuGo1ikJzL3QCEzCvW9g7lX6wFFiGLF74+WNBsGcaWTiej5Mt13rh4y/u/2CRyfpgIMoJLdH5K3cMo0UomvII1knRJRMG8WJrXfA+R6dn1m67LCb+OR0GktvLfJHWMhdK1Zsm522Gg73NtiuFrx4Hg86Aqaa4fLMUGYiUpLjtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=siLSuHu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="siLSuHu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9D7C4CEEB;
	Tue, 22 Jul 2025 14:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193380;
	bh=6Y4ChGAvnOAGedA0gnu8KuAfWL7uEpU7zTBgM+F63JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=siLSuHu1MalpyX0kB6cXZ3X/QiLMfuqg2nuNqHm3IpZvj2mrpZY/B6LkQm99FbAgq
	 I2wvMKJfrntFddZQRBVjhh1CbHGzcPUdepkTbjvV5ghqwkUX0Lt07CwGrzpbgppLdi
	 qaFFWggbEEFFRaK4nQDPR6reVgiU8sLLPTys2KLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Benno Lossin <lossin@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.15 031/187] rust: init: Fix generics in *_init! macros
Date: Tue, 22 Jul 2025 15:43:21 +0200
Message-ID: <20250722134346.918055407@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

commit fe49aae0fcb348b656bbde2eb1d1c75d8a1a5c3c upstream.

The match pattern for a optional trailing comma in the list of generics
is erroneously repeated in the code block resulting in following error:

| error: attempted to repeat an expression containing no syntax variables matched as repeating at this depth
|    --> rust/kernel/init.rs:301:73
|     |
| 301 |         ::pin_init::try_pin_init!($(&$this in)? $t $(::<$($generics),* $(,)?>)? {
|     |                                                                         ^^^

Remove "$(,)?" from all code blocks in the try_init! and try_pin_init!
definitions.

Cc: stable@vger.kernel.org
Fixes: 578eb8b6db13 ("rust: pin-init: move the default error behavior of `try_[pin_]init`")
Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Benno Lossin <lossin@kernel.org>
Link: https://lore.kernel.org/r/20250628-rust_init_trailing_comma-v1-1-2d162ae1a757@jannau.net
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/init.rs | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index 8d228c237954..21ef202ab0db 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -231,14 +231,14 @@ macro_rules! try_init {
     ($(&$this:ident in)? $t:ident $(::<$($generics:ty),* $(,)?>)? {
         $($fields:tt)*
     }) => {
-        ::pin_init::try_init!($(&$this in)? $t $(::<$($generics),* $(,)?>)? {
+        ::pin_init::try_init!($(&$this in)? $t $(::<$($generics),*>)? {
             $($fields)*
         }? $crate::error::Error)
     };
     ($(&$this:ident in)? $t:ident $(::<$($generics:ty),* $(,)?>)? {
         $($fields:tt)*
     }? $err:ty) => {
-        ::pin_init::try_init!($(&$this in)? $t $(::<$($generics),* $(,)?>)? {
+        ::pin_init::try_init!($(&$this in)? $t $(::<$($generics),*>)? {
             $($fields)*
         }? $err)
     };
@@ -291,14 +291,14 @@ macro_rules! try_pin_init {
     ($(&$this:ident in)? $t:ident $(::<$($generics:ty),* $(,)?>)? {
         $($fields:tt)*
     }) => {
-        ::pin_init::try_pin_init!($(&$this in)? $t $(::<$($generics),* $(,)?>)? {
+        ::pin_init::try_pin_init!($(&$this in)? $t $(::<$($generics),*>)? {
             $($fields)*
         }? $crate::error::Error)
     };
     ($(&$this:ident in)? $t:ident $(::<$($generics:ty),* $(,)?>)? {
         $($fields:tt)*
     }? $err:ty) => {
-        ::pin_init::try_pin_init!($(&$this in)? $t $(::<$($generics),* $(,)?>)? {
+        ::pin_init::try_pin_init!($(&$this in)? $t $(::<$($generics),*>)? {
             $($fields)*
         }? $err)
     };
-- 
2.50.1



