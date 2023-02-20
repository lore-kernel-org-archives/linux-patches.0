Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD12C63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56525C433EF;
	Mon, 20 Feb 2023 13:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900665;
	bh=ITNjiqF+dN5QS2x0vyF0QWRBbjVDSlE/VfQnx4l1+WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1h2Hmz65ZiNRDh0+bb7W3PLNdYOW2S52VXUWqyis1Ty11K7QEN9GDr6S8QRcsgJk
	 J8B+5R+/QMbR9DbhIPhhEHrrVoCkzzqEJ92Qg0aC9iHy+DNw9RAVdLNzJUjk9NGVUM
	 4B2Dxy9gdWvlSoFMNA4SL3NLsK8PLixWhR1yX8QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Gusev <aagusev@ispras.ru>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/156] efi: fix potential NULL deref in efi_mem_reserve_persistent
Date: Mon, 20 Feb 2023 14:34:26 +0100
Message-Id: <20230220133603.372029889@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anton Gusev <aagusev@ispras.ru>

[ Upstream commit 966d47e1f27c45507c5df82b2a2157e5a4fd3909 ]

When iterating on a linked list, a result of memremap is dereferenced
without checking it for NULL.

This patch adds a check that falls back on allocating a new page in
case memremap doesn't succeed.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 18df7577adae ("efi/memreserve: deal with memreserve entries in unmapped memory")
Signed-off-by: Anton Gusev <aagusev@ispras.ru>
[ardb: return -ENOMEM instead of breaking out of the loop]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index eb98018ab420..ed31b08855f9 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -1022,6 +1022,8 @@ int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 	/* first try to find a slot in an existing linked list entry */
 	for (prsv = efi_memreserve_root->next; prsv; ) {
 		rsv = memremap(prsv, sizeof(*rsv), MEMREMAP_WB);
+		if (!rsv)
+			return -ENOMEM;
 		index = atomic_fetch_add_unless(&rsv->count, 1, rsv->size);
 		if (index < rsv->size) {
 			rsv->entry[index].base = addr;
-- 
2.39.0



