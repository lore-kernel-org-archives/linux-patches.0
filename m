Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585887;
	b=KWDMx6Pq//uic+vtlbUr95Dxec6RnGqN44C+SOwmtiVK/dOiKMGiGUiSxef7tazTT/JL
	 pUtmevUSoexNrqzsxcIWipiOQMQWdkJPiKAfdCE8C0Kwo7H/mYrdBn/xTSH7nz1d22qsa
	 UF5qlZVRAmilQ/ZgretlxaED2Hi0ewPVO+rfE3R6h0uMN8pI4eHisE9cmv1BuYrhN6cn1
	 nKqBH4T51tKCXyaVsyORiIRQJKNXxb9U+mqxIN1O5n3JAZkOM1TkJiG9oFWrCxNkhO6zA
	 qrXRTTyYVOKP2WaqUPAI0UIlYxOt7LcGxL+fAg+i6A5mll+IA5OonMPktDNZ34EusxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L9saf5ZO/Q46oZxUhTGnLOlMN8UPOu/+7uaDL6kMRTI=;
	b=RonDQ4xsUsZ+QLmRHHXEy4lkhWd3EjFbQM3mo5reXAgSXPB3RDUdlCt+6Z48G+zsJQTe
	 zgd+cwNGYOqgbhd61DktsFLXAAe5pjAglNHhSfHObTIYSpDaOhGf8h672nwg+ECmulEII
	 sqjlhTg8M8zuwcvF3gEFbj9h/z48c1lxf20Lmng0mxITWXmrUVs2qUb6jaPstwDRe4/vP
	 Zds5APy0/GZtqiHlSx4HGcJaoLPEHqYN+GCAAnTgWI/DZUEGx+5ymR5M/kBV5UzRAZjDi
	 lUM3QqcTw66vMC8uHCVEO/F4po36owZcT0pJjv0/EMcOZaTwf2y6Y9LIWcovOOOWjXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=izrtamoj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D264606EA9D;
	Fri, 13 Nov 2026 16:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=izrtamoj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236CF1F000C4;
	Fri, 13 Nov 2026 16:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585887;
	bh=L9saf5ZO/Q46oZxUhTGnLOlMN8UPOu/+7uaDL6kMRTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izrtamoj5br7s5ztfvwxC1vu2GytGv3C8kbPHGRdyWeifv83D2wtMmjjsU9FR2fIv
	 fKt98SxSaAmPc2qWh2oXM3u2j/Cuz5NQLVMbK81Q9wxM61bLSKmtm04O+Otoh2HLPn
	 QvzcnbVFsF02k6L5ic7L/WHOp2P+R2ZWuDqeVhfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 453/507] f2fs: fix to check continuousness in f2fs_sync_meta_pages() correctly
Date: Fri, 13 Nov 2026 10:52:37 -0500
Message-ID: <20261113153812.082898337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

[ Upstream commit 1383cff4ccf3c8833c6255edffa29eb67c6419bb ]

In f2fs_sync_meta_pages(), whenever i becomes zero inside while loop,
below check may be skipped, it failed to check the continuousness:

	if (nr_to_write != LONG_MAX && i != 0 &&
		folio->index != prev +
		folio_nr_pages(fbatch.folios[i-1])) {

Cc: stable@kernel.org
Fixes: 580e7a492608 ("f2fs: convert f2fs_sync_meta_pages() to use filemap_get_folios_tag()")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: adapted f2fs_sync_meta_caches() changes to folio-based f2fs_sync_meta_pages(), using folio_nr_pages() to advance the expected index ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 794b1cb9221ef..a84517023e54f 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -610,7 +610,7 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, long nr_to_write,
 				enum iostat_type io_type)
 {
 	struct address_space *mapping = META_MAPPING(sbi);
-	pgoff_t index = 0, prev = ULONG_MAX;
+	pgoff_t index = 0, next = ULONG_MAX;
 	struct folio_batch fbatch;
 	long nwritten = 0;
 	int nr_folios;
@@ -629,9 +629,8 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, long nr_to_write,
 		for (i = 0; i < nr_folios; i++) {
 			struct folio *folio = fbatch.folios[i];
 
-			if (nr_to_write != LONG_MAX && i != 0 &&
-					folio->index != prev +
-					folio_nr_pages(fbatch.folios[i-1])) {
+			if (nr_to_write != LONG_MAX && next != ULONG_MAX &&
+					folio->index != next) {
 				folio_batch_release(&fbatch);
 				goto stop;
 			}
@@ -659,7 +658,7 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, long nr_to_write,
 				break;
 			}
 			nwritten += folio_nr_pages(folio);
-			prev = folio->index;
+			next = folio->index + folio_nr_pages(folio);
 			if (unlikely(nwritten >= nr_to_write))
 				break;
 		}
-- 
2.53.0



