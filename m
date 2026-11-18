Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037574;
	b=nucu84AkXx5ptyVkKIEWiNf1Lz7FHeIeug+Rg5/1SUQ5c5hnc6DbT9K9gopekHZhIUql
	 dsAAt1rGENd+TEhHceimnVNUbaRWQbDbRiEaBn+i/FPHG7c6Lx3YNpHex7KUReiJbhEMz
	 JbIMOGXye+GOA6QHZhIU9Rm8aoQi891ZV3upBDrVDI2u7fhNNhQcJCoP2y9eg6wanOeQj
	 dENtJLNLKtB+fqwGOseWuzPzfFA/ru/DnvHo4PvksK0gipht/mMGjj4dq7hp5/tlwAwjm
	 OnQ5Esh1mQQipr/d7zQWRX/Q0ntbHrCQQs6fMd6NVGT6cqgiefEIQm/kd0xkm9ag2fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TWNtV43ShBZJ0dtn6N2Ix1+i0LoJ4nEzb0Iu6hM1Mhc=;
	b=kYPTWkQ11DAxaAf+1pRK6uYB70kt0NKEBKYf+bF8E4PnoG2kWiGU2cH624qAuUvBpJak
	 d11YGP447viJ++KA7eOatDAJDVrtGf8EQPgxyXTu1S0/b40DImzD0BfJLd6r+zSEnNVq5
	 jV48R8zJEVYNFxRG+eVxkvTdkkqY3CBs+OLOom82Vlqd9nkrDNQLqInAzGqkTEIilAyHa
	 tZBrN/4Pg7lojjapIt1rOoIovlCi5b3aUv1LrDYdv8j7qU8h5fj7dX5/oHjqKtcEvvlUM
	 fpqReSf1fstv/5BE+CFi7/nNv/Mb/DflrQwqyz/ZdFxZx+FGtBcFouLY9GLCriDjanQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IpfvaEIv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D606E606A31C;
	Wed, 18 Nov 2026 21:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IpfvaEIv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061531F000C4;
	Wed, 18 Nov 2026 21:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037574;
	bh=TWNtV43ShBZJ0dtn6N2Ix1+i0LoJ4nEzb0Iu6hM1Mhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IpfvaEIvaZHF4VFEEfsIWdd9q1enWrvv0kHBzMJ77oB6aTRj7lG2elBGKI9XyMK9G
	 8c8TrjmaC63R+S/AOSIGsBX08Wz8l3107y+V+fS1LpaQcv5SJMf11dsVBgGuufgXbh
	 CceN11UQl3CWQIz/mPyGi7YJrlKy/0oQQKf51KK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1445/3318] mm/shmem: fix truncation of files containing only swapin-error markers
Date: Wed, 18 Nov 2026 15:34:27 +0100
Message-ID: <20261118150404.189341765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 59511d630a6942356ac4b6984797998a8f3a9017 ]

It might not be very common, but we can end up with shmem files that are
composed only of swapin-error/poison markers.

Such markers are not counted in info->alloced. Consequently,
shmem_setattr() can skip shmem_truncate_range(), leaving the markers
behind.

Truncating the file to zero and growing it again will result in reads
failing with -EIO instead of returning zeroes.

Check whether the mapping contains entries, in addition to
info->alloced, before skipping the truncation. Keep the info->alloced
check so that shmem_recalc_inode(), called at the end of
shmem_undo_range(), can fix up accounting after reclaim has emptied the
mapping.

Fixes: 6cec2b95dadf ("mm/shmem: fix infinite loop when swap in shmem error at swapoff time")
Cc: stable@vger.kernel.org
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-15-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 96c36c3d4a0f5..3a6192f5cc7d6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1232,7 +1232,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 			if (oldsize > holebegin)
 				unmap_mapping_range(inode->i_mapping,
 							holebegin, 0, 1);
-			if (info->alloced)
+			/* Swapin-error markers are not counted in alloced. */
+			if (info->alloced || !mapping_empty(inode->i_mapping))
 				shmem_truncate_range(inode,
 							newsize, (loff_t)-1);
 			/* unmap again to remove racily COWed private pages */
-- 
2.53.0



