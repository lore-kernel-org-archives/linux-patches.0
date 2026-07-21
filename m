Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005D1340416;
	Tue, 21 Jul 2026 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648705; cv=none; b=HwkRPrJXYpe5jHXYQwUp+X3JcxVxjp6xZwtVgTtRajxlMS7XVt6RMPdT5VhUd3Nli7PEk1SMdzCajNfevuo8wAw6enZ4/3Fw06PsD+IG0z00k6OnhQlZQQ50QZO5V21tc18N6bAcvx89tHYXzD0Wzwb+bcvMH5EvepU8gpkhKMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648705; c=relaxed/simple;
	bh=MoQxKMJLs2NrWPjlKMvKuv8N3O2JADzUXLGPJpsrQWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cL6FPWloiHH2OjY+beDP5Xcc6MwnwVBeclle7WwwcC8QupiJNsHULcKI1Q4kJlgt5phzQEZdFR7ypV6rVDqdw8v7XIekeVBdDOeTuKbGRq/7YymVPKDdhMKMFtzKBNVZFFGAZssL1WgkzWufcnZUSestBATWDlCDDcHJy690P5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwtrOEiN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwtrOEiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674551F000E9;
	Tue, 21 Jul 2026 15:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648703;
	bh=KmVTKLXQUSLzA+UkLisZL8aH0bVMFnYyNxFLIncKgyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwtrOEiNIpVfKL3dqc/E+ZlGHRCE2WXMGA4Rleb3Au4n+qvYmCm6buv012kGFVTxy
	 qr5+yorLfTOHhpcFtLYF/bza20vb5U/KSC3xu2z8PAFWdP7euc6s6HKK6boqV37i6c
	 sf3mDF+0RZercIZ5gXTYsG759F1YPyyGyGCaucUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hubbard <jhubbard@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0299/2077] gpu: nova-core: vbios: avoid reading too far in read_more_at_offset
Date: Tue, 21 Jul 2026 16:59:32 +0200
Message-ID: <20260721152559.731396800@linuxfoundation.org>
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

[ Upstream commit 33f1402bcfa6cfd85fa265ce6fa5c6bb7d981c6d ]

Fix bug where `read_more_at_offset` would unnecessarily read more data.
This happens when the window to read has some part cached and some part
not. It would read `len` bytes instead of just the uncached portion,
which could read past `BIOS_MAX_SCAN_LEN`.

Fixes: 6fda04e7f0cd ("gpu: nova-core: vbios: Add base support for VBIOS construction and iteration")
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260525-fix-vbios-v5-3-e5e455251537@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/vbios.rs | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/nova-core/vbios.rs b/drivers/gpu/nova-core/vbios.rs
index d25f9a11228009..10473279ebeaf7 100644
--- a/drivers/gpu/nova-core/vbios.rs
+++ b/drivers/gpu/nova-core/vbios.rs
@@ -102,8 +102,13 @@ impl<'a> VbiosIterator<'a> {
 
     /// Read bytes from the ROM at the current end of the data vector.
     fn read_more(&mut self, len: usize) -> Result {
-        let current_len = self.data.len();
-        let start = ROM_OFFSET + current_len;
+        let start = self.data.len();
+        let end = start + len;
+
+        if end > BIOS_MAX_SCAN_LEN {
+            dev_err!(self.dev, "Error: exceeded BIOS scan limit.\n");
+            return Err(EINVAL);
+        }
 
         // Ensure length is a multiple of 4 for 32-bit reads
         if len % core::mem::size_of::<u32>() != 0 {
@@ -117,9 +122,9 @@ impl<'a> VbiosIterator<'a> {
 
         self.data.reserve(len, GFP_KERNEL)?;
         // Read ROM data bytes and push directly to `data`.
-        for addr in (start..start + len).step_by(core::mem::size_of::<u32>()) {
+        for addr in (start..end).step_by(core::mem::size_of::<u32>()) {
             // Read 32-bit word from the VBIOS ROM
-            let word = self.bar0.try_read32(addr)?;
+            let word = self.bar0.try_read32(ROM_OFFSET + addr)?;
 
             // Convert the `u32` to a 4 byte array and push each byte.
             word.to_ne_bytes()
@@ -132,17 +137,9 @@ impl<'a> VbiosIterator<'a> {
 
     /// Read bytes at a specific offset, filling any gap.
     fn read_more_at_offset(&mut self, offset: usize, len: usize) -> Result {
-        if offset > BIOS_MAX_SCAN_LEN {
-            dev_err!(self.dev, "Error: exceeded BIOS scan limit.\n");
-            return Err(EINVAL);
-        }
-
-        // If `offset` is beyond current data size, fill the gap first.
-        let current_len = self.data.len();
-        let gap_bytes = offset.saturating_sub(current_len);
+        let end = offset.checked_add(len).ok_or(EINVAL)?;
 
-        // Now read the requested bytes at the offset.
-        self.read_more(gap_bytes + len)
+        self.read_more(end.saturating_sub(self.data.len()))
     }
 
     /// Read a BIOS image at a specific offset and create a [`BiosImage`] from it.
-- 
2.53.0



