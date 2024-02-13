Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E5D5FEEB;
	Tue, 13 Feb 2024 17:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845228; cv=none; b=dSC2J/ebK7N3+qGfs8xyspbLgGDdBf/HpLRM0Z6OAAhVXKBiod4iRGW/seAy7hFxw/pM8B11V6Ri+YKXba5PFOPJDr6T23Ks9VbEoIQx9tv95TfvFJjC4pevWrIF7I5iqKruZ2h1k+/3mMAP5cPTCZjIfedXo/MQdsR1NY8vZZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845228; c=relaxed/simple;
	bh=ovGARSdyQTS0gytVRwSF8Kszn3uH5ZZjyYsTIzNXir0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UP63V6B0osxE0vs2tenzF8k2ta8ovfdwjWaWRhIiMfKSIkiBG7W4w5F7tYYOMj4ElZpkl6N52vuLJGdEh3gWh275U0+A9uXKaUAeGWKoZAO4UMgwLI5wvqHWB+4uYt++rrQo1y+fzr/nqbLd9Ip5o7JfNLW5H5mFtb19kau2CWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Erp8BJXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Erp8BJXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD2AC43390;
	Tue, 13 Feb 2024 17:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845227;
	bh=ovGARSdyQTS0gytVRwSF8Kszn3uH5ZZjyYsTIzNXir0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Erp8BJXTbBghkrFGPMWoRX6V3KSvIh173V9SVqOBuMc6Dmyo+Pxmgms1RRQGIVxZ1
	 mpJU3yh6eMaLgISsNwF359kV/UuOHJW7DQ04fSDOZDMlkTRQSmDL72cMV1l1p1cxvK
	 zHbFgubtfUhGV/B8bKfgRIXMPW7JKTalhZnB2NZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.6 012/121] rust: arc: add explicit `drop()` around `Box::from_raw()`
Date: Tue, 13 Feb 2024 18:20:21 +0100
Message-ID: <20240213171853.316775561@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 828176d037e29f813792a8b3ac1591834240e96f upstream.

`Box::from_raw()` is `#[must_use]`, which means the result cannot
go unused.

In Rust 1.71.0, this was not detected because the block expression
swallows the diagnostic [1]:

    unsafe { Box::from_raw(self.ptr.as_ptr()) };

It would have been detected, however, if the line had been instead:

    unsafe { Box::from_raw(self.ptr.as_ptr()); }

i.e. the semicolon being inside the `unsafe` block, rather than
outside.

In Rust 1.72.0, the compiler started warning about this [2], so
without this patch we will get:

        error: unused return value of `alloc::boxed::Box::<T>::from_raw` that must be used
        --> rust/kernel/sync/arc.rs:302:22
        |
    302 |             unsafe { Box::from_raw(self.ptr.as_ptr()) };
        |                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        |
        = note: call `drop(Box::from_raw(ptr))` if you intend to drop the `Box`
        = note: `-D unused-must-use` implied by `-D warnings`
    help: use `let _ = ...` to ignore the resulting value
        |
    302 |             unsafe { let _ = Box::from_raw(self.ptr.as_ptr()); };
        |                      +++++++                                 +

Thus add an add an explicit `drop()` as the `#[must_use]`'s
annotation suggests (instead of the more general help line).

Link: https://github.com/rust-lang/rust/issues/104253 [1]
Link: https://github.com/rust-lang/rust/pull/112529 [2]
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
Link: https://lore.kernel.org/r/20230823160244.188033-2-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/sync/arc.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -302,7 +302,7 @@ impl<T: ?Sized> Drop for Arc<T> {
             // The count reached zero, we must free the memory.
             //
             // SAFETY: The pointer was initialised from the result of `Box::leak`.
-            unsafe { Box::from_raw(self.ptr.as_ptr()) };
+            unsafe { drop(Box::from_raw(self.ptr.as_ptr())) };
         }
     }
 }


