Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AA72376E4;
	Fri, 31 Oct 2025 14:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919632; cv=none; b=GFQaYptmT0lR+VGWzM56uintW6fxJUxiSu85o80nkRD6wOsLNQRi/OAfnF/uPUQXOnYEaXL+B0IF1XM2swLokmIsJP5t8bauBaZ/IPCVk8IvWd0CrwSoqgdkhnjjkXHVA9TRhzYRensMmcmQje8y7OVxCyPqAJNn0GZ7weFi1dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919632; c=relaxed/simple;
	bh=KKjYKJBx1XujnmxIh6XqMyP2oknWDDBKjUNF9AswvTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxailjsfMWMf3ilS86D60REO1QdCChMpt/nuVwsEVoWTmxalmUDlYmN9v9QerMDIMvnCPmFe8BuHYsH4jt7FgIUqZRuiHNJDeuTV+Rt7POTR9UoJbw4U/t21cH97jtB5RtKaOUzGDV5Nr7X7B/gHSVQO1UAmI0RAeB3aMNSUEjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xya5ysxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xya5ysxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC53C4CEE7;
	Fri, 31 Oct 2025 14:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919632;
	bh=KKjYKJBx1XujnmxIh6XqMyP2oknWDDBKjUNF9AswvTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xya5ysxAHH6aUOvpH6WDitbSvA8X0Xy8VLcDEcEcLSwENEDYVtNDnowvOlX500LZO
	 Ek9VM7tmPUxr5se5+CjDTBmmHAhmzLHNvCOrggqVE5jHBJa9jx2BuZOx7xfoROaCku
	 XwJClgPSJKgMpY4FyMlK5iXpjRX18gcXYsF1/8ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 30/35] btrfs: use level argument in log tree walk callback replay_one_buffer()
Date: Fri, 31 Oct 2025 15:01:38 +0100
Message-ID: <20251031140044.364189212@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 518cd74191e77..4f92aa15d9b1d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2461,15 +2461,13 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
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



