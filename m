Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8580366542;
	Wed, 20 May 2026 16:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295029; cv=none; b=ejWSeYprYybR0snurqOXHiqdS2zH7zFXdTV2jroI8c2LuIQa6+Bsw5MoYT7vpfRtO1mR/voG1DExAETDTgFQ/pmNtu9ESstUgJd/ehQgKRZw3vym5qbgxQvzadUgy/mLiiCLXhkME+pQRvxY6Snu9fCTzRxKSboFszCT96DpK3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295029; c=relaxed/simple;
	bh=alWhcQGWm8mkbY+Tq1rPlC05AUDPYhD+IO0THG0C/u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8cCOg08pG27y7z7bkBz4/DRxPS9ea5AGynQWNI+oqa+Qc1944e6AC7hxvhPfvcYm2w8TJeTjZt3fs4gieykN1woeBKmlzKVpwHwiDF23AhRqrb249T7sAU45HyVbH7vflntOUq3G3VfkGKFr1xEenUJXzDUUrDCexbDLWCADho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUpTdymb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUpTdymb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C75A1F000E9;
	Wed, 20 May 2026 16:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295026;
	bh=z5ScwjJrMtFM5mcshSn256OEcFI/Dw4vsWtu8RgJMzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUpTdymbqEJIdVmLv2hhA3vXWP3iCMqukFJO82+1KHo2820qDMS+f+qbeJxxOuoBu
	 0zjlgP2Pa9feeDr6XuVxMOHFSpoe4V3PgWAMiuL/HIXOgT2cvU4mh+TkSSnjOQn56r
	 nGSoJNdNd1N4vVWp1iPCkfI+J7T1uJuwksluc1jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliot Courtney <ecourtney@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0264/1146] gpu: nova-core: firmware: fix and explain v2 header offsets computations
Date: Wed, 20 May 2026 18:08:34 +0200
Message-ID: <20260520162154.200862516@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Courbot <acourbot@nvidia.com>

[ Upstream commit 17d7c97f73c7a0bd90bd22cd7441269a6f8a1d72 ]

There are no offsets in `FalconUCodeDescV2` to give the non-secure and
secure IMEM sections start offsets relative to the beginning of the
firmware object.

The start offsets for both sections were set to `0`, but that is
obviously incorrect since two different sections cannot start at the
same offset. Since these offsets were not used by the bootloader, this
doesn't prevent proper function but is incorrect nonetheless.

Fix this by computing the start of the secure IMEM section relatively to
the start of the firmware object and setting it properly. Also add and
improve comments to explain how the values are obtained.

Fixes: dbfb5aa41f16 ("gpu: nova-core: add FalconUCodeDescV2 support")
Reviewed-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260306-turing_prep-v11-9-8f0042c5d026@nvidia.com
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/firmware.rs | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/nova-core/firmware.rs b/drivers/gpu/nova-core/firmware.rs
index 186f166564651..6a58118648652 100644
--- a/drivers/gpu/nova-core/firmware.rs
+++ b/drivers/gpu/nova-core/firmware.rs
@@ -63,7 +63,8 @@ pub(crate) struct FalconUCodeDescV2 {
     pub(crate) interface_offset: u32,
     /// Base address at which to load the code segment into 'IMEM'.
     pub(crate) imem_phys_base: u32,
-    /// Size in bytes of the code to copy into 'IMEM'.
+    /// Size in bytes of the code to copy into 'IMEM' (includes both secure and non-secure
+    /// segments).
     pub(crate) imem_load_size: u32,
     /// Virtual 'IMEM' address (i.e. 'tag') at which the code should start.
     pub(crate) imem_virt_base: u32,
@@ -205,18 +206,25 @@ impl FalconUCodeDescriptor for FalconUCodeDescV2 {
     }
 
     fn imem_sec_load_params(&self) -> FalconDmaLoadTarget {
+        // `imem_sec_base` is the *virtual* start address of the secure IMEM segment, so subtract
+        // `imem_virt_base` to get its physical offset.
+        let imem_sec_start = self.imem_sec_base.saturating_sub(self.imem_virt_base);
+
         FalconDmaLoadTarget {
-            src_start: 0,
-            dst_start: self.imem_sec_base,
+            src_start: imem_sec_start,
+            dst_start: self.imem_phys_base.saturating_add(imem_sec_start),
             len: self.imem_sec_size,
         }
     }
 
     fn imem_ns_load_params(&self) -> Option<FalconDmaLoadTarget> {
         Some(FalconDmaLoadTarget {
+            // Non-secure code always starts at offset 0.
             src_start: 0,
             dst_start: self.imem_phys_base,
-            len: self.imem_load_size.checked_sub(self.imem_sec_size)?,
+            // `imem_load_size` includes the size of the secure segment, so subtract it to
+            // get the correct amount of data to copy.
+            len: self.imem_load_size.saturating_sub(self.imem_sec_size),
         })
     }
 
-- 
2.53.0



