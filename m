Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657F2377ABA;
	Sat, 12 Sep 2026 18:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239140; cv=none; b=MTuno4T7TnmSDayf4kF7l/y2ulM8lZ4piEg9/z1R7A9sU9Yk0bL/S5rLF9JEBl5Q+fqBWcq+y4B4cPHPHMmXqcF/K+LSH8Pv0q3HBnZ05wGzJuck8t4YGEYtl7ZcbSinMbRSeZEhV6GGri59MafKMLNdPcB/PViWi2b9nnE0Ge8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239140; c=relaxed/simple;
	bh=zNjBBaY+R+hjGc5Nm4OObMmm0Gz8uwm9fOqrHiwNaSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTd1BDkIhUs4GvZDU/1Hhzkbf5zDVggNvFemgdpF3+4HWh6e8ttevaCGNCf/mC4U6nRJGQs/zPYnpAE3MDwEmPTtRXsZyQGA4+x9bZ3IPmwXkdJw3q/suQpz3SwgIO+qA9ZHRtKTDL8VrsJF1wBE8UEzCgaNMeS+9fFoyDprqvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBC3vnTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBC3vnTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0053F1F000FF;
	Sat, 12 Sep 2026 18:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239139;
	bh=uMaSezxJg83mFs7De6sV9JU99fuOMyj/lGvPk+FayBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xBC3vnTJqlA2vK/DxqMIehSXtXGKnBU4UZ9AsS/FCfs8LN+vaZUb1sViXKFgfO9cs
	 8r9mPKCdiF9F0d9Nt36J0TUUHyuXAqO2Wdpuu+lRfc2ZXdyndQvJvHJox4DnA1Mkcz
	 1PNMCaiaa+WKHG8qwaThZF4VZNlQDf0VD0nsXMRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 604/935] isofs: release zisofs block pointer buffer head
Date: Sat, 12 Sep 2026 09:00:34 +0200
Message-ID: <20260912065540.693600086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b81415e73aaf4..f81f121283056 100644
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



