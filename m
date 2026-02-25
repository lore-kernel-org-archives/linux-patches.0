Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1962313546;
	Wed, 25 Feb 2026 06:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002796; cv=none; b=LXD2GNWyL/DalCFRCTG6gbt4jiCGUJdd+OrJ6xjlTXYDvpv2QoBoFSqQBZ+dDo4A57VWqBdzipDW8pMASMLAJJOEBf6lVmHR5TAC98+UKvLD3U08n/GcOgTyX60gCbNST6movOXSjGEiWjZZapvvOGF2DI09S0fHCknmDlKIwlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002796; c=relaxed/simple;
	bh=GQgM9x1nkEadYt6ldUAtfrjxvADFro1H8vkYUu1Z7Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLCwy0KL1ACjLtlwTTLnxA3/W9WnwCwFSeBG4Ql3LHpd4wVIIOXwjXBaL4KrgsPwVYxIghwG8Cq8IQ820ecNWrBMIG6AslkHZ/XZFT7roK5Gcwtc89JAbOWCW58HWMxY+wGAl40OMvDxpGsSDCdNaaW8UDAzrK6MQNIXVkZthyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPK1iizi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPK1iizi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1FDC116D0;
	Wed, 25 Feb 2026 06:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002796;
	bh=GQgM9x1nkEadYt6ldUAtfrjxvADFro1H8vkYUu1Z7Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPK1iizic+nM6u35920f+bUzkHKIzXa9QueN+zWccoWOnkWl0bniCdnLd46A1qBZM
	 97HthUoEtUYHyAUdw9WopBrCTdBqJa+xBSpZ0iN7owIZCag+ir6C83zMHFHPsdfq7Y
	 Lp39iCR4UtnTXxSDBq/5F0UXW+d5qyoIOmb+iMHQ=
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
Subject: [PATCH 6.18 601/641] efi: Fix reservation of unaccepted memory table
Date: Tue, 24 Feb 2026 17:25:27 -0800
Message-ID: <20260225012403.077794761@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
Message-ID: <20260225012527.atdF7SkZkjfQZnq83h8AUzBBEa2yi8GRh0JHOFmBLoo@z>

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fc407d891348f..c3cf5541ed682 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -691,13 +691,13 @@ static __init int match_config_table(const efi_guid_t *guid,
 
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



