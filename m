Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479D33A6418;
	Sat, 17 Oct 2026 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256126; cv=none; b=sWLOzS/dZMLShHrQPeHZnuucYMWvkycDg18mmXOx2VA2jV7T/hSie18wxFO4ho+pkio3eS9uKImzNkRWzqtd2YLju7A01rzRyx+qmvkz8N387e9QYOZg5mXptRbL/hgvjEnJu4vL0x76zC9VVv/686DA5KlP5pG0bBpYAhTrv1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256126; c=relaxed/simple;
	bh=QnMKhPFPmZIIu1JVxt3OSjwlzyvfPiXnpqIzJJpZztU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiV9Qa54d5vbalC431XIAm9UrfpxJYON8QI/5QtnFu2lcQIsmI6QsJZOeKjTEbF2Hd9tkvOzpfNOAcAA12aDqfS8mYu8W/WeHWCjZAXUe9SEoUc1a3e4HHpFo80eBByx9mS5/+qc54uFXps9brWy679mq/eBEcH06/q3snMybI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSHls2LL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSHls2LL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936381F000C4;
	Sat, 17 Oct 2026 16:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256125;
	bh=QxEDCBc+cvpMeuonQb4bPUvaJ1MQ2VDf55L2RYw0PQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZSHls2LL2XAxvtD98YY894p+TWKfkgyi7FvFqgsGKousnWv48wNEk75sxjAa4ucUH
	 umzrZccryf5Xw+/dORSlDLqamqiREVF6uLkuUFBZVWzSlNsPG8gccS9jh6q9GKGcuY
	 OcpGMyD8nNCD7OMQEPoEcAHMlNrTU4onBFGvUDN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0116/1674] btrfs: take commit root semaphore when iterating in mark_block_group_to_copy()
Date: Sat, 17 Oct 2026 17:39:48 +0200
Message-ID: <20261017160434.126766290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 0594e3423f4ba3137c734371169491f9a98e9af4 ]

mark_block_group_to_copy() iterates over the commit root with
skip_locking=true. A concurrent transaction commit can swap and free
the commit root during iteration, causing use-after-free when
accessing extent buffers.

Fix it by using path->need_commit_sem to protect the commit root search.

Fixes: 78ce9fc269af ("btrfs: zoned: mark block groups to copy for device-replace")
CC: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.5
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ changed path->need_commit_sem assignment from true to 1 to match the older unsigned bitfield representation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/dev-replace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index f77ef719a3b11..4f97a9222b74e 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -506,6 +506,7 @@ static int mark_block_group_to_copy(struct btrfs_fs_info *fs_info,
 	path->reada = READA_FORWARD;
 	path->search_commit_root = 1;
 	path->skip_locking = 1;
+	path->need_commit_sem = 1;
 
 	key.objectid = src_dev->devid;
 	key.type = BTRFS_DEV_EXTENT_KEY;
-- 
2.53.0



