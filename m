Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F032C8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70945C433C7;
	Sun, 16 Jul 2023 19:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537439;
	bh=aNZ79TRuYE9AabEZpTW3AOU83Gak0BtyEQwaFS8AAzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jki4sSImLzDALwOyVclPmQteAhwgjF2HuAI9S3nuUH4zalI1F0K8HgNX8ZH4MswU+
	 CaIJSqQXEczXdawntN7jKurjqAK+QV5w7Qk7SD4SkqtbJAfGJLbf+8iFH59YsGjtl0
	 GD/Af0ZtqzQ/Ynkdutve37BjjkuVnytN+3l2dggw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+00a3779539a23cbee38c@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 097/800] reiserfs: Initialize sec->length in reiserfs_security_init().
Date: Sun, 16 Jul 2023 21:39:10 +0200
Message-ID: <20230716194951.366859558@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit d031f4e8b493df299123fbb4ec13db870584ed28 ]

syzbot is reporting that sec->length is not initialized.

Since security_inode_init_security() returns 0 when initxattrs is provided
but call_int_hook(inode_init_security) returned -EOPNOTSUPP, control will
reach to "if (sec->length && ...) {" without initializing sec->length.

Reported-by: syzbot <syzbot+00a3779539a23cbee38c@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=00a3779539a23cbee38c
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 52ca4b6435a4 ("reiserfs: Switch to security_inode_init_security()")
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/xattr_security.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/reiserfs/xattr_security.c b/fs/reiserfs/xattr_security.c
index 6e0a099dd7886..078dd8cc312fc 100644
--- a/fs/reiserfs/xattr_security.c
+++ b/fs/reiserfs/xattr_security.c
@@ -67,6 +67,7 @@ int reiserfs_security_init(struct inode *dir, struct inode *inode,
 
 	sec->name = NULL;
 	sec->value = NULL;
+	sec->length = 0;
 
 	/* Don't add selinux attributes on xattrs - they'll never get used */
 	if (IS_PRIVATE(dir))
-- 
2.39.2



