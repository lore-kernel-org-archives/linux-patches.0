Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB6B161302;
	Mon, 27 May 2024 19:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837326; cv=none; b=GqLEz0yVof5Atk2KJ8AM4wqIlbG4qlzBCLqOcTYGjzpRIgniXkNbVm5XLZd5PFa3V2MDBMLA9MBjD7MyjWhAQJYt6M+uJag1bAcoIVtPjD0PnBWFXuWkE/9wB1NUVDaixQx7/R8bdh0q7c76XjNByM2EfCw+nastpj4xPsIKc8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837326; c=relaxed/simple;
	bh=MOimMQdEwXibqU45fKzdEdiLPnL2mMaeXvIW5j+ping=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2sSgrTmPnYW9rO/3BFTjUmvyFE0Ntrie9lUmKHOWuXgJc8wDfOu/ak+Zd3RVTmjFfEK9kU38FkPlrgxb1UEYdjLRAU5tJyQh334dYEFYXCqHg1Y4iZPmpWmiydR4SEqnHTclcfh7UWpTze1olesRCLNmRF/hOwPz7hrU00xdEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNjSpW8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNjSpW8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59F0C2BBFC;
	Mon, 27 May 2024 19:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837326;
	bh=MOimMQdEwXibqU45fKzdEdiLPnL2mMaeXvIW5j+ping=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNjSpW8alwbehYbeK6LLopyUAPsqQSKLwzRiANdxQRLFWMG49l8wtgdkVi5HwMe95
	 ElTcbLF9RbFyxWMn9SdibQbvrPZD5V34h7RSLgp4GRhWm5WtBOvxdoDUauTI/TuMcA
	 c8z8cOPvhg5ZcCUeCz/XlAgflCBSh8tBiFTlWa1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 396/427] ext4: fix potential unnitialized variable
Date: Mon, 27 May 2024 20:57:23 +0200
Message-ID: <20240527185634.971886005@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 12b3f196010b8..714f83632e3f9 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6113,6 +6113,7 @@ ext4_mb_new_blocks_simple(struct ext4_allocation_request *ar, int *errp)
 	ext4_mb_mark_bb(sb, block, 1, true);
 	ar->len = 1;
 
+	*errp = 0;
 	return block;
 }
 
-- 
2.43.0



