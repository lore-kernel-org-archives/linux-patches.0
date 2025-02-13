Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8CB211468;
	Thu, 13 Feb 2025 14:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457965; cv=none; b=AIcmg4u5CsiwwFn4w0nQgu3Otefd5DHmVAglsTWvFbkqTLTHcORwa3vo7kC7gdTSGpupISM52tMlIb0ammkCOGwn+HKmhCWPEu6Jo7ywFk8DhGCVs0fH5ktVn/TildJCaRymNsDVV8cgIU5H5ozRLX2AQZGuEQVdJfgWk1yqu8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457965; c=relaxed/simple;
	bh=sWHOy66jahNeCWYhw9839gM1HICvkUM5kw4vYrCjee4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjVrT0Q/8ZVhZ+twtvDP85II3kv4v60CvFrYmfynNctFYo1sFYKDZ16FCNlY5JanXYObQhDKeQV1ULxJrGmY1MVEDcJiEBBRlQuJicwbFoy3zBY9USgzhHifolEPFzNWqvyQYrxcE1GJdBTXBKzgYaUjUK7raNwJFlxpcnI4gQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAW09YTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAW09YTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FDBC4CED1;
	Thu, 13 Feb 2025 14:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457965;
	bh=sWHOy66jahNeCWYhw9839gM1HICvkUM5kw4vYrCjee4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAW09YThaUuhI4LqI1qpGOveB3UEqDTTqqGpc8xjkQSF0me8/4s5PhZrVzN2gxgPL
	 usT/61dnW+qT6kNYZXluivnH9Ff82IZ54RV5+BkPRD/vpSovfeYxQ207WCI0RFDg3h
	 9Cg0IM7lTKj1lukx5a5mNpcwn9BNbJYXUkerpPIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.12 262/422] x86: rust: set rustc-abi=x86-softfloat on rustc>=1.86.0
Date: Thu, 13 Feb 2025 15:26:51 +0100
Message-ID: <20250213142446.651887297@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Alice Ryhl <aliceryhl@google.com>

commit 6273a058383e05465083b535ed9469f2c8a48321 upstream.

When using Rust on the x86 architecture, we are currently using the
unstable target.json feature to specify the compilation target. Rustc is
going to change how softfloat is specified in the target.json file on
x86, thus update generate_rust_target.rs to specify softfloat using the
new option.

Note that if you enable this parameter with a compiler that does not
recognize it, then that triggers a warning but it does not break the
build.

[ For future reference, this solves the following error:

        RUSTC L rust/core.o
      error: Error loading target specification: target feature
      `soft-float` is incompatible with the ABI but gets enabled in
      target spec. Run `rustc --print target-list` for a list of
      built-in targets

  - Miguel ]

Cc: <stable@vger.kernel.org> # Needed in 6.12.y and 6.13.y only (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust/pull/136146
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com> # for x86
Link: https://lore.kernel.org/r/20250203-rustc-1-86-x86-softfloat-v1-1-220a72a5003e@google.com
[ Added 6.13.y too to Cc: stable tag and added reasoning to avoid
  over-backporting. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_rust_target.rs | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/scripts/generate_rust_target.rs b/scripts/generate_rust_target.rs
index 0d00ac3723b5..4fd6b6ab3e32 100644
--- a/scripts/generate_rust_target.rs
+++ b/scripts/generate_rust_target.rs
@@ -165,6 +165,18 @@ fn has(&self, option: &str) -> bool {
         let option = "CONFIG_".to_owned() + option;
         self.0.contains_key(&option)
     }
+
+    /// Is the rustc version at least `major.minor.patch`?
+    fn rustc_version_atleast(&self, major: u32, minor: u32, patch: u32) -> bool {
+        let check_version = 100000 * major + 100 * minor + patch;
+        let actual_version = self
+            .0
+            .get("CONFIG_RUSTC_VERSION")
+            .unwrap()
+            .parse::<u32>()
+            .unwrap();
+        check_version <= actual_version
+    }
 }
 
 fn main() {
@@ -182,6 +194,9 @@ fn main() {
         }
     } else if cfg.has("X86_64") {
         ts.push("arch", "x86_64");
+        if cfg.rustc_version_atleast(1, 86, 0) {
+            ts.push("rustc-abi", "x86-softfloat");
+        }
         ts.push(
             "data-layout",
             "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128",
@@ -215,6 +230,9 @@ fn main() {
             panic!("32-bit x86 only works under UML");
         }
         ts.push("arch", "x86");
+        if cfg.rustc_version_atleast(1, 86, 0) {
+            ts.push("rustc-abi", "x86-softfloat");
+        }
         ts.push(
             "data-layout",
             "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128",
-- 
2.48.1



