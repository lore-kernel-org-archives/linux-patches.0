Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51593B05AC;
	Fri,  4 Sep 2026 05:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498328; cv=none; b=PxMqtRkH4afJfsrqA5gpZPvmMF0tvuiY+XcU2FyIVbgePLLXLo92R6mmF9ZD9jrvAMD/9ko9pPCniiJEIqZll1vTZIzaUbwKXMHaSXiMBDgjHo6GkBabWt4WXLEUyuosVzFXi0Qop3X9vjasBveGGFr9/Kx5EFb1GtaPYTcW90s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498328; c=relaxed/simple;
	bh=RR8UpjLmDfNirOLSjjVpB3KdDwdVvmnle5+RJCqD4Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOdN6mqe1CBvWRvMBjAMfClsmx0ZIfdyYy/r/w0Z6hy8hcAD1d+EMs08DoAplWVpwWUyrOmaOoJEEjsV4xo9Mi+lTOJz5b2sib/c2eER5swJKAx7V39ibOzQ1uPSiZPDhx3BnZoMxjmDheBLXjVybJ4SAwIad7mV5a8YoZf0HUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7d7KpcS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7d7KpcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291B61F00A3D;
	Fri,  4 Sep 2026 05:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498326;
	bh=ceoT6U6NMxRCkYvOHiGo6v9iHyAVxhhESl2rtwfoJJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7d7KpcSAalkI/CjIceEbeVpX9VHXfD5RJubJl1lp+tXQTw28EZ0EIqZsXss5ciKj
	 Fj7odBe8o8LGHvoa/dqnCQ7kIBkjmjAdJO7aCu3395IX8bYWBX9b8tS57KdVFqkwVW
	 BNDI1FTqdRMsF/6D2OkY6F/D0DFBz0sIlEmhgLTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ke Sun <sunke@kylinos.cn>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Link Mauve <linkmauve@linkmauve.fr>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 023/713] rust: fmt: fix {:p} printing stack addresses
Date: Fri,  4 Sep 2026 06:49:51 +0200
Message-ID: <20260904045804.346405949@linuxfoundation.org>
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

From: Ke Sun <sunke@kylinos.cn>

commit fb7d645176189d2b068d69861e230fa5aceb4922 upstream.

The `impl_fmt_adapter_forward!` macro forwards `Pointer` for
`Adapter<T>` by destructuring `self` into a local `t`, causing `{:p}`
to print the address of that temporary stack variable rather than the
actual pointer.

Remove `Pointer` from the macro and provide a manual impl for
`Adapter<&T>` that passes `self.0` directly.

Signed-off-by: Ke Sun <sunke@kylinos.cn>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Tested-by: Link Mauve <linkmauve@linkmauve.fr>
Cc: stable@vger.kernel.org
Fixes: c5cf01ba8dfe ("rust: support formatting of foreign types")
Link: https://patch.msgid.link/20260810-hashedptr-v15-1-eafd27d36476@kylinos.cn
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/fmt.rs |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/rust/kernel/fmt.rs
+++ b/rust/kernel/fmt.rs
@@ -43,7 +43,14 @@ use core::fmt::{
     UpperExp,
     UpperHex, //
 };
-impl_fmt_adapter_forward!(Debug, LowerHex, UpperHex, Octal, Binary, Pointer, LowerExp, UpperExp);
+impl_fmt_adapter_forward!(Debug, LowerHex, UpperHex, Octal, Binary, LowerExp, UpperExp);
+
+impl<T: ?Sized + Pointer> Pointer for Adapter<&T> {
+    #[inline]
+    fn fmt(&self, f: &mut Formatter<'_>) -> Result {
+        Pointer::fmt(self.0, f)
+    }
+}
 
 /// A copy of [`core::fmt::Display`] that allows us to implement it for foreign types.
 ///


