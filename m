Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D677F847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE33C433EF;
	Fri, 10 Mar 2023 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456243;
	bh=g9Lv4qTeLQdX9C55kCFkrGGrESf4pXX0d1ZWauN1kUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHYfNPcdj2T9RJxTiDWXKdDjc/494gvqm1lQhipIyWYh4wSXz2YwxeUjDNGjXj7Oj
	 PYzcMFda/HWKJYHGxRsXf53h4r8gwg98hIUFchSpqsHcUsCLZ+CZA1UqqTgo5aoE6E
	 rlPx2MHGL4KQ4ta0lCT9Wb1DUQX/id1IFrnmD8bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2dacb8f015bf1420155f@syzkaller.appspotmail.com,
	stable@kernel.org,
	Jun Nie <jun.nie@linaro.org>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 128/193] ext4: refuse to create ea block when umounted
Date: Fri, 10 Mar 2023 14:38:30 +0100
Message-Id: <20230310133715.502156354@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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
@@ -1426,6 +1426,13 @@ static struct inode *ext4_xattr_inode_cr
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


