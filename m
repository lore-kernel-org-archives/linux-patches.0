Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063549;
	b=SsZRyOjaq3ztRDpxlTtJm2wzNCQwZrNjiM3JVODcfFXukGUC14XQ35voQQzaklUIwI4A
	 MdLqw0momaxYeCAwAZyttL6842u7C8MyVsfFe09S0HCV7S04oy1ou7BPSqqqiy6FE/GHp
	 7mtLxUC0G4F9Dr08FCnoLG5EO/cEMdleTiBp8irBKFBRrBlgpG8l6jULypaz6xQ+yrd+0
	 uB2LhQcQSxyRch1oZkAM+SxG43VYHCZvV9jj+tTcNCGgJVl+hmgDmefCVsODeBuA7urbM
	 HEeBKUGb2jbT/3n1Jtppx5u9G7aMtQlSo7bZBju1xKoetTigYWapm6dCUEZYAAl8iGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nsDF5Qu8dACc40WUTkMjM45LodcVsJIIsSA6RKk8azw=;
	b=u8KKnV94AR4KJAWziDiYs1utCGADZ0lEUciutUFMzs11M/a8mMbS/R9H5DRhw+UFzTOE
	 cD8b1tUYPItaC+PQH6lUudqg5xp0q/5Ojwm89a1VFJOoTTfNxJplq4jTD73+6iGCbRf5T
	 5P1aMvOnYNTuYXojcDYlcoViaVSNYXPnlIRCSn30hI5mwcSp6QodPDF6Y8o9wSBKXoXGR
	 +eJc4Q231F9Ivq9weVRmz1isxxF++BQ6TVc7oD9Q6zLyJ8Qk1N7NRbYygb/ph1jDmw/nu
	 Dv1sQ+DhnR/6dfLMRYF+kPJ7NHheiSRpEaJBAZLjcWobvIPnxQPq65Ap6KNxTRfHuuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMZdUqyz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D50E606A32D;
	Sat,  7 Nov 2026 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMZdUqyz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC921F0089F;
	Sat,  7 Nov 2026 14:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063549;
	bh=nsDF5Qu8dACc40WUTkMjM45LodcVsJIIsSA6RKk8azw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMZdUqyzGb8Y/RJDJVAsgA7dOuH64Uxvug2P64k+c4Xb7Sy6MiDVnA7o9E/0BKgfA
	 RCXYor8ac/gs3T/KzU5B7Xqj5UZOKCcwEL4+lHHJ6HCNnvE0ntGzorm89fEN+Dh56V
	 uun2hJvM/27LhVIqelFo/MrwuTT5QXIDr99j8YCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 646/869] f2fs: flush SIT journal during filesystem resize
Date: Sat,  7 Nov 2026 08:55:28 -0500
Message-ID: <20261107134914.870383204@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit a6ede405455106bf42164ec96fd84008c5aabdd9 ]

During a filesystem resize, SBI_IS_RESIZEFS prevents new SIT entries
from being added to the journal and forces existing entries to the SIT
area. However, f2fs_flush_sit_entries() returns early when there are no
new dirty sentries, leaving existing journal entries behind.

After the main area shrinks, a later checkpoint can access a journal
entry whose segment number is outside the new geometry and trigger
f2fs_bug_on().

Only take the zero-dirty fast path when entries may be written back to
the journal. This lets resize drain existing entries through
remove_sits_in_journal() even when there are no new dirty sentries.

Cc: stable@kernel.org
Fixes: 04f0b2eaa3b3 ("f2fs: ioctl for removing a range from F2FS")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 510d073f8ec54..23f9b76ee0145 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4687,7 +4687,7 @@ void f2fs_flush_sit_entries(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	down_write(&sit_i->sentry_lock);
 
-	if (!sit_i->dirty_sentries)
+	if (!sit_i->dirty_sentries && to_journal)
 		goto out;
 
 	/*
-- 
2.53.0



