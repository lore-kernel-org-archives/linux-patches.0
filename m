Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031481;
	b=0tHfwXhG5vo+0c+3fV96ZBwsLvAD0NlhVH59OLUjby7D5wtZI+G90vGYGFLcxKaJIfcg
	 TvChJmeIUczA9t3pG7EYMJMCvwG36pRpLtf9PeD8/B4LqB/8ddI2o0OhcJyMxC1dvv93W
	 2nqcpAR9BF1oKq8TeWOoHmhsInrbDDCBKXqENhfhb6MuWeHj+/OitwcGFTrrIJmxBKYXh
	 pXnik1XlSM7JcaCRs6R5Jb6PlAxVTuplZ9KwlxeEC6i+zPJY7nP7NwunA5hSa9ilDGgWF
	 CkILOyXTqs517lDPPDwpDTawm19eI1z2/ju6thKcEy47KipSEDUl9EJhPZ0J+07fnXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eCRHB2z4ErL2UkT9KyB31WeQJYzJ+xMPy1cxSXy+Nq4=;
	b=5Oot3CPQUw/Y9JA4VL/Fd06e/qyKpUjYkq/a8F7Q/g+YKJnfAz96L8ekq7QkllhIKlj7
	 kF/vvIi3n5uf1TxcGugiruafNqNwcFlC3lv+e/DhUYVZg+3RwJNUldrlPXpbYzGTSYLkQ
	 hGPeRRB+am0VbrEAlgZ+vP71KnbLLydRTVJ6UXDqsi/W2oufZrOT3ZBACsiEvbSJRBBmf
	 8AyMMbi9NYlTwyNHOjEbbKiGsR4sy8BsAUYXM3g+BVh0+RgE2KxbXw5L6B0KF23OY09rg
	 pdxLA/yAqz3y+nWCvgg252/3TgdYX8T1pyOor4U98GT9qeqePhyFqUrVDzE8o0dj6fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wk8oIjfe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2541606A32F;
	Wed, 18 Nov 2026 19:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wk8oIjfe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A151F000C4;
	Wed, 18 Nov 2026 19:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031480;
	bh=eCRHB2z4ErL2UkT9KyB31WeQJYzJ+xMPy1cxSXy+Nq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wk8oIjfesavH4/+A5mDIwiwQDrUsmgTmq4EFoAS4CW1SHxrlEH930FIWYjg9pDyJ0
	 yiPoJyzNjbkyOhc6QkdAJvht/5NW7Nr4OqQ5RubcPBm75t2HO+zc413Cklnfjg8vIc
	 WVSU+VRz/J4Fp8LPjyIQ9jyTxgrP/1pwGMruZuuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Daniel Vacek <neelx@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1075/1756] btrfs: fix off-by-one end offset check in report_setget_bounds()
Date: Wed, 18 Nov 2026 15:53:22 +0100
Message-ID: <20261118150053.032203974@linuxfoundation.org>
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

[ Upstream commit 08f750d9f8930e4ca053913b5ca3fd49fd9268c9 ]

The addressable range with an extent buffer goes from byte 0 to byte
eb->len - 1, so if a byte address matches eb->len, it's already beyond
the addressable range and we should log that it's bad start address
and not end address.

Fixes: 234fdd2815ce ("btrfs: remove redundant check in up check_setget_bounds")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Daniel Vacek <neelx@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/accessors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/accessors.c b/fs/btrfs/accessors.c
index a7b6b2d7bde22..359ec3d66cdc1 100644
--- a/fs/btrfs/accessors.c
+++ b/fs/btrfs/accessors.c
@@ -16,7 +16,7 @@ static void __cold report_setget_bounds(const struct extent_buffer *eb,
 
 	btrfs_warn(eb->fs_info,
 		   "bad eb member %s: ptr 0x%lx start %llu member offset %lu size %d",
-		   (member_offset > eb->len ? "start" : "end"),
+		   (member_offset >= eb->len ? "start" : "end"),
 		   (unsigned long)ptr, eb->start, member_offset, size);
 }
 
-- 
2.53.0



