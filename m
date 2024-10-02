Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1801D0491;
	Wed,  2 Oct 2024 13:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876171; cv=none; b=aCCaaFH07PHEk34+S4yxb8J97DXBUb9RNJlBD4RAeBv1DQIM7KMcwnlAeMZadx3wwCmWQC5waUqA2I8lwB3icvkO0vEHz1zd3anP4TSfjE6tHzZufcyAy24O80Klh3lbFaEWK8gaEZu8vYQqAlFZJnfCvmuez14kwNPu+lgHZpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876171; c=relaxed/simple;
	bh=oPXHTIEI5jBAfilEuFi7Neo4/aebIIQbk73Xg0Pl3jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NE893OUJvU64i/eAGUrF4DfAZ5g6IjTMci9AiHe5H2Auj8EQc3ELJ5Hiovc9TkWN4YKQzLhOlr5TKDcb0oeAAt+jbszAjvjNW5YblgDrzkib5K18Es+VTT5VHTui5DpetiaoFmAPrXZqQUy3h1TeTfigi5UToWNXCHrCLAB8qkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LynXxnGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LynXxnGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4894C4CEC5;
	Wed,  2 Oct 2024 13:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876171;
	bh=oPXHTIEI5jBAfilEuFi7Neo4/aebIIQbk73Xg0Pl3jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LynXxnGY5x07pGtbuJfhcwG/zZDTpGoISFDmARhJ1i59WViPcAOslrsTQJvB1aopL
	 Tm63GnTlMiDIfrCx5d2jhf2Ncy6UNvcP6CKK+Dw9XbZvfNpFfd81KxvVrmu9LB/0sB
	 N+6U8qzkCD4tmDt3UUZWtjzeT3wH29jg3AmkUqzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 351/695] quota: avoid missing put_quota_format when DQUOT_SUSPENDED is passed
Date: Wed,  2 Oct 2024 14:55:49 +0200
Message-ID: <20241002125836.459396995@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit d16a5f852025be546b6e4ceef15899db3490f4d7 ]

Avoid missing put_quota_format when DQUOT_SUSPENDED is passed to
dquot_load_quota_sb.

Link: https://patch.msgid.link/20240715130534.2112678-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Fixes: d44c57663723 ("quota: Remove BUG_ON in dquot_load_quota_sb()")
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 7ae885e6d5d73..d533b58e21c28 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2406,7 +2406,7 @@ static int vfs_setup_quota_inode(struct inode *inode, int type)
 int dquot_load_quota_sb(struct super_block *sb, int type, int format_id,
 	unsigned int flags)
 {
-	struct quota_format_type *fmt = find_quota_format(format_id);
+	struct quota_format_type *fmt;
 	struct quota_info *dqopt = sb_dqopt(sb);
 	int error;
 
@@ -2416,6 +2416,7 @@ int dquot_load_quota_sb(struct super_block *sb, int type, int format_id,
 	if (WARN_ON_ONCE(flags & DQUOT_SUSPENDED))
 		return -EINVAL;
 
+	fmt = find_quota_format(format_id);
 	if (!fmt)
 		return -ESRCH;
 	if (!sb->dq_op || !sb->s_qcop ||
-- 
2.43.0



