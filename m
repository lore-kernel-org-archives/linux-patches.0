Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D74C4C71
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 16:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB17CC433D6;
	Fri,  2 Dec 2022 16:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669997779;
	bh=McON9F/ZloZh668lpPUE38B16LOD0pkq/6vZiAe96vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWEPSFt+U4afB3ouQrOI1dLiNWj3KsyQrFnMe6wXclW9FaDMwanxU+sSaojYWuOfs
	 35U/6EixklK6+dHznILLTTZUQ+02HcE89fQkAbYwqMtsLsaGz06G5yQQuLwNZbbwAW
	 l0R/1d//A1po2ye7IzgGzH8YEIhamMRWQKFj93NMgVxRrGZR5QknhIM4bh0OhHWiQ8
	 tLzZ7fnaW338OGOWQ6OgQ0iM92aJUl2ccLt5ZlbD9kffjzE1c+srOlAe8p2CgiQRey
	 OFJGPprap12XvVxfEWApZfBxhkdTF7iNCGlbUVKZFhA7mbQmthzoY9EYa2TwCBkF0N
	 4wg11YkLdQYwQ==
From: ojeda@kernel.org
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Milan Landaverde <milan@mdaverde.com>
Subject: [PATCH v2 18/28] rust: str: add `CStr` unit tests
Date: Fri,  2 Dec 2022 17:14:49 +0100
Message-Id: <20221202161502.385525-19-ojeda@kernel.org>
In-Reply-To: <20221202161502.385525-1-ojeda@kernel.org>
References: <20221202161502.385525-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Milan Landaverde <milan@mdaverde.com>

Add unit tests for `CStr::from_bytes_with_nul()` and
`CStr::from_bytes_with_nul_unchecked()`.

These serve as an example of the first unit tests for Rust code
(i.e. different from documentation tests).

Signed-off-by: Milan Landaverde <milan@mdaverde.com>
[Reworded, adapted for upstream and applied latest changes]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/str.rs | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index 11d297c1a61c..3ed685cb5a3c 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -321,6 +321,35 @@ where
     }
 }
 
+#[cfg(test)]
+mod tests {
+    use super::*;
+
+    #[test]
+    fn test_cstr_to_str() {
+        let good_bytes = b"\xf0\x9f\xa6\x80\0";
+        let checked_cstr = CStr::from_bytes_with_nul(good_bytes).unwrap();
+        let checked_str = checked_cstr.to_str().unwrap();
+        assert_eq!(checked_str, "🦀");
+    }
+
+    #[test]
+    #[should_panic]
+    fn test_cstr_to_str_panic() {
+        let bad_bytes = b"\xc3\x28\0";
+        let checked_cstr = CStr::from_bytes_with_nul(bad_bytes).unwrap();
+        checked_cstr.to_str().unwrap();
+    }
+
+    #[test]
+    fn test_cstr_as_str_unchecked() {
+        let good_bytes = b"\xf0\x9f\x90\xA7\0";
+        let checked_cstr = CStr::from_bytes_with_nul(good_bytes).unwrap();
+        let unchecked_str = unsafe { checked_cstr.as_str_unchecked() };
+        assert_eq!(unchecked_str, "🐧");
+    }
+}
+
 /// Allows formatting of [`fmt::Arguments`] into a raw buffer.
 ///
 /// It does not fail if callers write past the end of the buffer so that they can calculate the
-- 
2.38.1

