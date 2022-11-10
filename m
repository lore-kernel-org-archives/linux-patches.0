Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB74107A2
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 16:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D687C433C1;
	Thu, 10 Nov 2022 16:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668098598;
	bh=Z3Poal8/0sehEb7NLOgdH3l5JP1/vq7TUA9vjjBRHIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLFepvqhskfPiO9iSLzm0an7+SN+UMlAWx99yK/eHXyeVW2bZmLa5cfif0sVu9kbw
	 WFqYdTyDbQ85XqNWhZzwuvnRhBUEZWWEefvXDU6kFv3/RChF+U/SikwzuntqV6qJlK
	 e3zLr3B0QjaCQ9YRnHDZMm/0/rr1dhUtM6KG58Y3LD3Cv0knc0j8mKtQMq3Kosb8/5
	 0vrXxNLcocW5m4rz3TLhiJXIBGneTrap2b2acp+O5K73KzyfRQUZ/tjzWe65CPqWsV
	 5hztVAqrW3FioMbMiXR26ZeWvUvTcu7k7SstTfGM0j0ltAMEgXqNFRIDgYCKke6Jl0
	 s/IFAJzVZ/DqQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Adam Bratschi-Kaye <ark.email@gmail.com>
Subject: [PATCH v1 20/28] rust: str: add `Formatter` type
Date: Thu, 10 Nov 2022 17:41:32 +0100
Message-Id: <20221110164152.26136-21-ojeda@kernel.org>
In-Reply-To: <20221110164152.26136-1-ojeda@kernel.org>
References: <20221110164152.26136-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wedson Almeida Filho <wedsonaf@gmail.com>

Add the `Formatter` type, which leverages `RawFormatter`,
but fails if callers attempt to write more than will fit
in the buffer.

In order to so, implement the `RawFormatter::from_buffer()`
constructor as well.

Co-developed-by: Adam Bratschi-Kaye <ark.email@gmail.com>
Signed-off-by: Adam Bratschi-Kaye <ark.email@gmail.com>
Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
[Reworded, adapted for upstream and applied latest changes]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/str.rs | 57 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index 3fb73b888dce..db6473db31c6 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -415,6 +415,23 @@ impl RawFormatter {
         }
     }
 
+    /// Creates a new instance of [`RawFormatter`] with the given buffer.
+    ///
+    /// # Safety
+    ///
+    /// The memory region starting at `buf` and extending for `len` bytes must be valid for writes
+    /// for the lifetime of the returned [`RawFormatter`].
+    pub(crate) unsafe fn from_buffer(buf: *mut u8, len: usize) -> Self {
+        let pos = buf as usize;
+        // INVARIANT: We ensure that `end` is never less then `buf`, and the safety requirements
+        // guarantees that the memory region is valid for writes.
+        Self {
+            pos,
+            beg: pos,
+            end: pos.saturating_add(len),
+        }
+    }
+
     /// Returns the current insert position.
     ///
     /// N.B. It may point to invalid memory.
@@ -448,3 +465,43 @@ impl fmt::Write for RawFormatter {
         Ok(())
     }
 }
+
+/// Allows formatting of [`fmt::Arguments`] into a raw buffer.
+///
+/// Fails if callers attempt to write more than will fit in the buffer.
+pub(crate) struct Formatter(RawFormatter);
+
+impl Formatter {
+    /// Creates a new instance of [`Formatter`] with the given buffer.
+    ///
+    /// # Safety
+    ///
+    /// The memory region starting at `buf` and extending for `len` bytes must be valid for writes
+    /// for the lifetime of the returned [`Formatter`].
+    #[allow(dead_code)]
+    pub(crate) unsafe fn from_buffer(buf: *mut u8, len: usize) -> Self {
+        // SAFETY: The safety requirements of this function satisfy those of the callee.
+        Self(unsafe { RawFormatter::from_buffer(buf, len) })
+    }
+}
+
+impl Deref for Formatter {
+    type Target = RawFormatter;
+
+    fn deref(&self) -> &Self::Target {
+        &self.0
+    }
+}
+
+impl fmt::Write for Formatter {
+    fn write_str(&mut self, s: &str) -> fmt::Result {
+        self.0.write_str(s)?;
+
+        // Fail the request if we go past the end of the buffer.
+        if self.0.pos > self.0.end {
+            Err(fmt::Error)
+        } else {
+            Ok(())
+        }
+    }
+}
-- 
2.38.1

