Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020E5372B4B;
	Fri,  4 Sep 2026 05:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500322; cv=none; b=JktlVZICcRZW51h7WUdhMcTz0ZcRwA7STeKFAmYUesbGoKTTcclaHwW7lA+RmsCZi8yJMqbU8mBf1ZJBszM/A9lHtQS7HgV1EeOIo+HRQgL9Md9bj0M4avnTmSDL+VRulvsRbsv51fFKM3/uEfKp9AQV1vqq37NPaTvCzgg8oEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500322; c=relaxed/simple;
	bh=e8P6Dh3q++1gQzg4HVbawnfx3xxb08sBH6XYB2zg9GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDc04FXLCDVL3MjDeAqcpRtlrmhVobpHeoedPaB07b5s5buaNg6UzEbNCNdEivFyxPyP/052U9DkiPAXtukl7V7Cn9SwhIYOPfCEl3pdlPWgEAjYLJC67LbGrIxhamPTzo+hURnTkJl+y+Dbl47Tt0h4fXiImVXBPkxrN0oY1Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RADF2SFX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RADF2SFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526A51F00A3D;
	Fri,  4 Sep 2026 05:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500320;
	bh=dcOk1S8XuzXPcju9G/SmGvuqG26JK9q5W3Gzb3Vf+tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RADF2SFXtXyStRAseF9hqeO6/G6Zj8b4jll5wNXfhdFZZwCOeOvdeYJtDBaxxWTQt
	 6bLrodmGqVIyviqwoY5YczXZcRY6kpj+m0CAdONuaiTE3EwImGXUZGfKPFTohWVYkc
	 mBFVphyGf44t/UHhL8bdNxIp7ukV5EzVhfH/N+kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 016/552] rust: time: fix as_micros_ceil() rounding near i64::MAX
Date: Fri,  4 Sep 2026 06:52:53 +0200
Message-ID: <20260904045748.193382461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

commit ec90dfcf05f02206c280bb59af660bbb3ae177d0 upstream.

The ceiling adjustment used saturating_add(NSEC_PER_USEC - 1) before
dividing. Once the nanosecond value gets within NSEC_PER_USEC - 1 of
i64::MAX the addition saturates to i64::MAX, which drops the ceiling
bias and can yield a result one microsecond too small.

Fixes: fae0cdc12340 ("rust: time: Introduce Delta type")
Reported-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Closes: https://lore.kernel.org/rust-for-linux/CANiq72mtS0ABA2JnT5tpz6J9c_mnxY+vyPvghV_ukngWvN8F2w@mail.gmail.com/
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Acked-by: Andreas Hindborg <a.hindborg@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260807130531.1056209-1-tomo@flapping.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/time.rs |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/rust/kernel/time.rs
+++ b/rust/kernel/time.rs
@@ -421,22 +421,25 @@ impl Delta {
     /// to the value in the [`Delta`].
     #[inline]
     pub fn as_micros_ceil(self) -> i64 {
+        // Only positive values need to be rounded up: truncating division already
+        // rounds towards zero, i.e. up, for negative values.
+        //
+        // The usual `(nanos + d - 1) / d` is not used because the addition overflows
+        // once `nanos` exceeds `i64::MAX - (d - 1)`; saturating the addition instead
+        // would drop the rounding bias and return a result one unit too small.
         let n = self.as_nanos();
-        let n = if n >= 0 {
-            n.saturating_add(NSEC_PER_USEC - 1)
-        } else {
-            n
-        };
+
+        let (n, add) = if n > 0 { (n - 1, 1) } else { (n, 0) };
 
         #[cfg(CONFIG_64BIT)]
         {
-            n / NSEC_PER_USEC
+            n / NSEC_PER_USEC + add
         }
 
         #[cfg(not(CONFIG_64BIT))]
         // SAFETY: It is always safe to call `ktime_to_us()` with any value.
         unsafe {
-            bindings::ktime_to_us(n)
+            bindings::ktime_to_us(n) + add
         }
     }
 


