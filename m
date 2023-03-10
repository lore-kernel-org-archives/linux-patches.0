Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C588494
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11877C4339E;
	Fri, 10 Mar 2023 14:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459130;
	bh=7IBCn/nH9gL5Mc0IQ74fGPll+52yvaw+Qi16mKP9omw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TboxsQmCrZa1OOFtBQKW044uZQHOsqOOIMtyJRw5opXmvGe6G0AjhkOg5sutbPMcm
	 bFgK3ii0yKuDYidwL5LsxoA6hyV3RJDQsUDxsTXi/UyhyELegNUQwNYUQzT8FEmABF
	 c0ISBfooj1CPB74foJ16l5y9TjggIS0GoFWZ2x2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2dacb8f015bf1420155f@syzkaller.appspotmail.com,
	stable@kernel.org,
	Jun Nie <jun.nie@linaro.org>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 251/357] ext4: refuse to create ea block when umounted
Date: Fri, 10 Mar 2023 14:39:00 +0100
Message-Id: <20230310133745.840485853@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jun Nie <jun.nie@linaro.org>

commit f31173c19901a96bb2ebf6bcfec8a08df7095c91 upstream.

The ea block expansion need to access s_root while it is
already set as NULL when umount is triggered. Refuse this
request to avoid panic.

Reported-by: syzbot+2dacb8f015bf1420155f@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=3613786cb88c93aa1c6a279b1df6a7b201347d08
Link: https://lore.kernel.org/r/20230103014517.495275-3-jun.nie@linaro.org
Cc: stable@kernel.org
Signed-off-by: Jun Nie <jun.nie@linaro.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1432,6 +1432,13 @@ static struct inode *ext4_xattr_inode_cr
 	uid_t owner[2] = { i_uid_read(inode), i_gid_read(inode) };
 	int err;
 
+	if (inode->i_sb->s_root == NULL) {
+		ext4_warning(inode->i_sb,
+			     "refuse to create EA inode when umounting");
+		WARN_ON(1);
+		return ERR_PTR(-EINVAL);
+	}
+
 	/*
 	 * Let the next inode be the goal, so we try and allocate the EA inode
 	 * in the same group, or nearby one.


