Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590261;
	b=nNinNBfGiU4KftVlRuODR99ErVosDBxyXa2ejhE6o7RbaTjRAE5tnmDwb1cJbbuEhh3q
	 6kMU5W/f5Blp5gJmGgFp/LihYP+XFLo5g6iCLXBpl/xNFSzuoJy4svNzrMVRZDX54myhN
	 iJnAPuCORBBOO9aaYhsBc7QBdquFtRA0Rsi6wP2jId552aun04UaCdrsmBzcNYJGiiY7O
	 9RH+WUBZ65Y/I3ncGy8gx7ngml+TZWFSetMhtViuXrcyK6+fLXH2kl0xV2m06vADPSmC5
	 r1RkIYVpHLQbuy49DN/lP9NdwPMFo+HQarW8athpRksfBK/ABUkQr2DmXNYtwaijLKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V9Xbleuq82hD8fUGko8C4lwk3NcXKyfTfVBM7d9RHc0=;
	b=1Q11t1Te1aZaPTujjgnQm+3TgAw1fvJDd7EZihwJFJOT0tgB+gAo6Xo76wYPYkm/+rFv
	 sm04LTvHKtot4NXrYxOqR9jwnv3FElrDIss5Edbt8n6+NZriUNnR2PC7QKENTjEplA9ae
	 jqXXR+zbCwudDGEFCAi7lvGR3cFuhekl1EDC+NGdZHjac7lrsTStnE+zgqSktnWg8YKR0
	 AhknleWi/rpNwPyfIABgD+Jrh2JAXaehuMzvP9OAqkJltgW43jDCXXLuvWXBG57kk1+Ll
	 tnp3v8FTLX6PwaK2DXqmt6DmfO3VQoliOBMrb7Ku4aoD2Y0R3rDbBnnwbSjghiKGbmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=og45YtNO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC68360A380C;
	Fri, 13 Nov 2026 17:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=og45YtNO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786EA1F000C4;
	Fri, 13 Nov 2026 17:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590261;
	bh=V9Xbleuq82hD8fUGko8C4lwk3NcXKyfTfVBM7d9RHc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=og45YtNORAzB/Ru/iYlZB4B7K2Rd7V3mIK3Io1Y8aAUz8EbG7m16BIBrCSkfxKKHs
	 PtKz/Uqo7aVkKMMcmDQIHxwQKhre5DW6YoGcXioBrMV6Zic+uQaKMDSPzHi/qkh8pR
	 nJqzpb8T0K0ORQTKI94qfyqTlGxiFGfQG3AGD30E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 255/686] mm/shmem: fix truncation of files containing only swapin-error markers
Date: Fri, 13 Nov 2026 10:46:28 -0500
Message-ID: <20261113153829.674080341@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 169ba30664782..da043ca0c2e22 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1351,7 +1351,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
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



