Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728491C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C810AC433C1;
	Wed, 23 Nov 2022 09:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196750;
	bh=m7H/1F7srcbf/Xd5NOKYCw65oBVqXXthpE4VklhKM08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ni38keb83C/kHgI9V+XoeYVnznrgZ49CXWFFeouTb1xrThwCObpREkWMzQzMD75Jr
	 S58cuHk0sdvcyNX66G6IsK50CHFI+YnY74sADUrAH1+hg5zJrwdUoXor/GPRmWxEmx
	 zrd2jKxlP/Rd6j6xTjim6vlrAEJhclELMmef4wQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 114/314] erofs: get correct count for unmapped range in fscache mode
Date: Wed, 23 Nov 2022 09:49:19 +0100
Message-Id: <20221123084630.675780082@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit e6d9f9ba111b56154f1b1120252aff269cebd49c ]

For unmapped range, the returned map.m_llen is zero, and thus the
calculated count is unexpected zero.

Prior to the refactoring introduced by commit 1ae9470c3e14 ("erofs:
clean up .read_folio() and .readahead() in fscache mode"), only the
readahead routine suffers from this. With the refactoring of making
.read_folio() and .readahead() calling one common routine, both
read_folio and readahead have this issue now.

Fix this by calculating count separately in unmapped condition.

Fixes: c665b394b9e8 ("erofs: implement fscache-based data readahead")
Fixes: 1ae9470c3e14 ("erofs: clean up .read_folio() and .readahead() in fscache mode")
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20221104054028.52208-3-jefflexu@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/fscache.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index 508b1a4df15e..8585e324298c 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -288,15 +288,16 @@ static int erofs_fscache_data_read(struct address_space *mapping,
 		return PAGE_SIZE;
 	}
 
-	count = min_t(size_t, map.m_llen - (pos - map.m_la), len);
-	DBG_BUGON(!count || count % PAGE_SIZE);
-
 	if (!(map.m_flags & EROFS_MAP_MAPPED)) {
+		count = len;
 		iov_iter_xarray(&iter, READ, &mapping->i_pages, pos, count);
 		iov_iter_zero(count, &iter);
 		return count;
 	}
 
+	count = min_t(size_t, map.m_llen - (pos - map.m_la), len);
+	DBG_BUGON(!count || count % PAGE_SIZE);
+
 	mdev = (struct erofs_map_dev) {
 		.m_deviceid = map.m_deviceid,
 		.m_pa = map.m_pa,
-- 
2.35.1



