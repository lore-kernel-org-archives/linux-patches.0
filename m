Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83574188006;
	Tue, 17 Jun 2025 16:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177990; cv=none; b=RCbkFHTXYydEi8JB82z8+LmYFQFM1ClIQsY1FLqOuCra4WoYYghYCOPyMLMF5tnABsxk+zQIe8/F04RcMmWAB4krhZkW/nB5n/J7AZtYWhSdgzuAG12YIYE4szc+4t41OZIuxh3EVdtHfingkf5NBryXezskwVCTpi7ittXylmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177990; c=relaxed/simple;
	bh=JThAhBUL5Pu9yG94BNM83LRYfVJgKjTEv6GYxM4EPQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/aTjn92PE3MccpCGFl1Zc0j3dE5qlU96WQAMHTZODV3smUi3EoEoxUd2mk3XFwM1WBXJNaADKdahl/lVYjO3mtfRUAcei++oRfAEeFHU7pTdI61K7bQUPS3GhndsL6Z2jf8WAQiXnOv5nia4G6WnHH+Rm4zH9x10kXCGFNKwPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/QEsx+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/QEsx+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6943C4CEE7;
	Tue, 17 Jun 2025 16:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177990;
	bh=JThAhBUL5Pu9yG94BNM83LRYfVJgKjTEv6GYxM4EPQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/QEsx+usmIZWWz3KbIWADidCD8mMWrBjnuMRTtJgZkRnNUhDfmYqKszoHNZTSS7H
	 m/v9kUflJ1Xgg6+bvhwO8758yGKan4kHXd7Ic1bi439foTpGt0GKQSvJhCPT+OOeuK
	 nethPfXiA5v0bAVat35Z60NoX2tDgDZ3mEeJFWJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Jan Kara <jack@suse.cz>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 393/780] ocfs2: fix possible memory leak in ocfs2_finish_quota_recovery
Date: Tue, 17 Jun 2025 17:21:41 +0200
Message-ID: <20250617152507.457069965@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit cdc3ed3035d0fe934aa1d9b78ce256752fd3bb7d ]

If ocfs2_finish_quota_recovery() exits due to an error before passing all
rc_list elements to ocfs2_recover_local_quota_file() then it can lead to a
memory leak as rc_list may still contain elements that have to be freed.

Release all memory allocated by ocfs2_add_recovery_chunk() using
ocfs2_free_quota_recovery() instead of kfree().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Link: https://lkml.kernel.org/r/20250402065628.706359-2-m.masimov@mt-integration.ru
Fixes: 2205363dce74 ("ocfs2: Implement quota recovery")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/quota_local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index e272429da3db3..de7f12858729a 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -674,7 +674,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 			break;
 	}
 out:
-	kfree(rec);
+	ocfs2_free_quota_recovery(rec);
 	return status;
 }
 
-- 
2.39.5



