Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FAD1D042F;
	Wed,  2 Oct 2024 13:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875602; cv=none; b=bRg8AfHs/67OuY8ifd8Z7+pQodPUor6DtShchg5JeIhja6RFMTk/e3SQabT6NwVX0rmnJJRRhGOjOvF4Wfhxi2O2N6jYf9ILVhKa5RIODVaUEpRW6sk1NnVapYMjXY9RDrqLegDB96NxBp3t1mdztkcc+y1Rq7eowhe6OD1e+LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875602; c=relaxed/simple;
	bh=tzapE4RTJYy3n0DzT79KUuxUk2NglmmCvubd+yWdbw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ca+TDCTk018n4ylnas3kjd0vkpWbXtfjsPSnn1P2MOdbCUa0B6vbnoJ4NRAZZinw3cJpbJ9/thy/22HQottlxnF/5bFUAc14vkuFv3cgpi9PV/An0kBDdNbC1ksd6QtJMtv+LJG39Vu9zOFGW2mNkX3W1eF2tpHp9qjvCn39Ick=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3OpBX6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3OpBX6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261CCC4CECD;
	Wed,  2 Oct 2024 13:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875602;
	bh=tzapE4RTJYy3n0DzT79KUuxUk2NglmmCvubd+yWdbw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3OpBX6PRF9ImURauvZ0+DJ21hyp2FLYCHqUo+Q1miVJwX4bUE/kaKTXuyuMvLfyp
	 1us3NrhLDzTPyD3ikmgZifXBzgte4x1MwRKad3HY/fyeKwYOJO0U8ylhkGHFQo8EXH
	 3FimBkfPqad4MPA96JkxfNve9o5Pdhr5Ew6TlWkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liujinbao1 <liujinbao1@xiaomi.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 126/695] erofs: fix error handling in z_erofs_init_decompressor
Date: Wed,  2 Oct 2024 14:52:04 +0200
Message-ID: <20241002125827.506195275@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandeep Dhavale <dhavale@google.com>

[ Upstream commit 3fc3e45fcdeaad4b7660b560fcbc827eb733f58e ]

If we get a failure at the first decompressor init (i = 0),
the clean up while loop could enter infinite loop due to wrong while
check. Check the value of i now to see if we need any clean up at all.

Fixes: 5a7cce827ee9 ("erofs: refine z_erofs_{init,exit}_subsystem()")
Reported-by: liujinbao1 <liujinbao1@xiaomi.com>
Signed-off-by: Sandeep Dhavale <dhavale@google.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20240905060027.2388893-1-dhavale@google.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index c2253b6a54164..eb318c7ddd80e 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -539,7 +539,7 @@ int __init z_erofs_init_decompressor(void)
 	for (i = 0; i < Z_EROFS_COMPRESSION_MAX; ++i) {
 		err = z_erofs_decomp[i] ? z_erofs_decomp[i]->init() : 0;
 		if (err) {
-			while (--i)
+			while (i--)
 				if (z_erofs_decomp[i])
 					z_erofs_decomp[i]->exit();
 			return err;
-- 
2.43.0



