Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6339D3783AE;
	Tue, 21 Jul 2026 15:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648710; cv=none; b=MgXNAaXfXrUl7pOL3hmBs37SwNjepAgBO4c/mVH+tDQUGMjY9nNMpuYPYMWfAbYl7xpiYRd4/WrUyNWZ3aT/Iww3m5wEGI/x74s1Aetv4FYx8/me27Y325EZJscR0ZzvYQRVh41weHws015/2iwNBcFzT0wI8H64E64YVVHa+vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648710; c=relaxed/simple;
	bh=8iEJBy441KHX8SsVK2+UKr5drtw6RrYQgoEvzxGyZIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUB0DpjM6DKjs7LJnlwfE5/1S85t93aejK8RYrwsF68t4/Gk3Pv7Hs7bpozR2eKNP7dCNElAPSpBB2Cize7ul7Udt4IGD6+iJYhxefAaScSpkEFN4b53FwQYG9285Q66kNSHsYhHQ4AfX5DQvPGux2FkPbtQx6/CuxfhPYCRFW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgs5Gn8t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgs5Gn8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BA91F000E9;
	Tue, 21 Jul 2026 15:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648709;
	bh=nQT3Kk6N0CJc4xg4xDlVT92zIpo6zAmh1bC4Pb3qrTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zgs5Gn8tTmUH+GbObLw8aFhFIL9BYcNMi6/nLqnIq1lgZpMYWQuF8JRg5zsc714Ld
	 7sBsWBjCFs60JXRI2ZMiVmA2o6QjMMqTLS5i6Al26iBIUvvbGyeja9mmPk7yTak3jP
	 cxekuOJP52hbrcbxxdST2NMqGJhqyVslN5aR0shY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Fernandes <joelagnelf@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0301/2077] gpu: nova-core: vbios: use checked ops and accesses in `FwSecBiosImage::ucode`
Date: Tue, 21 Jul 2026 16:59:34 +0200
Message-ID: <20260721152559.778953234@linuxfoundation.org>
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

[ Upstream commit 7c62d0b006527efc5fb4609b555c65674c819603 ]

Use checked arithmetic and access for extracting the microcode since the
offsets are firmware derived.

Fixes: 47c4846e4319 ("gpu: nova-core: vbios: Add support for FWSEC ucode extraction")
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260525-fix-vbios-v5-5-e5e455251537@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/vbios.rs | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/nova-core/vbios.rs b/drivers/gpu/nova-core/vbios.rs
index 517d113e14137a..10f812714e4dcd 100644
--- a/drivers/gpu/nova-core/vbios.rs
+++ b/drivers/gpu/nova-core/vbios.rs
@@ -1027,16 +1027,18 @@ impl FwSecBiosImage {
 
     /// Get the ucode data as a byte slice
     pub(crate) fn ucode(&self, desc: &FalconUCodeDesc) -> Result<&[u8]> {
-        let falcon_ucode_offset = self.falcon_ucode_offset;
+        let size = usize::from_safe_cast(
+            desc.imem_load_size()
+                .checked_add(desc.dmem_load_size())
+                .ok_or(ERANGE)?,
+        );
 
         // The ucode data follows the descriptor.
-        let ucode_data_offset = falcon_ucode_offset + desc.size();
-        let size = usize::from_safe_cast(desc.imem_load_size() + desc.dmem_load_size());
-
-        // Get the data slice, checking bounds in a single operation.
         self.base
             .data
-            .get(ucode_data_offset..ucode_data_offset + size)
+            .get(self.falcon_ucode_offset..)
+            .and_then(|data| data.get(desc.size()..))
+            .and_then(|data| data.get(..size))
             .ok_or(ERANGE)
             .inspect_err(|_| {
                 dev_err!(
-- 
2.53.0



