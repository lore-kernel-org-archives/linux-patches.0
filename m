Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6722D1419A0;
	Tue, 27 Feb 2024 13:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041946; cv=none; b=MeRe680xqTZBKpwfQMxoiDhIj6Ddi4e3uSQ++Ld6B+Jwh8UMxIPSU+hGi17FtS9l3jJnoYS4VB6ZzCLQtXgaGJaD1nCUMW022ay2+Sa5DDF8mZe8Hz//YUki5HBBWUQx6NaE4O1ys+1H3vTRxsnU8TUP9nXI2ocJocrhKJMns6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041946; c=relaxed/simple;
	bh=5K+24DINhG0TNamWc/t+56KjwjxKW6WgpdBJswA0OVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q91PZC2F8X4EenPsHYNMr7OecSj2wmNMqdsXG4+SrMlsfLHOt2MkzTHLwvNHMsw5+lnR95CTlIKRVyfawCyWpxXE4fV+RwqfOunD3+/b35rDbcuy1h1qGTrRU7RjHcE2b5/11brNJUne+eTfy/BEhyp8bOh5YCmoo7TO/PAi3ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7AudfAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7AudfAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B49BC433F1;
	Tue, 27 Feb 2024 13:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041945;
	bh=5K+24DINhG0TNamWc/t+56KjwjxKW6WgpdBJswA0OVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7AudfAK1hZgYw0XB4O8OtnF9L07HPtd53VYcBC6ytdGi3Pc+QXX2Ghf0Ng5wDWAq
	 M6C0rUv3h76/Radbzi48csCRwE6y7t0hdUAdJwjg9c65rmsdoqZCGBxIqupov/LibH
	 j6Ai47pqcwPqFbgqcVZQQkTeQr5wCiIapI257me8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Bresticker <abrestic@rivosinc.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/299] efi: runtime: Fix potential overflow of soft-reserved region size
Date: Tue, 27 Feb 2024 14:23:27 +0100
Message-ID: <20240227131628.989192263@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Bresticker <abrestic@rivosinc.com>

[ Upstream commit de1034b38a346ef6be25fe8792f5d1e0684d5ff4 ]

md_size will have been narrowed if we have >= 4GB worth of pages in a
soft-reserved region.

Signed-off-by: Andrew Bresticker <abrestic@rivosinc.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/arm-runtime.c   | 2 +-
 drivers/firmware/efi/riscv-runtime.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 83f5bb57fa4c4..83092d93f36a6 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -107,7 +107,7 @@ static int __init arm_enable_runtime_services(void)
 		efi_memory_desc_t *md;
 
 		for_each_efi_memory_desc(md) {
-			int md_size = md->num_pages << EFI_PAGE_SHIFT;
+			u64 md_size = md->num_pages << EFI_PAGE_SHIFT;
 			struct resource *res;
 
 			if (!(md->attribute & EFI_MEMORY_SP))
diff --git a/drivers/firmware/efi/riscv-runtime.c b/drivers/firmware/efi/riscv-runtime.c
index 09525fb5c240e..01f0f90ea4183 100644
--- a/drivers/firmware/efi/riscv-runtime.c
+++ b/drivers/firmware/efi/riscv-runtime.c
@@ -85,7 +85,7 @@ static int __init riscv_enable_runtime_services(void)
 		efi_memory_desc_t *md;
 
 		for_each_efi_memory_desc(md) {
-			int md_size = md->num_pages << EFI_PAGE_SHIFT;
+			u64 md_size = md->num_pages << EFI_PAGE_SHIFT;
 			struct resource *res;
 
 			if (!(md->attribute & EFI_MEMORY_SP))
-- 
2.43.0



