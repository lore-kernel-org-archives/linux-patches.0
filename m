Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443E82FF15D;
	Tue, 12 Aug 2025 18:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024819; cv=none; b=O/t3Fqv4HNA1ysXjHhoV4x5MBHK5aDR6xzIg3MMijm8FB+1rf/xcWaboCOL73A9WWweFF2bi+f6AiGL5acKUqsaP4wRYXUmumXGTedc6Jv11vdsvwo0XoZGDBTA+6K7FTFA3IkXKfyIJ/hibC/tOdUnQuPXWAm3djKgjNbOuZYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024819; c=relaxed/simple;
	bh=8nA6tfCm++n+10gJ9bz38TofmhOsVP/yPq/Bu/5NN20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khA+Fkpv/q0XQEcZbPjw6LdHxvWoSqpwgP7D6bk4qT8cpxxrIrpI03GJVhm9B5D2jqd7Q9Y+nh66AVASmA0hrqU4eGQDjg/fHnIixUu9gaapKKsjGLiYXz/twAtlzyVgsbEJsZfPzgxRb/WnlCPKZap+Z/sXMd9xTbUFYXFgA/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tT6n/cLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tT6n/cLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8145C4CEF0;
	Tue, 12 Aug 2025 18:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024819;
	bh=8nA6tfCm++n+10gJ9bz38TofmhOsVP/yPq/Bu/5NN20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tT6n/cLHfZTWn/EtQlgZhiuJBTSbJ6leJDfXSFh9KlqapdVzShYdcKO3F2stsq8DO
	 noOpaWaW3d4wkIQ1Frs2EnK0w7uNfWVyTFpUaA1jfX6jZfS529I+QRA5ChyrnaXhBp
	 lWsDV7YUF09jsTZbEP7d7l//TdRwwMj21emBKM+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 485/627] f2fs: fix to update upper_p in __get_secs_required() correctly
Date: Tue, 12 Aug 2025 19:33:00 +0200
Message-ID: <20250812173444.027348692@linuxfoundation.org>
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

[ Upstream commit 6840faddb65683b4e7bd8196f177b038a1e19faf ]

Commit 1acd73edbbfe ("f2fs: fix to account dirty data in __get_secs_required()")
missed to calculate upper_p w/ data_secs, fix it.

Fixes: 1acd73edbbfe ("f2fs: fix to account dirty data in __get_secs_required()")
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index db619fd2f51a..f11822ec3fec 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -684,7 +684,7 @@ static inline void __get_secs_required(struct f2fs_sb_info *sbi,
 	if (lower_p)
 		*lower_p = node_secs + dent_secs + data_secs;
 	if (upper_p)
-		*upper_p = node_secs + dent_secs +
+		*upper_p = node_secs + dent_secs + data_secs +
 			(node_blocks ? 1 : 0) + (dent_blocks ? 1 : 0) +
 			(data_blocks ? 1 : 0);
 	if (curseg_p)
-- 
2.39.5



