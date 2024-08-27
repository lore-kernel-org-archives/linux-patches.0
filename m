Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD541BFE07;
	Tue, 27 Aug 2024 15:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772344; cv=none; b=MYlHuDwkkqR5zHEPw3PBw2ivLeHrjRJXwMLzVh6ywCUP3sXXR93gf8cyxkiP+z3ju//bqgdTJF8YAtKzO6bm7rO/yQurd2Bm9V6aR5qymE3LwJrKuGj3Rhx/BH74Kg7Jh6YgK9qlfS/G+SYzRX8xNhs0yPbs/8PF4GxB/dEY7+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772344; c=relaxed/simple;
	bh=okZIhDwxvspKhCwYn4wFnI/NgJp7/8vTsk1qL6+4Jo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8JMKE6TIELFZwoUinhCSP9WsF/JGiDyCNgF4uSO1On61YUQRIdsBQZ29XgMNZVjpJQdUSljymAtQ6FrIYS52cvya0gEu2SnV2spJ5dMnba7DKSwTWZTd03s1UMWHvYQW4zNPbgACqp/1JQqRwA+4M7f30Dq+azoWVExrkxiyjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvkQ8Plq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvkQ8Plq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D41C61071;
	Tue, 27 Aug 2024 15:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772344;
	bh=okZIhDwxvspKhCwYn4wFnI/NgJp7/8vTsk1qL6+4Jo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvkQ8Plq9afI5BDongtQW5UU3g7vL0H7SrXB26wedIIA4B4w9PzMWdqt+xbSyG3zl
	 9nZgms3Q1pG1jIulQkJZ3lmp9A9jKNYjFr+XCm1K0sVsbfaCjuN5CoeJitxRZqKFdO
	 Ld3W68pGZWHFkPu+BCEaR6PI6COo3XuN20t2oDEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 186/321] btrfs: delete pointless BUG_ON check on quota root in btrfs_qgroup_account_extent()
Date: Tue, 27 Aug 2024 16:38:14 +0200
Message-ID: <20240827143845.309105507@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

[ Upstream commit f40a3ea94881f668084f68f6b9931486b1606db0 ]

The BUG_ON is deep in the qgroup code where we can expect that it
exists. A NULL pointer would cause a crash.

It was added long ago in 550d7a2ed5db35 ("btrfs: qgroup: Add new qgroup
calculation function btrfs_qgroup_account_extents()."). It maybe made
sense back then as the quota enable/disable state machine was not that
robust as it is nowadays, so we can just delete it.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e482889667ec9..f3b066b442807 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2697,8 +2697,6 @@ int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 	if (nr_old_roots == 0 && nr_new_roots == 0)
 		goto out_free;
 
-	BUG_ON(!fs_info->quota_root);
-
 	trace_btrfs_qgroup_account_extent(fs_info, trans->transid, bytenr,
 					num_bytes, nr_old_roots, nr_new_roots);
 
-- 
2.43.0



