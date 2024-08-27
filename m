Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F2C1C5792;
	Tue, 27 Aug 2024 14:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770283; cv=none; b=SnzzZEAZRDg7BjKowhQfoghxyew983JcgjsN8rvJ44oIzH3mZXzktmLzaaqXRURESGY0nU+5pgyr3Vs5TgvKMS7lIfxfkTC4rLK625ep73dRU5ev+myu027vp94csVDaqy6Z3CORWU4z6prBDiHf+7Y85SsKb84MsJ0nLrEyHPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770283; c=relaxed/simple;
	bh=NDEg030/0cHAiOK+exZh1CnxtA0/O4GlCuexvbznrZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4b50mo5lWDyUZ3n+NAKjL7c0gC+EBemGDS3xUVKV6xbidTj1nXRJ+7SD53ZS6axACC0RFvuLuRkR7czQAsCsSfmmwsMlWKnnD3xw2CgXQZehFVqSq6Gu0uQNdejdxfVkbPZQ5OT015T2VqGWOGalPgqkLSSkrscJGYUvUQaY1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfA/z8aR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfA/z8aR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7818C4DE03;
	Tue, 27 Aug 2024 14:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770283;
	bh=NDEg030/0cHAiOK+exZh1CnxtA0/O4GlCuexvbznrZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfA/z8aRL9iRrcUgiCz+yGe30Er5M829T1IyEfdE2ihNFQS9UDd9FPBPYzLAoiSFR
	 X+J/LNKW1YHGB6bDnlSC0xeNcMcFAPkXbt+3aD43teKbdqGwXJLuyeIJegsgR5o4VG
	 idbP663FFGDj6B8sg0hyeBaIk3JqhkvMQIvq//Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/341] f2fs: stop checkpoint when get a out-of-bounds segment
Date: Tue, 27 Aug 2024 16:36:52 +0200
Message-ID: <20240827143850.301883134@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit f9e28904e6442019043a8e94ec6747a064d06003 ]

There is low probability that an out-of-bounds segment will be got
on a small-capacity device. In order to prevent subsequent write requests
allocating block address from this invalid segment, which may cause
unexpected issue, stop checkpoint should be performed.

Also introduce a new stop cp reason: STOP_CP_REASON_NO_SEGMENT.

Note, f2fs_stop_checkpoint(, false) is complex and it may sleep, so we should
move it outside segmap_lock spinlock coverage in get_new_segment().

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c       | 12 +++++++++++-
 include/linux/f2fs_fs.h |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 804958c6de34c..50c7537eb2250 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2646,6 +2646,7 @@ static void get_new_segment(struct f2fs_sb_info *sbi,
 	unsigned int old_zoneno = GET_ZONE_FROM_SEG(sbi, *newseg);
 	bool init = true;
 	int i;
+	int ret = 0;
 
 	spin_lock(&free_i->segmap_lock);
 
@@ -2670,7 +2671,10 @@ static void get_new_segment(struct f2fs_sb_info *sbi,
 	if (secno >= MAIN_SECS(sbi)) {
 		secno = find_first_zero_bit(free_i->free_secmap,
 							MAIN_SECS(sbi));
-		f2fs_bug_on(sbi, secno >= MAIN_SECS(sbi));
+		if (secno >= MAIN_SECS(sbi)) {
+			ret = -ENOSPC;
+			goto out_unlock;
+		}
 	}
 	segno = GET_SEG_FROM_SEC(sbi, secno);
 	zoneno = GET_ZONE_FROM_SEC(sbi, secno);
@@ -2700,7 +2704,13 @@ static void get_new_segment(struct f2fs_sb_info *sbi,
 	f2fs_bug_on(sbi, test_bit(segno, free_i->free_segmap));
 	__set_inuse(sbi, segno);
 	*newseg = segno;
+out_unlock:
 	spin_unlock(&free_i->segmap_lock);
+
+	if (ret) {
+		f2fs_stop_checkpoint(sbi, false, STOP_CP_REASON_NO_SEGMENT);
+		f2fs_bug_on(sbi, 1);
+	}
 }
 
 static void reset_curseg(struct f2fs_sb_info *sbi, int type, int modified)
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 3b04657787d09..1352a24d72ef4 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -76,6 +76,7 @@ enum stop_cp_reason {
 	STOP_CP_REASON_CORRUPTED_SUMMARY,
 	STOP_CP_REASON_UPDATE_INODE,
 	STOP_CP_REASON_FLUSH_FAIL,
+	STOP_CP_REASON_NO_SEGMENT,
 	STOP_CP_REASON_MAX,
 };
 
-- 
2.43.0



