Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5412FF173;
	Tue, 12 Aug 2025 18:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021632; cv=none; b=Cp2OI/geZ+lrp+YompJTo2pEae2SNq//0o0soaohtyC97QEfuYHlEQUPMPmoQEnFIKNEQunk/wCxVwsDkX1KdSy3zPGf+pH+l4nLSx/C//ehPKx29TRTgkoz6zvbId2/5ve9I/0UMSw71J8R7GkU4a1QVbng/BJZ8x9GOAdDhHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021632; c=relaxed/simple;
	bh=aFlHBXAhg+C1uXAduXvi3j2rdRh61bYUPMdYESlYHMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4ES/ZeNEkgcKduZ31d7/vZcXtEmtfLp1/wxcBGq279iRWiyn+B6ZQAqaRx6qtorulaOn7zX/3Lpb3GDDJG+yUo4nYbzxnawWTUlhpJfWqjPUoGmWNna2b9gSRxyjrgyf4AgVOLdf9X7VtqKFbV3/r4zOuve7c9JCzGXD3Dv6mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcyZjyZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcyZjyZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FE8C4CEF0;
	Tue, 12 Aug 2025 18:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021631;
	bh=aFlHBXAhg+C1uXAduXvi3j2rdRh61bYUPMdYESlYHMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcyZjyZV48FcRhDx2zsdFKXuLbvE9KPL6EqJN3wA3gNo7Bq6qghyfM0Ly8TJlzR2B
	 Mf8be34Gz172Q/FqY+tAO/goI8vESoRZZk0LpJUeqA/CzQDqsYlwNDnpgEvlMunoY7
	 deHmV1fDkqimuh6PJ7gKhxSBnxUhU8oJKmm77KpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/262] f2fs: fix to update upper_p in __get_secs_required() correctly
Date: Tue, 12 Aug 2025 19:29:26 +0200
Message-ID: <20250812173000.703193669@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cd2ec6acc717..66b89687fab1 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -616,7 +616,7 @@ static inline void __get_secs_required(struct f2fs_sb_info *sbi,
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



