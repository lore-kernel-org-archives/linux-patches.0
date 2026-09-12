Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33DC191F93;
	Sat, 12 Sep 2026 14:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224046; cv=none; b=l4jmb4vUoQRNm5AUaNyqpILPX9gBe+PAOx9OwYnhd20m6aERc21m6KAcG9vK6km8QrLrV/0e4RmidM7qkSnyTCQ6WhA1D2bP5VLxRhyyhiRSOVwF5DT0OEG4YcPKFptjDgXEsfMS0RTQ+PFlGuFBoVL+Mg80FpS6TH3NSnuknRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224046; c=relaxed/simple;
	bh=2wFoSCex10AXvdfe+VCmoqqgNkEPooY0Y8AlYDdN5kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Et4Z704BxRW0p3mD8EkGQJjuBMUMQScnveeDwKNBibnx/DOSUDhhYDrUGSf9N1jYxoaXpwe3YDP/B87/1W/q+flYq2hHwofoDnVo9xeWTU7hcfEalcNq2RbACYezyUuCJHQmHdMCIjsfgXEjbaRaNLM2V8Y6BUYX0xXpTLqP4wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDq4x+8N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDq4x+8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC811F000FF;
	Sat, 12 Sep 2026 14:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224044;
	bh=/VgCkL7qkCRFgTmtVqo+fzx9dEcPdkTd8YlnLUDzxu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDq4x+8Nk6xR812zfsr/CFuBkHlKDfXN7Jjdwd//fnVclCWYntz9MHUW+57OQdTc3
	 wcUIktlfADdCJgc2Do+RT0JPRfgWfB5Hg26HePZ1q/GOEz/ARJv9P9YEvXmcxU9znI
	 fSZbH2u1lQljQH9R/C5lcuRGVQQh0eoI95GwTSJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0906/1424] nilfs2: prevent out-of-bounds read in super root block parsing
Date: Sat, 12 Sep 2026 08:55:38 +0200
Message-ID: <20260912065627.614348990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lee <david.lee@trailofbits.com>

[ Upstream commit 7cb2f76a6a2ba2130b577cb8ac13e1e46c4fc689 ]

super-root inode metadata size is trusted before nilfs_read_inode_common().

Reject super-root inode sizes whose computed on-disk footprint exceeds the
filesystem block size. This prevents malformed filesystem images from
making nilfs_read_inode_common() read past the end of the super-root block.

[ryusuke: clarify the commit title]

Fixes: 8a9d2191e9f4 ("nilfs2: operations for the_nilfs core object")
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/the_nilfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 05fdbbc63e1f5..d1891dd4a5109 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -450,6 +450,12 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 			  nilfs->ns_inode_size);
 		return -EINVAL;
 	}
+	if (NILFS_SR_BYTES(nilfs->ns_inode_size) > nilfs->ns_blocksize) {
+		nilfs_err(nilfs->ns_sb,
+			  "too large inode size for super root: %d bytes",
+			  nilfs->ns_inode_size);
+		return -EINVAL;
+	}
 
 	nilfs->ns_first_ino = le32_to_cpu(sbp->s_first_ino);
 	if (nilfs->ns_first_ino < NILFS_USER_INO) {
-- 
2.53.0



