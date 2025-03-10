Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB79222CBED;
	Mon, 10 Mar 2025 17:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627714; cv=none; b=NAMCwZdaS/3jxoV3r2W/YJ9Plxaan8tMSVUUCUQFf9XiDvle5e3yTMK8HgkjYu5b2drtfkKbbajwDD9oVmY76re5+O9HmGso+jhGzof40j22nuv9mpVEJyhzx0m0+KsIgbHaqaEKbqRlX2OpTCQw9REgsRXrVuLk035aOUrR1ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627714; c=relaxed/simple;
	bh=6rfLXNFcO2gX2bUbGyzB4WXpmVC2hQA8zC6Tr44/YLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIgFB9W/6QXunQGkDxAT6GT8EI+QSAYNBISWpbhCup9UclrevQvIx6wxY1UfsZxw/22tjKOHmjUxmltY6bDWmkI9hUw3atsfjwIhLljkqadOdRJTRwV9aYlBW4r/EJq12487vQLs1BiLLFzk/rNO5xV4JsJVgTwpFECNQfJpopc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnLodBfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnLodBfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313F2C4CEE5;
	Mon, 10 Mar 2025 17:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627714;
	bh=6rfLXNFcO2gX2bUbGyzB4WXpmVC2hQA8zC6Tr44/YLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xnLodBfg2BPY9YDAynKRB+nZ3mEEVpkY1tM8nvFnV6U3up3QG26/RFCt9uc5fgOnN
	 XwfHOnZYHtStg8rdnFlwsgAzbICGDOV65fn46yFNQ0TEBZkcZpR6yAxEqwvtdVMqfD
	 XKUcoKVMBQxjpnDwZzsvrKSDkh2sD4KmnT//fa48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH 6.12 225/269] rust: finish using custom FFI integer types
Date: Mon, 10 Mar 2025 18:06:18 +0100
Message-ID: <20250310170506.655494555@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

commit 27c7518e7f1ccaaa43eb5f25dc362779d2dc2ccb upstream.

In the last kernel cycle we migrated most of the `core::ffi` cases in
commit d072acda4862 ("rust: use custom FFI integer types"):

    Currently FFI integer types are defined in libcore. This commit
    creates the `ffi` crate and asks bindgen to use that crate for FFI
    integer types instead of `core::ffi`.

    This commit is preparatory and no type changes are made in this
    commit yet.

Finish now the few remaining/new cases so that we perform the actual
remapping in the next commit as planned.

Acked-by: Jocelyn Falempe <jfalempe@redhat.com> # drm
Link: https://lore.kernel.org/rust-for-linux/CANiq72m_rg42SvZK=bF2f0yEoBLVA33UBhiAsv8THhVu=G2dPA@mail.gmail.com/
Link: https://lore.kernel.org/all/cc9253fa-9d5f-460b-9841-94948fb6580c@redhat.com/
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panic_qr.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -931,7 +931,7 @@ impl QrImage<'_> {
 /// They must remain valid for the duration of the function call.
 #[no_mangle]
 pub unsafe extern "C" fn drm_panic_qr_generate(
-    url: *const i8,
+    url: *const kernel::ffi::c_char,
     data: *mut u8,
     data_len: usize,
     data_size: usize,


