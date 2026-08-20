Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC64246781;
	Thu, 20 Aug 2026 16:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244166; cv=none; b=XkamX6XVwQgT5wdHhXrVeJRMsy0+LXG6lTv0zk/QY0iEKBtv/qyTR6aIuniMGrkNa8hYX7DBLUIsTW/JC6sTJ77ODsAeTwZmAVfdIXaInSKmCf2EWNzFMQfdGW4t/hbFIl7SR7EDUxgETc/KyH7k0Hj2dn0yRowrsntE9BhRtGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244166; c=relaxed/simple;
	bh=gsMcnALeRc+rSe49tTTDFi9YGNkjp1ufYT4w04fjPJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzVqAqv4jiewgAWf6py/AtY39QBrbtoZkEF7xCOInpw0TKE0aB7unWkJwYMyw2bXT75/Q+GmgAhD+8ThUxTUxqExGD7i0vkFwEVxBRbxOdqndr8PMTcvD6z2kUWs+p9RuPbyAR3iGlvnpcnHaV9M6s2wmv2Hf5kocwNaf0rRke8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jy/D16Cx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jy/D16Cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDEC1F000E9;
	Thu, 20 Aug 2026 16:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244165;
	bh=IJuyuO+4McDrcpf511YKgSxHSbNytqSordAFOZYzvnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jy/D16Cxp03AyWD2dlWIFDReInr0hKSPdV9tv/CglZqsjRkGk86vj8COF9M8Z04Yo
	 El/xOPjkuwrupnbNQbl8A7HC4tuD5HaTuJKqljOurnjbcaTsyv513KZSHUWpTR4acT
	 X9wMUxhhVTke8OGiMDV/KTZz3TJYwd34HKMg7T3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/235] jbd2: fix integer underflow in jbd2_journal_initialize_fast_commit()
Date: Thu, 20 Aug 2026 16:55:10 +0200
Message-ID: <20260820145218.689830323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 289a2ca0c9b7eae74f93fc213b0b971669b8683d ]

jbd2_journal_initialize_fast_commit() validates journal capacity by
checking (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS).
Both j_last and num_fc_blks are unsigned, so when num_fc_blks exceeds
j_last the subtraction wraps to a large value, bypassing the bounds
check.

The resulting underflow corrupts j_last, j_fc_first, and j_free,
leading to journal abort.

Fix by checking num_fc_blks against j_last before the subtraction,
returning -EFSCORRUPTED.

Fixes: 6866d7b3f2bb ("ext4 / jbd2: add fast commit initialization")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: e029c5f27987 ("ext4: make num of fast commit blocks configurable")
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Fixes: e029c5f279872 ("ext4: make num of fast commit blocks configurable")
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/SYBPR01MB7881663C927DE9D7BBF4D1DFAF062@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/journal.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2116,6 +2116,8 @@ jbd2_journal_initialize_fast_commit(jour
 	unsigned long long num_fc_blks;
 
 	num_fc_blks = jbd2_journal_get_num_fc_blks(sb);
+	if (num_fc_blks > journal->j_last)
+		return -EFSCORRUPTED;
 	if (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS)
 		return -ENOSPC;
 


