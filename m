Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7684C955A;
	Tue, 21 Jul 2026 17:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655979; cv=none; b=eUhbUAkDik77ozq3bCOk785t2gidUm0cxekPSKKzsgaZUHeoPpAmd2DDTNzlmrZHc3M0NZxeRJwuI5duLL7UWBTok5jxWAaqL6FK7ZgAmHrXTDnC6XvWndsA0RxGeU8S73d9+Wt4Wh5ymxladuKiGBE9DxVNxvCUxeR5K+lAr4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655979; c=relaxed/simple;
	bh=oZ2TP8Sq1TqOrHydEFBEP7vrEoTs3isCgb8uVV94KXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWP0Rb4Lr1fcI666Iv5TE8oMh0yTA4gCer682PNJsYzqTGrkqEtc2hw37fFnKvgX0UEI+n/bEBBO8XbVTnpMN6ENXps0tVRYfbSvmKoksiCh1tzBiEebNYovZ8a3n4lFjbALUn7sR1Wonb8Vmz5uhnF4Se8lpOVFPuL60Xe2kOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0y0dN17o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0y0dN17o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B48A1F00A3A;
	Tue, 21 Jul 2026 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655977;
	bh=HxoS6NzH9Kr/QaM8+am1cMa4Cny72RheF0RoDttjL5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0y0dN17oOvVcNRZdLz4ZgvN//LEQ/mJUCys1lHyl4gHZxr335pDJOHiEVMIeOXyFX
	 99UU9H+23Thg561lopFzfmgKSPKIjqnEJ+Mg7t1LI94EEPaTfzpyNZrRDVxM82ZMqd
	 7XgzwobrdKFvj4zP4dzDNRViDw1JrkF+b8zQO9dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hubbard <jhubbard@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0213/1611] gpu: nova-core: vbios: read BitToken using FromBytes
Date: Tue, 21 Jul 2026 17:05:29 +0200
Message-ID: <20260721152519.771012604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Eliot Courtney <ecourtney@nvidia.com>

[ Upstream commit 237c252be0db616c93e4984369db7e74bb797564 ]

If `header.token_size` is smaller than `BitToken`, then we currently can
read past the end of `image.base.data`. Use checked arithmetic for
computing offsets and simplify reading it in using `FromBytes`.

Fixes: dc70c6ae2441 ("gpu: nova-core: vbios: Add support to look up PMU table in FWSEC")
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260525-fix-vbios-v5-4-e5e455251537@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/vbios.rs | 37 +++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/nova-core/vbios.rs b/drivers/gpu/nova-core/vbios.rs
index 8bbee9a53b38df..56fcdd8bc02acf 100644
--- a/drivers/gpu/nova-core/vbios.rs
+++ b/drivers/gpu/nova-core/vbios.rs
@@ -382,7 +382,7 @@ impl BitHeader {
 
 /// BIT Token Entry: Records in the BIT table followed by the BIT header.
 #[derive(Debug, Clone, Copy)]
-#[expect(dead_code)]
+#[repr(C)]
 struct BitToken {
     /// 00h: Token identifier
     id: u8,
@@ -394,6 +394,9 @@ struct BitToken {
     data_offset: u16,
 }
 
+// SAFETY: all bit patterns are valid for `BitToken`.
+unsafe impl FromBytes for BitToken {}
+
 // Define the token ID for the Falcon data
 const BIT_TOKEN_ID_FALCON_DATA: u8 = 0x70;
 
@@ -401,32 +404,28 @@ impl BitToken {
     /// Find a BIT token entry by BIT ID in a PciAtBiosImage
     fn from_id(image: &PciAtBiosImage, token_id: u8) -> Result<Self> {
         let header = &image.bit_header;
+        let entry_size = usize::from(header.token_size);
 
         // Offset to the first token entry
         let tokens_start = image.bit_offset + usize::from(header.header_size);
 
         for i in 0..usize::from(header.token_entries) {
-            let entry_offset = tokens_start + (i * usize::from(header.token_size));
+            let entry_offset = i
+                .checked_mul(entry_size)
+                .and_then(|offset| tokens_start.checked_add(offset))
+                .ok_or(EINVAL)?;
+            let entry = image
+                .base
+                .data
+                .get(entry_offset..)
+                .and_then(|data| data.get(..entry_size))
+                .ok_or(EINVAL)?;
 
-            // Make sure we don't go out of bounds
-            if entry_offset + usize::from(header.token_size) > image.base.data.len() {
-                return Err(EINVAL);
-            }
+            let (token, _) = BitToken::from_bytes_copy_prefix(entry).ok_or(EINVAL)?;
 
             // Check if this token has the requested ID
-            if image.base.data[entry_offset] == token_id {
-                return Ok(BitToken {
-                    id: image.base.data[entry_offset],
-                    data_version: image.base.data[entry_offset + 1],
-                    data_size: u16::from_le_bytes([
-                        image.base.data[entry_offset + 2],
-                        image.base.data[entry_offset + 3],
-                    ]),
-                    data_offset: u16::from_le_bytes([
-                        image.base.data[entry_offset + 4],
-                        image.base.data[entry_offset + 5],
-                    ]),
-                });
+            if token.id == token_id {
+                return Ok(token);
             }
         }
 
-- 
2.53.0



