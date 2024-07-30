Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F9D1A6192;
	Tue, 30 Jul 2024 16:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357374; cv=none; b=cfnf+RuuYl7Q/CncQqcbf29y4o8DYkXo3KR5h0i1LBASFji3t8LjLFkS2NyuYRHp8Bl7sbDENuabsuRbBzHdyGasOUKRlzmXwLqWE7eyVyrWmeFIBP6doXPc8VdMOdteA58kyqBZvgMQoGHStLv0/+SydC1mawKNufaINMXdp+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357374; c=relaxed/simple;
	bh=nPwIxx1/iPDF2NlmRKy+13iQufvFjeg5cKdg24xWx4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QL8vLHrS3BuxPwTmV+Upx7K8F72/5f/YNDIv2BBaG3QGmFlyLqKJZWuvu9DhzF8m9NpGkkY0i+6Y/imx1n28fQfnUeDglctnj4Zt4LlBNQsh5yVPlnMDW687Nk54WV3CGqn6h5iAXDYgLKWB+efP1MHMjZJy3TPSdaeJbBygUIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjyopVvQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjyopVvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC88C4AF0A;
	Tue, 30 Jul 2024 16:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357373;
	bh=nPwIxx1/iPDF2NlmRKy+13iQufvFjeg5cKdg24xWx4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjyopVvQSeRpANN/g23CVmc0Pw46YGRaguNIhP95hjvFFvvMxAy6L4sP73+o9Eij+
	 St0K3eIrQWURFMUR2DKIhuNv76wLokvmoLXjiFjNEXtYyXy4ifuNT0UVdpyrl5lGql
	 KeMun86hry1WQGcCrVkQ/tqv/R8B2aqSDY3z2KyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Ben Hutchings <benh@debian.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 242/568] ext4: dont track ranges in fast_commit if inode has inlined data
Date: Tue, 30 Jul 2024 17:45:49 +0200
Message-ID: <20240730151649.340715664@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index b06de728b3b6c..5d473e50598f9 100644
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



