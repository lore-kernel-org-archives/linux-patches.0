Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5FE1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3453AC433C8;
	Tue, 25 Jul 2023 11:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284472;
	bh=Ck/zJOViymiPxN5VJ0XHsqGeWhDBIHHAoFOcTkzvVfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaQXPV4k/Hg0JzPODrGwwynGkPw2hbPdn6WRJjtUnAFDplBe+/izZ8eYE0RtS7TGl
	 XZwp5lwFVbZu1Nsltjjsa5ripmwITMuk/3K2LK1k4GVbiKX1CgAJprjOLKtQ+zz8D0
	 cQjsin8Hp3rdAcAnM1ydkDn66aMb4aAx7WYDtU9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunhai Guo <guochunhai@vivo.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 368/509] erofs: avoid infinite loop in z_erofs_do_read_page() when reading beyond EOF
Date: Tue, 25 Jul 2023 12:45:07 +0200
Message-ID: <20230725104610.561899646@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chunhai Guo <guochunhai@vivo.com>

[ Upstream commit 8191213a5835b0317c5e4d0d337ae1ae00c75253 ]

z_erofs_do_read_page() may loop infinitely due to the inappropriate
truncation in the below statement. Since the offset is 64 bits and min_t()
truncates the result to 32 bits. The solution is to replace unsigned int
with a 64-bit type, such as erofs_off_t.
    cur = end - min_t(unsigned int, offset + end - map->m_la, end);

    - For example:
        - offset = 0x400160000
        - end = 0x370
        - map->m_la = 0x160370
        - offset + end - map->m_la = 0x400000000
        - offset + end - map->m_la = 0x00000000 (truncated as unsigned int)
    - Expected result:
        - cur = 0
    - Actual result:
        - cur = 0x370

Signed-off-by: Chunhai Guo <guochunhai@vivo.com>
Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20230710093410.44071-1-guochunhai@vivo.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 8cb2cf612e49b..9cff927382599 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -629,7 +629,7 @@ static int z_erofs_do_read_page(struct z_erofs_decompress_frontend *fe,
 	tight &= (clt->mode >= COLLECT_PRIMARY_HOOKED &&
 		  clt->mode != COLLECT_PRIMARY_FOLLOWED_NOINPLACE);
 
-	cur = end - min_t(unsigned int, offset + end - map->m_la, end);
+	cur = end - min_t(erofs_off_t, offset + end - map->m_la, end);
 	if (!(map->m_flags & EROFS_MAP_MAPPED)) {
 		zero_user_segment(page, cur, end);
 		goto next_part;
-- 
2.39.2



