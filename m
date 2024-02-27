Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E29E145B1C;
	Tue, 27 Feb 2024 13:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041948; cv=none; b=ru7ozB2ZQh9ODUQXUjEqXpaO1z9TovLlU/DERy7EcpdvXeJEYITgh+wXh2EOfhpErRpz1fo1wBbZNMn9POcqDWK0p0wJ47zYo3vpCntkvHxiyBEm0ckBBbKyBhKWUHJ/dgCdAsdxqhHq1iJb0ecl4q8QwbP6jYGW/pUPvWmbMdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041948; c=relaxed/simple;
	bh=0QMDD6kyv1XRVORXmd3xjPvZjzP8LJjkJlhWAMAV4Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMdd7tcY3sWpNFppNUiWyPqdDruVsr45kqGdQ3tfH2IafvEstFfIma7CMU6j5PzARNG0zuvrWnREFosifRb2eQzhFPEFg4vzN9IBRdTWPI58v3uUu1MOYqKfhTFAAn7lJkzU430ZfO8yya11uTzkfXJvqN28QoWfKRI59M8okOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3VRr6Dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3VRr6Dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24E8C43330;
	Tue, 27 Feb 2024 13:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041948;
	bh=0QMDD6kyv1XRVORXmd3xjPvZjzP8LJjkJlhWAMAV4Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3VRr6DndXLy2JyEorrdRTFdFu6lyw81zMmRCU8UGxYEFGXmlPj6mC5ooCcikNXrj
	 pjEWbh9sqOtulDjmBHt27xYVSVYBa0N4Ccaz+AUJjEnW/04yxiarYUsqCIn/VBi33A
	 j+QseX8SMDheqy8YhL/lVzSBrFa9Nqm6Sv6CTSM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Bresticker <abrestic@rivosinc.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/299] efi: Dont add memblocks for soft-reserved memory
Date: Tue, 27 Feb 2024 14:23:28 +0100
Message-ID: <20240227131629.019772197@linuxfoundation.org>
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
index ef0820f1a9246..59b0d7197b685 100644
--- a/drivers/firmware/efi/efi-init.c
+++ b/drivers/firmware/efi/efi-init.c
@@ -134,15 +134,6 @@ static __init int is_usable_memory(efi_memory_desc_t *md)
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
@@ -187,6 +178,16 @@ static __init void reserve_regions(void)
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



