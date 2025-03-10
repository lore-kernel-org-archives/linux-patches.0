Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC5422154C;
	Mon, 10 Mar 2025 17:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627240; cv=none; b=P24S1MixPvjitsY0F1lvF1qDRp15JcQaaB5f9TTN1dMirMGmA3dWU3xxQ8yfaVnWkjfab2HRHlkc/kRFFFmJkUUhkzyBwDDocQ3XJDnhBS48n5jLfBjtiPqaKlUgHHGnWhA/Bc2IgkFbuMgELRBG/XdM4oggtx0rnm8hQBLyes8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627240; c=relaxed/simple;
	bh=Cv0KAqNzyYANgQoILDjwvr3bBU5/lIYwwDBFXFPJuFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rLXPOhm7m79C+o7CfTRYvWZrAirWlffIzrvhy6oEFmNhAZZYQdCrIvf1kQAsxtkF36nIRWcSb07NBkrfgyncd8Zu1neT5aXQ1aGob3GGP9Zzg1Gb7UpptdHuwEnrae3bxfdntMQZgYNs0kdNjN6WPi94lUgJgeGuKrp99q+LxcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJysrCyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJysrCyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEB2C4CEE5;
	Mon, 10 Mar 2025 17:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627240;
	bh=Cv0KAqNzyYANgQoILDjwvr3bBU5/lIYwwDBFXFPJuFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJysrCyZ9r5dvpkcy8Lxa0JY5F1jqndfqbYW1jQt1x/OQnKjQFpS9NFeZ8RLCPF6Y
	 4OaXBigEJcyskVwcmtK4M9Z+amWUQr3PRw9yMeo7nHGF9+Z6WKycQ3tmla1aCe/qph
	 4TnAv5EQ5g/Vv9LNwvt/NaF3Uk01NtQKkTcbzJoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	=?UTF-8?q?Thomas=20B=C3=B6hler?= <witcher@wiredspace.de>,
	Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH 6.12 061/269] drm/panic: remove unnecessary borrow in alignment_pattern
Date: Mon, 10 Mar 2025 18:03:34 +0100
Message-ID: <20250310170500.160640798@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Böhler <witcher@wiredspace.de>

commit 7b6de57e0b2d1e62becfa3aac063c4c58d2c2c42 upstream.

The function `alignment_pattern` returns a static reference to a `u8`
slice. The borrow of the returned element in `ALIGNMENT_PATTERNS` is
already a reference as defined in the array definition above so this
borrow is unnecessary and removed by the compiler. Clippy notes this in
`needless_borrow`:

    error: this expression creates a reference which is immediately dereferenced by the compiler
       --> drivers/gpu/drm/drm_panic_qr.rs:245:9
        |
    245 |         &ALIGNMENT_PATTERNS[self.0 - 1]
        |         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ help: change this to: `ALIGNMENT_PATTERNS[self.0 - 1]`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#needless_borrow
        = note: `-D clippy::needless-borrow` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::needless_borrow)]`

Remove the unnecessary borrow.

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1123
Signed-off-by: Thomas Böhler <witcher@wiredspace.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20241019084048.22336-3-witcher@wiredspace.de
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panic_qr.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -239,7 +239,7 @@ impl Version {
     }
 
     fn alignment_pattern(&self) -> &'static [u8] {
-        &ALIGNMENT_PATTERNS[self.0 - 1]
+        ALIGNMENT_PATTERNS[self.0 - 1]
     }
 
     fn poly(&self) -> &'static [u8] {


