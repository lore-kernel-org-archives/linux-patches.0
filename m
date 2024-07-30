Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2D318801A;
	Tue, 30 Jul 2024 16:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358664; cv=none; b=VRhiveeBJc5XU1dyfrGV/RA1mqSKAy+T36Rmer0xhZN9vq3065fONmwuPvaYfdKtZWSkaDpiT6AnssksO5UQlKePXGFpl+U1ERuc2Zu7xZ+89xLAh1pgOV08EyRG6Y97+Zw/kxRNiaQ4cv86id/PXM/fOM+AU8LlWZvryyIS5H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358664; c=relaxed/simple;
	bh=h/QTKwqImn0KmAVWg1h7DxWoe3ZUNqN+5QxfjuxwsFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBpUEfwgCyNWkIi1cQPN1wPE/1et78i8/93LvmIXly2ddpvAwRV4jaxyQOS94+k8HvgSDvLSRVXwqK6NDt9IJ+AtVLgsJei3uUH/b4TIdK3Yrn8G3VfNIY2d5SfAB90pSVpoXLR8pBu9EvGrhPF7MDg5i89ywR0MqWP57lPNIeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PrAggOg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PrAggOg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380BCC32782;
	Tue, 30 Jul 2024 16:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358664;
	bh=h/QTKwqImn0KmAVWg1h7DxWoe3ZUNqN+5QxfjuxwsFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrAggOg0ei3+QbbttNJsPkfDvXssuEVVg2l1uMPc1ET8tprxHg91vs4kMMQPqWLkW
	 vhzOW++ttFm66GvmxdrXQo0fsOwfRQNS7A/gmuSQDEcaX6ZtXG9Ut/oKUDvs6hviVl
	 9JRjvzFA48aifJ6b54x+EN3HX2CK68TtAQDu0Oa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Ben Hutchings <benh@debian.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 371/809] ext4: dont track ranges in fast_commit if inode has inlined data
Date: Tue, 30 Jul 2024 17:44:07 +0200
Message-ID: <20240730151739.313958192@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 87c009e0c59a5..d3a67bc06d109 100644
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



