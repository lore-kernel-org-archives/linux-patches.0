Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B1F38F620;
	Sat, 12 Sep 2026 19:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242783; cv=none; b=SkNQx8dEu752zFB+UaYxMpi136TIY8arXg0E1xqPJDW6m3JS+vwTJ9WeYYfOvX6B0aRqUUHNNNlTYmLV8r67OQ/Jvz9IvxkmqorLhkWBiYiEZ1L1jDxOfEkAA6VRaapoSFgvR/qX7DKdSJBw/9g916wnUNs6FVurwHQy6l2etCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242783; c=relaxed/simple;
	bh=tOSIYr42a7GXKjS6o8gcUkapjgKjHdUf4Dbo2i9GXrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+9/ljFx/N812lFa2m1yQgQWcoczXiT7X5QzrhTIfpgjfjb3a+4iCDjNiuoafNUHJaeFiCOr1xPQLB+ZMgJM7KaRFpkuBHpDy9fc2oGZNxRapjzXcYENwwYDl2RJBKyAwzzGnesdjPiiq1pNVlwmj8lVsBgz4f1VKU1zDGv0mMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmOrdI3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmOrdI3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8681F00893;
	Sat, 12 Sep 2026 19:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242782;
	bh=5wb3cIj7uj1ULOIf5sbvH+Rw5vvPWfTkWI1/yAqB9cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TmOrdI3ThS1QElh4sKKDoO65NcVPJ7K0bt6/X823/0swRzLbbKOuCZM3cuda1vQCr
	 pT1x3/EbdWyHHtp7ZGmv2EDwjHYdUJU2sYKyILofFP9wSblwnhaFuO4pHBtN7USSAH
	 OaynfIUT//W9vbYetwnrgmsXBzMQEBqJtVPn3ukk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 518/798] isofs: release zisofs block pointer buffer head
Date: Sat, 12 Sep 2026 09:02:26 +0200
Message-ID: <20260912065529.006955851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 2f7dd9b86fe4076059e6a4a2a2c5d565afd76b9e ]

zisofs_fill_pages() reads the compressed block pointer table.  The error
paths release the current buffer_head, the loop also releases the old
buffer_head when it advances. However, the success path leaves the last
buffer_head referenced. Release it before returning success.

Fixes: 59bc055211b8 ("zisofs: Implement reading of compressed files when PAGE_CACHE_SIZE > compress block size")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Link: https://patch.msgid.link/20260721091152.1450622-1-chenyichong@uniontech.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/compress.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
index bc12ac7e23127..710368536cdf4 100644
--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -288,6 +288,7 @@ static int zisofs_fill_pages(struct inode *inode, int full_page, int pcount,
 		flush_dcache_page(*pages);
 		SetPageUptodate(*pages);
 	}
+	brelse(bh);
 	return 0;
 }
 
-- 
2.53.0



