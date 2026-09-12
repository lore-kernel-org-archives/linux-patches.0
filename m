Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EC12737FC;
	Sat, 12 Sep 2026 10:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208298; cv=none; b=bzeCc3nF0/wISa+owiRH0KK9RT1pjkVqHiz35Z7l6W9tghdaN01MVTIg1+p9+9ipOXTX6e3dx2VrnPwJBYVhflfH2a64S3Gq3vL1ozV92tnXbyqC/lyUcKew1pLhlaO87/tuzDj94ixLOE9KnoewFajJMNZp2hhEJK2HHfdEEL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208298; c=relaxed/simple;
	bh=7V5UGDHJIXVQNVan1CgYl9f9SADzpWN2eSFPKrJC0Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1gWE3AMmN5riIrdHVxEINlQFFd9jefEfaO6mAQmq6XHGKJTLacPge0qUSanQqo2Fd704GAmKJWp1KbULc0r0P3GLen0FnD5fUqJv7zsnopOpI20xbWheHAqrXXV6rgn3CM4Q8uU2Bf7vwlcNbytoU65cfACqsi4I2f1vXvEhOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LP9mft4h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LP9mft4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BAD1F000FF;
	Sat, 12 Sep 2026 10:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208296;
	bh=oJGhkRdL+b5xR6fJX432Rr03cT+LULtVj1JeoPaZG+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LP9mft4hb1UOksP7MlFuwuaNi86Gj9drrz46uJ2IWdrL5XisUeVXQA6WkBRHUQtLf
	 rRcaa6cK3DXvOEP61veg+pzKduPIx7Btk1qIzzU3a24gB3BrHNqn7LeeH07QCLfJSl
	 4tTSYN1A8xl1+iXaZCa/rqoxEg0SG60+qcm2wQ9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0588/1518] isofs: release zisofs block pointer buffer head
Date: Sat, 12 Sep 2026 08:45:57 +0200
Message-ID: <20260912065636.729266454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 172faf79a259d..4500b14f802a6 100644
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



