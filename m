Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FF12D5C91;
	Wed,  4 Feb 2026 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219188; cv=none; b=PMMZ9YdGoUA/83vKCRybn3Uss2OyGWJ73C4LaNet37lRzUfFx0LvhbUvZrCKc2e9ox+m8Cx54X+0zZ1SZh7l0nNkBSGW0Or6YmBe97QGdqY8YT+GX8Vf/tOYJfbDszLGlA1WNvfmuPBAHSCINDKu2C451e9L7LxE7P3KWXs5fuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219188; c=relaxed/simple;
	bh=nfQIA6CvaelNj7kzTvV1xho6QnrycBsdKJg1ylYfaDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jHBL4UzTrkvBZW/+JejLnTey4tSIPKER3TeFMYMyU2ISA2CpZP/u73W+hlgO9yfVMSRFi3pWyjbiRDaVQO32D0aJ57vJsFTONxGW89gboT5BHhh5bVvEkuXNo22jsqIPqlwOoFHbtbjY5jekU1awl/ZvaL+EJSvZq7COe274LIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opHsIQb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opHsIQb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D88C4CEF7;
	Wed,  4 Feb 2026 15:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219188;
	bh=nfQIA6CvaelNj7kzTvV1xho6QnrycBsdKJg1ylYfaDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opHsIQb1Mz9IhPCLrvUZSrAH4TklRXP4Jv/RTBPqjIh2wS2/EYmK5XjCGemlZ4B3v
	 5vvT/a0Ji0qAhvvQWxUeQXiJeuSLUh60SXlvpPNmP8JqP/QRNQxZgSjIocVZESpldh
	 5XloBZZxe/Am5L/mXAy0XNz5YAu7IgkRB8eQef0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Boqun Feng <boqun.feng@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 092/122] rust: sync: atomic: Provide stub for `rusttest` 32-bit hosts
Date: Wed,  4 Feb 2026 15:41:14 +0100
Message-ID: <20260204143855.161961076@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit bd36f6e2abf7f85644f7ea8deb1de4040b03bbc1 upstream.

For arm32, on a x86_64 builder, running the `rusttest` target yields:

    error[E0080]: evaluation of constant value failed
      --> rust/kernel/static_assert.rs:37:23
       |
    37 |         const _: () = ::core::assert!($condition $(,$arg)?);
       |                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ the evaluated program panicked at 'assertion failed: size_of::<isize>() == size_of::<isize_atomic_repr>()', rust/kernel/sync/atomic/predefine.rs:68:1
       |
      ::: rust/kernel/sync/atomic/predefine.rs:68:1
       |
    68 | static_assert!(size_of::<isize>() == size_of::<isize_atomic_repr>());
       | -------------------------------------------------------------------- in this macro invocation
       |
       = note: this error originates in the macro `::core::assert` which comes from the expansion of the macro `static_assert` (in Nightly builds, run with -Z macro-backtrace for more info)

The reason is that `rusttest` runs on the host, so for e.g. a x86_64
builder `isize` is 64 bits but it is not a `CONFIG_64BIT` build.

Fix it by providing a stub for `rusttest` as usual.

Fixes: 84c6d36bcaf9 ("rust: sync: atomic: Add Atomic<{usize,isize}>")
Cc: stable@vger.kernel.org
Reviewed-by: Onur Özkan <work@onurozkan.dev>
Acked-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://patch.msgid.link/20260123233432.22703-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/sync/atomic/predefine.rs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/rust/kernel/sync/atomic/predefine.rs b/rust/kernel/sync/atomic/predefine.rs
index 45a17985cda4..0fca1ba3c2db 100644
--- a/rust/kernel/sync/atomic/predefine.rs
+++ b/rust/kernel/sync/atomic/predefine.rs
@@ -35,12 +35,23 @@ fn rhs_into_delta(rhs: i64) -> i64 {
 // as `isize` and `usize`, and `isize` and `usize` are always bi-directional transmutable to
 // `isize_atomic_repr`, which also always implements `AtomicImpl`.
 #[allow(non_camel_case_types)]
+#[cfg(not(testlib))]
 #[cfg(not(CONFIG_64BIT))]
 type isize_atomic_repr = i32;
 #[allow(non_camel_case_types)]
+#[cfg(not(testlib))]
 #[cfg(CONFIG_64BIT)]
 type isize_atomic_repr = i64;
 
+#[allow(non_camel_case_types)]
+#[cfg(testlib)]
+#[cfg(target_pointer_width = "32")]
+type isize_atomic_repr = i32;
+#[allow(non_camel_case_types)]
+#[cfg(testlib)]
+#[cfg(target_pointer_width = "64")]
+type isize_atomic_repr = i64;
+
 // Ensure size and alignment requirements are checked.
 static_assert!(size_of::<isize>() == size_of::<isize_atomic_repr>());
 static_assert!(align_of::<isize>() == align_of::<isize_atomic_repr>());
-- 
2.53.0



