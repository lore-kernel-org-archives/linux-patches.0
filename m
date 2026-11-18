Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037690;
	b=e5Bj4COVliJhM9swbzwsI8zbl5lBiSax9/0YrdI3tSo68p4r28x2NOJRqqfAqQ0ZUQwt
	 HrqqiXLnJHBndJ2LHda7Si9Fhw2LylAwrRhHCBlvOG3Pk9m/WBHt2QT2n1I/uziBUgiCZ
	 HoaNuUmSwIBuRISRescdm+8q1C4G7DnHcPZvVHbKT3mtjzfRpeINLbPJB4FbMkSSulwFQ
	 Y+FbgMlcetwSLKAa933kba30ZN8NxWk20S3pUC5tHV7wHekdxMRC+rD7xA+olO0rZSLtN
	 E0Whq3xeA+FRC+k1lrV4EhBCrsHQAc/u2iPiF+UTqyviNWKDynqEjetcJ/ZWhzGyr8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W8dvI2BV/5WfD9h6a7BSyGFWI1haPbda2ceU7YhgNxE=;
	b=c0bhNoXCWcZDsPjCVFfZojAgDPKSGI/Zt+KIqdWOJtMfwsVPotzeB+yD4F78vp62mov2
	 Hg+r+2YOAbWkCS79gdG/PNEk6NOQxO/3XhwQ0+1FuJz8JG/CYxO1fr3hJS3VAUXU1bV5A
	 zZIpZqp+HJaif/0sRCbZa4m+RbK8YdD1Iqeqs1ZSp9jYCqXNIkjJjPDUlbWMbaOO+z4ti
	 iCXFtaZr3r2I75tzLXpruNEXiD28NiJUAFKQW8Of8Ava1/6JqeEXl7fKf8yLb5n0hhnXD
	 pFZWKwD5GL8kADh79HOi1ouiXwuPmz84i10JggqWPQKsLnuh26LV6vkPUfZo+VDQdFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DhADIQGd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BA2606A325;
	Wed, 18 Nov 2026 21:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DhADIQGd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41701F000C4;
	Wed, 18 Nov 2026 21:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037690;
	bh=W8dvI2BV/5WfD9h6a7BSyGFWI1haPbda2ceU7YhgNxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DhADIQGdLeDZwp4YCMqICzpVFVYg+G1V0VQraDLPKKY3Vnm+TvMVmN9JThScIbFLC
	 xEXyFYB1z6CMLdY1A1uT8Zivhyi1WrxMIy3ev94z86JNUvdUwhuA3AQZH4/3oh7R7x
	 ZV1CsVBUGykQG7LWnJh9Xf9i+7Osyn/F4y2FVf+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>,
	Andrew Morton <akpm@linux-foundation.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Pedro Falcato <pfalcato@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1486/3318] fat: hold truncate_lock in fat_write_failed()
Date: Wed, 18 Nov 2026 15:35:08 +0100
Message-ID: <20261118150405.481988858@linuxfoundation.org>
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

From: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>

[ Upstream commit 7b90009546f5d3f3ac9428040cd7ffbdfd60f2eb ]

The current fat_write_failed() implementation calls into
fat_truncate_blocks() without holding truncate_lock.

A failed or short extending write racing with FIBMAP can spuriously make a
FAT filesystem read-only.  FIBMAP bounds its lookup by i_blocks, so it can
walk allocated clusters beyond i_size while fat_write_failed() is removing
them.  If the chain is shortened during the walk, the mapper can report a
bogus "request beyond EOF" error, triggering the default read-only error
policy.  Hold truncate_lock for write around the block cleanup to
serialize it with _fat_bmap().

For comparison, fat_setattr() correctly holds truncate_lock during
truncation:

	down_write(&MSDOS_I(inode)->truncate_lock);
	truncate_setsize(inode, attr->ia_size);
	fat_truncate_blocks(inode, attr->ia_size);
	up_write(&MSDOS_I(inode)->truncate_lock);

Make it so ->truncate_lock is held exclusive while truncating.

Link: https://lore.kernel.org/20261021162105.62525-1-matheus.aalmeida@inf.ufrgs.br
Fixes: 16fab2015099 ("fat: permit to return phy block number by fibmap in fallocated region")
Fixes: 459f6ed3b8c7 ("fat: convert to use the new truncate convention.")
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index cdd39b6020f3d..26d9e39051234 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -216,7 +216,9 @@ static void fat_write_failed(struct address_space *mapping, loff_t to)
 
 	if (to > inode->i_size) {
 		truncate_pagecache(inode, inode->i_size);
+		down_write(&MSDOS_I(inode)->truncate_lock);
 		fat_truncate_blocks(inode, inode->i_size);
+		up_write(&MSDOS_I(inode)->truncate_lock);
 	}
 }
 
-- 
2.53.0



