Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065425;
	b=Fdq7X84+cuhkSIHDI3h8wXyCA3h9SGSniQZNgG5lFwGdQNoEr71tMOxDc7NbDUfOSOVm
	 /T+f3E6FNZMQt5PGkbZK1HFyR1I/pqL4AiHQiAUGk+acXZdqmrlcBHgqpE+QJB8zApN3F
	 a3qPRsmW5ibicvKkRVr8VM8ifIT1AD1GmpbJ3VG3ZOQ7ZUJ/YZWbVppjdoU375GoFKMmf
	 +9cQDZ5/4+aoPqjWc4dMIOFlT6bjPNvzP6DOM41ecMK39uG1sYCNic11+YGcKvDqxQ125
	 piTgwAr0CIB/BY1ccA3OBiNMRdJ4xV8wt/IhmflW6c0HVkSotI5tXFIy8iq4764u4dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q3EhbnTxXSXIyeCqDShM0IsW0zQzNsKMucFVRj7VTXw=;
	b=lVgSWan2xP1oZgfr+jB7wxvYs2VJnpsbo+9RTrGm65YLqw+Qft+s0+Y2DrGWnBC6gr55
	 Lkp4kVdI9UMxqzpM1e3cED1ROOWH4PAGpgE1KGVlrDVCGHbCV44gnOLNISP+YLobCQh9a
	 sO0csxEm+7vwPGUEOOajMvFbpbeaT0bXXxPeg5jdW0x50ezAhQYBEUw5UN9Q2ir0Od/qY
	 r4D0q0pLKPKOSqVx/k1VlysraUsbzsQb4Scczm5HFRyoL/XWGgD5qTYsxeVHvGMu1YazP
	 BV1zC7Fm5wC0LIKSywl9EhuUX484A7QJ9wpPLg6EsxdbSK3Wl8kZwjC/xbxN4Dme+ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0NFBCVOq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A9C606D805;
	Sat,  7 Nov 2026 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0NFBCVOq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3651F0089F;
	Sat,  7 Nov 2026 15:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065424;
	bh=Q3EhbnTxXSXIyeCqDShM0IsW0zQzNsKMucFVRj7VTXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0NFBCVOqmKK+jICwmpiQzmDoI6jOMKeZNsGBRTyxwnqBnHRnTrAo7rLYTSL3awcZW
	 maKEvqLejwfdUkJrMJ8nDs/v7Ts+zKdbDSnNSZcdO8ZwcCeEvi/2CFt+XxF0ZyVU4C
	 jSINIPQnuVtOmcmGgSs7orJXLfrsLXLII7vO0pHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1137/1257] f2fs: fix to update superblock crc in sanity_check_area_boundary()
Date: Sat,  7 Nov 2026 08:57:13 -0500
Message-ID: <20261107135010.631517516@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 0278f2f193fbc..b9adad85e18c3 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4047,6 +4047,12 @@ static inline bool sanity_check_area_boundary(struct f2fs_sb_info *sbi,
 		/* fix in-memory information all the time */
 		raw_super->segment_count = cpu_to_le32((main_end_blkaddr -
 				segment0_blkaddr) >> log_blocks_per_seg);
+		if (__F2FS_HAS_FEATURE(raw_super, F2FS_FEATURE_SB_CHKSUM)) {
+			__u32 crc = f2fs_crc32(raw_super,
+					offsetof(struct f2fs_super_block, crc));
+
+			raw_super->crc = cpu_to_le32(crc);
+		}
 
 		if (f2fs_readonly(sb) || f2fs_hw_is_readonly(sbi)) {
 			set_sbi_flag(sbi, SBI_NEED_SB_WRITE);
-- 
2.53.0



