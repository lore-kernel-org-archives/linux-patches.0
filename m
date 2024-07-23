Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E06F13C3F5;
	Tue, 23 Jul 2024 18:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759706; cv=none; b=Uvygyzg65el+y8+W9EX0JmFnKSrBCKGbJ10gTa8Ea6j7pyyhlkWJfUdZ/NUdzWB2pSPIzHvWGO30/QDa6r7N/yx8AdIP45T8PezLPBNGHPxiLIZImemRX5P/10k1gMj8hgH4ZQEE+2xU0AEmO8fm0g+pfdHCv+qUkYAvMldqmEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759706; c=relaxed/simple;
	bh=3eZUOTGOJJASQTMKVWJKw3OkHNqOs3iCP/qIejn+bEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCU0wvBUrXezYS11uvoOF5Us8xj3v91ZLFFfKLYXQefJavcZj9043EbDIEy8l67LCqOFBPO1nF1dwD6eUZHKVGSKEXvogaAHPnH4cJkX6BsRW+UQRmJ/NKcaR0U6PsEdgdy1E2BbnjNSLe+zEsZ2I0+Yy/DvMidNri+4zFp6rn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cM2cJ2hh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cM2cJ2hh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2393BC4AF09;
	Tue, 23 Jul 2024 18:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759706;
	bh=3eZUOTGOJJASQTMKVWJKw3OkHNqOs3iCP/qIejn+bEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cM2cJ2hhyEC4T6GuTZTc0khxUDCoCkbMP714jCoGVzgHMRovzUt8nnimho6a4Il/K
	 GQ8cEVUyfl212Fei+207z+PO+QLVF5AOylFVKmRogYyfkgTgzmwoGOS4n43073A0DA
	 lOHdh5qSYnqkEzcwDVi9mHmUUIYwnNRjVE4zSVn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/129] erofs: ensure m_llen is reset to 0 if metadata is invalid
Date: Tue, 23 Jul 2024 20:24:09 +0200
Message-ID: <20240723180408.695154854@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 9b32b063be1001e322c5f6e01f2a649636947851 ]

Sometimes, the on-disk metadata might be invalid due to user
interrupts, storage failures, or other unknown causes.

In that case, z_erofs_map_blocks_iter() may still return a valid
m_llen while other fields remain invalid (e.g., m_plen can be 0).

Due to the return value of z_erofs_scan_folio() in some path will
be ignored on purpose, the following z_erofs_scan_folio() could
then use the invalid value by accident.

Let's reset m_llen to 0 to prevent this.

Link: https://lore.kernel.org/r/20240629185743.2819229-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index e313c936351d5..6bd435a565f61 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -723,6 +723,8 @@ int z_erofs_map_blocks_iter(struct inode *inode, struct erofs_map_blocks *map,
 
 	err = z_erofs_do_map_blocks(inode, map, flags);
 out:
+	if (err)
+		map->m_llen = 0;
 	trace_z_erofs_map_blocks_iter_exit(inode, map, flags, err);
 	return err;
 }
-- 
2.43.0



