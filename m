Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F154373BF2;
	Sat, 12 Sep 2026 10:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208459; cv=none; b=fJlPNJCVGdPR4bFo0+t/YuTvUGAS7BUaNgmVllc8vyuUPu+d7tkcfnbbi8pCzCo1CFd5H0VNiJzvkNQMOIMHnkbt2F8CB+3HZsUZFzaaMMujVCkbWhGAjsKSfR2U7wapJNoUafc2rs2zSmxovosAcP3jHUnmtvy0fFjvbJP4bQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208459; c=relaxed/simple;
	bh=Mpd+GtAUICBNlUUbbAbrrTfL87i3QhYt2L5ZqMFLVk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aw5F6Q74WVxjQIzlWpKPBTGdoqfTqz3c1dxfQsIVfYqZoE1s4l3KX6hARMC0gdR6Ib2/5ULrclh4wChSJXb+K12MCNIOzoAkM2oizPU5ppFbKAEGjYOtUUATmB+IlMbZdwwzqs6QyLLlKDB4Fcn0AZ5Lzo1pdMAZyigQa/fKkLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2+BUlCU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2+BUlCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD15D1F000FF;
	Sat, 12 Sep 2026 10:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208457;
	bh=ibTgxsk3sOFLnSCmchFoh95er7A65JW8r3qqkbWNmco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p2+BUlCUpOwhSBaa/yz5/XMZ6Qu7aU8q/c1Nbz+naHLgTH3klQwLl84Nv+PHHACMt
	 K8Qk/XNCbT/B8rUWqijD2EJTcVSO+lOTpY14QEJl60Bduww6l95Ajz1bPFJewlebd1
	 Cd7pN5FJCFih7m2G0L+OmfaaWk/olFfl9xaO4r4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0621/1518] nilfs2: prevent out-of-bounds read in super root block parsing
Date: Sat, 12 Sep 2026 08:46:30 +0200
Message-ID: <20260912065637.478455025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d0bcf744c553a..9911a484398a0 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -461,6 +461,12 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
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



