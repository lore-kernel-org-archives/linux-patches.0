Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E2B537FF;
	Sun,  1 Sep 2024 16:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208954; cv=none; b=Kv0UtS6TRe+tVBI+liTcBCpUf9N514px0o7vn+l4JQ9C74GxEcgDgWIgdlIpt3uK0xuonAgreefC0GNIN6qGtnLCXao2w0m+5Ld6crHEhBSYP988FEUkVCJNrwdYM3Qc0urMC5aC/PocFG6nnuWgkwOItv7kwb3uDG83xcvfu4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208954; c=relaxed/simple;
	bh=iTJQ1XZyLn5T6r+wzOF1NZMmZzIGOg843op3Svjps4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ea1l3d8E32rjzTDE8+I6V96RC59OLecPjcHhDoXaocaTcCPphuFqjOq2NW437FrKV4e4/DI3SRBxwbAgy4VxilfqoptgpPXC6jQIuySmaD6KTajXRPPftZKxMta/qM/lhw6u0Md6lvysbGC9+IOqjHnkd3nd3Avdfo0EymJzkiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZWgs7Zz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZWgs7Zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED41C4CEC3;
	Sun,  1 Sep 2024 16:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208954;
	bh=iTJQ1XZyLn5T6r+wzOF1NZMmZzIGOg843op3Svjps4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZWgs7ZzuxE+2y8CmiwjBR+6WJeiOM8HwQF6KJ0GvwE/MlptXj+72hrqRWTb5FBXF
	 RWr4Ru+hWmm3O9PPNLQV+qvQ3GbuWtBOBtddlQkwgpkLQKfNXCHGHnQ4Mm2UOLf7Ix
	 0J7/s5GHaG0bK3/Shfq7key0mqp9ZNIH9n3sqszc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/134] btrfs: delete pointless BUG_ON check on quota root in btrfs_qgroup_account_extent()
Date: Sun,  1 Sep 2024 18:16:45 +0200
Message-ID: <20240901160812.326639403@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d6184b6206ff2..7d0b7e58d66af 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2603,8 +2603,6 @@ int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 	if (nr_old_roots == 0 && nr_new_roots == 0)
 		goto out_free;
 
-	BUG_ON(!fs_info->quota_root);
-
 	trace_btrfs_qgroup_account_extent(fs_info, trans->transid, bytenr,
 					num_bytes, nr_old_roots, nr_new_roots);
 
-- 
2.43.0



