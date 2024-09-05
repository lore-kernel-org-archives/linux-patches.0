Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276F31494DB;
	Thu,  5 Sep 2024 10:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530709; cv=none; b=fFtrCBgxJUxE56MqaFivfe9a25gF1KthnsXIXjyCAMQLDXXHyMAcwC+ZGufMLCdRDM0cqUd1W4IigwYxxeBgPROQ3l4c+gtNDrCqtiEm4WZHnNjgHYHZwxm5hQx9V78598UP5GiRTZuFD/uB3iib1QwUA7t73F6A7sIfehbnvLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530709; c=relaxed/simple;
	bh=hJvDfGCYCTBecKWuXRqKcQtoK50gYHBOL2QQGHh1TFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzJFNymgkxN/v1pZyd/EyJfQ36lT9S5eUJLI6Yp5am+vjSMZrZpN5pMbQEN+d6RLZfHsRtnd2WbwLLzfRZEoZYft5LYQ//FihlzHVrSnSSM+7+U1n62sjPPZKbg+PKVFMw9HQFd5ycMOmIeFVyMkUPuylji5ConpcKRW+cAHu3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zf9kH9x8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zf9kH9x8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844E3C4CEC3;
	Thu,  5 Sep 2024 10:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530709;
	bh=hJvDfGCYCTBecKWuXRqKcQtoK50gYHBOL2QQGHh1TFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zf9kH9x8Fx74d/2vZA3uaO9Zubn1H8R/p6epAbGwtRGazOpT0ey786E9bmpNEKP4k
	 UMgeRKBxwbGM07TjjkUW+ZXRLPmlSniNuUmZdPw0H+9J5ejZvsLvLA234lEwoCMfNc
	 UE1ttnfgq5IJHysqWRNh7P64UQA3PsRs/zGOaGaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 099/101] ext4: reject casefold inode flag without casefold feature
Date: Thu,  5 Sep 2024 11:42:11 +0200
Message-ID: <20240905093719.993616292@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit 8216776ccff6fcd40e3fdaa109aa4150ebe760b3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5101,9 +5101,12 @@ struct inode *__ext4_iget(struct super_b
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


