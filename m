Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591354;
	b=GNJcNEtkNPKIoHsfWcs3uXMtgjKwCQtz3x97P+L5O5+9Y1OqT7jsoTFzy3RQLLrR/zJq
	 n3kaXOofEixYxKyHvRLXHy6/po3oIHm0xA9ghPADhPpx6SqkOR9nZa+0EdJyRW15a/GKb
	 Qdph8AM0m4LmtL7L5Takz530SfIOYNstBatgr+Xs4RS5upBKrcIU7MITMf8RmahG6yFCv
	 A9T1pwGU6na6z1nKPtoiesS3WJOmpylAUvo4TAIyVqiVourCZeZkpF7qpFUkNgvqvOaHm
	 A8cdR1H15J2r7svAVaMyi10fBzWTTZ1AUAqYL2m2krR9hBQ5lXre3e+aFst5zbjEQQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/el28muAIbhx6vJ2SO439u14zlh8aW4pahIHklfMt1s=;
	b=SRU/ZbzqE0ffr6QB5tBu2AUM365rBuRzN+zgqhj+ADyRjgqzRgxtN5Ny1wtIfmKnr9yX
	 MuNEhFFXWQMgc7WLM+zNollCYR12OQpU8QI8dv+Vtp+SbxG7tr+sqtIvbLdt1AdTkqNfb
	 QgIJWGV8Vy2MZ6ZJcxNpqTg5klikr2coaJEiZiZ0caF1yT4FGJKUYxGpIxogFIu1yd0NV
	 OVIboxhUP9QlzA1icvIAivtyuvle3Fhu9TGTZSHRh0Oitn21FA/iZ0qLYxIwSh9fzSU2P
	 WXZmdURrP3ET5QaEI+11Ztw6+jsVPOBOd5Zkb6OtJOBMMpeTL5Rhlm2MrjGk69gfkqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPSy6a80;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F86606CEE8;
	Fri, 13 Nov 2026 17:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPSy6a80
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916211F000C7;
	Fri, 13 Nov 2026 17:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591353;
	bh=/el28muAIbhx6vJ2SO439u14zlh8aW4pahIHklfMt1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPSy6a80F4pzHSh6IcIpl2yxbnMjWFtTek9Dwxxh529V46xwQrLMT4UjhJTIGqw4K
	 S4Y6sDZ8yT8uqe/T3f89rg6BJZ3efIo3UiqnC7QLGSb+/lkyVVLkUps7pOtSjPeHnU
	 eCX0vK4sPqlGPYMx9CWfXQjavJsUuXV3YSQzb5Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 459/670] f2fs: fix to check continuousness in f2fs_sync_meta_pages() correctly
Date: Fri, 13 Nov 2026 10:50:23 -0500
Message-ID: <20261113153827.532018777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: adapted the cached-block check to folio-based f2fs_sync_meta_pages(), using nr_to_write instead of background and folio_nr_pages() for index increments ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index dc9540400caae..eb928d644542f 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -423,7 +423,7 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 				long nr_to_write, enum iostat_type io_type)
 {
 	struct address_space *mapping = META_MAPPING(sbi);
-	pgoff_t index = 0, prev = ULONG_MAX;
+	pgoff_t index = 0, next = ULONG_MAX;
 	struct folio_batch fbatch;
 	long nwritten = 0;
 	int nr_folios;
@@ -444,9 +444,8 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
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
@@ -475,7 +474,7 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
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



