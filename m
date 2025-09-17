Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605001DFE22;
	Wed, 17 Sep 2025 12:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112578; cv=none; b=o8UZzH4m3Hgq3hyJubRuMO3rbt1o2s6vBG3N0K1eUoQxRmM8Qkg+4ct44Y5SGEDvDBJQ1+5/3WIvKcSHJehU0W8/FNk4NBfLi9JrzVLZwDbVgY72GMT9wxuPSJrOVlTdYTio3VsqTGPytO4X76UjXHxACWrjiNpsu/rhinRpDo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112578; c=relaxed/simple;
	bh=0qENdMfXrZo76sLBLKwivYOOQnQVDQ45uBEwkjamHbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRbcJrShEwp3yLyDmEs6qeP0B9NiWwSeiS+Rmqh0HKHk9zHzBBY0KjE7oJQ2kluYzrH2y5TwZDj57Sttbij4ySZPhNJpQp7Vk00Te4o4T2AorJIX6gb63sPGTTQAjtR0QkvQ3j++kp0osTm+nF2nlCP+XpqREvi6+gSHUJ0gFAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWe88q5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWe88q5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3C1C4CEF0;
	Wed, 17 Sep 2025 12:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112576;
	bh=0qENdMfXrZo76sLBLKwivYOOQnQVDQ45uBEwkjamHbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWe88q5ShLK3IbGFxV7TwCCP3Hm7cfi3cxTQgnHrLJfcndvf+V+UbqJLAvVeN4dqH
	 2dDHnzMwaOmKNpZ6uvR88ktqqi0JZjdC7c6HGXAJb2LITOsLQJuIXyd5S/Ia9UPA4r
	 FW7IhYVRFxOpQEbgvCLGGyHmKvwqFHO7GYtbEJRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 005/189] fhandle: use more consistent rules for decoding file handle from userns
Date: Wed, 17 Sep 2025 14:31:55 +0200
Message-ID: <20250917123351.981812276@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit bb585591ebf00fb1f6a1fdd1ea96b5848bd9112d ]

Commit 620c266f39493 ("fhandle: relax open_by_handle_at() permission
checks") relaxed the coditions for decoding a file handle from non init
userns.

The conditions are that that decoded dentry is accessible from the user
provided mountfd (or to fs root) and that all the ancestors along the
path have a valid id mapping in the userns.

These conditions are intentionally more strict than the condition that
the decoded dentry should be "lookable" by path from the mountfd.

For example, the path /home/amir/dir/subdir is lookable by path from
unpriv userns of user amir, because /home perms is 755, but the owner of
/home does not have a valid id mapping in unpriv userns of user amir.

The current code did not check that the decoded dentry itself has a
valid id mapping in the userns.  There is no security risk in that,
because that final open still performs the needed permission checks,
but this is inconsistent with the checks performed on the ancestors,
so the behavior can be a bit confusing.

Add the check for the decoded dentry itself, so that the entire path,
including the last component has a valid id mapping in the userns.

Fixes: 620c266f39493 ("fhandle: relax open_by_handle_at() permission checks")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/20250827194309.1259650-1-amir73il@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fhandle.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index e21ec857f2abc..52c72896e1c16 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -202,6 +202,14 @@ static int vfs_dentry_acceptable(void *context, struct dentry *dentry)
 	if (!ctx->flags)
 		return 1;
 
+	/*
+	 * Verify that the decoded dentry itself has a valid id mapping.
+	 * In case the decoded dentry is the mountfd root itself, this
+	 * verifies that the mountfd inode itself has a valid id mapping.
+	 */
+	if (!privileged_wrt_inode_uidgid(user_ns, idmap, d_inode(dentry)))
+		return 0;
+
 	/*
 	 * It's racy as we're not taking rename_lock but we're able to ignore
 	 * permissions and we just need an approximation whether we were able
-- 
2.51.0



