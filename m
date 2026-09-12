Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20C429992B;
	Sat, 12 Sep 2026 16:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230115; cv=none; b=swCRRK8rR28FCkazV8W94u+L9kcSzpi9FVnb3WLd83sNaSvpcuQvNcnxVqwHe/Fz/clX8mhKR+2W7kHV2YzKXwbfChVDgeWv6LJTx0PsXElvuVS15v21GmmSf06sdIqPUEd/sjrHkAZQLhLZjIagJHevkBp5EOc3R3lZNV1vG+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230115; c=relaxed/simple;
	bh=DZWwVffeDut/BH0NAa+eBPaB4O6LmOwAvy+FR9ohJ64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvxBnFJfzCzPF1zjD4hJfnIrJkeHRIY56HDFAhFW8VnuKWBT6pnS0a/Zgqkken22IjIPvsumfR3KLmRwnIyf7Tp4Oh7pWcBTBng5SrYdi11OUlBOcIj0PwNIJDZ0eUfciVkOXt2b61YEp4cUrq5lvtA1KELjKDmgvGjfCaNNfyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5WOR4Ck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5WOR4Ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538AD1F000FF;
	Sat, 12 Sep 2026 16:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230114;
	bh=tN1eMaCErz7PNCFSeV4YzMgb31J4q2WZpk/gfBIPSgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5WOR4CkN4TulmllTj4wm4BDSGbyWW1/Hz0O9PPWEPhT9kuUoO0lOgGcxXN5EgwFw
	 DsKv6lohLSwZ4rWH0xfVHiiviXgJcuJ3sAtMbp9wRp9XOiEqMf7UaCheakHyrlLDvz
	 l3u1HQMQcoFoac5zbx7RHzt1yEyTH195+H1wPE1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0727/1191] isofs: release zisofs block pointer buffer head
Date: Sat, 12 Sep 2026 08:57:35 +0200
Message-ID: <20260912065604.608225908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



