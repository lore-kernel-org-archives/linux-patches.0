Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031494;
	b=jkyM49NJKvELrb1UhEOrgSOfPTjII9uvDm/eGycfCl/Yb3r5I7twUeV4i0tRgi4skgPH
	 GlYNWL73BQwaO/LcmpHEsp7KvQAL2jrXEjxqDkgJd/p4QKB0ZWZmdUCBBd2DSr8Kha+Gi
	 NO58bqp7smgUZ2QC3sAst9WU9bbrb6oJRVn8hgUY6KKZ196vD0VYeuEF4Epg6OPF+Sbi6
	 0mdy1wzvGidm84pI+FgkktOW/SPpA8QM/S35vyX3yurIz0YnK5z0KdRFtXHUvlLuDBrFe
	 u+cDCcB3AQ9KCkJee3XMjI5sTvkK5I1JSFXfkanb4oiXYHn0gIWjsFK3Pn0Ptlrzikw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JWIuy+Aw9vCjzEbpho2kbs6YJGQx090z7FUsPlePoO4=;
	b=5p1AMOqbb3Syl4tWBRjV1Tm50pOz58B4TRBOL7Y89J1qEEkp3qlWdJPoCclfq65tou3c
	 LNEfYZPTB6Vv/eSsL/yzhsD6QkM+IGkXtkE6uc0CIeW8kUHXG6TvoVayWBsB9Th52zR5n
	 DhTXduKZIGmrVYgKlhxbDOiY+f9gI2QBfdLu58kh6tSxzbHAATp68oJyt/Aq359JtreUS
	 HxyvaZV1tDxd0ZptqvLyrAi2Bbn6Kh7R98xcin8MOaC0t6uW16FrUjJnxlKZ6kw0vvuK8
	 32n61cfvV7+rgqI4fc86tVm9nqnt5Si+VAY23aH4nfevbaURZeRZDPrpw14RoCzqVcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gSOL0bBl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB44D606A33A;
	Wed, 18 Nov 2026 19:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gSOL0bBl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E091F000D1;
	Wed, 18 Nov 2026 19:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031494;
	bh=JWIuy+Aw9vCjzEbpho2kbs6YJGQx090z7FUsPlePoO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSOL0bBlnyZgs8sPnBM4feBkHENmmlZ5+7s0i32MNHVDjJWogzbDU6reJaqcyMCyR
	 dLEGn8tjZxiaVDz6IZG7U7zgPxiC+mFVvWuQ1mYGTXJUMUWQ8Fmn0Yk22WVQTGrwnE
	 GG8vrYW1QsO9FXfZi/h8L8DEJg1vzeb4Dil1mDl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1079/1756] btrfs: defrag: fix check to see if next extent can be defragged too
Date: Wed, 18 Nov 2026 15:53:26 +0100
Message-ID: <20261118150053.176457635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit eb55bc2bfe204e6bfccfe179226d7fb5024cb010 ]

We want to check if the next extent is at maximum capacity but we are
passing the current extent map to get_extent_max_capacity() and not
the next extent map. For example if the current extent is compressed (its
maximum capacity is 128K) and the next extent is uncompressed (its
maximum capacity is 128M), then we can bail out and not defrag the next
extent too - when for example the next extent as a size of 128K, is
uncompressed, and the extent threshold is >= 256K.

Fixes: 979b25c300db ("btrfs: defrag: don't defrag extents which are already at max capacity")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/defrag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 727a016b2025b..0cad202664a68 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -826,7 +826,7 @@ static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em,
 	 * If the next extent is at its max capacity, defragging current extent
 	 * makes no sense, as the total number of extents won't change.
 	 */
-	if (next->len >= get_extent_max_capacity(fs_info, em))
+	if (next->len >= get_extent_max_capacity(fs_info, next))
 		goto out;
 	/* Skip older extent */
 	if (next->generation < newer_than)
-- 
2.53.0



