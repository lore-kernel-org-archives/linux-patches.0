Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038932;
	b=JLFVUudaf3U3ImztzJ7pxMKGRmBy87Gl8czRmRr1+b1Sex022EZjJFBLEqwD6H2elztL
	 h5ykcSTNMXX6fLtnbYeq7QrO47gwqf0gsN+BVm8YGk4qnYODQH8unEwrHZp4ctseuDba2
	 PfIYt4AQGebYxNtK+PfgoPUmVp49eibMC1/N8AHY5p0gQr5HmR6HdRtPNKuVtOzAgvjlU
	 U6xWjaMgP8mbCgPUtVBdiGwneM/dExjD3MucVCh/SvXsDkDUQq1vizUG0FV6z10rHvdBJ
	 LHQ5wAV5J5Cku1tshJfnqMPkUXVkcpZnDy8xlqo//adXXqDAZCTdID2GiGvKnTjDbag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YDOggH9wHpYf1mdxKq92jIv4KWOYpmeoDw0EEBV/VJY=;
	b=WaRIypiFecKU1EF9W5rSvYLt5srETtgHo4Amz2eCnfSZEKPMfyZQmCVxiu7R+F3pHvU4
	 BZ4RjchL/w9m/sDAccAIdYJI343B4pfIV4qLxjHk2yzfj5c7kA/Y0FFTnUoBquVVpn0oV
	 HXRKC7EtIk0DMueXgPCHNwmfscekFiAfoUKq6FjZ2JlH4LMcdpgEgvLTr1sUmE445otUv
	 KyvnXpYwOn1ERrkbM6j66BqPR5KW07CaOEtAg7uHt69RTDvgWHeeHhoTcn5g+gSfX00qs
	 YCebgSZahLqtO/dH7PaukwDzQe0hk8Ip4/gE+SxPIhhCgQkcK6ffW/pwGOvnZgQWLkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aVfRUtLv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCD6606A325;
	Wed, 18 Nov 2026 21:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aVfRUtLv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D591F000C4;
	Wed, 18 Nov 2026 21:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038932;
	bh=YDOggH9wHpYf1mdxKq92jIv4KWOYpmeoDw0EEBV/VJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aVfRUtLviPTAPFcDXwsQFHfnRJIG2U6yBC+//dN8Cv/EibOya+ocBs0auoHPc6rBa
	 4Z3ITx1TcguWctXKjJsP3zNdZCP8PohfPJyxc6JzkYvAds6kQ+IQq8GELwf7tqmO1s
	 QwpunZdVXaInfYcZOiSPSlJ1Tbr4eaF+lDO09Wg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1878/3318] f2fs: fix to update superblock crc in sanity_check_area_boundary()
Date: Wed, 18 Nov 2026 15:41:40 +0100
Message-ID: <20261118150418.322869021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Added the sbi argument to f2fs_crc32() to match the older checksum API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index a7c35c1cf76cf..88faa95719438 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3446,6 +3446,12 @@ static inline bool sanity_check_area_boundary(struct f2fs_sb_info *sbi,
 		/* fix in-memory information all the time */
 		raw_super->segment_count = cpu_to_le32((main_end_blkaddr -
 				segment0_blkaddr) >> log_blocks_per_seg);
+		if (__F2FS_HAS_FEATURE(raw_super, F2FS_FEATURE_SB_CHKSUM)) {
+			__u32 crc = f2fs_crc32(sbi, raw_super,
+					offsetof(struct f2fs_super_block, crc));
+
+			raw_super->crc = cpu_to_le32(crc);
+		}
 
 		if (f2fs_readonly(sb) || f2fs_hw_is_readonly(sbi)) {
 			set_sbi_flag(sbi, SBI_NEED_SB_WRITE);
-- 
2.53.0



