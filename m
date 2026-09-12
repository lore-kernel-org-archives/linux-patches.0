Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C5B4BEE5C;
	Sat, 12 Sep 2026 14:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223939; cv=none; b=aGYVhimcMPqi8BuxskDmJ+W6F6KpHiuEbOUl1M+r7KClveYZ06pIRYw4ecq8ZYtriJ/lxVAucJFhJXXOT5a8o5vkWS67FbusTnk/1wPIHvATyar7Zry7TQwc1mUDuHnhfA3uBVU6Psvl+vGsth7ypfWqxxd7uhvP+faXSMEjOqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223939; c=relaxed/simple;
	bh=i4bDAVkrHOJnidl3znayTpwcReCCaHsV/tzKg7wu8rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpZwX6FpB1IkY7J7MP7lZwumr12fBeeY/l8m8SuWqFbLfAWRtF/TaguBOOsP6L/5bW4SFq9Z78+X84swomF98LyxZpYXPadfkKFqd4r7OP/0vWQfAwyCrWxB68YzECBMh3eaX0OLF8lgw4YN9XjinnX5+azWCMkqynBHWUlSIzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeYjdghr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeYjdghr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06C11F000FF;
	Sat, 12 Sep 2026 14:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223937;
	bh=pFfuQkTSPg+ASt7Oivf3m6I8M0FE9mqHmOxWVJcIb9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SeYjdghrMT6p66yBddR1HYNNcyl92zXhYz2wkU+nRx7yTra8Qp7gzPeEL7QznF6QD
	 7qH5uxQJbWTv+JAT1uhG+GrE0BGTbr+Fw8juXhx9aA+qbnU7bZrwp3SILEZPwteDAe
	 Ui9yldktGHBsQuq87beJuJ+ru1fiNZOfkhpoM8ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0890/1424] isofs: release zisofs block pointer buffer head
Date: Sat, 12 Sep 2026 08:55:22 +0200
Message-ID: <20260912065627.259947545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b94b56211b5ce..fa3daeebad194 100644
--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -293,6 +293,7 @@ static int zisofs_fill_pages(struct inode *inode, int full_page, int pcount,
 		memzero_page(*pages, poffset, PAGE_SIZE - poffset);
 		SetPageUptodate(*pages);
 	}
+	brelse(bh);
 	return 0;
 }
 
-- 
2.53.0



