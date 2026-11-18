Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036658;
	b=T7g0khZoVxLR8cJEhxqIjEWXeORqdyByPBasLM3WMNIQKBneNamWI3Qz8ywPtDCKOjNK
	 10KfO2yK5Wat1rdjBl7nx+GijhxJqEWTDbNoHhV0/FJ//E01Tq7PcovTfu35N3ZP1Tf0X
	 D2/RgzlPwrjEt5midkd7+bFKnvzVaHqYmAMopgYsVXd4iCDZ/M4po1VRXT3/rwSqcjMtA
	 sStP7YGiWl/SNTTmmAKQE8m2QCDhCvMVu4szhp2HNwuTBvgLujKbNoVDnrIxaaGmZchVS
	 zCfjRQmuTnyxFNid220atS1JSWUvKEp3Jacz1/B3+XBNmjrrN0mP9dCu8tVhdfnB6YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S1NXHMIfuJBBsBasU6wjzLxuwbhmoTjVjVnJlUCO0x8=;
	b=w1zcKHDrfMfb9upPnbUSH6H6dHz0ZwFvhqip9UBOp1W8Cbt5cwKU5VbDIrpMRCb8M/Ua
	 b3UgFHX9gjeS9IJKgkLXrE+/1UB3sjPnZDkzGEClIslbZd3q6xx2AF7fYzanb6rnY1xta
	 77NSJYaKvi7394n+cHVqxCb1QROMr3oRlZo7VDjgqok7HaXxjVOYbeaEzv89AmOFqUw2/
	 Wz+AaJsbjKB1qwE5RrM4hNzOt7y4pXD2E+swfeQPXTAquPyyVN34eeRHescxJrtOlIYkT
	 K2I2jN2tzOMpXKrkH3rXXFgt2Go32CKMREcTs29uqAufKciLoSsqJPBUiZOsqI4tALA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxHi0uTQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FAA606A320;
	Wed, 18 Nov 2026 21:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxHi0uTQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1C11F000C4;
	Wed, 18 Nov 2026 21:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036658;
	bh=S1NXHMIfuJBBsBasU6wjzLxuwbhmoTjVjVnJlUCO0x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxHi0uTQMGMIMHcVtS6YXK4VdQBG7kCYwm3XQG7yLLQhNQ4e6dd0o32REFyyb6feY
	 L8D23i2JVxoVL8ezeMEQH98QC7zOIi2jQOQKBZnxphFapA04muN2AvHFABJcpg5L+m
	 RfdtE07cAcIba5cNwZlOEv0lfuXW2dwPlV0cKiUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1137/3318] dax: fix dax_range_compare_iter() to use correct size and address offset
Date: Wed, 18 Nov 2026 15:29:19 +0100
Message-ID: <20261118150354.163487837@linuxfoundation.org>
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

From: Jianyun Gao <jianyungao89@gmail.com>

[ Upstream commit a4bfbfb4e98a62b589ac7ca9e73e9612bfe8cab7 ]

dax_range_compare_iter() has two bugs in how it calls
dax_iomap_direct_access() and uses the returned addresses:

1. The size argument passed to dax_iomap_direct_access() is
   ALIGN(pos + len, PAGE_SIZE), which is an absolute file offset
   rather than a length. This causes the underlying dax_direct_access()
   to request a massively inflated nr_pages via PHYS_PFN(size).

2. The addresses returned by dax_iomap_direct_access() are page-aligned
   starting addresses, but memcmp() compares from saddr/daddr directly
   without adding the page-in-page offset of pos1/pos2. When pos1/pos2
   are not page-aligned, this compares the wrong data.

Fix the size by computing ALIGN(len + offset_in_page(pos), PAGE_SIZE),
matching the pattern used in dax_iomap_copy_around(). Fix the address
by adding offset_in_page(pos1)/offset_in_page(pos2) to saddr/daddr in
the memcmp() call.

Fixes: 6f7db3894ae2 ("fsdax: dedup file range to use a compare function")
Cc: stable@vger.kernel.org
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20261011064840.1296-1-jianyungao89@gmail.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index e1451efaab140..94d552a2e6097 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2006,6 +2006,7 @@ static loff_t dax_range_compare_iter(struct iomap_iter *it_src,
 	const struct iomap *dmap = &it_dest->iomap;
 	loff_t pos1 = it_src->pos, pos2 = it_dest->pos;
 	void *saddr, *daddr;
+	size_t size1, size2;
 	int id, ret;
 
 	len = min(len, min(smap->length, dmap->length));
@@ -2021,17 +2022,18 @@ static loff_t dax_range_compare_iter(struct iomap_iter *it_src,
 	}
 
 	id = dax_read_lock();
-	ret = dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
-				      &saddr, NULL);
+	size1 = ALIGN(len + offset_in_page(pos1), PAGE_SIZE);
+	ret = dax_iomap_direct_access(smap, pos1, size1, &saddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
-	ret = dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
-				      &daddr, NULL);
+	size2 = ALIGN(len + offset_in_page(pos2), PAGE_SIZE);
+	ret = dax_iomap_direct_access(dmap, pos2, size2, &daddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
-	*same = !memcmp(saddr, daddr, len);
+	*same = !memcmp(saddr + offset_in_page(pos1),
+			daddr + offset_in_page(pos2), len);
 	if (!*same)
 		len = 0;
 	dax_read_unlock(id);
-- 
2.53.0



