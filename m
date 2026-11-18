Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054317;
	b=o0WKA69ohBTxDw+Ftkch8ruYmS4fijMRTMZEebsnOmSNPtjSxsgyH3eHEflQuVnBJPlI
	 Z5+f/0hS72wqW4fp8bvRZTuwR6BaQEGCJcSgzMk/b/+QbgtmU0+Scg9RWv1IgwRjfp9yv
	 3u63hUEZ/z+J/mMngubAnfjXgk4fAfM07c9vbixkS2JroQ9wr8q+k7BP6aM3C31B6j6xs
	 xF5AkRkfZ07wEerT4+x3WwtA17yPZ2FWAAHPl4+mwaVV8V9n4z4Uod5wueixfGsZnkvNv
	 ZYRLYNjeMk3RaiVXo89ZObTOn4ukejCYPNrdCEaMjdIJ+PEcu2raC44KGma9M3tXyHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xOxDOsBFC5r0a+t+SdNwlYpmS+hJa3+pf064s8o3s/w=;
	b=uHisJMU2bDbO7nwI6VZ3Rjo3sCUBUpkEzyldRrqlJtsZjz+SODs2gNVsU9L1NHyR2e/p
	 MfmYghkWcAif7vfHnXn39MuZcfS3s/bVBtOa2PVCfn4h4aK+E1AAT/GTRwOgOAPh1JRLY
	 h19TezyxYPZ+x/OEtJLa23xLzfwUr+2nE0pOr+ifvveONejr8kWr+NL2wh/tDT2KZ0T+T
	 7ya2/vl7e46yqwqBYg0q+DmZfUsZfuZzhc7VjSSQSuvHDFSriaO1hauwJBS1eDZJd1US/
	 A6SwU79NVvat0HW+hGV4WqXYzXA3JLCBxKJmPuWjE5lgSRsDdHGrs8sEKHQyKXRVfjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A4fpLknJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2C1606A31C;
	Thu, 19 Nov 2026 02:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A4fpLknJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21D21F000C4;
	Thu, 19 Nov 2026 02:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054317;
	bh=xOxDOsBFC5r0a+t+SdNwlYpmS+hJa3+pf064s8o3s/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4fpLknJYqgQoo+7/VTQXwPYF3YVBGTO8KtQucmE7JkkWu8I+wgt6rk5jSaESUm4N
	 jyrjfIk/fbJoZQwpW0Vuy46yYbZRNq0fGcxq759PdvnzPtHT1HNVyy+rdlfMxjAF85
	 CAyHew12bgCtVKkSyIpWcm3QO3PceiFda4kgmqH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1231/2214] f2fs: fix to update superblock crc in sanity_check_area_boundary()
Date: Wed, 18 Nov 2026 15:48:27 +0100
Message-ID: <20261118150100.996012788@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit f8f956c7ec8c0285d7a80bed497d2f7adcbded15 ]

This patch fixes the bug reported by Sashiko:

We should update superblock crc along w/ raw_super->segment_count in
sanity_check_area_boundary() if sb_checksum feature is enabled.

Cc: stable@kernel.org
Fixes: d440c52d3151 ("f2fs: support superblock checksum")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: Added sbi as the first argument to f2fs_crc32() to match the three-argument API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index a2dcee4e675f9..b6b9999f8d879 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3268,6 +3268,12 @@ static inline bool sanity_check_area_boundary(struct f2fs_sb_info *sbi,
 		/* fix in-memory information all the time */
 		raw_super->segment_count = cpu_to_le32((main_end_blkaddr -
 				segment0_blkaddr) >> log_blocks_per_seg);
+		if (__F2FS_HAS_FEATURE(raw_super, F2FS_FEATURE_SB_CHKSUM)) {
+			__u32 crc = f2fs_crc32(sbi, raw_super,
+					offsetof(struct f2fs_super_block, crc));
+
+			raw_super->crc = cpu_to_le32(crc);
+		}
 
 		if (f2fs_readonly(sb) || bdev_read_only(sb->s_bdev)) {
 			set_sbi_flag(sbi, SBI_NEED_SB_WRITE);
-- 
2.53.0



