Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B2C4582C8;
	Tue, 21 Jul 2026 22:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672374; cv=none; b=oYgRuQ4D1chUu6oRbOAOuSCR4NzwsKmIH9SSFdaUb631V/WgWq7D+5ylP9BPqWVoTxr8ANZa0PBmVQeH00kvOSDeC+GeJGcV0ZjWgvKQy5mkoTY/0gvkseshKuhrlKBWbtePfpb/nOjP3OixNSRtXVeMxZkg5eBusP9aWoqBotM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672374; c=relaxed/simple;
	bh=Wnib2OP+iiyLdiM4W36bvzYvnQktlaS+eeisKqH9Km0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyDdOdiQVfLLD0jtQz9XClDc56IVZNydTDEZoVmbdKDzG7J2n8iB1NVbXttu5Xt6HVJvd3U6pVmOwT5XYU8Z8PJKTJA66hhOwJxjYkeDDkCNxuHFGIoX/5fhCMnmLo0wDvVINuXhilBi8QZe7l3cIwSkgVQQoU0xns2xmchq/6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJArUsJ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJArUsJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779921F00A3D;
	Tue, 21 Jul 2026 22:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672372;
	bh=Yj7o1/Xze6TgVN1xx0J1MZQKmZO1vFq2uUIhGpFAsqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJArUsJ0nUnjj5llFP1mDrSubmAgt2zhyok39BFIMlSVLgoI/TnR5uUgI+NqWux1U
	 S+2kqIpQ6BKnAzWfktbj2wdewFWROhckRWoedxE8OhdWKOBm1QCuaTKEo3otad2imn
	 5jmiwq+m3OQtYMKScjWqW3oHeb/8qdItHMGjCHpk=
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
Subject: [PATCH 5.15 601/843] jbd2: fix integer underflow in jbd2_journal_initialize_fast_commit()
Date: Tue, 21 Jul 2026 17:23:56 +0200
Message-ID: <20260721152419.571117007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2286,6 +2286,8 @@ jbd2_journal_initialize_fast_commit(jour
 	unsigned long long num_fc_blks;
 
 	num_fc_blks = jbd2_journal_get_num_fc_blks(sb);
+	if (num_fc_blks > journal->j_last)
+		return -EFSCORRUPTED;
 	if (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS)
 		return -ENOSPC;
 


