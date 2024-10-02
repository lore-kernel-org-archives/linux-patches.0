Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E74E1D0488;
	Wed,  2 Oct 2024 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878144; cv=none; b=AunXzbd6EmhBDr98Vy5SHWf7Cfp9WA3OfeleCdWSnFTKhdOV9RJzM7W0eN2j90aMk8iDevPRtwkv3sTYgaTuqaEPVuvhuwuJivns8sLzU8XpY7kR9MLoHGHgWXL/zzlujNuSRMjWA/cPQeTtKVCK7rliIJezH2EtwgKDs6BPDyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878144; c=relaxed/simple;
	bh=N7IxAtEBNZAcgziCom0gehKAVi1LBEQ8C5QN3Tk1k8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b026ZBDF7SqomNdDS2QTnJUqHam1RitsJOmwX8FT2LdET7EIezqLFYs5kKxFpRsCHG81xg6Fpr1ponkVDshzX/cyMZxPA7FFhTJj4SGDXQbhO7RzFv0fzLjXfBQf2+P9BcygvBX8blGofM5ZS/aEFTXyMTV9z/gihZCikPD7NrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ai9U1UW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ai9U1UW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D680BC4CEC2;
	Wed,  2 Oct 2024 14:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878144;
	bh=N7IxAtEBNZAcgziCom0gehKAVi1LBEQ8C5QN3Tk1k8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ai9U1UWsPSGKDy/mtoEFzCV8DSkXlyDO7Wwct6pm+JBhJ365psMQ5iSySFBJD1Y8
	 mB/PG9oSTla9b+JjtXedC64e02av6hinA4CS5s+Q74PhffxH8DEt60p5C0PWHCTEwe
	 Qej0HH6w0MRUwK/xmyVygLDa8TLQdRPhq3aTJTdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 317/634] quota: avoid missing put_quota_format when DQUOT_SUSPENDED is passed
Date: Wed,  2 Oct 2024 14:56:57 +0200
Message-ID: <20241002125823.617420720@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 627eb2f72ef37..23fcf9e9d6c55 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2408,7 +2408,7 @@ static int vfs_setup_quota_inode(struct inode *inode, int type)
 int dquot_load_quota_sb(struct super_block *sb, int type, int format_id,
 	unsigned int flags)
 {
-	struct quota_format_type *fmt = find_quota_format(format_id);
+	struct quota_format_type *fmt;
 	struct quota_info *dqopt = sb_dqopt(sb);
 	int error;
 
@@ -2418,6 +2418,7 @@ int dquot_load_quota_sb(struct super_block *sb, int type, int format_id,
 	if (WARN_ON_ONCE(flags & DQUOT_SUSPENDED))
 		return -EINVAL;
 
+	fmt = find_quota_format(format_id);
 	if (!fmt)
 		return -ESRCH;
 	if (!sb->dq_op || !sb->s_qcop ||
-- 
2.43.0



