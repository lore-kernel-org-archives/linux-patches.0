Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194061DF722;
	Tue,  8 Oct 2024 13:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393934; cv=none; b=KmzMgHB/ect0FKkN1MtdP8MvjZNqkWfh/4w9Z3zNJhCagQl+QDC670xQBsEQ5W+1u86Q+BsJUCNDEcPTjHoHBGTXQ5eyBiY3V8WqAMIQn4x76k8pm7gD7TYv6Rd3TyTP37ntytwzsn9G2+q1MUQ+r1D4u9i1abyBLAZNiyr47Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393934; c=relaxed/simple;
	bh=E+r8NMZ4y4CP1W6nUeCgyB4LvS2oLCrMNS2hYYL/3Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKc8pmAVlLPMuEX+4FLMw1Kexy4eWruLSTPXF1J+KmrAp6btp5NMe+j+YgpBpmSqILA1QIYv9WuHuofSx2vf3L0gQz5xUYCDkkYlnogs2kmrwKCiC3uyV9DTecXo0vpcq2kNOG4g4aQd5R4gfuTbQNvD64pvRU69HH6GaNcNKdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSql8C5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSql8C5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AC0C4CEC7;
	Tue,  8 Oct 2024 13:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393933;
	bh=E+r8NMZ4y4CP1W6nUeCgyB4LvS2oLCrMNS2hYYL/3Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSql8C5DJ6XftDqrOpr700XQQGutRTenfIwmVMU/mslBi5f/+pRFuHhB7S3QDeREX
	 zWb1VyPmMND3uw1fxTLJ2T6pXhjpcNTQFmM4C+b8Slw5atghUhAZ2CueT1xeqEiAxt
	 BRa4iRjHo6xH8h884fUu9TZJOHqEifhfZ9MbNio8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 257/386] jbd2: correctly compare tids with tid_geq function in jbd2_fc_begin_commit
Date: Tue,  8 Oct 2024 14:08:22 +0200
Message-ID: <20241008115639.507681377@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit f0e3c14802515f60a47e6ef347ea59c2733402aa upstream.

Use tid_geq to compare tids to work over sequence number wraps.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Cc: stable@kernel.org
Link: https://patch.msgid.link/20240801013815.2393869-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -725,7 +725,7 @@ int jbd2_fc_begin_commit(journal_t *jour
 		return -EINVAL;
 
 	write_lock(&journal->j_state_lock);
-	if (tid <= journal->j_commit_sequence) {
+	if (tid_geq(journal->j_commit_sequence, tid)) {
 		write_unlock(&journal->j_state_lock);
 		return -EALREADY;
 	}


