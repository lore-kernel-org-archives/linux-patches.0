Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4163E1A616E;
	Tue, 30 Jul 2024 16:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356256; cv=none; b=E6L3NXe1iyiTXzXyCOiFqkUZRT0nJVH8SBpbyA2Wm7ZnSQ9afliMDk/CiRsKQ0GXnpELn+BjP6w2V4ePYbadMi8a74kSsRDOgPXSfz04iNNuL+OQ3dJSPKMyX8GoLdaua2i9Sfli0W0YmMwEixn3kzyQbMSBkPl7pKnN0nx3QAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356256; c=relaxed/simple;
	bh=Fb7iM616dWw310G4Q016cMtycSwVkLvDm80nJ3ySMCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLqjZhXfCo6UBi3jqSeA6A6eFaVljkNbTI6zwD2qN0t39oqHehISot4ykoxxn3zxJTN8WsdML9+ZmlYS2624tjCd56ZTP4i3oQegpK23WB1wVxBB1JFu9x7mSHOB4GYAr2yOUiNQm+vYSKOkM6YD5TLprhp/FYyMYyX8yGnkSLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrVuYZwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrVuYZwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2B8C32782;
	Tue, 30 Jul 2024 16:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356255;
	bh=Fb7iM616dWw310G4Q016cMtycSwVkLvDm80nJ3ySMCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrVuYZwSNz1d53SwTrEWef/XS28KAKQNQ7PezS2NllQa/DEnf3f6HKmugC88famLN
	 92zuDDQurnqKMuyZkscMsZJBMhNwN+yKuCS4xsNGcLQg8mFki4Jsg8eUJCkJvrxwEp
	 xWpyaBVjZ/6f0EzK9QcKc2kVIxrFS8QmXmWStGrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Ben Hutchings <benh@debian.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/440] ext4: dont track ranges in fast_commit if inode has inlined data
Date: Tue, 30 Jul 2024 17:46:46 +0200
Message-ID: <20240730151622.631986828@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

[ Upstream commit 7882b0187bbeb647967a7b5998ce4ad26ef68a9a ]

When fast-commit needs to track ranges, it has to handle inodes that have
inlined data in a different way because ext4_fc_write_inode_data(), in the
actual commit path, will attempt to map the required blocks for the range.
However, inodes that have inlined data will have it's data stored in
inode->i_block and, eventually, in the extended attribute space.

Unfortunately, because fast commit doesn't currently support extended
attributes, the solution is to mark this commit as ineligible.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1039883
Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Tested-by: Ben Hutchings <benh@debian.org>
Fixes: 9725958bb75c ("ext4: fast commit may miss tracking unwritten range during ftruncate")
Link: https://patch.msgid.link/20240618144312.17786-1-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/fast_commit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 1110bfa0a5b73..19353a2f44bb3 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -649,6 +649,12 @@ void ext4_fc_track_range(handle_t *handle, struct inode *inode, ext4_lblk_t star
 	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
 		return;
 
+	if (ext4_has_inline_data(inode)) {
+		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR,
+					handle);
+		return;
+	}
+
 	args.start = start;
 	args.end = end;
 
-- 
2.43.0



