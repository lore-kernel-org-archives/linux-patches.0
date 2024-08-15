Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E19A19DF9A;
	Thu, 15 Aug 2024 13:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729498; cv=none; b=AEMwRvFeYxfu2QLu0z582b28oC7zFQSj14qa7a6oByJpPigw/HwvBH6MWv3jb94I4B0awjPfp1M6o1Dq8iqhDLG9TASf+ai7z8novCcfO9gTCMzxWxwTXp0hGB3L0srlSIat20DFYd/NtE/yyygZYvdXPSVXfzVY0nLCcEqaqw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729498; c=relaxed/simple;
	bh=DZ/5IV54XxRaSKzAjjjHCmrCiPWFIpT8Tjqy8gr+vZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uScXHJ2pYeBukKePKpMbniB12USNgzqHnCttTrD4RjtYLvhheZDFgS0+YJn5Ll1c+Ennr6bAwxdt3vXmxF2zcqwpCpY1jJuK8bY5bNVT3dC5nrRHexL9KIeUIDFaqqjuliLe9K+jo9p3rqbBnRU+ZiKc2xBJ1TQfLQvOFQZFbek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qd4UyY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qd4UyY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD60C32786;
	Thu, 15 Aug 2024 13:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729498;
	bh=DZ/5IV54XxRaSKzAjjjHCmrCiPWFIpT8Tjqy8gr+vZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0qd4UyY3Xc9Hhzi4x+EiSpV3ULcUG7iSEIUYY15JtJKVGCCEFPzk0XybrGDXDSh6N
	 kbfvGQU3ckcSuAZnZqnmN8H+MWiRXcDnDQTkfCUN5bZJn9BtN3yx5gDOpc54e6GGio
	 7VcrnqSSRHnJ/NKL16hSZ2DSww751LFGdJwJlvw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Ben Hutchings <benh@debian.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/484] ext4: dont track ranges in fast_commit if inode has inlined data
Date: Thu, 15 Aug 2024 15:19:34 +0200
Message-ID: <20240815131945.772848413@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c6814edf0ce0a..e81b886d9c673 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -617,6 +617,12 @@ void ext4_fc_track_range(handle_t *handle, struct inode *inode, ext4_lblk_t star
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



