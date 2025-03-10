Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFFA230BD5;
	Mon, 10 Mar 2025 17:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627246; cv=none; b=f/dzSy0Xa9TF8lcyZOGnLqi7yhsp5yl53ZvwOoOoqAGKU8lxbO5iUwMWgY7y2Z7JJr4ToYNZChOKvgEEnN24AhY0lc3NcducpsSbowrjoUMb3v488Zo5fOfQvxCESLAilRfXAD3tQ0H8626JV2uchMkrmj5mNO6LNf08GGCy1xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627246; c=relaxed/simple;
	bh=DAGkjcJ8JhbBYz1hS7a5kGIRCUaBgT2bhM92YGDAOO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KpBsUTxoJmDBZiNo8hNQx0MEzV1/bCKnCVD98jgbW4puMV32MRIZNp9SxEWUARihaPXST881whRmNTA1kR0+zEkPi8r7d605y6Ln+V3QDi635fxsDYE9SxDnzzwi1F/fN5alZkqzQOnF1a3VBjfFBpArQOdVB0VhkxiUPeAYhDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ko1t8eeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ko1t8eeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C4DC4CEED;
	Mon, 10 Mar 2025 17:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627246;
	bh=DAGkjcJ8JhbBYz1hS7a5kGIRCUaBgT2bhM92YGDAOO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ko1t8eeHY4987UWGIW1DoaBoEB8Xr8FmvlC+e74D7jtC/8cIxnHn0YrjeS7k30u5n
	 NSDyi0qLbBrBo8Qj7kAcaMqzPl5DTm8epe68k8vU7CO9oAFjlcMBuqtIfq1Mtddyou
	 Gy8o0rnVgiNRwtNHtST2kYAid2Ja3fq1yU88hgPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	=?UTF-8?q?Thomas=20B=C3=B6hler?= <witcher@wiredspace.de>,
	Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH 6.12 063/269] drm/panic: remove redundant field when assigning value
Date: Mon, 10 Mar 2025 18:03:36 +0100
Message-ID: <20250310170500.241532296@linuxfoundation.org>
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

commit da13129a3f2a75d49469e1d6f7dcefac2d11d205 upstream.

Rust allows initializing fields of a struct without specifying the
attribute that is assigned if the variable has the same name. In this
instance this is done for all other attributes of the struct except for
`data`. Clippy notes the redundant field name:

    error: redundant field names in struct initialization
    --> drivers/gpu/drm/drm_panic_qr.rs:495:13
        |
    495 |             data: data,
        |             ^^^^^^^^^^ help: replace it with: `data`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#redundant_field_names
        = note: `-D clippy::redundant-field-names` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::redundant_field_names)]`

Remove the redundant `data` in the assignment to be consistent.

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1123
Signed-off-by: Thomas Böhler <witcher@wiredspace.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20241019084048.22336-5-witcher@wiredspace.de
[ Reworded to add Clippy warning like it is done in the rest of the
  series. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panic_qr.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -489,7 +489,7 @@ impl EncodedMsg<'_> {
         data.fill(0);
 
         let mut em = EncodedMsg {
-            data: data,
+            data,
             ec_size,
             g1_blocks,
             g2_blocks,


