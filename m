Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67CD19B3D5;
	Thu,  6 Jun 2024 14:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683382; cv=none; b=Y/2SmMAZ3+udoKl87qhKa66WNQvx95ov9WzNzmqF+Rt/NwbwMqZgAj0rvMY07pY5oo4UWGd6kA1b2gc/7S7smd+lVFffs2DdgMCGoHrV74zDeMaynhMfFT5H7ugc4wBb/zDqC+vLj8elcCaIafGLxKZc6QjfCGKS6KcMBlumceo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683382; c=relaxed/simple;
	bh=VgWGRjhhEj0q93eRjICUTyR6+2BThnWphRBhfqK4nxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EU8gZASZubLglFGvm92lyl8GFsyC5+jvsAFYzvWUiB8DoxOGA0mk659gOrUGmk/qyxquoO6+5rQ0aEmwZBnHgnt7DA4s9r6Nx9DTAbuSitCzZqcV57nB3GHz3ELnQQQl/fbXEAstd0pS/QOasLa6yaNvheT4BQJqnmfclc8q++Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tk1FD4wE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tk1FD4wE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8991BC32786;
	Thu,  6 Jun 2024 14:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683382;
	bh=VgWGRjhhEj0q93eRjICUTyR6+2BThnWphRBhfqK4nxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tk1FD4wEQUjMBVAaVL6tZCKI4Lx9CAagbfgbNjitaMyWhnzbpfG2GDDQFGPxtsHxD
	 vSWjYgZ/Y4AoJIO4BqggR1BZqj/GuwVaMNekILmrYfMaV+4X3HiUqOLTnATA9hJQ6B
	 /gzeyvXQGC7M0LdoqMUZ881I/BPeYto8hQWrbVd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 265/473] ext4: fix potential unnitialized variable
Date: Thu,  6 Jun 2024 16:03:14 +0200
Message-ID: <20240606131708.702470960@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 97f4563a97c8e..71ce3ed5ab6ba 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5672,6 +5672,7 @@ ext4_mb_new_blocks_simple(struct ext4_allocation_request *ar, int *errp)
 	ext4_mb_mark_bb(sb, block, 1, 1);
 	ar->len = 1;
 
+	*errp = 0;
 	return block;
 }
 
-- 
2.43.0



