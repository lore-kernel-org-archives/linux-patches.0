Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053A42D839C;
	Wed, 25 Feb 2026 06:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002702; cv=none; b=Tzca45eiFQg0uNYa612SJXlRVxX5v7fRe0XRVFS7gXRjIXrxXqLQ6siLPEH5fnn+udL27mdgaoY+ECsgtQnN+KLGaTh7ucNL0t9lu6AECeiUYLUehuLsoWYb23GN+tFd2J4aYImYX7omTTb4OVNfvOXxj83cvniTLQ2dohxhHcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002702; c=relaxed/simple;
	bh=Rwyh0LBwFipqy9QBLnRW5Qgbqnkos2I0F5MnculfuKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBqcKZa+JOU2xmxqMBxaUm0jM6ljlWdmEDc2hD34b4Ij/ahVQ0TAX28yksoWzkBm0j3ijbJ2nFYoaRCpg+zlUw2BipiVAxUSG/pR0f1fAUj5jch58cP1VNYqQzn03tia9OFRckU4vr2QVUOH7iic1KOydlpQmP3JPZ9txtFHzZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCKRD9Wg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCKRD9Wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DA3C19422;
	Wed, 25 Feb 2026 06:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002701;
	bh=Rwyh0LBwFipqy9QBLnRW5Qgbqnkos2I0F5MnculfuKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCKRD9WgiDXdzZJFrLnfoechKZPn6uYjkfUpZc+TfuT8k4R7yj4aXMwDcm0/BLg+G
	 afMHTnTmjmVE96rEyYDsMp7NUv+xqZ7H/bgGYCXxctBhP8H/fMw88RB6Ktsy7slUhF
	 Y9wNg5sye3tcO3Uj3gFp3hzXkBuyloaSyeSVCsRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+08d8956768c96a2c52cf@syzkaller.appspotmail.com,
	Bartlomiej Kubik <kubik.bartlomiej@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 500/641] fs/ntfs3: Initialize new folios before use
Date: Tue, 24 Feb 2026 17:23:46 -0800
Message-ID: <20260225012400.636829989@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>

[ Upstream commit f223ebffa185cc8da934333c5a31ff2d4f992dc9 ]

KMSAN reports an uninitialized value in longest_match_std(), invoked
from ntfs_compress_write(). When new folios are allocated without being
marked uptodate and ni_read_frame() is skipped because the caller expects
the frame to be completely overwritten, some reserved folios may remain
only partially filled, leaving the rest memory uninitialized.

Fixes: 584f60ba22f7 ("ntfs3: Convert ntfs_get_frame_pages() to use a folio")
Tested-by: syzbot+08d8956768c96a2c52cf@syzkaller.appspotmail.com
Reported-by: syzbot+08d8956768c96a2c52cf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=08d8956768c96a2c52cf

Signed-off-by: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 83f0072f0896c..3e61eaf28e088 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -930,7 +930,7 @@ static int ntfs_get_frame_pages(struct address_space *mapping, pgoff_t index,
 
 		folio = __filemap_get_folio(mapping, index,
 					    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
-					    gfp_mask);
+					    gfp_mask | __GFP_ZERO);
 		if (IS_ERR(folio)) {
 			while (npages--) {
 				folio = page_folio(pages[npages]);
-- 
2.51.0



