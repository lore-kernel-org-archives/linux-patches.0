Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DAE23FC54;
	Fri, 31 Oct 2025 14:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919523; cv=none; b=slgvDfKu6qUnC5Qhdea5kG+Ac5TbXJHTZWiN9p3FsB4KdhkPUT2+Lfb208QqfZzBM4AQL07IfxtdGJPJDDJSngQ4TS4PCvuiIdh0h+CQW1Ks64IyiAbsiruFeSRPEPCpNWx+GDTTa37BQHRkv7d0Z7wFk06TfZH/NxmDiiElbU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919523; c=relaxed/simple;
	bh=XKoaNGqqoLQYN5pPqlI6Kyw52tCfz8zf3VXtJjBhZ9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKCNwp6A+XP5wNYQIkH13tRzgMafE7+XeVez4GGkEu56AtlLztSfVXkyTebG67u/8a/gzSJU3VKa1KNlZ8L4CW5Q6YI0gxz0i4+AWVCQVgyg031z1vaXxGu22tkxi2OLjFO8VmhO9OLEPw6T4HirzeWK3MgKX28i5t/JAEjgM08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnL/43KG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnL/43KG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9908CC4CEE7;
	Fri, 31 Oct 2025 14:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919523;
	bh=XKoaNGqqoLQYN5pPqlI6Kyw52tCfz8zf3VXtJjBhZ9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnL/43KGaC6sc65o8hoxev65T7QLvVmI4zjmH3Z+O+CYOMvukqQ6i+KGU5i4b6/EW
	 ese42idb9BVdIM3G7qMTeNCPeOoTMVChw4wfIWSQX/NeYVVZLsqppomtCRhl6m91le
	 u9QJHGJ9CyWa5i1Vcj5LaKa5u2Y3m9IpL//1/nsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 18/40] btrfs: use level argument in log tree walk callback replay_one_buffer()
Date: Fri, 31 Oct 2025 15:01:11 +0100
Message-ID: <20251031140044.451625442@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 6cb7f0b8c9b0d6a35682335fea88bd26f089306f ]

We already have the extent buffer's level in an argument, there's no need
to first ensure the extent buffer's data is loaded (by calling
btrfs_read_extent_buffer()) and then call btrfs_header_level() to check
the level. So use the level argument and do the check before calling
btrfs_read_extent_buffer().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 63b14005f5066..b43a7c0c7cb7a 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2443,15 +2443,13 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 	int i;
 	int ret;
 
+	if (level != 0)
+		return 0;
+
 	ret = btrfs_read_extent_buffer(eb, &check);
 	if (ret)
 		return ret;
 
-	level = btrfs_header_level(eb);
-
-	if (level != 0)
-		return 0;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-- 
2.51.0



