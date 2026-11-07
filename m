Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063349;
	b=lBiy3VJWUuuTpsZsItidAEs20Ws+Y4rPwFt4VnXzuEYybUQ54ERJ/fUxlrAAos6KnkwS
	 9Sjih663NUNAS1FeEgTYO4pFrgQbKIJX6nkIHOWJb7dghKEpG8Dffmy3aBxV/hpaZb90/
	 uIaZZ0jrao8olmLXNyNazEcixhq/pYksvbvo8PSTxRCJNvwq3bwTXWUD3J3GTtQwHnZOB
	 OdsIPucDcqJaKELPJX2H88HhGb/wImGZuBkQDoyx2Wll1EVvYzfyH5r82m5zufzTUphO5
	 w76l7oQzcNEfmJ+hq/61YKGGRetOih5zIzrTGUQEokixn6FLmt3MFs6P06xZ75lZrbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZGeS+9/q55/5pzNy/Wz0/jHxAL6gUHy2RrSMWliKgwo=;
	b=mXevydG1sokNa6D9kppmo3VVMO72/oqtcApVbnerwqQ8PrRx19LBQzGBKSeZNRQFRKZm
	 HfzzkbMfC+znx5RS6MPURIyZz0+HnI8YqUDXhd1fOMpjWVOslR6d6BLOii5Ug4wdNqnv9
	 azn6/j2lY0yb9rEC6XD2qHiWDk5ECOSC+S5wsZH5NrHPfkCpF05YufJA3RhzXC7hqKsEs
	 /xAD/A9DVpsf39SB1rZXVNlb3OEjslICZrCp5mPq/paj2ikfmJZhDyeA+YjAn6bMevr5R
	 3oLO2Igo4Hc7lDRgKGQ2RT7bp91brAUxIgWMpdx7MtIHjahclXGzVbPvd4M758yEEaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gmwHil6b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78FC606D831;
	Sat,  7 Nov 2026 14:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gmwHil6b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567CE1F0089F;
	Sat,  7 Nov 2026 14:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063348;
	bh=ZGeS+9/q55/5pzNy/Wz0/jHxAL6gUHy2RrSMWliKgwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmwHil6b60OQJDpBgbIP+yUXeB1hE2dYcKnB9Jaw3yltn1m6piKLpmuLm+ezEt705
	 2oxSIsvmbiRmDiD6J0arVT41K2tQh6jSSdYiGLWm6E1CJSNJ2e54/GJEmHJDZvS0MK
	 XvPT7qNYccxXmBiaZHj6NiP4pdXl2teqnFTMeHt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kaixuan Li <kaixuanli0131@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 530/869] f2fs: check every cur_*_segno[] entry on readonly images
Date: Sat,  7 Nov 2026 08:53:32 -0500
Message-ID: <20261107134911.441294699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaixuan Li <kaixuanli0131@gmail.com>

[ Upstream commit 9c4ee79190c8c23a9fb5c07d3bc87eaac514b2bb ]

sanity_check_ckpt() bounds-checks cur_node_segno[] and cur_data_segno[]
against main_segs, but on an image with the RO feature the goto that skips
the duplicate-segno cross-checks also leaves the enclosing loop, so only
index 0 of each array is ever checked.

An unchecked index reaches __set_sit_entry_type() through build_curseg() ->
reset_curseg(), which writes se->type through &sit_i->sentries[segno]. With
segment_count_main 120 and cur_data_segno[1] set to 200, KASAN reports
three out-of-bounds writes during mount and the mount then succeeds.

Use continue so every index is bounds-checked, and skip the node-vs-data
cross-check explicitly, which is the other thing the old goto skipped.

Cc: stable@kernel.org
Fixes: a7d9fe3c3388 ("f2fs: support RO feature")
Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 146bd977bb591..11d218b415b0d 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4180,7 +4180,7 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 			return 1;
 
 		if (f2fs_sb_has_readonly(sbi))
-			goto check_data;
+			continue;
 
 		for (j = i + 1; j < NR_CURSEG_NODE_TYPE; j++) {
 			if (le32_to_cpu(ckpt->cur_node_segno[i]) ==
@@ -4192,14 +4192,14 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 			}
 		}
 	}
-check_data:
+
 	for (i = 0; i < NR_CURSEG_DATA_TYPE; i++) {
 		if (le32_to_cpu(ckpt->cur_data_segno[i]) >= main_segs ||
 			le16_to_cpu(ckpt->cur_data_blkoff[i]) >= blocks_per_seg)
 			return 1;
 
 		if (f2fs_sb_has_readonly(sbi))
-			goto skip_cross;
+			continue;
 
 		for (j = i + 1; j < NR_CURSEG_DATA_TYPE; j++) {
 			if (le32_to_cpu(ckpt->cur_data_segno[i]) ==
@@ -4211,6 +4211,9 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 			}
 		}
 	}
+	if (f2fs_sb_has_readonly(sbi))
+		goto skip_cross;
+
 	for (i = 0; i < NR_CURSEG_NODE_TYPE; i++) {
 		for (j = 0; j < NR_CURSEG_DATA_TYPE; j++) {
 			if (le32_to_cpu(ckpt->cur_node_segno[i]) ==
-- 
2.53.0



