Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4904C62;
	Thu, 27 Jun 2024 00:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719446969; cv=none; b=cTLXI0/0ZRGPkdr/GTjmHeN/rAhUKbB7V7PvolBGNEDITbLHrszQDLfKSJiCYqiow+GB7xD82gCqLMlxmNKfTwTrEj1ziGFFCAkMd5hK/lLTE/D0Wvq1M7uqngClEsdkOEIlvkN9jkU2JMQljYn1Q8qO6dHC7+KAer765v5poZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719446969; c=relaxed/simple;
	bh=g6aSf05EzYYETlf2o9BOCJG4fdLkL9sKEIU7uhFD1/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GtWtaWETB9a2p33VW4oP5jdY6OUMlJCGyMx1+oVGByamEysCG80uQmXdCl2SGGJaIOfOCf2JCKwELsKaGptvlmQoCnwS8u/wjxzJ261Nl5LaTeDu1rTaArRvXKIPCjShv5lzv4WUZA+KqmynjeLeeiUzheXo5YqdwS9YSI4f9MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4tsWEX2w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4tsWEX2w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=EBkUb0Zod9PMNfEgCDDzkHALc55cp6jjtgA5Pre3tic=; b=4tsWEX2wHYGMaDcp38dowwnbkY
	siqhLhl1H0IrtLIwoKDNc+MYS9LC7kcNE/5IvFDhXXFFRRK/bkDPGWoi7CbhCYZYVPiSzxiCJU84y
	s6oMkHrHMLYyTmjCjfuOONBN4sc/F6MFjzyZBg9sYpobJ/DbK2oW0EAAK6g8uJGr9nW+4G7tj9KXB
	GilaFrcZkkCykbjXLLI1cJh89Lz2ESHDIgQDsPnLvVzMKtT25DxgA/rKfn+iBvzenUl427Jp/nqSG
	xJuwUMO+RMK3DXoBFWKWyRffIWBUtpGq8VgkMDtOR2w5Sfu3CfSjOIcdvsLLQPzq+Z+iAUHT/RfOH
	3MAM7X3A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sMchZ-00000008hnT-2iFu;
	Thu, 27 Jun 2024 00:09:25 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: p.raghav@samsung.com,
	hare@suse.de,
	kbusch@kernel.org,
	david@fromorbit.com,
	neilb@suse.de
Cc: mcgrof@kernel.org,
	gost.dev@samsung.com,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	patches@lists.linux.dev
Subject: [RFC] swapfile: disable swapon for bs > ps devices
Date: Wed, 26 Jun 2024 17:09:23 -0700
Message-ID: <20240627000924.2074949-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Devices which have a requirement for bs > ps cannot be supported for
swap as swap still needs work. Once the block device cache sets the
min order for block devices [0] we need this stop gap otherwise all
swap operations are rejected.

[0] https://lore.kernel.org/all/20240510102906.51844-6-hare@kernel.org/T/#md09501306c649dd84db0a711f9359570c17a197f

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---

This is super *way* forward looking after LBS patches and once we square away
how to support things on the block device cache. Only then does it make
sense to start to consider this. But this is just a stop gap.

But if you think about it, in practice since we are going forward with a
world where we have AWUPF >= NPWG to enable the physical_block_size to
be >= NPWG, the corner case we want to help users *try* to avoid is to enable
swap not when the LBA format is > PAGE_SIZE (although for sport we can
support that) but when the NPWG > PAGE_SIZE. So we'd warn about that until
swap gets a facelift. That is 4k writes will work for devices with 4k
LBA format for example but NPWG = 16k, they would work with a RMW
penalty, just as RMWs today happen with drives formatted with 512 LBA
format and today's default world of 4k IU.

As it turns out we have no topology information for the IU today.  It used
to be that physical_block_size used to have a language about RMW.
During the 2024 LSFMM thread about Large Block for IO that Hannes
proposed we reviewed this discrepancy [1] but we seemed to conclude then
that no changes are required.

I'm starting to think that exposing the IU might make sense now. The
below would not capture the case of the IU > PAGE_SIZE, in theory that
should work but then its just RMWs, but users likely should be informed
it is stupid for them to do that. The other more important use case
would be for STATX_DIOALIGN for the dio_offset_align. That seems
incorrect today even for existing drives with 4k IU and 512 LBA format.

Thoughts?

[1] https://lore.kernel.org/all/ZekfZdchUnRZoebo@bombadil.infradead.org/

 mm/swapfile.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2f5203aa2d2c..9ff168760bc2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3153,6 +3153,11 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 
+	if (mapping_min_folio_order(mapping) > 0) {
+		error = -EINVAL;
+		goto bad_swap_unlock_inode;
+	}
+
 	/*
 	 * Read the swap header.
 	 */
-- 
2.43.0

