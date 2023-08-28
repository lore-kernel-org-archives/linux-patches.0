Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FF06FAF
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7B6C433C8;
	Mon, 28 Aug 2023 10:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217709;
	bh=/j370p9/EH8BB2KY7tM8Az23JwXMmYVLN5QivVHZ3gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSd6aWXP8l8TmWr116D85twix1j3Y1myl5+fQ1lchwCZYhXr+9BqKi5C3hzHuMfX/
	 XiXL7M012wgN9DFi407jvEikcDuP4E5nPF7ir97Zquab6YHJCSkcgy4ETyH4i8NeCR
	 vg3UJ3o0a2pgWaUrcgyA8sDWzxSLJLOk74Fn1dtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e633c79ceaecbf479854@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>,
	Ye Bin <yebin10@huawei.com>
Subject: [PATCH 4.14 04/57] quota: Properly disable quotas when add_dquot_ref() fails
Date: Mon, 28 Aug 2023 12:12:24 +0200
Message-ID: <20230828101144.364240155@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101144.231099710@linuxfoundation.org>
References: <20230828101144.231099710@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 6a4e3363792e30177cc3965697e34ddcea8b900b ]

When add_dquot_ref() fails (usually due to IO error or ENOMEM), we want
to disable quotas we are trying to enable. However dquot_disable() call
was passed just the flags we are enabling so in case flags ==
DQUOT_USAGE_ENABLED dquot_disable() call will just fail with EINVAL
instead of properly disabling quotas. Fix the problem by always passing
DQUOT_LIMITS_ENABLED | DQUOT_USAGE_ENABLED to dquot_disable() in this
case.

Reported-and-tested-by: Ye Bin <yebin10@huawei.com>
Reported-by: syzbot+e633c79ceaecbf479854@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20230605140731.2427629-2-yebin10@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 7c364cda8daac..1cbec5dde5830 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2387,7 +2387,8 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 
 	error = add_dquot_ref(sb, type);
 	if (error)
-		dquot_disable(sb, type, flags);
+		dquot_disable(sb, type,
+			      DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
 
 	return error;
 out_file_init:
-- 
2.40.1



