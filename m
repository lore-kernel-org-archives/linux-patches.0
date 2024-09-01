Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3E644C93;
	Sun,  1 Sep 2024 16:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209638; cv=none; b=i77HUR5nI2UX4LT9V1pEw+uMBAFbdQ2mV/1i6xzu7JgJSq5wwGu/CxHqO2dvx5o3Be7qQ2t8pXNc4F2Yh6UlSFSG3/mEu6bEB/1apwtwkzG1RZ1gMrdamMGPHy/+qqjjDQHnRsCYA8fy6t4eiUv6r2A8Gca2cTIo4JS6DqXGoIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209638; c=relaxed/simple;
	bh=zAXDs0tD0K9mKy9EatKAhjM3/ZX2UqIWuYl7xBzJY4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eo4FMzwPuCfSX9xnVL43ZOvX3oXtG3F2jVvftlARJ7H+bdbkxQw+zYaDPZLcurgXcDKdEZ5u7vXUzjkeiGWBzTxDyPwHK3TIXVcjgQ719OUQJ3ULGmfEGSLFdQNORmkYhYt+oGmphhIXZNhUCy+mzgh2gHp/6CxfQk0YV+NdaIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghl6Lttq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghl6Lttq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7399BC4CEC3;
	Sun,  1 Sep 2024 16:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209637;
	bh=zAXDs0tD0K9mKy9EatKAhjM3/ZX2UqIWuYl7xBzJY4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghl6LttqhxkyIG52bX9dS/V9mDwkKO5bEG/l0OfmBYTlLLd04SeShSF3zq83dZCTZ
	 VzIgzt6otqa3hG9JYVt0sEpfKHGj2xSYaXdsfe7o7MvzXgdJxU6wVIVoYJuSJ00N4H
	 Tsop6PAdFyHDfTOouMwpCdiWeGijvjJohu6D9hf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/151] btrfs: delete pointless BUG_ON check on quota root in btrfs_qgroup_account_extent()
Date: Sun,  1 Sep 2024 18:17:07 +0200
Message-ID: <20240901160816.639048906@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 83d17f22335b1..7518ab3b409c5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2658,8 +2658,6 @@ int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 	if (nr_old_roots == 0 && nr_new_roots == 0)
 		goto out_free;
 
-	BUG_ON(!fs_info->quota_root);
-
 	trace_btrfs_qgroup_account_extent(fs_info, trans->transid, bytenr,
 					num_bytes, nr_old_roots, nr_new_roots);
 
-- 
2.43.0



