Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062409;
	b=0dBxIpU/BDRJFNXwnVXzH/EBIQio/J0jNL8H7tV5P89XMvbOiM96hwZxMrVWUcmfKaaB
	 o6nof0QyOerFlvnBMmq31b+9sLPZwmz22CnmiigzARojJlLzgXXD2u7zl4aun7jexKcp1
	 EFsXl80YzYrXv2rq0KB02/bhNLO/5eVilVaPT8rsQ/1fSmAUaiJfnct8jv7ozDNd1pTyB
	 LlAqDdFO39ePmwS05hYrTYSkLC4kBXIKTcDzmL7sY8TjYB0DWeYSQtlTclhDAMlVbna2P
	 slJHFAxJEu9Yl6xcZU79p0c1M+47vktHLqXYee59IOdvu9Xv+SPpf4tFoBJA2HcWaMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BPPvnpkH0jnegNarQZls+EavPDc+oLsusY/KuWOfDEE=;
	b=TffUnZVimFLBqM4S56v615JTuBkS7xf053096zawzRnvXZDkSyhNaxPh+qBQfWZMglk+
	 0HqqWdYrrN1N2htmQfSJbUn0Qbh/voG9cG2ho/PTepprGqWysr1jP97U4n7Z4rmWVH8zL
	 SsZP/qM7aibPmahCrCEtltMoY0ca8fYKfjGXJbduoU30bv4YlB9/P/B4JuqtsJKcgXtE/
	 pWScelTjr7vw2LwWvFWDepEBACMsf5nNRBItIJEria0go7e9lAzr2foVJhM9qdY8PVBdA
	 Ypc9q8suMRhTekW91QyCoW6OEhdF83uboePDoreiUxs+fKFX6UiYosVPKjjS+6+G5EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DBWZ7dNF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E435B606A33C;
	Sat,  7 Nov 2026 14:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DBWZ7dNF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7E61F008A3;
	Sat,  7 Nov 2026 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062408;
	bh=BPPvnpkH0jnegNarQZls+EavPDc+oLsusY/KuWOfDEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBWZ7dNFDa1a6nq0YGEGT57wBRwTJD92ei+SnEeHv8nZD/GzkhKxDtrmJi7jLWfFH
	 ac8SLqeHCdaZX4jaTXarKL8LWJG+XEaTaV9M1n1f69BCB8otnUWL5hNprOIUS8ovHn
	 wxmDR66aC/wudK32f8EIDCbnHEn00ZWxPLC51LBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kaixuan Li <kaixuanli0131@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1276/1536] f2fs: check every cur_*_segno[] entry on readonly images
Date: Sat,  7 Nov 2026 08:54:52 -0500
Message-ID: <20261107135033.618144794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1e5aea6352497..31724ab224d4a 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3831,7 +3831,7 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 			return 1;
 
 		if (f2fs_sb_has_readonly(sbi))
-			goto check_data;
+			continue;
 
 		for (j = i + 1; j < NR_CURSEG_NODE_TYPE; j++) {
 			if (le32_to_cpu(ckpt->cur_node_segno[i]) ==
@@ -3843,14 +3843,14 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
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
@@ -3862,6 +3862,9 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
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



