Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46972D738F;
	Wed,  4 Feb 2026 15:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219184; cv=none; b=QrCaKNaUr7YgMOOoEM990fEles+3MerxJW2GksO92nkaRCt9LJzo1cFVS0zVi0POjTCrHuagGbOkUJNx++s5yMOOKhNSne8LoiIoFn55kI7lj4EYIoZ6t+vEm8+pPjO/SG1dsw61IDKTlZvSyKCajcKPUO2V1j3kA90UKIP8td0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219184; c=relaxed/simple;
	bh=1WEWMUHBa7UO1cJCIKf5UdiQiJexXkwjpKXy9RdpG/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQqFuBYdf5Atov+lNVmQAXSDCIJfGf43cku/2VWdxDkCibRsZUP5OZH0VtdFMnLKGEugKI3fhLUqY6I5lzjQT8fh77R4Fu6ybtLT3vInJ6uC5oz/jCSZodnVIvXnbDtXhgdnQ0Ii5TGbNCzbvSrZNPT71vFo9qrf+5gXAAgJr6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TP2+RMFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TP2+RMFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F88EC4CEF7;
	Wed,  4 Feb 2026 15:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219184;
	bh=1WEWMUHBa7UO1cJCIKf5UdiQiJexXkwjpKXy9RdpG/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TP2+RMFbHM2SgvIbcS3WE1YoBMPr3f1kCNOR3n6nFmMP29CHRJdMdOWmzwIMEfHDl
	 e9jOhW4l4XmRu3sknm06NylvjT/BceJAAISMU27fPH6EzoekEgnVqLFFfAMXrkleLC
	 BSZHU8Lraskrg0VsfMUJ/pyjp8gBOQdZGZZqt3rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 091/122] rust: bits: always inline functions using build_assert with arguments
Date: Wed,  4 Feb 2026 15:41:13 +0100
Message-ID: <20260204143855.125714449@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Alexandre Courbot <acourbot@nvidia.com>

commit 09c3c9112d71c44146419c87c55c710e68335741 upstream.

`build_assert` relies on the compiler to optimize out its error path.
Functions using it with its arguments must thus always be inlined,
otherwise the error path of `build_assert` might not be optimized out,
triggering a build error.

Cc: stable@vger.kernel.org
Fixes: cc84ef3b88f4 ("rust: bits: add support for bits/genmask macros")
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Link: https://patch.msgid.link/20251208-io-build-assert-v3-4-98aded02c1ea@nvidia.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/bits.rs | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/bits.rs b/rust/kernel/bits.rs
index 553d50265883..2daead125626 100644
--- a/rust/kernel/bits.rs
+++ b/rust/kernel/bits.rs
@@ -27,7 +27,8 @@ pub fn [<checked_bit_ $ty>](n: u32) -> Option<$ty> {
             ///
             /// This version is the default and should be used if `n` is known at
             /// compile time.
-            #[inline]
+            // Always inline to optimize out error path of `build_assert`.
+            #[inline(always)]
             pub const fn [<bit_ $ty>](n: u32) -> $ty {
                 build_assert!(n < <$ty>::BITS);
                 (1 as $ty) << n
@@ -75,7 +76,8 @@ pub fn [<genmask_checked_ $ty>](range: RangeInclusive<u32>) -> Option<$ty> {
             /// This version is the default and should be used if the range is known
             /// at compile time.
             $(#[$genmask_ex])*
-            #[inline]
+            // Always inline to optimize out error path of `build_assert`.
+            #[inline(always)]
             pub const fn [<genmask_ $ty>](range: RangeInclusive<u32>) -> $ty {
                 let start = *range.start();
                 let end = *range.end();
-- 
2.53.0



