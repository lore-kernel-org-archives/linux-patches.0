Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054054;
	b=aCItivpNMamMXpF0OoGwFch69vKdJY1Y/2zMVnriXZ75n4arbCRikUTmPioXXBwIUS1m
	 Erl2xT+lGuJTm0YkQeCFH/vibdA5cOdX0OnF6NSAY8Vbysb6+j7bZICx748WBO0VZhQM8
	 mwC05niGA0PBR4xdSXNqo1oUGHYBMau8VIemVYSYUHFNOGyAewuWgP21did08UK/J8gd+
	 FsG1x/UB/7G9EV3C/E0SpVAHkKyB2PZPwF9O6B8Hs+tH/qRjfv6T+mP/8xWIyypzOUH8b
	 YTX781kurdQwx5LTYraIFTy65fTseZwUH60Kn5wCZwOQtGlNlMZOkuPk/JKYT/C5L/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fwaHPRYWwwnCjeYaZ3joieRS7lHfq1/Ok2/jwN3CHW4=;
	b=qlAGwK26z1/ZZGZcfwFE5hKL9duA54r+CIExbgIWccNIN/plPv38EFKecrI8FGaoWHHp
	 2dmIzL9A1vzZfsUEvBUbdzT9PUlonRTKLrgwBkdYeKVOBZkCxSlXcuTUec/qagleu81L2
	 1A1ItlMEcIgY51oD+YppWKJMnfuTZUjC9B7c7e6Y0XDhHe24MHYhWFbMOBuWfqPmYVcEU
	 FAgA9ekitMn3AxT3ODai2gQCpiRQMhQ+djROuxKktkWBtBH8boXY/31mYXdpST01AM1yN
	 yubD85RjQ4KQx8SxFUJjzDcpSB/U0cTDHGepl5g5qUosyuP2zmsHrZomhmD7C8pq13g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WDvZJBgy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786B8606A31C;
	Thu, 19 Nov 2026 02:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WDvZJBgy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB751F000C4;
	Thu, 19 Nov 2026 02:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054054;
	bh=fwaHPRYWwwnCjeYaZ3joieRS7lHfq1/Ok2/jwN3CHW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDvZJBgyaNmwwEfiP+ozmqYZ6HrHApu9BBZJ50sW5nfYN9khIpvWKLJiZc+T6x7Sd
	 axCsyoKN1e8UpJi+7RSQm75dCDapfEETUb+1mdB7GSzT6S47IKLyv2mWld2Yjr9G1y
	 Hr8wh7bMcc4dfIXZWOr0TmTTbGos+GaRtxWPPV2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1138/2214] f2fs: fix to adjust appropirate defragment pg_end
Date: Wed, 18 Nov 2026 15:46:54 +0100
Message-ID: <20261118150057.559520831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 197080156f27b6bf8cf198e9313dfbb94769c736 ]

A length that exceeds the real size of the inode may be
specified from user, although these out-of-range areas
are not mapped, but they still need to be check in
while loop, which is unnecessary.

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 92154fe28c37 ("f2fs: fix defragment writeback range truncation on 32-bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index dd4eab6367a66..5cf96cac8aabd 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2610,12 +2610,13 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 	bool fragmented = false;
 	int err;
 
-	pg_start = range->start >> PAGE_SHIFT;
-	pg_end = (range->start + range->len) >> PAGE_SHIFT;
-
 	f2fs_balance_fs(sbi, true);
 
 	inode_lock(inode);
+	pg_start = range->start >> PAGE_SHIFT;
+	pg_end = min_t(pgoff_t,
+				(range->start + range->len) >> PAGE_SHIFT,
+				DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
 
 	/* if in-place-update policy is enabled, don't waste time here */
 	set_inode_flag(inode, FI_OPU_WRITE);
@@ -2625,8 +2626,9 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 	}
 
 	/* writeback all dirty pages in the range */
-	err = filemap_write_and_wait_range(inode->i_mapping, range->start,
-						range->start + range->len - 1);
+	err = filemap_write_and_wait_range(inode->i_mapping,
+						pg_start << PAGE_SHIFT,
+						(pg_end << PAGE_SHIFT) - 1);
 	if (err)
 		goto out;
 
-- 
2.53.0



