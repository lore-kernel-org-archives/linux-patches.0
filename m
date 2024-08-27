Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848891BA294;
	Tue, 27 Aug 2024 14:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770429; cv=none; b=LrPXxmI0X8Un5z/2NCAHqtJFojhVTpCcer8iHD5TBfexHFr6qSmOubEufmjsAJAtl6sOamgtGodKTxxNBP3L1QJ1v/ZBBt9SCaCf0cUhCBpOEXfjWOEZb+DmrTrnh3HmGRAnhccCQwQO88xYJCA+1XHoBGz/i3asDFjYnoYHDfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770429; c=relaxed/simple;
	bh=PxO15zOZRycx4FLq9kCi25Sj6Q+DFuCHSzA9FLCwqpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A30Ot1qmDJEx9ug+bhN17OY1rqV9TdDgYjRknacbduveOtU9tXrdc/ywwyLAbZaMCBLifCHP5VtbyVpOSNlyDN6oFAI6rzns4oyj9JPuN8nbvtiMgvYGgzTzKNd6hytArqix5Zr2wpfvXtB/z4l/NPAL3Xi80o3D5agUjrWiFD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klGtT0ZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klGtT0ZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA52C6105B;
	Tue, 27 Aug 2024 14:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770429;
	bh=PxO15zOZRycx4FLq9kCi25Sj6Q+DFuCHSzA9FLCwqpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klGtT0ZTuBc0KFrYkrFYV6Wte6wlfvVbkWl6Ez5DiW8IjsXJ92sVpi351XiUQjABn
	 6jh9E6uEXQrFdkKSeDEEbONAxEK+Cqjgx60XkRNs4lFwcNgcwI14kmr+mhr/CVp9Pf
	 lTABU456H3lgVIU4ozQwzrD0OS1I7fIE/sVg/iJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/341] btrfs: defrag: change BUG_ON to assertion in btrfs_defrag_leaves()
Date: Tue, 27 Aug 2024 16:36:56 +0200
Message-ID: <20240827143850.452677824@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 51d4be540054be32d7ce28b63ea9b84ac6ff1db2 ]

The BUG_ON verifies a condition that should be guaranteed by the correct
use of the path search (with keep_locks and lowest_level set), an
assertion is the suitable check.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/defrag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index a2e614cf3c19c..e1475dfdf7a8b 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -416,7 +416,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 	 * keep_locks set and lowest_level is 1, regardless of the value of
 	 * path->slots[1].
 	 */
-	BUG_ON(path->locks[1] == 0);
+	ASSERT(path->locks[1] != 0);
 	ret = btrfs_realloc_node(trans, root,
 				 path->nodes[1], 0,
 				 &last_ret,
-- 
2.43.0



