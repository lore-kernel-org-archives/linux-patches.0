Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AD5217F35;
	Tue, 12 Aug 2025 19:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026463; cv=none; b=GMgA55J1turdJEETPhLfiDnHgHJkZBYepbCC6mroPDx0QxTEXNyNBCRqsN4OEIx/Kmn0YvbhbfcEzrrJ93A/vMKzN7wF15iehcS4NkaL4sJxroqFc0Ylo8Ln19EwHp8cxQ6+LTG7llbkSQOPhqyD0pe9xBMLYnKGZCcOtQHBBJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026463; c=relaxed/simple;
	bh=vSq2EmlmkD4k26Aejo4pgK4tF5VAu9bOxKPK/7Y5QqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NH5frWBO8FNKrGo3RCDWz6WHJbw4YTYSB1wq1XMhZtglewoRz/sdQTuxBBPItKGETgPSmIJLKn1BD41VOrwNJIyozhWxLbsdkJ77Ej2yFmZFehGfFJA6x7MWwdyVhEE1cyfB8tSxJjQxin3VIXN9a5cggUhlI60MtweQnuqsQhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+tkXzR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+tkXzR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E365DC4CEF0;
	Tue, 12 Aug 2025 19:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026463;
	bh=vSq2EmlmkD4k26Aejo4pgK4tF5VAu9bOxKPK/7Y5QqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+tkXzR/KXiUVwgmS/HbMMk3/fimYRjSmDQpeixPfygAkyEtE1tB97hkW08AUfFD+
	 cYPo3pi38QBzgj8S4uE5OOYq+K1OhdF1UJeeCl9+huxQPmOuzri8PICU+EEw/tqLuQ
	 HMWFLLdJV5vMURVAQOKRKqueQbvb20B2i+0oPiXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 345/480] f2fs: turn off one_time when forcibly set to foreground GC
Date: Tue, 12 Aug 2025 19:49:13 +0200
Message-ID: <20250812174411.663357818@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 8142daf8a53806689186ee255cc02f89af7f8890 ]

one_time mode is only for background GC. So, we need to set it back to
false when foreground GC is enforced.

Fixes: 9748c2ddea4a ("f2fs: do FG_GC when GC boosting is required for zoned devices")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 8b5a55b72264..67f04d140e0f 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1893,6 +1893,7 @@ int f2fs_gc(struct f2fs_sb_info *sbi, struct f2fs_gc_control *gc_control)
 	/* Let's run FG_GC, if we don't have enough space. */
 	if (has_not_enough_free_secs(sbi, 0, 0)) {
 		gc_type = FG_GC;
+		gc_control->one_time = false;
 
 		/*
 		 * For example, if there are many prefree_segments below given
-- 
2.39.5



