Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671D21AA1F4;
	Fri,  4 Sep 2026 05:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498302; cv=none; b=PL8NAiFHHAbvNVGsZMtrFpnhT3sjCVORKE85Yyj5ST5nOs/T3cFyAgbR2qEXPJfKggEIXJQLVuSDaIX20v2D0PIdOiOlj1GY4pm0IdN5YcUxeZAU86c1Y3su+2yWrPkTjkTsSp0l4EiFN5oO9N4g1HorwHw5+gdsgRwxGnfnctI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498302; c=relaxed/simple;
	bh=flG7mDKb+xywLmG1X1bh8c9Kw8V0YAP73Smj0lRJ3Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fakVdtZjPnGLdSnx16i9yz4k1zJwNVB9fAH3cgltccGSMKO6F5iCbVj1SoCEOvS+u1DI9nT8/yaXmSzvhFZzsta5jhdg9owak8ICUSxZ+IayeOPOm2jY7VGqf4+qMxz+RaMNkgWVSJdvN/7dw0Dxpj+Z1SGuRhaDkDV0tvkBqFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CT0m0u6e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CT0m0u6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C016D1F00A3D;
	Fri,  4 Sep 2026 05:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498301;
	bh=ztlSSobCffXxjau+32AvRLVXy70x52fcbg3ADnuWP4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CT0m0u6eHsBKMXm87C0YC2Kju8FWOSFFsRxi4oWQTMWvxxlq2BGuDZUxA4v7N45C/
	 /2W8T8M8XmNYACa2JUN9+kceYKRdTg504vZzqf5pi3/Aqh08mGAc+Kfp1qFtMAmj8e
	 wQ+icjB3i8JAdiZBKkcPXzkvSh8Swe3t8SHMXW6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 015/713] rust: time: fix as_micros_ceil() rounding near i64::MAX
Date: Fri,  4 Sep 2026 06:49:43 +0200
Message-ID: <20260904045804.167109357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -441,22 +441,25 @@ impl Delta {
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
 


