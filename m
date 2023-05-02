Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBA27E
	for <patches@lists.linux.dev>; Tue,  2 May 2023 12:53:37 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-b9a8023ccf1so7493448276.2
        for <patches@lists.linux.dev>; Tue, 02 May 2023 05:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683032017; x=1685624017;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yD3RHOmw2YonU9lq/qLKI0ISZtFJQuh0JdGUDdx5IQ4=;
        b=Nd8aPNd3NegOIXfFnsIObxs6yMD8V4tXgHyCuXTTN/BZDFLwElKICS86m6HIeGPcJo
         sa21trMsksNhMFTJpnRHFOxe6gNFa2PqBhWUMgMEqBNGYcOmhcrg8ei2+afLGBQtW/1I
         YIMFA+EfZnd6QWWaANQ6O85meD1Xgamv1yPKfhukbtXAhHP9s5JJiBaZJQdgAi8CTqMJ
         Qw+6goOIKN8vyJJALi4cHybsIVUi6VKK1rXv+P7sExw7GiS2FJJRPFi1pw8zKYjxwhbK
         Ccmy/M8HU8QnaK9dBM6FoQA3CxY0dQgSjB+fxgTqTuEnRE+Rb8jAuL2v7MM0U9luLK2k
         Agjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683032017; x=1685624017;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yD3RHOmw2YonU9lq/qLKI0ISZtFJQuh0JdGUDdx5IQ4=;
        b=EZ4UmPfczn5C7wXyPiaVigpm2c3vQzAoqOmLU1K3tDDdVETeq3b+526VTMiwOHv+N0
         H2pXIPO5ENN6CiZSjf/a8GRZbpB0Xey+vMbLLC4NburF24bK0D5HxLfWt8FwLBGmciFR
         vTg9SZB/8xzzd/uRV2I8fXXv+lAvbLaYG+QpYFr8MidFaLhYhVsZ9WcVIgAR45RAXtEx
         IVEyTwXFVKQz8wpFKaFMIr0AcIxeid+KntTmCCHJ84wgFKZDkrRuBj5ulrURRGUPLu3X
         MmaTpKoIlghWxO2nKgzqTA2EY/O1JW2IrDWTE3Fx3RwEbv057MrDLmkyVLV6mOM6wvy/
         xxuQ==
X-Gm-Message-State: AC+VfDzh9mitpvf1HEQhtFpeyTOMoxChFmwvgQQwQ5jvLmb06r7eIGoH
	owyGcRVtRnrRcbpa+WT6hCzxdG0g1AiVQ70=
X-Google-Smtp-Source: ACHHUZ5gPH29sQUYLHBCrXjx3vdTmEARKf1rg93iTFELyjd4V+wNVN9mwS0ZUXmZdt8eM/8Fc88lx09nESpYrVE=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a05:6902:100e:b0:b8f:47c4:58ed with SMTP
 id w14-20020a056902100e00b00b8f47c458edmr10400410ybt.9.1683032016822; Tue, 02
 May 2023 05:53:36 -0700 (PDT)
Date: Tue,  2 May 2023 12:53:06 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230502125306.358283-1-aliceryhl@google.com>
Subject: [PATCH] rust: str: add conversion from `CStr` to `CString`
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="UTF-8"

These methods can be used to copy the data in a temporary c string into
a separate allocation, so that it can be accessed later even if the
original is deallocated.

The API in this file mirrors the standard library API for the `&str` and
`String` types. The `ToOwned` trait is not implemented because it
assumes that allocations are infallible.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/str.rs | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index b771310fa4a4..54935ff3a610 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -2,6 +2,7 @@
 
 //! String representations.
 
+use alloc::collections::TryReserveError;
 use alloc::vec::Vec;
 use core::fmt::{self, Write};
 use core::ops::{self, Deref, Index};
@@ -199,6 +200,12 @@ impl CStr {
     pub unsafe fn as_str_unchecked(&self) -> &str {
         unsafe { core::str::from_utf8_unchecked(self.as_bytes()) }
     }
+
+    /// Convert this [`CStr`] into a [`CString`] by allocating memory and
+    /// copying over the string data.
+    pub fn to_cstring(&self) -> Result<CString, TryReserveError> {
+        CString::try_from(self)
+    }
 }
 
 impl fmt::Display for CStr {
@@ -584,6 +591,20 @@ impl Deref for CString {
     }
 }
 
+impl<'a> TryFrom<&'a CStr> for CString {
+    type Error = TryReserveError;
+
+    fn try_from(cstr: &'a CStr) -> Result<CString, TryReserveError> {
+        let len = cstr.len_with_nul();
+        let mut buf = Vec::try_with_capacity(len)?;
+        buf.try_extend_from_slice(cstr.as_bytes_with_nul())?;
+
+        // INVARIANT: The CStr and CString types have the same invariants for
+        // the string data, and we copied it over without changes.
+        Ok(CString { buf })
+    }
+}
+
 /// A convenience alias for [`core::format_args`].
 #[macro_export]
 macro_rules! fmt {

base-commit: ea76e08f4d901a450619831a255e9e0a4c0ed162
-- 
2.40.1.495.gc816e09b53d-goog

