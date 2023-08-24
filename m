Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AA511C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC333C43397;
	Thu, 24 Aug 2023 14:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889101;
	bh=yWGIvhBon1LyRS6uwxVtkymcj0YZKiyj3c2jGc9jCnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+QyE5kvDjaQhjwiLeexwRipEo95VVi+CJFbEF/eXr045F88ZyOjfxH5unGrcHNmq
	 yaSzcfX0MN3xPF3pVXCpJO++e9kryY4jJ8+KKFVZv5H0XT76xw8T+3xOLs+KFzXej7
	 uDaPmiXyITiud0hrxCmWtA6TDak4WU1T0ia5DSLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e633c79ceaecbf479854@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>,
	Ye Bin <yebin10@huawei.com>
Subject: [PATCH 5.10 015/135] quota: Properly disable quotas when add_dquot_ref() fails
Date: Thu, 24 Aug 2023 16:49:18 +0200
Message-ID: <20230824145027.623569717@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index ad255f8ab5c55..135984a1a52f4 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2415,7 +2415,8 @@ int dquot_load_quota_sb(struct super_block *sb, int type, int format_id,
 
 	error = add_dquot_ref(sb, type);
 	if (error)
-		dquot_disable(sb, type, flags);
+		dquot_disable(sb, type,
+			      DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
 
 	return error;
 out_fmt:
-- 
2.40.1



