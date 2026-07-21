Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714FC3E49E7;
	Tue, 21 Jul 2026 17:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654318; cv=none; b=TM/ZrjfS2c9tToiEmcMUjwFXrT2SUMIlGI4ZcuOKbyLR9E4iMoVI41+k01z6vnHD8VpZ4GljmQnCvN35Khch5n0AxAbIzIEX0FuPyVADfD52m0ZvkglkHxSL91fOLYfHYnF7v+4lGU5ceEO4AiXao+Y7YtcwPyzdvS3k6EC6UjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654318; c=relaxed/simple;
	bh=DEVLSWJVXaFszoeY8IkwRDwDVaO6mHq+W6ZWAmQOKpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihzXvZSyRetDmsqx72GtQPJUwK+MTXB4IqYlfRCFbcjYfB6T3UvIoL9EqM7HwjHEwprl4b4OnFbW8FU3yzpjGB+bQJzaSlAMPszTiyJkry2Wng+LBM3ucq6vDtaOfAPSSXCkczJM3Q3MxctCvp0IgTxMt3LBPK+mc37YwScr/tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FflqCQGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FflqCQGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8601F000E9;
	Tue, 21 Jul 2026 17:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654317;
	bh=UlYVFrUVMk+v/p5hdPZtu4IYmNrsKYRG8uhN7+fwO0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FflqCQGY4KgCf0bFyjMaiRpeOrvftEbcJWcU3A92qtoznhXIOSyZnJATtzIXQSFOU
	 rZ6jnB264QmU5goc6cHhjmQSl0BbvM7xJ9/mFxyI92LQBNJMtrLb/VwXsRkznIKUvg
	 6phGoFrKT4ubqsWup2xW0d0EO2zQ/tm2OaTvZWho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 7.1 1657/2077] jbd2: fix integer underflow in jbd2_journal_initialize_fast_commit()
Date: Tue, 21 Jul 2026 17:22:10 +0200
Message-ID: <20260721152631.831019095@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit 289a2ca0c9b7eae74f93fc213b0b971669b8683d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/journal.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2263,6 +2263,8 @@ jbd2_journal_initialize_fast_commit(jour
 	unsigned long long num_fc_blks;
 
 	num_fc_blks = jbd2_journal_get_num_fc_blks(sb);
+	if (num_fc_blks > journal->j_last)
+		return -EFSCORRUPTED;
 	if (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS)
 		return -ENOSPC;
 


