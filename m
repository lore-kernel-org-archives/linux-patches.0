Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D020829CE7;
	Wed,  2 Oct 2024 13:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877265; cv=none; b=jdM2uIhl6BsSF7IXEw2FCpPFPXv6bumK5S2UYYPHoxWqDjO1zlenyJp7TiF5brABFT03e7qG07TtBALMeCP7Fef+jEb8kSKxI1hBLd6/9P6lg5TTkmnZdqExgPxr2LldGXKLhw83j1AGaC8PqBNhdrRBCDGANAtDc6VWpP1GZ3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877265; c=relaxed/simple;
	bh=WkEJwNd1xhb1RizIkWvvNyilBrs9yKTFIyYm7Npx8FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlnra5xWQBEVOGrh9n6uXJKoifPc+2G32CRimUrpNZMFeuUF1gUCsyIBAz7VqzbCM7PAll+eDWAYuPvY43IhpmyDj4TtWcKe/Wpryl8Mc27A6sDvKraatT3jdb5DPJAsN4FFxVEbw/d39hS4Ksy68J1/ooEf0bURNc4nrlXmjmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHoKou3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHoKou3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CA7C4CEF2;
	Wed,  2 Oct 2024 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877265;
	bh=WkEJwNd1xhb1RizIkWvvNyilBrs9yKTFIyYm7Npx8FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHoKou3PLWNLbOPk8uwenb3ATPSJpHHslT4A2e6NxB57SKDb0ZsB06Ws0O8+C879+
	 q3R8crfE8J01svGZnm/+N9wJVsP/ijOZ7xJNFTTU50Cpd55eAqOT1la0L8SHQiYjpu
	 c5LNJZABIBCJjlz65APlzB8qoLxWvI9pwZWiYoTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 024/634] autofs: fix missing fput for FSCONFIG_SET_FD
Date: Wed,  2 Oct 2024 14:52:04 +0200
Message-ID: <20241002125812.049934612@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksa Sarai <cyphar@cyphar.com>

[ Upstream commit 6a64c5220c5df235448b846aeff3c0660d4cc83e ]

If you pass an fd using FSCONFIG_SET_FD, autofs_parse_fd() "steals" the
param->file and so the fs_context infrastructure will not do fput() for
us.

Fixes: e6ec453bd0f0 ("autofs: convert autofs to use the new mount api")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Link: https://lore.kernel.org/r/20240731-fsconfig-fsparam_fd-fixes-v2-1-e7c472224417@cyphar.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/autofs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index 1f5db68636631..bb404bfce036b 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -172,8 +172,7 @@ static int autofs_parse_fd(struct fs_context *fc, struct autofs_sb_info *sbi,
 	ret = autofs_check_pipe(pipe);
 	if (ret < 0) {
 		errorf(fc, "Invalid/unusable pipe");
-		if (param->type != fs_value_is_file)
-			fput(pipe);
+		fput(pipe);
 		return -EBADF;
 	}
 
-- 
2.43.0



