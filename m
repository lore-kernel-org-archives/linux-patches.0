Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBA32FFDC4;
	Tue, 12 Aug 2025 18:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024792; cv=none; b=Ay9YTiF6wi9Xz5Esr7qVBGFe7ENkIwwpJIbweHLR04kI1CtLyaN+xnEla5R7mUaKFpqps+szheJYdtlZk7I2glXFzCkmBeIiHzp7tHMjbC5bQmev7MmktPIRj/ho7anuu/27KP08zrkbjAOTMaDIbSPlk3TPwhejw+AVWPdcybE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024792; c=relaxed/simple;
	bh=QA0staZXItnXaQu24cYzuAo99K6ST8zsfkSc4yt1xBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hhf7lEIdfpd0FeaPyovCMZNQmXIAuaKjy3mTlI/92UNbeHwnh5ieVsfOfccFFHt2Ib8ZukIS7Ja/5x7BZLjEH67PbwJ7wuGCRDkIZRESzORAYgO5aLZcy78pCJ+jXcxMM7kNcZJkZSM5bDD60k/5H01ofzkMJPROcecCZuKd/FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyXkJWfT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyXkJWfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54471C4CEF0;
	Tue, 12 Aug 2025 18:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024791;
	bh=QA0staZXItnXaQu24cYzuAo99K6ST8zsfkSc4yt1xBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyXkJWfTgQn1uD9HqKGCl0ubG7w3wyipE+Go1CNdKolzzUH3DbUlt+OCtlGEW5tF6
	 n0i42cfZiVxErh54kv3bFCn2XavkLZqd404QGHqT0GU4OrJij9TSnhrIxeNbumQppu
	 m1oR8geeN/eWRJ3a/ES5URswrWi35oBaNCXF7lJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 478/627] f2fs: fix to check upper boundary for gc_valid_thresh_ratio
Date: Tue, 12 Aug 2025 19:32:53 +0200
Message-ID: <20250812173442.586693539@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 7a96d1d73ce9de5041e891a623b722f900651561 ]

This patch adds missing upper boundary check while setting
gc_valid_thresh_ratio via sysfs.

Fixes: e791d00bd06c ("f2fs: add valid block ratio not to do excessive GC for one time GC")
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index d0ec9963ff1b..173ad1a72746 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -635,6 +635,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 		return count;
 	}
 
+	if (!strcmp(a->attr.name, "gc_valid_thresh_ratio")) {
+		if (t > 100)
+			return -EINVAL;
+		*ui = (unsigned int)t;
+		return count;
+	}
+
 #ifdef CONFIG_F2FS_IOSTAT
 	if (!strcmp(a->attr.name, "iostat_enable")) {
 		sbi->iostat_enable = !!t;
-- 
2.39.5



