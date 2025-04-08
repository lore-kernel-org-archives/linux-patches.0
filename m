Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0C22135CD;
	Tue,  8 Apr 2025 11:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110727; cv=none; b=pFRGBwvuVNmHBb5INmyzDBcOAXNLy80zXKCzfmqGrNTKR5a5Tx8IqNmrSmYd/Jrwb7pcYFAQ36TPDQbG/wIHdI3VYFrAA2itxfspSLMyuNQBDD9Q/S2j/Sb+sLag70rH2HFmV2NYL/2cpPuRVylga3bh/3gTWNsaNugyBA30KjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110727; c=relaxed/simple;
	bh=rwQSRbBAFebCzEmHdesWT2LfXY72d6TzkxBkja0knq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tp9KnYYPWYLsdOgeILymXH5FaupsB13W5tUYQpXznh0GGxZ2cifDUwTJFt6AB1skGQeA9O2/SfNMCawzDOMn16EyrPH0pkMpqdVwBgLlnh8v5vL4TqkYkMzWLqasefgut//I/gcks1HIV1rvouASKLkGV0YyjhYEGPuSh1i/FJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VAdqOtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VAdqOtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6DFC4CEE5;
	Tue,  8 Apr 2025 11:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110727;
	bh=rwQSRbBAFebCzEmHdesWT2LfXY72d6TzkxBkja0knq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VAdqOtOiJ1N11nhBhIu5wYqF08nzKh4mQo0IQzwMGmu2Kz1jkiCG4L9yc+u9ugMT
	 IoaTnEJedp4Mt+7wnSAVBlyxxZbox+3OZyS2eJGQ4FTlt6ybv/sl5fNd2LIFukwWP9
	 /hnfEXlMoL6QLqW606yuVgwfYCLC78TjgWT3ELxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 131/731] f2fs: fix to call f2fs_recover_quota_end() correctly
Date: Tue,  8 Apr 2025 12:40:28 +0200
Message-ID: <20250408104917.327729607@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit d8f5b91d77a651705d3f76ba0ebd5d7981533333 ]

f2fs_recover_quota_begin() and f2fs_recover_quota_end() should be called
in pair, there is some cases we may skip calling f2fs_recover_quota_end(),
fix it.

Fixes: e1bb7d3d9cbf ("f2fs: fix to recover quota data correctly")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 1beff52ae80b3..26b1021427ae0 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4800,10 +4800,10 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		}
 	}
 
+reset_checkpoint:
 #ifdef CONFIG_QUOTA
 	f2fs_recover_quota_end(sbi, quota_enabled);
 #endif
-reset_checkpoint:
 	/*
 	 * If the f2fs is not readonly and fsync data recovery succeeds,
 	 * write pointer consistency of cursegs and other zones are already
-- 
2.39.5



