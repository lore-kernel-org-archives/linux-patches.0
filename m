Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021168;
	b=ve1GRKwJmoeJq3bHWtmNNR+5vWc2H76d32V47l3iZodmeUlfEvazdH2I9A+vGbAZENZ4
	 2eSq9aQsJRgjeRujN2kYJvQoYlc/KzO9V2c+9Htn2PS9TvbLJhmRJm/hgrD6V/kLRecKs
	 g33QmewFay/ZkoB99l3zwodFzt6P87iH0Zjkm1Yglkm0Pw+cI1dBhC8G1ChHJb5+JJd6v
	 VF8wWkpoam6P3Qyy7u38jBEGu6wuv2Cy6qdcSUKtaxyOB+qrU7N0BB0XJ3dsZguEraclp
	 oULJbC1pIT1OHqFQ/ktMSuwYvgwKaRxY8z3Tgg15kkbnOxD5tndEryKN3MGD8wgD7IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2/rgOhKhW7q0s3J2VGgScJOUf9HGJyRQ0JixhtBjap0=;
	b=VWrfPCzsoBiA5W+6W7nQZc8Z8I6ahvwgcKEBWNPZWxgnZd6/OuLmReDMbl2K2QyNArNe
	 mN+qXsDP83hq9w2XhEFXfhFKGpQQG3kx6kYI3yXpsk06P6+c3qhFXaKm3Qt2mCQWdvulM
	 A6Bvi3qQEYKcFW65m73y9FUWLrg/yVfYMaz54AvP1bJFFzX8OLjfFSeO0Hwx0XFbDAgI9
	 4U/AgzWXUdQLw7rfPZPEnC146mk0EsSWCfjoExllT5y7m0Qj9EjZOwhN7yw6EsHxAmlxB
	 /YBSjBJiNqTZQjL1TMYQdg6077ixsj5hHXDr4DXqm6zklzqiakmResjfBlCFKOKVbYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngFABZsB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96809606A325;
	Wed, 18 Nov 2026 16:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngFABZsB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CDB1F000CB;
	Wed, 18 Nov 2026 16:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021168;
	bh=2/rgOhKhW7q0s3J2VGgScJOUf9HGJyRQ0JixhtBjap0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngFABZsBD9typFP/M+3edJPhVH51ghGZEP2Iv+ZjBIvJuIx9EQ4dNwIRzU75d/9zn
	 hLfOjgURa67452WFcXs5/fzdqGO1IFptYJuzGcZZmsrcZrYPYPbfswl1uIIWywyoo3
	 6+TLmy73Ls3FY5pnGbASR8oVsCNCZLyM83PO+w7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2211/2651] ntfs: account for direct MFT bitmap cluster allocation
Date: Wed, 18 Nov 2026 15:57:31 +0100
Message-ID: <20261118150405.244536855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuewen Wang <wangxuewen@kylinos.cn>

[ Upstream commit 109c9b0f67f97a34b19491fa82242a2130114903 ]

The MFT bitmap extension fast path sets $Bitmap directly, bypassing
ntfs_cluster_alloc() and its free_clusters and lcn_empty_bits_per_page
updates. Successful extensions overreport free space, and rollback adds
back counts that were never deducted.

Update both counts under lcnbmp_lock and the bitmap folio lock. Require
a nonzero page count and space remaining after delayed-allocation
reservations; otherwise use the regular allocator. The page check also
prevents underflow when the initial scan recorded zero after a read error.

Fixes: 6251f0b0de7d ("ntfs: update super block operations")
Suggested-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/mft.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 3192c018653b3..04ea38a824380 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -1399,10 +1399,18 @@ static int ntfs_mft_bitmap_extend_allocation_nolock(struct ntfs_volume *vol)
 	folio_lock(folio);
 	b = (u8 *)kmap_local_folio(folio, 0) + (ll & ~PAGE_MASK);
 	tb = 1 << (lcn & 7ull);
-	if (*b != 0xff && !(*b & tb)) {
+	/*
+	 * A page skipped by the initial scan has no free bits recorded.
+	 * Honor that and the space reserved for delayed allocation.
+	 */
+	if (*b != 0xff && !(*b & tb) &&
+	    vol->lcn_empty_bits_per_page[ll >> PAGE_SHIFT] &&
+	    ntfs_available_clusters_count(vol, 1) > 0) {
 		/* Next cluster is free, allocate it. */
 		*b |= tb;
 		folio_mark_dirty(folio);
+		ntfs_dec_free_clusters(vol, 1);
+		ntfs_set_lcn_empty_bits(vol, ll >> PAGE_SHIFT, 1, 1);
 		folio_unlock(folio);
 		kunmap_local(b);
 		folio_put(folio);
-- 
2.53.0



