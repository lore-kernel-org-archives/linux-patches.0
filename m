Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047419;
	b=KFyb5rkhoMyzjP8hX/56ew7GobGeICQyG3El870Ta9KFLIkwOEYmDNoV0ha64tUntQ5g
	 N+5zOTMv0WyQQZwo1kGJYNS0jlNX4t/N8NdlmM8CYWo2U3Hj2m25zb5J/LvN1Q55VWO5Z
	 cMN6t1U/9dp7lrU5rHk/fCRmvLXyRTVTVnWETPbNajjHCGAg3FQ3R+ZJiMBi4Epw8QVo3
	 aLNjnzpNLWYq8hwjAHB/hMVuvLlr6Xc9SQENqBefVfDTYPuuZoLG0aD3y3P08hcR9gDhc
	 eNtpaeozzOYM4vUFhx842zLGHpFumUGBLFi4Cbl3CRNt7hMbkVFmBwJt8cXwWC+eOig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=reC2HlhTftSlEoQWnl5NoUIKNaXOnRYM+z9lh+c8qB8=;
	b=4KbbaOWvCCsTD6awmotZNWER9fuwB+QTHpoHjOKy/x6Kocs+iVO0hZVBw3/EwZpwE1dz
	 0Qhthh5VwyE8FNXj+gm0BKQ2TfDNl7NGYT/ahMlWqJzqyQ+aMD4jVaZpeZbRLuhfflAJV
	 mE5Pw806LtDf48juz4iZ1FC7wn1YEf4XnUxlMiCeIrw41Imrwu+fGTm8BcFDW8D/Z4Ci3
	 cPk8aXfZUzsNTyRJHyi5fVGV6GqBSbguJ4COf6GZxACygYEU6a9Rv2YVxYXDi+OMW40lx
	 iZ8EThQyqzGG+czkbpBid7AJXfTze2dALhQI0/sZFurli0E70yeGd3akBkf7deGhTSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yG452B15;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5D1606A325;
	Thu, 19 Nov 2026 00:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yG452B15
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A481F000C4;
	Thu, 19 Nov 2026 00:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047419;
	bh=reC2HlhTftSlEoQWnl5NoUIKNaXOnRYM+z9lh+c8qB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yG452B15Bd61xGRCQkXsVBDDSQg5Cd2L12c+jdycBeYKaUAV9sdZkKyUxU+HPOtdc
	 yGHbtHUb1URGOFwH1LOu0hbo/otaIjLcwuxNxbsw4GNbtKr/cNY8XqEbdFiBdyPxAt
	 lblllVJK+eMz0Do0uMJn7hViQhU36QExsuqcCjno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1631/2857] f2fs: fix to fetch ino via ino_of_node() under cache lock
Date: Wed, 18 Nov 2026 15:44:25 +0100
Message-ID: <20261118150300.064996957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit cd6d8b1891395b681f2060916a4b83880b765698 ]

In f2fs_writeback_node_caches(), it's better to fetch ino via ino_of_node()
under cache lock, otherwise, node cache content may become stale after cache
is unlocked due to racing w/ truncation.

Commit 493b9dc8b52c ("f2fs: cache: use node cache") fixes similar issue in
f2fs_flush_inline_data() introduced in commit 34c061ad85a2 ("f2fs: Avoid double
lock for cp_rwsem during checkpoint").

Cc: stable@kernel.org
Fixes: 2049d4fcb057 ("f2fs: avoid multiple node page writes due to inline_data")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: adapted cache entry handling to page-based APIs in f2fs_sync_node_pages() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 4ef20021d4dc6..91bd42baff407 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2073,9 +2073,11 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 
 			/* flush inline_data */
 			if (page_private_inline(page)) {
+				nid_t ino = ino_of_node(page);
+
 				clear_page_private_inline(page);
 				unlock_page(page);
-				flush_inline_data(sbi, ino_of_node(page));
+				flush_inline_data(sbi, ino);
 				goto lock_node;
 			}
 
-- 
2.53.0



