Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE76C3A5E6F;
	Thu, 17 Sep 2026 15:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660096; cv=none; b=Pg25uHQ1Hc5VXAsUMeM7wbQE2q2tYM1mChvS4pTmS7FCLqvMP1oOTSWwm+5oOIX5iJco7/bTxH37jni1MC+tXJkU4od9r0esa5Sy2XG8b61S848uM68hYQid6Zp0H02SLrry1WG07S4ZvGq02XfpM27jR9FCfc6i4HU7cKElLes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660096; c=relaxed/simple;
	bh=i9c5DDy511syHsrjS4JyxlZa78iYIsWyaRPfk9mTPN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1IgZVGRWT4ofBa+l5p37CQl1PrjzjqLwRgz8VfDneH5CUah+fODEjv7Qr3ykXgLsYWASXk/FYxH19sNc5bnNsAMrieenIqkIxoxV+BrqnnluieQAXW4Bxp/UzCdHnQ/Cs4quevn9oKftBa9ZvgJKuyicIcW+SO5y2n0p5ciYDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Td56ZqSo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Td56ZqSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5911F00893;
	Thu, 17 Sep 2026 15:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660088;
	bh=KXUJLOQXqp9sje6NvqkuS2aB26VtOK/huwUCGJFA1n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Td56ZqSowgHs2hvWfTTMREX/7TuQzpDDAsdiJUzxk3gEk4OfE0GdkmK0prlBFQ+s5
	 64gpJIyKTfNKjiGzJe9KrFYaYo4VJMmAHzIrrWM3YyzIxCl9l4/Ld+5bQtybgV6CAQ
	 h/ooQ5sN41onwHuvCgeB33/mn1k7Up/m/GQruVfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Younes Akhouayri <git@younes.io>,
	Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 7.2 475/733] rust: num: seal Integer
Date: Thu, 17 Sep 2026 16:13:03 +0100
Message-ID: <20260917151403.836358862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Younes Akhouayri <git@younes.io>

commit c6709d5e14072d0e3d02f291daee46a199e5dad3 upstream.

Bounded relies on Integer implementations to describe primitive integer
semantics correctly. In particular, it uses Integer::BITS and Signedness
to justify unchecked operations.

Integer is currently safe and externally implementable, so an
implementation can violate those assumptions and make safe Bounded
operations reach undefined behavior.

For example, an Integer implementation for a u8 wrapper can report
BITS = 16. Safe code can then cast a Bounded<u16, 9> containing 256
to that wrapper. Its TryFrom<u16> implementation returns Err, and
Bounded::cast() calls unwrap_unchecked() on it, causing undefined
behavior.

Seal Integer so only the primitive implementations provided by the
kernel crate can satisfy it.

Fixes: 01e345e82ec3 ("rust: num: add Bounded integer wrapping type")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Closes: https://lore.kernel.org/rust-for-linux/CANiq72mOfR33s4y+Ueivd5NrC5yre+Pcp57ZOBz0msw9A4AP1Q@mail.gmail.com/
Cc: stable@vger.kernel.org
Suggested-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Younes Akhouayri <git@younes.io>
Acked-by: Alexandre Courbot <acourbot@nvidia.com>
Link: https://patch.msgid.link/20260905-feature-rust-num-seal-integer-v2-1-f1311ffbe6e7@younes.io
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/num.rs |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/rust/kernel/num.rs
+++ b/rust/kernel/num.rs
@@ -13,9 +13,14 @@ pub enum Unsigned {}
 /// Designates signed primitive types.
 pub enum Signed {}
 
+mod private {
+    pub trait Sealed {}
+}
+
 /// Describes core properties of integer types.
 pub trait Integer:
-    Sized
+    private::Sealed
+    + Sized
     + Copy
     + Clone
     + PartialEq
@@ -54,6 +59,8 @@ pub trait Integer:
 macro_rules! impl_integer {
     ($($type:ty: $signedness:ty), *) => {
         $(
+        impl private::Sealed for $type {}
+
         impl Integer for $type {
             type Signedness = $signedness;
 


