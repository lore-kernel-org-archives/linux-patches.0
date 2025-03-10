Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E601B22154C;
	Mon, 10 Mar 2025 17:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627252; cv=none; b=dk2HfvMJ9AgBsRVkRLlQbd+YetxL/zvECJYOI50wqugUNx/OUOI8LawHUTDzT4lZOXyCpojggGhlYfHJ1FptcU45BttPwL1g44VDIY5cbWEb7w6ARmQOzLA1+A5flbfLql+Ev+76sNFEQ7OQuEBBVFrGvcGsF8fhm5Wlp3in274=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627252; c=relaxed/simple;
	bh=+wONn944gk6wUas09GClsWjIPrM1j5PTy0cjOiootoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AfLJTMMmfFyuU1XDPOwUcN4Uz8IbqCjv3Dgta1kNwa0czakFRKv3nRuA6n+iMlP3KeMxidcU7CmkQ010gu/AeC1WLVuAnNMwezvZP+MABQI0QiHJ63bqU65iwDSdOyRQd04L6ZB9zv0jr6ZW/zGZQcSIZD2OfiugesWDERkY4ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wc4L/DsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wc4L/DsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE18C4CEE5;
	Mon, 10 Mar 2025 17:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627251;
	bh=+wONn944gk6wUas09GClsWjIPrM1j5PTy0cjOiootoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wc4L/DsN4NnbRRhkyS92IqRSGTAUdfwcq/qZkJHLYFriqIFBL0pwxTxsAz4cbzbKr
	 LfvtCkBlHmWBCaIRKnGRJLGlYxgo69Ystlw01DLFjI3NIB1S2R2LIom1XGqUExCTFh
	 c6mRfHKmHDJ0q/9778plMzP40mL4ZSWhYElrZv2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	=?UTF-8?q?Thomas=20B=C3=B6hler?= <witcher@wiredspace.de>,
	Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH 6.12 065/269] drm/panic: allow verbose boolean for clarity
Date: Mon, 10 Mar 2025 18:03:38 +0100
Message-ID: <20250310170500.320472118@linuxfoundation.org>
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

commit 27aef8a52e4b7f120ce47cd638d9d83065b759d2 upstream.

Clippy complains about a non-minimal boolean expression with
`nonminimal_bool`:

    error: this boolean expression can be simplified
       --> drivers/gpu/drm/drm_panic_qr.rs:722:9
        |
    722 |         (x < 8 && y < 8) || (x < 8 && y >= end) || (x >= end && y < 8)
        |         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#nonminimal_bool
        = note: `-D clippy::nonminimal-bool` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::nonminimal_bool)]`
    help: try
        |
    722 |         !(x >= 8 || y >= 8 && y < end) || (x >= end && y < 8)
        |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    722 |         (y >= end || y < 8) && x < 8 || (x >= end && y < 8)
        |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While this can be useful in a lot of cases, it isn't here because the
line expresses clearly what the intention is. Simplifying the expression
means losing clarity, so opt-out of this lint for the offending line.

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1123
Signed-off-by: Thomas Böhler <witcher@wiredspace.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20241019084048.22336-7-witcher@wiredspace.de
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panic_qr.rs |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -719,7 +719,10 @@ impl QrImage<'_> {
 
     fn is_finder(&self, x: u8, y: u8) -> bool {
         let end = self.width - 8;
-        (x < 8 && y < 8) || (x < 8 && y >= end) || (x >= end && y < 8)
+        #[expect(clippy::nonminimal_bool)]
+        {
+            (x < 8 && y < 8) || (x < 8 && y >= end) || (x >= end && y < 8)
+        }
     }
 
     // Alignment pattern: 5x5 squares in a grid.


