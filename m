Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391901C0DED;
	Wed, 19 Mar 2025 14:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394951; cv=none; b=eJHrAxP5pXXlaSzaPdp5nnO32eD9qShfJxRKXYVfvnuci/AKAfRnkcDu8Jl3U7jAELAhH/WHFKQ3RwLuoZq2HqRXqk2mbTV5w4v9rQqgK5tguDmB7mp6y6T+Fh90tJwsuzr55GUF3mc40CMRWM++gwiNTcx0kiWEDB1L38qNd9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394951; c=relaxed/simple;
	bh=5r1/S7rl0wYlrWGlA+ZTmxRuPn9XHlKtObucOnXsy/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JE/pq+7MrAReP4cOdws4Fx9oHMj8KivUGg8ggmtDW/G60IXcXG8bCZWmRvs9rxa/qP29WoCQpFyPT1nkO+fgwjg1VphXrFkU2ynhw9d6BSwkf3uUe9Rn+EAPr4Fq7zoYywT/1I/4V2Jsq3nZtoPIJwqU5/nd1WiqSSh9Rv7gteg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxEIQ8/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxEIQ8/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5885C4CEE4;
	Wed, 19 Mar 2025 14:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394950;
	bh=5r1/S7rl0wYlrWGlA+ZTmxRuPn9XHlKtObucOnXsy/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxEIQ8/ZS+t/+PrZWjbuvANG/A7H/EloC0SimjI2GpdIhubb4PhocJ7jwke9ASZ38
	 EiHAw17z8ZB9enDA5KOakT2eQqmocVZOG4n3uKdhDSKqYhLgHXYFa7JKN3TdzYFYry
	 XDOiXj7APNPsExh42edF7NcT7yX38Rv3yVmCFsqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH 6.13 175/241] drm/panic: use `div_ceil` to clean Clippy warning
Date: Wed, 19 Mar 2025 07:30:45 -0700
Message-ID: <20250319143032.065062242@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 986c2e9ca818b0b74cfc737517549fd0b80ff15d upstream.

Starting with the upcoming Rust 1.86.0 (to be released 2025-04-03),
Clippy warns:

    error: manually reimplementing `div_ceil`
       --> drivers/gpu/drm/drm_panic_qr.rs:548:26
        |
    548 |         let pad_offset = (offset + 7) / 8;
        |                          ^^^^^^^^^^^^^^^^ help: consider using `.div_ceil()`: `offset.div_ceil(8)`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#manual_div_ceil

And similarly for `stride`. Thus apply the suggestion to both.

The behavior (and thus codegen) is not exactly equivalent [1][2], since
`div_ceil()` returns the right value for the values that currently
would overflow.

Link: https://github.com/rust-lang/rust-clippy/issues/14333 [1]
Link: https://godbolt.org/z/dPq6nGnv3 [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Cc: stable@vger.kernel.org # Needed in 6.12.y and 6.13.y only (Rust is pinned in older LTSs).
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250301231602.917580-1-ojeda@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panic_qr.rs |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -545,7 +545,7 @@ impl EncodedMsg<'_> {
         }
         self.push(&mut offset, (MODE_STOP, 4));
 
-        let pad_offset = (offset + 7) / 8;
+        let pad_offset = offset.div_ceil(8);
         for i in pad_offset..self.version.max_data() {
             self.data[i] = PADDING[(i & 1) ^ (pad_offset & 1)];
         }
@@ -659,7 +659,7 @@ struct QrImage<'a> {
 impl QrImage<'_> {
     fn new<'a, 'b>(em: &'b EncodedMsg<'b>, qrdata: &'a mut [u8]) -> QrImage<'a> {
         let width = em.version.width();
-        let stride = (width + 7) / 8;
+        let stride = width.div_ceil(8);
         let data = qrdata;
 
         let mut qr_image = QrImage {


