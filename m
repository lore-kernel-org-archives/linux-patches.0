Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2412ED87D;
	Tue, 17 Jun 2025 16:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176157; cv=none; b=Z8BIN/Pk8obFZWZwxDfzS/uJm89Pl2QlCdYUMHwospfn25aQfbMBaD03GXqkTZTitg147tp3VSqSofbQdruzm22lKyMLCDggXw8OGHeVtvfwrWqMQoXpOW1eRyo92/5t1aUtM/N/rCLz97HAAW+KAMZ0atw8tdrZ8EQvJbPY4xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176157; c=relaxed/simple;
	bh=YUEFEYYjk6Y2X9IbN7hIMTvyiyULxuvttbE7CFlVa+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UW1KQ3MZQMhxoHzSJl4EVR0RUSyf2JzovYG3673IGpoVKSKg3ObMwkWYlkztRGhbeeGk9zpw9UsB51tdJ8yIOrEGtQfQd/xvDk+WjxOL91TU9aAXZVWPPqiqMX8bpttEy+9EB4uprpvXBlu+7UKfP+vPtKY+k6rwbnoTiOBcWjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBvnhrdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBvnhrdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FBDC4CEE3;
	Tue, 17 Jun 2025 16:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176157;
	bh=YUEFEYYjk6Y2X9IbN7hIMTvyiyULxuvttbE7CFlVa+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBvnhrdzWKq21ikkhYE1SBYtGfJCLmx8utKOQGsxNHnYblWhSLX5ORW/gwVxUluet
	 +cAo65k9BmVSFk1lrx1ckLJRwfd2cQsW6d2ltWFaYrocblwbLhxMdV+LL+e7GLgXkz
	 E2EDjR3xp/rUtC3zUBIzs6ml0aooiFwSEVp1+s+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 160/780] drm/panic: Use a decimal fifo to avoid u64 by u64 divide
Date: Tue, 17 Jun 2025 17:17:48 +0200
Message-ID: <20250617152458.007540079@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Jocelyn Falempe <jfalempe@redhat.com>

[ Upstream commit 675008f196ca5c8d8413204e861cc2a2238581aa ]

On 32bits ARM, u64/u64 is not supported [1], so change the algorithm
to use a simple fifo with decimal digits as u8 instead.
This is slower but should compile on all architecture.

Link: https://lore.kernel.org/dri-devel/CANiq72ke45eOwckMhWHvmwxc03dxr4rnxxKvx+HvWdBLopZfrQ@mail.gmail.com/ [1]
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Closes: https://lore.kernel.org/dri-devel/CANiq72ke45eOwckMhWHvmwxc03dxr4rnxxKvx+HvWdBLopZfrQ@mail.gmail.com/
Fixes: ccb8ce526807 ("ARM: 9441/1: rust: Enable Rust support for ARMv7")
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20250418165059.560503-1-jfalempe@redhat.com
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 71 ++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index ba6724aed51c9..de2ddf5dbbd3f 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -366,8 +366,48 @@ impl Segment<'_> {
         SegmentIterator {
             segment: self,
             offset: 0,
-            carry: 0,
-            carry_len: 0,
+            decfifo: Default::default(),
+        }
+    }
+}
+
+/// Max fifo size is 17 (max push) + 2 (max remaining)
+const MAX_FIFO_SIZE: usize = 19;
+
+/// A simple Decimal digit FIFO
+#[derive(Default)]
+struct DecFifo {
+    decimals: [u8; MAX_FIFO_SIZE],
+    len: usize,
+}
+
+impl DecFifo {
+    fn push(&mut self, data: u64, len: usize) {
+        let mut chunk = data;
+        for i in (0..self.len).rev() {
+            self.decimals[i + len] = self.decimals[i];
+        }
+        for i in 0..len {
+            self.decimals[i] = (chunk % 10) as u8;
+            chunk /= 10;
+        }
+        self.len += len;
+    }
+
+    /// Pop 3 decimal digits from the FIFO
+    fn pop3(&mut self) -> Option<(u16, usize)> {
+        if self.len == 0 {
+            None
+        } else {
+            let poplen = 3.min(self.len);
+            self.len -= poplen;
+            let mut out = 0;
+            let mut exp = 1;
+            for i in 0..poplen {
+                out += self.decimals[self.len + i] as u16 * exp;
+                exp *= 10;
+            }
+            Some((out, NUM_CHARS_BITS[poplen]))
         }
     }
 }
@@ -375,8 +415,7 @@ impl Segment<'_> {
 struct SegmentIterator<'a> {
     segment: &'a Segment<'a>,
     offset: usize,
-    carry: u64,
-    carry_len: usize,
+    decfifo: DecFifo,
 }
 
 impl Iterator for SegmentIterator<'_> {
@@ -394,31 +433,17 @@ impl Iterator for SegmentIterator<'_> {
                 }
             }
             Segment::Numeric(data) => {
-                if self.carry_len < 3 && self.offset < data.len() {
-                    // If there are less than 3 decimal digits in the carry,
-                    // take the next 7 bytes of input, and add them to the carry.
+                if self.decfifo.len < 3 && self.offset < data.len() {
+                    // If there are less than 3 decimal digits in the fifo,
+                    // take the next 7 bytes of input, and push them to the fifo.
                     let mut buf = [0u8; 8];
                     let len = 7.min(data.len() - self.offset);
                     buf[..len].copy_from_slice(&data[self.offset..self.offset + len]);
                     let chunk = u64::from_le_bytes(buf);
-                    let pow = u64::pow(10, BYTES_TO_DIGITS[len] as u32);
-                    self.carry = chunk + self.carry * pow;
+                    self.decfifo.push(chunk, BYTES_TO_DIGITS[len]);
                     self.offset += len;
-                    self.carry_len += BYTES_TO_DIGITS[len];
-                }
-                match self.carry_len {
-                    0 => None,
-                    len => {
-                        // take the next 3 decimal digits of the carry
-                        // and return 10bits of numeric data.
-                        let out_len = 3.min(len);
-                        self.carry_len -= out_len;
-                        let pow = u64::pow(10, self.carry_len as u32);
-                        let out = (self.carry / pow) as u16;
-                        self.carry %= pow;
-                        Some((out, NUM_CHARS_BITS[out_len]))
-                    }
                 }
+                self.decfifo.pop3()
             }
         }
     }
-- 
2.39.5



