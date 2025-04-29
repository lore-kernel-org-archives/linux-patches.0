Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95954244679;
	Tue, 29 Apr 2025 16:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945226; cv=none; b=AmAUae6V3Hk5GnGOiozc52BjIjXyLjFUsNou5xrRNz5W4+6VhvEooIFMECjNHKZzbzhhy9JrNZi3li+uIKCvr1q58EfbI8oknd6gN89ZxTKoV4Ag2Heo+QDZjU1uGKhZM0l/CnxxB9SRNOBYmzFME0L38Dv1yU7UdKKUEWu6yXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945226; c=relaxed/simple;
	bh=bHbz4TPbRR5NLORD7eXrognPdk+SEzDOluCGi1/8eg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cj5QAKH3VYiE/PyRKZ+Ni5iKj9WjPTrPwXpQBODutMHVqLsuDZCUOjDUi8WSMOODqMoNrbRpE/QdG0irIp/Fug8gBLdhRM8dW9nLiMj8iLPEaZ9PWYuO1k+H1owX9Ll5ZHWjsk/maygzDKfLc3VX2TBbokeWxKlgH0ikpkzmRho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxv3uR0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxv3uR0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF860C4CEED;
	Tue, 29 Apr 2025 16:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945226;
	bh=bHbz4TPbRR5NLORD7eXrognPdk+SEzDOluCGi1/8eg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxv3uR0YL7IH27J/Pp0Rebtdzf7GCjetZFNxpI5c6gO3w0j9MQEgXVNSLD9P5g4Al
	 fJKxkB1Ud4Ho0I6yQ10KNLMAn/VnhpJvQLzg3B4GBdt83e4GR0NI+5mYZ2fI6WsfOS
	 LiRl5ER43OEj0vkoYh3f9/xFlaFTmFOe63ICwGUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/179] ext4: reject casefold inode flag without casefold feature
Date: Tue, 29 Apr 2025 18:39:43 +0200
Message-ID: <20250429161051.110140842@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 8216776ccff6fcd40e3fdaa109aa4150ebe760b3 ]

It is invalid for the casefold inode flag to be set without the casefold
superblock feature flag also being set.  e2fsck already considers this
case to be invalid and handles it by offering to clear the casefold flag
on the inode.  __ext4_iget() also already considered this to be invalid,
sort of, but it only got so far as logging an error message; it didn't
actually reject the inode.  Make it reject the inode so that other code
doesn't have to handle this case.  This matches what f2fs does.

Note: we could check 's_encoding != NULL' instead of
ext4_has_feature_casefold().  This would make the check robust against
the casefold feature being enabled by userspace writing to the page
cache of the mounted block device.  However, it's unsolvable in general
for filesystems to be robust against concurrent writes to the page cache
of the mounted block device.  Though this very particular scenario
involving the casefold feature is solvable, we should not pretend that
we can support this model, so let's just check the casefold feature.
tune2fs already forbids enabling casefold on a mounted filesystem.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20230814182903.37267-2-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 642335f3ea2b ("ext4: don't treat fhandle lookup of ea_inode as FS corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 97c884f7b0d82..0289a9e36d355 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5212,9 +5212,12 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 				 "iget: bogus i_mode (%o)", inode->i_mode);
 		goto bad_inode;
 	}
-	if (IS_CASEFOLDED(inode) && !ext4_has_feature_casefold(inode->i_sb))
+	if (IS_CASEFOLDED(inode) && !ext4_has_feature_casefold(inode->i_sb)) {
 		ext4_error_inode(inode, function, line, 0,
 				 "casefold flag without casefold feature");
+		ret = -EFSCORRUPTED;
+		goto bad_inode;
+	}
 	if ((err_str = check_igot_inode(inode, flags)) != NULL) {
 		ext4_error_inode(inode, function, line, 0, err_str);
 		ret = -EFSCORRUPTED;
-- 
2.39.5



