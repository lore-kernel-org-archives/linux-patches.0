Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B213356742;
	Thu, 20 Aug 2026 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247947; cv=none; b=Bi0zWVYuOGNGbYKfX7yzJ5f0jc3bTCLCmFQHQ/llqrFZ95gJENsbovTysRCzd685fEO1AaHMhpF97obHBFkkMSrGKH0vpzJPdenUWLeezTVXN4VZxVsLhFoBuFqTkfZInUbZz3UijdeoRYALg5v/swQ/wobnwMWYdclGIjDbwpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247947; c=relaxed/simple;
	bh=ZKKTbiMPV8lhRauln5AksqvUC5UHvSKw9DxC2L2PUeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+QKmmydn2vTEBTLxK4/4JiCof8GuIvTBg/s8E6hLooiAJSmZj40pffjVKBPbIZ5D8+U+jAbgvA6qaNpXg0gqHBcLSrCMYnbOPPYfbUgI8Bs7MyOlOhaUnOxRih6dcWYglG5fcY+f2MA7FR9TD/7r583Nc5aVB91GA1mcUHuVUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ocy1Ni0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ocy1Ni0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E4D1F000E9;
	Thu, 20 Aug 2026 17:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247946;
	bh=NMMLf2miOojPNor3a0VK79HxRMxfZ+U13bLzajPf/g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ocy1Ni0E7unPVNmAhnEPJmkCZLwu5y5n3vwnF7MaKOHlwVEQilQnBf7If1gQGIj7
	 UTqNOlaBGe9vCYTDiQJ35wLmfUNVuBWOPjsYYFH8+1doGh0+HF25D+cpfOvomkQC9v
	 saHcJbt6MAVzv17wxnJ8ktSoxD42KBNoD5/6FNW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Ben Zong-You Xie <ben717@andestech.com>
Subject: [PATCH 6.1 056/303] riscv: Dont use PGD entries for the linear mapping
Date: Thu, 20 Aug 2026 16:53:12 +0200
Message-ID: <20260820145254.852591481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit 629db01c64ff6cea08fc61b52426362689ef8618 upstream.

Propagating changes at this level is cumbersome as we need to go through
all the page tables when that happens (either when changing the
permissions or when splitting the mapping).

Note that this prevents the use of 4MB mapping for sv32 and 1GB mapping for
sv39 in the linear mapping.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20231108075930.7157-2-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
[ Ben: Only backport the RV32 guard. 6.1.y can build the RV32 linear
mapping from PGD entries, and there is no splitting in __set_memory().
So a one-page permission change mutates 1024 pages.]
Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/init.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -668,8 +668,13 @@ void __init create_pgd_mapping(pgd_t *pg
 
 static uintptr_t __init best_map_size(phys_addr_t base, phys_addr_t size)
 {
-	/* Upgrade to PMD_SIZE mappings whenever possible */
-	if ((base & (PMD_SIZE - 1)) || (size & (PMD_SIZE - 1)))
+	/*
+	 * Upgrade to PMD_SIZE mappings whenever possible. Not on 32-bit,
+	 * where PMD_SIZE == PGDIR_SIZE: such a mapping is a PGD leaf entry
+	 * that __set_memory() is unable to split.
+	 */
+	if (!IS_ENABLED(CONFIG_64BIT) ||
+	    (base & (PMD_SIZE - 1)) || (size & (PMD_SIZE - 1)))
 		return PAGE_SIZE;
 
 	return PMD_SIZE;


