Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9A926F469;
	Tue, 27 May 2025 17:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366338; cv=none; b=tzgjwS5ZHOtFCkya0EUsgwQ0aAbIcIqi/nNK2FnWzbWM0qM3+HJJ75UU7NW0Yfg85ULN976mWEoftnYEroyKfBKsHdlBITvKvoD1Wj3DKMgLSJ1LgWkxz9e09kMt3XPmw95GKmeA6k1/dlPCq6LosFOomdU+bcD/HlyL7UCDHyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366338; c=relaxed/simple;
	bh=qsVed7Iz796JymkftpvW7xOL7peN3bNDhzO/bj/FPEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQWMSQ8UcCBw9nZWZ3VVTgsUE0Ak7HBngEd69O6v8yV4nd6LMZEFun1kdL3TJZLH6wHpm/84uHF4gZ9Y6kfSsD+e73QwUmEH0NesvUKTbNnNDq2lLBWwWoSMjHCwFVkwgxzHZLEG+OopfC51nYFTruHTUO6l/8yI8DUPzb5HsHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l08hQS1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l08hQS1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A43C4CEE9;
	Tue, 27 May 2025 17:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366337;
	bh=qsVed7Iz796JymkftpvW7xOL7peN3bNDhzO/bj/FPEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l08hQS1gfSTcWyBmlQZKLTsxESzByOwyRfUho6fWytcxugFlzUrC+jK1c8PZb4Cd8
	 7mptT8QVBbhItjYxQvIr5k1E5DlX7b5ub1bFNjVH/li/IF4i34owBBSr3JPFg1tImi
	 pN+Oj/AlFesAB7Y/45bZ1iGoZVjAK5om8hi25mKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Davidlohr Bueso <dave@stgolabs.net>,
	kdevops@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 035/783] fs/ext4: use sleeping version of sb_find_get_block()
Date: Tue, 27 May 2025 18:17:12 +0200
Message-ID: <20250527162514.555536559@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit 6e8f57fd09c9fb569d10b2ccc3878155b702591a ]

Enable ext4_free_blocks() to use it, which has a cond_resched to begin
with. Convert to the new nonatomic flavor to benefit from potential
performance benefits and adapt in the future vs migration such that
semantics are kept.

Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://kdevops.org/ext4/v6.15-rc2.html # [0]
Link: https://lore.kernel.org/all/aAAEvcrmREWa1SKF@bombadil.infradead.org/ # [1]
Link: https://lore.kernel.org/20250418015921.132400-7-dave@stgolabs.net
Tested-by: kdevops@lists.linux.dev
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b25a27c866969..d6f1e61c6dc82 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6644,7 +6644,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		for (i = 0; i < count; i++) {
 			cond_resched();
 			if (is_metadata)
-				bh = sb_find_get_block(inode->i_sb, block + i);
+				bh = sb_find_get_block_nonatomic(inode->i_sb,
+								 block + i);
 			ext4_forget(handle, is_metadata, inode, bh, block + i);
 		}
 	}
-- 
2.39.5



