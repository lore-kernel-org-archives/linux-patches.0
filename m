Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B544F46D57A;
	Tue, 21 Jul 2026 15:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648707; cv=none; b=E0EOv43w3/p/oGfl1yQBJfTs6fqu9OvEvO+M63hsgsF1Z5BwALdudSNVdcHCM3Sr1X16f6kGAdo5yZFVi9BGy8R5+2JN3kIQtrsnCs+Shw7pKZYvUelbt/m8yjBIXGIEluRJmuef/AP/Rlcuy69DYCK6nySJQ/AxVMFXc0211w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648707; c=relaxed/simple;
	bh=4DpZhRglfaF8yDpO+jMr7qROvGetDESeWT+Zl8X1nJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Atv1KEG3m5lsk2FdqB3AFBByL4SgYOQQr3mOxDxdoTZBmb3BSTTN7Gp5QDsfvxZEf1TlW7Sn2aAVI4SyAIgWv74OGY/SOo9TvNkc9mRZfAm8cAUTLdSubfiFGWJGydK/cvMjP54FDj4Ko4AiOYrZAk+sonWZK4QnYxqFIpIkByQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWbCxEPC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWbCxEPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2150D1F000E9;
	Tue, 21 Jul 2026 15:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648706;
	bh=k2OiEZ71MBbv5plv57QsQQuKrByy6lwVQHAENQ2NnCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWbCxEPCilgP8wjLBt9t9ADyE2KHW5OR5Xw3ebSme/GoGMkLIYN8KhOwqQ8ZCkFWf
	 y7nO6ncrMSgqhsrB8pOBceIg+ibZvpRGQsJPbgQgu/9e+xxZSAr4lo1tjAjMseBe/n
	 koO9YzuLHDItKJBYtaUrCnspweyUrkg8jpL4ZSmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hubbard <jhubbard@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0300/2077] gpu: nova-core: vbios: read BitToken using FromBytes
Date: Tue, 21 Jul 2026 16:59:33 +0200
Message-ID: <20260721152559.754739253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/nova-core/vbios.rs | 39 +++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/nova-core/vbios.rs b/drivers/gpu/nova-core/vbios.rs
index 10473279ebeaf7..517d113e14137a 100644
--- a/drivers/gpu/nova-core/vbios.rs
+++ b/drivers/gpu/nova-core/vbios.rs
@@ -403,7 +403,7 @@ impl BitHeader {
 
 /// BIT Token Entry: Records in the BIT table followed by the BIT header.
 #[derive(Debug, Clone, Copy)]
-#[expect(dead_code)]
+#[repr(C)]
 struct BitToken {
     /// 00h: Token identifier
     id: u8,
@@ -415,6 +415,9 @@ struct BitToken {
     data_offset: u16,
 }
 
+// SAFETY: all bit patterns are valid for `BitToken`.
+unsafe impl FromBytes for BitToken {}
+
 // Define the token ID for the Falcon data
 const BIT_TOKEN_ID_FALCON_DATA: u8 = 0x70;
 
@@ -422,32 +425,28 @@ impl BitToken {
     /// Find a BIT token entry by BIT ID in a PciAtBiosImage
     fn from_id(image: &PciAtBiosImage, token_id: u8) -> Result<Self> {
         let header = &image.bit_header;
+        let entry_size = usize::from(header.token_size);
 
         // Offset to the first token entry
         let tokens_start = image.bit_offset + usize::from(header.header_size);
 
         for i in 0..usize::from(header.token_entries) {
-            let entry_offset = tokens_start + (i * usize::from(header.token_size));
-
-            // Make sure we don't go out of bounds
-            if entry_offset + usize::from(header.token_size) > image.base.data.len() {
-                return Err(EINVAL);
-            }
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
+
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



