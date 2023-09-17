Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28CE6FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10447C433C9;
	Sun, 17 Sep 2023 19:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980419;
	bh=ZykPAvmsFfKN9NS9q5vACLFlt2i+IFt/tiCNu0KVTl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scmflm06MjV652f5xUyMjr4atX8Oh8WHjvkItg8xQdFc09BUlvzpMLrLkICGfl0RJ
	 hgwfqVsRRplGpqe/uzBhiPx7DTi+i7vYftTSYPsueAUf0bzAVF6JLy501B5p0BiYFo
	 h4qmRABlbelb+gS2REdQm83DJUbpBTXc6kcHvqbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.5 186/285] jbd2: correct the end of the journal recovery scan range
Date: Sun, 17 Sep 2023 21:13:06 +0200
Message-ID: <20230917191058.050792700@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit 2dfba3bb40ad8536b9fa802364f2d40da31aa88e upstream.

We got a filesystem inconsistency issue below while running generic/475
I/O failure pressure test with fast_commit feature enabled.

 Symlink /p3/d3/d1c/d6c/dd6/dce/l101 (inode #132605) is invalid.

If fast_commit feature is enabled, a special fast_commit journal area is
appended to the end of the normal journal area. The journal->j_last
point to the first unused block behind the normal journal area instead
of the whole log area, and the journal->j_fc_last point to the first
unused block behind the fast_commit journal area. While doing journal
recovery, do_one_pass(PASS_SCAN) should first scan the normal journal
area and turn around to the first block once it meet journal->j_last,
but the wrap() macro misuse the journal->j_fc_last, so the recovering
could not read the next magic block (commit block perhaps) and would end
early mistakenly and missing tN and every transaction after it in the
following example. Finally, it could lead to filesystem inconsistency.

 | normal journal area                             | fast commit area |
 +-------------------------------------------------+------------------+
 | tN(rere) | tN+1 |~| tN-x |...| tN-1 | tN(front) |       ....       |
 +-------------------------------------------------+------------------+
                     /                             /                  /
                start               journal->j_last journal->j_fc_last

This patch fix it by use the correct ending journal->j_last.

Fixes: 5b849b5f96b4 ("jbd2: fast commit recovery path")
Cc: stable@kernel.org
Reported-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/linux-ext4/20230613043120.GB1584772@mit.edu/
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230626073322.3956567-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/recovery.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -230,12 +230,8 @@ static int count_tags(journal_t *journal
 /* Make sure we wrap around the log correctly! */
 #define wrap(journal, var)						\
 do {									\
-	unsigned long _wrap_last =					\
-		jbd2_has_feature_fast_commit(journal) ?			\
-			(journal)->j_fc_last : (journal)->j_last;	\
-									\
-	if (var >= _wrap_last)						\
-		var -= (_wrap_last - (journal)->j_first);		\
+	if (var >= (journal)->j_last)					\
+		var -= ((journal)->j_last - (journal)->j_first);	\
 } while (0)
 
 static int fc_do_one_pass(journal_t *journal,
@@ -524,9 +520,7 @@ static int do_one_pass(journal_t *journa
 				break;
 
 		jbd2_debug(2, "Scanning for sequence ID %u at %lu/%lu\n",
-			  next_commit_ID, next_log_block,
-			  jbd2_has_feature_fast_commit(journal) ?
-			  journal->j_fc_last : journal->j_last);
+			  next_commit_ID, next_log_block, journal->j_last);
 
 		/* Skip over each chunk of the transaction looking
 		 * either the next descriptor block or the final commit


