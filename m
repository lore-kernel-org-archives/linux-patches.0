Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFED31E3DCD;
	Mon, 23 Jun 2025 22:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717129; cv=none; b=br+U2LVDoDVt0YRh2ZFG0mX+3sTmXpPR2zxk/OG7cHH3MA5W1zI8cXZGKyNpYP7gUQEwFW1dYKg6IeKd3biX3cebZFfuph3mTMp+AwWFCtUWQaQGTaX5zsCsgW127vdZhEonY46E89O0a2+SKoREED4TdOd20chF/BAf1hknu0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717129; c=relaxed/simple;
	bh=qJUhERNOBJE6lpUVFVPVVA/thXGy6R4+xG1Bqn8g9i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJDfGH3mdIDXtYJI/gytzm0YxLbarB7hx3TBdX2V2OeD2gMr7wdumI3Kxy/Z1SmG9tbATOVeJvz2nf8LFS2bnfjPq4ALLdGyjstlgc5NpLYLjuA3SY/vZ/t1KgPtatPrF3uQbCW84jLeA5hI4boOzcHSDqs0cqGja/k0DO7i3Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVpPX4zJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVpPX4zJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E8FC4CEEA;
	Mon, 23 Jun 2025 22:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717128;
	bh=qJUhERNOBJE6lpUVFVPVVA/thXGy6R4+xG1Bqn8g9i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVpPX4zJ4P1j3VwpkVNgL5PTLwG0i371Jhpz5/4l6YbV00zJBXpH2rI2/F6vqbLWr
	 IZc8PAoARjVF85l/IBP0o9GEYv6+xKyqIlFuJEsbrp5AH84+S0XC6ebosIvbdTY6Od
	 SCxCR9Me0F+SGpK1ZBTZ8Jlx7y8RAIhg79Yd+1yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.15 405/411] ext4: avoid remount errors with abort mount option
Date: Mon, 23 Jun 2025 15:09:09 +0200
Message-ID: <20250623130643.878367959@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 76486b104168ae59703190566e372badf433314b upstream.

When we remount filesystem with 'abort' mount option while changing
other mount options as well (as is LTP test doing), we can return error
from the system call after commit d3476f3dad4a ("ext4: don't set
SB_RDONLY after filesystem errors") because the application of mount
option changes detects shutdown filesystem and refuses to do anything.
The behavior of application of other mount options in presence of
'abort' mount option is currently rather arbitary as some mount option
changes are handled before 'abort' and some after it.

Move aborting of the filesystem to the end of remount handling so all
requested changes are properly applied before the filesystem is shutdown
to have a reasonably consistent behavior.

Fixes: d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem errors")
Reported-by: Jan Stancek <jstancek@redhat.com>
Link: https://lore.kernel.org/all/Zvp6L+oFnfASaoHl@t14s
Signed-off-by: Jan Kara <jack@suse.cz>
Tested-by: Jan Stancek <jstancek@redhat.com>
Link: https://patch.msgid.link/20241004221556.19222-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5849,9 +5849,6 @@ static int ext4_remount(struct super_blo
 		goto restore_opts;
 	}
 
-	if (test_opt2(sb, ABORT))
-		ext4_abort(sb, ESHUTDOWN, "Abort forced by user");
-
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? SB_POSIXACL : 0);
 
@@ -6027,6 +6024,14 @@ static int ext4_remount(struct super_blo
 	 */
 	*flags = (*flags & ~vfs_flags) | (sb->s_flags & vfs_flags);
 
+	/*
+	 * Handle aborting the filesystem as the last thing during remount to
+	 * avoid obsure errors during remount when some option changes fail to
+	 * apply due to shutdown filesystem.
+	 */
+	if (test_opt2(sb, ABORT))
+		ext4_abort(sb, ESHUTDOWN, "Abort forced by user");
+
 	ext4_msg(sb, KERN_INFO, "re-mounted. Opts: %s. Quota mode: %s.",
 		 orig_data, ext4_quota_mode(sb));
 	kfree(orig_data);


