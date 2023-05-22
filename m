Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27653171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B364C433EF;
	Mon, 22 May 2023 19:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784716;
	bh=r3nSzcHu6zOam8kJq7keQ3dxmzWsnf7sOlNGe/Bja7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lh2fg7JrxSxhr+AFEFt7PMYuxC8urGmweKmYTCi2mYMX3g3gy5jQmbM4lQkT4gIIz
	 8rvY8LQVN5E/3fB+ZXz+RbVe3N7acrfBMyKS/G5CPfM/pHANo/foxOdJ8fFqn1o6xM
	 wV0LIwTOsvVOm/FbKmdQirWE3M8cKr+mTUMjpZZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+f45957555ed4a808cc7a@syzkaller.appspotmail.com
Subject: [PATCH 6.3 177/364] fs/ntfs3: Fix NULL dereference in ni_write_inode
Date: Mon, 22 May 2023 20:08:02 +0100
Message-Id: <20230522190417.146648410@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit 8dae4f6341e335a09575be60b4fdf697c732a470 ]

Syzbot reports a NULL dereference in ni_write_inode.
When creating a new inode, if allocation fails in mi_init function
(called in mi_format_new function), mi->mrec is set to NULL.
In the error path of this inode creation, mi->mrec is later
dereferenced in ni_write_inode.

Add a NULL check to prevent NULL dereference.

Link: https://syzkaller.appspot.com/bug?extid=f45957555ed4a808cc7a
Reported-and-tested-by: syzbot+f45957555ed4a808cc7a@syzkaller.appspotmail.com
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 7d0473da12c33..1103d4d9a4974 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -3258,6 +3258,9 @@ int ni_write_inode(struct inode *inode, int sync, const char *hint)
 		return 0;
 	}
 
+	if (!ni->mi.mrec)
+		goto out;
+
 	if (is_rec_inuse(ni->mi.mrec) &&
 	    !(sbi->flags & NTFS_FLAGS_LOG_REPLAYING) && inode->i_nlink) {
 		bool modified = false;
-- 
2.39.2



