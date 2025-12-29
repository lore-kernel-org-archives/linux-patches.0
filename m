Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA69531B111;
	Mon, 29 Dec 2025 16:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025744; cv=none; b=FARcQr6iYYn01ER25EcRbLr4Jr0BKyqwPfCJHOeNS1MUUHMHXh9NA6gNF4Bv2Dn3py8orrCe27CGHzGAM0ooX/cD0XbwzjTNm3414sVWEaxhvA0+w7Lj1kPEc4hcysD8fuRa61hbnikVja8RxjkIoqlgHyPiixYQHTgXzziGlbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025744; c=relaxed/simple;
	bh=ZRYiI/f1hSjbg3gAByZX6V0x3yCbmT81e6kSsr3p1I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPHaXCxwkNe0BEuu5Uvr1Y0UUpAOiYpiKLbYAdZO2Kqd26QFPO3W70fAkbtYo32fT8bpgsCOUQDIzkylq6vDgETvSUvXCepue9DeNdMLMZnVlB/4a5Gp30anJkWYgXWSg5oonCGPYEVdvKInLtnB6aJ0k/Aarf6O0thowi49fVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRiXKhj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRiXKhj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA0BC16AAE;
	Mon, 29 Dec 2025 16:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025743;
	bh=ZRYiI/f1hSjbg3gAByZX6V0x3yCbmT81e6kSsr3p1I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRiXKhj6EWx8xuGagDvr30CreMUO5nb+jYISx9OsoQX+vEHwxv3Pq8AVPKLY+wv8l
	 mGCgqjUrY0FPbOUjvsz7eTADt0efGYbB7Y50XCGpVk1gkGnL8l3ui6w1Do7TpzlA7H
	 PQKSMHCZqTaokc9bIrXiJR+ONZoy3/MUbo1zsq1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 322/430] f2fs: fix to not account invalid blocks in get_left_section_blocks()
Date: Mon, 29 Dec 2025 17:12:04 +0100
Message-ID: <20251229160736.178688680@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

commit 37345eae9deaa2e4f372eeb98f6594cd0ee0916e upstream.

w/ LFS mode, in get_left_section_blocks(), we should not account the
blocks which were used before and now are invalided, otherwise those
blocks will be counted as freed one in has_curseg_enough_space(), result
in missing to trigger GC in time.

Cc: stable@kernel.org
Fixes: 249ad438e1d9 ("f2fs: add a method for calculating the remaining blocks in the current segment in LFS mode.")
Fixes: bf34c93d2645 ("f2fs: check curseg space before foreground GC")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/segment.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -607,10 +607,12 @@ static inline int reserved_sections(stru
 static inline unsigned int get_left_section_blocks(struct f2fs_sb_info *sbi,
 					enum log_type type, unsigned int segno)
 {
-	if (f2fs_lfs_mode(sbi) && __is_large_section(sbi))
-		return CAP_BLKS_PER_SEC(sbi) - SEGS_TO_BLKS(sbi,
-			(segno - GET_START_SEG_FROM_SEC(sbi, segno))) -
+	if (f2fs_lfs_mode(sbi)) {
+		unsigned int used_blocks = __is_large_section(sbi) ? SEGS_TO_BLKS(sbi,
+				(segno - GET_START_SEG_FROM_SEC(sbi, segno))) : 0;
+		return CAP_BLKS_PER_SEC(sbi) - used_blocks -
 			CURSEG_I(sbi, type)->next_blkoff;
+	}
 	return CAP_BLKS_PER_SEC(sbi) - get_ckpt_valid_blocks(sbi, segno, true);
 }
 


