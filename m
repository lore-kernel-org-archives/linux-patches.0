Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065184;
	b=DoMNvBlPLQ/C4jewcIdXNFrkkHY0cspsIiF7ZJLHHDW4yhXTanfkAtLkani4fWoAEsLG
	 KG4k0u87CV2dopty+nDU9SfyJ2CnhRvO4vudgbIno7huwV/7XtxEYYhUyCkU2ruSGZuWC
	 VKS5uwF2sDKa3hNeyVMOSNYFHI5c+m1SkEBoH1scwXMZ8+mAfIayCRFHCZ/U2bdxAPzse
	 auD6Pd045N/2vUuGg6bjYFS0mzty62sL2uSaYDH0nc9FfrnyDLRAiRLaooc3Mczlr0i91
	 EqxYyFCiOLxR8abt+aWNNs3sT3a8t4I2ymM8cIixCS74Z95hHphAJl8j7lh7n/yvo0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GnCjdUnoioTKJmJUBz4+Re9pousG7lKn3GzE3jd++u4=;
	b=S/BexmTcvH4gu2Jeg7gQ+bHA88QIiSIEBvMDbrbhHrrRFWdiSwaPF6ONZZzgei1PDQyn
	 qDAkmX5XvpMH5tg6e/VhGfUDhaT5GlbZTdI9ZZdB5i2UpXH08SFNo5YIkEk8VidgPtIPo
	 hozOcNluuEu6g03xskBUot0KLlg7ca0qecptgwtjpAQxEC2fVvZf6bI6IV42AU1OIobmj
	 UcGCQhA7nMa0pWneRZQjjL1c1tVwLfqF1e1X/aIWwaWLxRU4WQ+EnHW5wmVLj/bUG6AV/
	 Y2GXevKoXXhrR3whWrPELxU/zlt+eGywf0ksE20HdmO+NVlcA9Hxc3Pq4c+JRCxBkAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0r7bn7na;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED8A606A33A;
	Sat,  7 Nov 2026 15:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0r7bn7na
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FFA1F0089F;
	Sat,  7 Nov 2026 15:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065184;
	bh=GnCjdUnoioTKJmJUBz4+Re9pousG7lKn3GzE3jd++u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0r7bn7nalFffjT2pnUOKH8h92hR6nQJhPq2SomMK06tT/aepkDhue88vfkxb+GeF5
	 3/ZFcTu6r2idxmqGor+PUV6CkYldvUt/butZjZMgN0eqF5dKIrKzhdcXvtaug9vxyn
	 ZzZYqsAHmsYa7ZDBoCg/GwNRuFcmQDbfFlSDCgZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0988/1257] exfat: zero invalid tail on partial overwrites
Date: Sat,  7 Nov 2026 08:54:44 -0500
Message-ID: <20261107135006.653279281@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 748ad4ba13cd14163ed7262c6ac304c380804167 ]

Buffered overwrite that ends before valid_size in the same filesystem
block reads the entire block without IOMAP_F_ZERO_TAIL. If an existing
cluster contains stale bytes beyond valid_size, the synchronous read
loads them into the page cache and marks the block uptodate. Subsequent
buffered reads can return these bytes while i_size exceeds valid_size.

For example, with 512-byte blocks, valid_size of 1000 and i_size of 2048,
a cold-cache overwrite of [900, 950) exposes stale data in [1000, 1024).
Setting ZERO_TAIL for this write would also erase valid data in
[950, 1000).

Use iomap_truncate_page() to zero only the invalid tail at valid_size
before preparing such buffered overwrites. Call it after dropping s_lock
and before iomap locks the write folio. The inode lock held by buffered
writes serializes valid_size against truncation and page_mkwrite.

Skip direct I/O, fault mappings and new allocations. Writes that reach
valid_size continue to use IOMAP_F_ZERO_TAIL.

Fixes: 82a81a7352bc ("exfat: add iomap buffered I/O support")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/iomap.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index faa9b116e5528..bcb7a9214f92b 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -149,7 +149,27 @@ static int exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 static int exfat_write_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
 {
-	return __exfat_iomap_begin(inode, offset, length, flags, iomap, true);
+	struct exfat_inode_info *ei = EXFAT_I(inode);
+	loff_t valid_size = exfat_get_valid_size(ei);
+	loff_t end;
+	int err;
+
+	err = __exfat_iomap_begin(inode, offset, length, flags, iomap, true);
+	if (err || flags & (IOMAP_DIRECT | IOMAP_FAULT) ||
+	    iomap->flags & IOMAP_F_NEW)
+		return err;
+
+	end = iomap->offset + iomap->length;
+	if (end >= valid_size ||
+	    round_up(end, i_blocksize(inode)) <= valid_size)
+		return 0;
+
+	/*
+	 * Zero the invalid bytes from valid_size to the end of the block
+	 * to prevent stale data from being exposed through the page cache.
+	 */
+	return iomap_truncate_page(inode, valid_size, NULL, &exfat_iomap_ops,
+				   NULL, NULL);
 }
 
 static DEFINE_IOMAP_ITER_NEXT(exfat_iomap_next, exfat_iomap_begin);
-- 
2.53.0



