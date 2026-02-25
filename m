Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE0D256C8B;
	Wed, 25 Feb 2026 01:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983649; cv=none; b=mHlw7EnRCqbTwyw4Wb7rBnJoIAaQiBWT49aIQWQyDfiszbYLLuH3ZdSH6/WtRGGskzjrkb3596pOQVWUBDgm4TnIyY3/t9DJnRwVRHO1AcJFUSFGWpK9eurZ0yO1dgUEbJ95Ztb8Vic8HGI0kDSpQliXT54BqglOgKQvrpFp6Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983649; c=relaxed/simple;
	bh=3LR/dS+4dHTsGm53kvYOz0Bd4zdJBnJFGEvIFYiZ20M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D14uhTstTrGmGXspzX/bCZgqzj9l9QL/0tOq40BKFtUCLLHvs67A4gXN7/+oxNb4+/2uC+/OVkypyOZI4CaMwUiKWZhqg91IEq+UyEg75AnKVfISXC8eztQO5Ftav5qS+W46+Jfx7eYp/Lu0GtcaTrtOXRxl8xfUjQTjvYC9SY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgPBRjS5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgPBRjS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BD7C116D0;
	Wed, 25 Feb 2026 01:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983648;
	bh=3LR/dS+4dHTsGm53kvYOz0Bd4zdJBnJFGEvIFYiZ20M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgPBRjS52sWLc4k1SBI3IX+RaXgKHxUhOi5FtNUH4rm0bBWhGPPjX0f+Ee1mJ4g1f
	 IkigSTrH86ZXBE8qH670KQyqqm33EBQ0w6dJXgCwJ88nRdX1f+8f7FHFIXJvJys9Sm
	 Ut2fYauPdc3ZGX9ktWjhTJfOtJ8VYEmZNxn7Yr+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moritz Sanft <ms@edgeless.systems>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 735/781] efi: Fix reservation of unaccepted memory table
Date: Tue, 24 Feb 2026 17:24:04 -0800
Message-ID: <20260225012417.758539954@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

[ Upstream commit 0862438c90487e79822d5647f854977d50381505 ]

The reserve_unaccepted() function incorrectly calculates the size of the
memblock reservation for the unaccepted memory table. It aligns the
size of the table, but fails to account for cases where the table's
starting physical address (efi.unaccepted) is not page-aligned.

If the table starts at an offset within a page and its end crosses into
a subsequent page that the aligned size does not cover, the end of the
table will not be reserved. This can lead to the table being overwritten
or inaccessible, causing a kernel panic in accept_memory().

This issue was observed when starting Intel TDX VMs with specific memory
sizes (e.g., > 64GB).

Fix this by calculating the end address first (including the unaligned
start) and then aligning it up, ensuring the entire range is covered
by the reservation.

Fixes: 8dbe33956d96 ("efi/unaccepted: Make sure unaccepted table is mapped")
Reported-by: Moritz Sanft <ms@edgeless.systems>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 17b5f3415465e..92e91c3eb4690 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -692,13 +692,13 @@ static __init int match_config_table(const efi_guid_t *guid,
 
 static __init void reserve_unaccepted(struct efi_unaccepted_memory *unaccepted)
 {
-	phys_addr_t start, size;
+	phys_addr_t start, end;
 
 	start = PAGE_ALIGN_DOWN(efi.unaccepted);
-	size = PAGE_ALIGN(sizeof(*unaccepted) + unaccepted->size);
+	end = PAGE_ALIGN(efi.unaccepted + sizeof(*unaccepted) + unaccepted->size);
 
-	memblock_add(start, size);
-	memblock_reserve(start, size);
+	memblock_add(start, end - start);
+	memblock_reserve(start, end - start);
 }
 
 int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
-- 
2.51.0



