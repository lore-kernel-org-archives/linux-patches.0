Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F366BB29;
	Thu, 11 Apr 2024 10:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832366; cv=none; b=VOd6yDa38NJYAS0W+5nSTO6XoQAMhykhX/YqbEi+Tu1JnOK3EY6rFS+PiHUbaNA+vNxIz/0C+TAtYFSXeaT5O5aGfHgmS0GAqQMU038TN+q68RTq68D2HBFmL0Kc3REI9PuVYPY/xKRp6Q54hqKiywkSsHYAhNVdKvM5dTNyvaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832366; c=relaxed/simple;
	bh=5cLvQSq28LuKM9nfnlueRzO1qrV84di4nttOLvXINs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdMCbHOA+jVAw0lGSDpHmFTTZUlf7YtDdD+7DOMZQjI+ovsLxiiBXKiSFdVO+rl5c2w75hCfzo5TnKVOXONd5Uns/Zi4Pnqn+BzSWulAJyT4uecczsSajMqfi/bsfR5AxrH4q32y1bGo8yRfH926GNpRdaMaK8cz1KCHLeDPa2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMFtY3yM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMFtY3yM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945A8C433C7;
	Thu, 11 Apr 2024 10:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832366;
	bh=5cLvQSq28LuKM9nfnlueRzO1qrV84di4nttOLvXINs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMFtY3yMbAykcRnxlnytPVqEYLRu/foU9KEmLsvsVjxsiX8KQQ1np938PUIu/bK4g
	 GidQpCYIJRr79gesrPfprEtyR9te/bs5z+zO3290pTtOXi9VzJ9tUBN2U5IgIRPfy7
	 B32yZdYvrq+Nnt1nOqh+mu3LihDph5l2h7LUX4Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/83] btrfs: send: handle path ref underflow in header iterate_inode_ref()
Date: Thu, 11 Apr 2024 11:56:56 +0200
Message-ID: <20240411095413.406713522@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 3c6ee34c6f9cd12802326da26631232a61743501 ]

Change BUG_ON to proper error handling if building the path buffer
fails. The pointers are not printed so we don't accidentally leak kernel
addresses.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 9f7ffd9ef6fd7..754a9fb0165fa 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1015,7 +1015,15 @@ static int iterate_inode_ref(struct btrfs_root *root, struct btrfs_path *path,
 					ret = PTR_ERR(start);
 					goto out;
 				}
-				BUG_ON(start < p->buf);
+				if (unlikely(start < p->buf)) {
+					btrfs_err(root->fs_info,
+			"send: path ref buffer underflow for key (%llu %u %llu)",
+						  found_key->objectid,
+						  found_key->type,
+						  found_key->offset);
+					ret = -EINVAL;
+					goto out;
+				}
 			}
 			p->start = start;
 		} else {
-- 
2.43.0



