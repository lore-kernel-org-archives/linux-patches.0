Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13C619E7FF;
	Thu,  6 Jun 2024 14:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683537; cv=none; b=Y3g/gVQ3UnKm99qFu2q2l3pl2zHywJg5yO7q6ffPmEI7vUx0DWG2j7x6xrKS9XLkaZz6ud5z5NGkqfDoFRbGmndv6VRfgdw6RWrJc3hZALOK90aAHd5Xta87vi+yoB0RZLETxgXLpwumr7J80+YDQDHa8568KFWVkYRUROlcfzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683537; c=relaxed/simple;
	bh=cyCNYShjL/IWzimCKIPhICp4PysmCtE9ZTYXOmJGuDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIh5FM4OsRUed07oek3tcXoWfJ0rUrSZmzbJpHALU4eXGB57DrCB59tlOx4S/NAE9lE7hOtk1UcivKmfkqNSYA9jUcLwpSCOlm7HLTf10EGMXAjHhpwNT7G7WWNwMy62i7lNmsHmGNXmVDexoD2ohx2x9wrQwgHwzje7gAQGWZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5hXl5Td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5hXl5Td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB88C2BD10;
	Thu,  6 Jun 2024 14:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683537;
	bh=cyCNYShjL/IWzimCKIPhICp4PysmCtE9ZTYXOmJGuDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5hXl5TdRpwvNcjnUybgu4L40XqLJoTN8MkExH1cquCHqPLvqZcw9sy/NMO+3UUpz
	 AArCXj23+4O3nbSHm+1dr9RUeXwgSAYfcJ+D1CrIawepAtWKi206aqabz0oLhOb9zX
	 qMRyCNKdqq1NbrB9yCVIV7V7+8nBzWCfDU3ugm90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 477/744] xfs: fix log recovery buffer allocation for the legacy h_size fixup
Date: Thu,  6 Jun 2024 16:02:29 +0200
Message-ID: <20240606131747.759795247@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 45cf976008ddef4a9c9a30310c9b4fb2a9a6602a ]

Commit a70f9fe52daa ("xfs: detect and handle invalid iclog size set by
mkfs") added a fixup for incorrect h_size values used for the initial
umount record in old xfsprogs versions.  Later commit 0c771b99d6c9
("xfs: clean up calculation of LR header blocks") cleaned up the log
reover buffer calculation, but stoped using the fixed up h_size value
to size the log recovery buffer, which can lead to an out of bounds
access when the incorrect h_size does not come from the old mkfs
tool, but a fuzzer.

Fix this by open coding xlog_logrec_hblks and taking the fixed h_size
into account for this calculation.

Fixes: 0c771b99d6c9 ("xfs: clean up calculation of LR header blocks")
Reported-by: Sam Sun <samsun1006219@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index f3fcd58349c16..d6cb097f63729 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2965,7 +2965,7 @@ xlog_do_recovery_pass(
 	int			error = 0, h_size, h_len;
 	int			error2 = 0;
 	int			bblks, split_bblks;
-	int			hblks, split_hblks, wrapped_hblks;
+	int			hblks = 1, split_hblks, wrapped_hblks;
 	int			i;
 	struct hlist_head	rhash[XLOG_RHASH_SIZE];
 	LIST_HEAD		(buffer_list);
@@ -3021,14 +3021,22 @@ xlog_do_recovery_pass(
 		if (error)
 			goto bread_err1;
 
-		hblks = xlog_logrec_hblks(log, rhead);
-		if (hblks != 1) {
-			kvfree(hbp);
-			hbp = xlog_alloc_buffer(log, hblks);
+		/*
+		 * This open codes xlog_logrec_hblks so that we can reuse the
+		 * fixed up h_size value calculated above.  Without that we'd
+		 * still allocate the buffer based on the incorrect on-disk
+		 * size.
+		 */
+		if (h_size > XLOG_HEADER_CYCLE_SIZE &&
+		    (rhead->h_version & cpu_to_be32(XLOG_VERSION_2))) {
+			hblks = DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
+			if (hblks > 1) {
+				kvfree(hbp);
+				hbp = xlog_alloc_buffer(log, hblks);
+			}
 		}
 	} else {
 		ASSERT(log->l_sectBBsize == 1);
-		hblks = 1;
 		hbp = xlog_alloc_buffer(log, 1);
 		h_size = XLOG_BIG_RECORD_BSIZE;
 	}
-- 
2.43.0



