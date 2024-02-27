Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A766D1419B4;
	Tue, 27 Feb 2024 14:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043379; cv=none; b=YAMqixqzAEnEMXJo1etO++35Q/HPt9d/Q7w1imuOyffUc3Du/sHjLwTWvAUWcVjLckpgYi0FNLzuGfAYvXLkHwRwj6XzzmJj0DZ62YPOzp68odWAKfH6SGJxZ1dtk37MJ+tMKeZyn8UbIpHPiGxK2KtA3Yz4BHE2A5yqQcou1dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043379; c=relaxed/simple;
	bh=oZDPcaZv8bh3TaEh3lxnBsmjMTzKLTyBwMXZWTUK13g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+YgR55+u0wI9t3ta2vqi5cHV+0oGJYegXNLHHBwWC+j6VC+/R2XIic/vxW5kxiU7rvJlbuv7RPECe7+mfnRCSOTfp2sco0ko5fSDnGVzJ1tLkkyYujs8uctBjHQI8EOPYES+EMt2ap8NhkMShUGpA0da2o+G10D9m0vbKVXQes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBk+g9ll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBk+g9ll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A8DC433C7;
	Tue, 27 Feb 2024 14:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043379;
	bh=oZDPcaZv8bh3TaEh3lxnBsmjMTzKLTyBwMXZWTUK13g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBk+g9llgnjmXbImfIB5z9UVESHYtDZZTFAT5ifFguWpfYOdjVCRx9vh6GHZrGekz
	 l8L0XhVlL+NtrmMCYGDbpbbv6CcTo8pHHKj2Rt3gw8FwAeRK6jhmqzBvF9xwIFZfyt
	 L2vVdPCLdH3C+emSi86kJnBBXNRzqf27lsJ+ehNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Bresticker <abrestic@rivosinc.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/195] efi: Dont add memblocks for soft-reserved memory
Date: Tue, 27 Feb 2024 14:25:30 +0100
Message-ID: <20240227131612.778078126@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Bresticker <abrestic@rivosinc.com>

[ Upstream commit 0bcff59ef7a652fcdc6d535554b63278c2406c8f ]

Adding memblocks for soft-reserved regions prevents them from later being
hotplugged in by dax_kmem.

Signed-off-by: Andrew Bresticker <abrestic@rivosinc.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi-init.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
index 2fd770b499a35..ff9791ce2e156 100644
--- a/drivers/firmware/efi/efi-init.c
+++ b/drivers/firmware/efi/efi-init.c
@@ -116,15 +116,6 @@ static __init int is_usable_memory(efi_memory_desc_t *md)
 	case EFI_BOOT_SERVICES_DATA:
 	case EFI_CONVENTIONAL_MEMORY:
 	case EFI_PERSISTENT_MEMORY:
-		/*
-		 * Special purpose memory is 'soft reserved', which means it
-		 * is set aside initially, but can be hotplugged back in or
-		 * be assigned to the dax driver after boot.
-		 */
-		if (efi_soft_reserve_enabled() &&
-		    (md->attribute & EFI_MEMORY_SP))
-			return false;
-
 		/*
 		 * According to the spec, these regions are no longer reserved
 		 * after calling ExitBootServices(). However, we can only use
@@ -169,6 +160,16 @@ static __init void reserve_regions(void)
 		size = npages << PAGE_SHIFT;
 
 		if (is_memory(md)) {
+			/*
+			 * Special purpose memory is 'soft reserved', which
+			 * means it is set aside initially. Don't add a memblock
+			 * for it now so that it can be hotplugged back in or
+			 * be assigned to the dax driver after boot.
+			 */
+			if (efi_soft_reserve_enabled() &&
+			    (md->attribute & EFI_MEMORY_SP))
+				continue;
+
 			early_init_dt_add_memory_arch(paddr, size);
 
 			if (!is_usable_memory(md))
-- 
2.43.0



