Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A1D318ED2;
	Mon, 13 Apr 2026 16:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099558; cv=none; b=PYtqxuYX/vFg2XIokIhqOuucMAETCNhH/wNHWX9nxecMIc9BMRrzLIaDfWekELsNjDo1LDP95x6DfICleqCTqfVt38EPDnr7PzfzvxeamlcG4osgYwyByUrezh5JeXBdwR1nttKVAFQke9sYxUx59ZgJsGnDyI7yOei6B8gp9w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099558; c=relaxed/simple;
	bh=esrMXbVF6Q544EQ2slZNdTAJofKCX6sF5RvAtIIvZBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRQDI4WAn/gzKNWTP7WUhw0IhhjOgG/f4Tv4W+1lmoHWOfEqPkIB9ywKBW8AvInxpQKzgB36b3UddYrO3L1J4JzbO+wvZ5OVqZfIQRojYabSXEaPX60//xBSp1yy7taJrLHFaEvsAhAnrFKR3vRKlpZSOZIehk3Jve+CJMpIcnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DUXcNd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DUXcNd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCBDC2BCAF;
	Mon, 13 Apr 2026 16:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099558;
	bh=esrMXbVF6Q544EQ2slZNdTAJofKCX6sF5RvAtIIvZBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2DUXcNd9S7XTgCiX6NScD8i2RWH8nXHOM+ZbCnVWskQtOqaJs6YXmAUgwyoO/toJm
	 i44SitXLsb4VoFkKlnk20q26fOv2CO58U7LsYTN9qOW1X2tBQ7CZp81tYV4jtpiCCa
	 2FVTDVTc6MCiYyKBTR21z3uzDlov2rqfzVznvIMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Jones <pjones@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 354/491] efi/mokvar-table: Avoid repeated map/unmap of the same page
Date: Mon, 13 Apr 2026 17:59:59 +0200
Message-ID: <20260413155832.292236682@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit e3cf2d91d0583cae70aeb512da87e3ade25ea912 ]

Tweak the logic that traverses the MOKVAR UEFI configuration table to
only unmap the entry header and map the next one if they don't live in
the same physical page.

Link: https://lore.kernel.org/all/8f085931-3e9d-4386-9209-1d6c95616327@uncooperative.org/
Tested-By: Peter Jones <pjones@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/mokvar-table.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/mokvar-table.c b/drivers/firmware/efi/mokvar-table.c
index 39a49adf007a5..69ac876ca809d 100644
--- a/drivers/firmware/efi/mokvar-table.c
+++ b/drivers/firmware/efi/mokvar-table.c
@@ -99,13 +99,13 @@ static struct kobject *mokvar_kobj;
  */
 void __init efi_mokvar_table_init(void)
 {
+	struct efi_mokvar_table_entry __aligned(1) *mokvar_entry, *next_entry;
 	efi_memory_desc_t md;
 	void *va = NULL;
 	unsigned long cur_offset = 0;
 	unsigned long offset_limit;
 	unsigned long map_size_needed = 0;
 	unsigned long size;
-	struct efi_mokvar_table_entry *mokvar_entry;
 	int err;
 
 	if (!efi_enabled(EFI_MEMMAP))
@@ -142,7 +142,7 @@ void __init efi_mokvar_table_init(void)
 			return;
 		}
 		mokvar_entry = va;
-
+next:
 		/* Check for last sentinel entry */
 		if (mokvar_entry->name[0] == '\0') {
 			if (mokvar_entry->data_size != 0)
@@ -156,7 +156,19 @@ void __init efi_mokvar_table_init(void)
 		mokvar_entry->name[sizeof(mokvar_entry->name) - 1] = '\0';
 
 		/* Advance to the next entry */
-		cur_offset += sizeof(*mokvar_entry) + mokvar_entry->data_size;
+		size = sizeof(*mokvar_entry) + mokvar_entry->data_size;
+		cur_offset += size;
+
+		/*
+		 * Don't bother remapping if the current entry header and the
+		 * next one end on the same page.
+		 */
+		next_entry = (void *)((unsigned long)mokvar_entry + size);
+		if (((((unsigned long)(mokvar_entry + 1) - 1) ^
+		      ((unsigned long)(next_entry + 1) - 1)) & PAGE_MASK) == 0) {
+			mokvar_entry = next_entry;
+			goto next;
+		}
 	}
 
 	if (va)
-- 
2.53.0



