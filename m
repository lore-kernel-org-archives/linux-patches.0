Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216820;
	b=Tr+fL0Pyv96WNpHLfkyrcMFLs5LMAzuQMPBYpTrEkuVgrcRJOzVryAWRJLmWjzWcB8Fs
	 EOuscfpSQHhxxY7CC0YwEyi4LtTblQFB1RTNZTegHO6u70DK9wlOIN1AfyNc0jWvZ9OBr
	 7u4JICSmjd3ZmUQSw1W3qa37/fvRvFNOuk/rdWu3H4AvNnl4/eUz0d/79Y3urUwr8kbE0
	 bp8mByBYO/DPFsur/LT+LviqHgeruQHjsH9p4QKO01C6AUxOOeDUGcdJtMwpQgKlDFIi8
	 VgTJ8yVypJvvhwXybjJKzaK9svwQTwbf02X6pxWONo1zlxkYAwvqJ7fg2MPVPVGDf+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aywRclQAibCiyoYViKoDus3TwAjuSyJAjbx7G6frjjM=;
	b=t/g5t4lAcCHhRTH3gIQrS0nTEpl3mBHe/O8M9HVFVw2sH0Tw69VIsjlI2o0VJK7sONXm
	 QIr7ZKPlLrISNYA8B7W/NHoGOge12XJpb89uMRrxjlvo7x8B32+u6o9hdi7SXkBJsulA3
	 H7O+5LLIVdznBBG5Sj8gROX2vbMOBmWq1IwVnihl1NW9x9smreHc9iK763CFNtSg3Wp3x
	 UR3kFoLGHaq23MIynTX+qbVwzcVyQa9suYu28rL2NAi6tCBV6g4xccStNs48CBLfHjcZb
	 ylpny07jCS+x3FQP/ZT0WYAobd2vBwSxmMwZUgIvTCTE9j7bU5sX85HLjs5U+Q702dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jedOdV7c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB3F606A31A;
	Wed, 28 Oct 2026 19:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jedOdV7c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED4E1F01825;
	Wed, 28 Oct 2026 19:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216819;
	bh=aywRclQAibCiyoYViKoDus3TwAjuSyJAjbx7G6frjjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jedOdV7c6ycbcxGdk6NyLUnhnui0o3MMXr0lu0DpVGFulCUrqe+0sCClBP+yZ/PRe
	 E3yD2cjkUanJSRMPGSUEz+wcdgQZQzwPApGDqLWG7bFPeeX59gNfnwmTRDinkJohZI
	 qtilGiuATAmME1estu8HLCAWFzQiHDmEL9cIj7So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1688/1887] f2fs: accurately adjust free_sections during free_segment_range
Date: Wed, 28 Oct 2026 18:03:04 +0100
Message-ID: <20261028170537.868762929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 8c963d1738fdca400082ff5f9d99e083de4f4e70 ]

In free_segment_range(), MAIN_SECS(sbi) is temporarily reduced by `secs`
to restrict block allocation to the safe remaining main area while valid
blocks in the truncated range are evacuated by GC.

However, FREE_I(sbi)->free_sections tracks the total number of free
sections across the whole filesystem. If any sections within the
truncated range were already free upon entering free_segment_range(),
failing to deduct them from free_sections causes the filesystem to
overestimate available free sections in the active, reduced main area.
This leads to inconsistent free section accounting during GC data
migration and can trigger unexpected allocation failures or assertion
errors when space is tight.

Fix this by calculating the number of already-free sections in the
truncated range, deducting them from free_sections upon entering
free_segment_range(), and restoring them on exit.

Fixes: b4b10061ef98 ("f2fs: refactor resize_fs to avoid meta updates in progress")
Cc: stable@vger.kernel.org
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Sunmin Jeong <s_min.jeong@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 2df6a5b503508..851f55aa37f4e 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1995,8 +1995,9 @@ void f2fs_build_gc_manager(struct f2fs_sb_info *sbi)
 static int free_segment_range(struct f2fs_sb_info *sbi,
 				unsigned int secs, bool gc_only)
 {
-	unsigned int segno, next_inuse, start, end;
+	unsigned int segno, secno, next_inuse, start, end, end_secno;
 	struct cp_control cpc = { CP_RESIZE, 0, 0, 0 };
+	unsigned int freed_secs = 0;
 	int gc_mode, gc_type;
 	int err = 0;
 	int type;
@@ -2005,6 +2006,7 @@ static int free_segment_range(struct f2fs_sb_info *sbi,
 	MAIN_SECS(sbi) -= secs;
 	start = MAIN_SECS(sbi) * sbi->segs_per_sec;
 	end = MAIN_SEGS(sbi) - 1;
+	end_secno = GET_SEC_FROM_SEG(sbi, end);
 
 	mutex_lock(&DIRTY_I(sbi)->seglist_lock);
 	for (gc_mode = 0; gc_mode < MAX_GC_POLICY; gc_mode++)
@@ -2016,6 +2018,14 @@ static int free_segment_range(struct f2fs_sb_info *sbi,
 			sbi->next_victim_seg[gc_type] = NULL_SEGNO;
 	mutex_unlock(&DIRTY_I(sbi)->seglist_lock);
 
+	spin_lock(&FREE_I(sbi)->segmap_lock);
+	for (secno = MAIN_SECS(sbi); secno <= end_secno; secno++) {
+		if (!test_bit(secno, FREE_I(sbi)->free_secmap))
+			freed_secs++;
+	}
+	FREE_I(sbi)->free_sections -= freed_secs;
+	spin_unlock(&FREE_I(sbi)->segmap_lock);
+
 	/* Move out cursegs from the target range */
 	for (type = CURSEG_HOT_DATA; type < NR_CURSEG_TYPE; type++)
 		f2fs_allocate_segment_for_resize(sbi, type, start, end);
@@ -2053,6 +2063,9 @@ static int free_segment_range(struct f2fs_sb_info *sbi,
 		f2fs_bug_on(sbi, 1);
 	}
 out:
+	spin_lock(&FREE_I(sbi)->segmap_lock);
+	FREE_I(sbi)->free_sections += freed_secs;
+	spin_unlock(&FREE_I(sbi)->segmap_lock);
 	MAIN_SECS(sbi) += secs;
 	return err;
 }
-- 
2.53.0



