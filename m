Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8F34A07;
	Thu, 13 Jun 2024 12:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282109; cv=none; b=brWMA42Gtob26A1u9I/0fIzDAcJvJRCMJBLPeGmVjoI7ZTzZ6XewRRPfpB49K62v18gucxBXmtHtTuAX4mwHe2Zeon/u4Sqbj6Dq5z5M4h7cuIAGqRXGNg60dpzD3PWMiJnHaOYwIxFhbEaWv6KqD362oFksmIhsuKcACbGnscU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282109; c=relaxed/simple;
	bh=RAwtk1ElnbwwHnlfZQkawa7k+I65ejba353nxaHeLS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNnzN9UMMJdtwrTp7DCToLnEyyWup4+qcbKxGpj6ReRU6JzHxZRStNmGgK5ygrIFmxoUS8l1eOyBoA2ChTaXDrMeSku6fOGi0pll7Ytj5IQQcbRlk///wO3WzPNTKuvXqMNbHJ1eSUPUWwVN8e6aCCk0ha5bzwZlVjFGkO17K2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPW/QQzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPW/QQzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96433C2BBFC;
	Thu, 13 Jun 2024 12:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282109;
	bh=RAwtk1ElnbwwHnlfZQkawa7k+I65ejba353nxaHeLS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPW/QQztdJ8+ep3A8nAxPmSXjCSPKZ5aSDLN2sj8cQuJFutb0HnDLn90AEdaAMxc8
	 hNR9Y/eY0lMtf3tmuE4A1zoDXeFFtH0Iv7kr9FRP3rXZ6C9UW3zAstGHUu+5H2iVVi
	 hA1roITloPyxbUh6anYb38pYbZti05s2GS7bWMgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/402] ext4: fix potential unnitialized variable
Date: Thu, 13 Jun 2024 13:32:03 +0200
Message-ID: <20240613113308.613001139@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 3f4830abd236d0428e50451e1ecb62e14c365e9b ]

Smatch complains "err" can be uninitialized in the caller.

    fs/ext4/indirect.c:349 ext4_alloc_branch()
    error: uninitialized symbol 'err'.

Set the error to zero on the success path.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/363a4673-0fb8-4adf-b4fb-90a499077276@moroto.mountain
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e85123e447f14..1145664a0bb71 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5684,6 +5684,7 @@ ext4_mb_new_blocks_simple(struct ext4_allocation_request *ar, int *errp)
 	ext4_mb_mark_bb(sb, block, 1, 1);
 	ar->len = 1;
 
+	*errp = 0;
 	return block;
 }
 
-- 
2.43.0



