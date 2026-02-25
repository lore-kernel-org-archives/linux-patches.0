Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0FE25A655;
	Wed, 25 Feb 2026 01:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983508; cv=none; b=VVyVPhq8djDYDn5Mpw64uR7mc/SQvLLUQ2NJvuffEv+mtLzyJYPDKXEiHqUM3mj98VF1OYV6a2k0hXsChWygHtwARTsciVxr1KjaU+rOzvMlUjuJXhhU7mM1H2nMNHKHP4PJjPDQHoRpuccV7hoP187LEHLqs4jFykA5nqBGPp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983508; c=relaxed/simple;
	bh=gRsRo9cSfuayeqRbBwRiepIgPgUHELEMkAQr0TAr//k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyshFWWKd56QByYg9ckUHkXEIVr0b4105zWc2ZApYnsnKXwlL7KUB8Ja1xBFIgOv1+8CcZ7bRZ7P5hwYUiepZOn4kU6HtZ/G9DDjyo3Uu0hbaqLa1augDo5rJ047DpmbSAC2sYYS0UNHLwh77VBUVuRQTgGmWtvKMADcC6iczT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qE/g3CkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qE/g3CkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132D3C116D0;
	Wed, 25 Feb 2026 01:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983508;
	bh=gRsRo9cSfuayeqRbBwRiepIgPgUHELEMkAQr0TAr//k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qE/g3CkYr0dN0XUYU+SoZucN9pG0RtnX70jdqUKzUUMZFHW/GnjXaFipDzi1czoec
	 L5GG/GoQkBlVAeI6njhTei5A0VdWql14UiPs7TGsUbS5+xwxiuM2y0mBeyuIToZ3ct
	 2CbkzOGwVwVYvGa1yUZiIjzTqFfVu288E9980NR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+08d8956768c96a2c52cf@syzkaller.appspotmail.com,
	Bartlomiej Kubik <kubik.bartlomiej@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 615/781] fs/ntfs3: Initialize new folios before use
Date: Tue, 24 Feb 2026 17:22:04 -0800
Message-ID: <20260225012414.884577790@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2e7b2e566ebe1..732260087066d 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -995,7 +995,7 @@ static int ntfs_get_frame_pages(struct address_space *mapping, pgoff_t index,
 
 		folio = __filemap_get_folio(mapping, index,
 					    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
-					    gfp_mask);
+					    gfp_mask | __GFP_ZERO);
 		if (IS_ERR(folio)) {
 			while (npages--) {
 				folio = page_folio(pages[npages]);
-- 
2.51.0



