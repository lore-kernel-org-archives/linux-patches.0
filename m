Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A936183CA6;
	Mon, 12 Aug 2024 16:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479754; cv=none; b=sbwrTU+4aQF5/lDuAfHJ0ygM4Z6pe9E3IgZ+gV01O5BmA49bm+6zaF8f4H3i76nREoGfp8AKHFJ70tRmGwvSRpfujB8VStMxyIZHysJcK7h+yOowKEBryK/1t2zXaoUpu7MN/dko0aPfuCv7cfdDhyavXftL6pNzbNzTnbhM+m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479754; c=relaxed/simple;
	bh=is3FBxTYkS7FSRoD9NtlavL7FHATqKP6Z3/mIzF2hoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOLBD1SzjSzk1/63MSqoCYhca8lYY6y7T49SU14qGGgEvYdB9aESkaMhwa9TXCzlZ8Ud8Rb1EVGMBc4tEVYXbJQ78VsIVjJohyxtpb4pss6yoc0WTEf+vPUKTwbsVWWEGNEtpXENpX2ZKbCROfHXvNFmV+pX99Hd0Op5oqEWxCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CeJH5paP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CeJH5paP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D228AC32782;
	Mon, 12 Aug 2024 16:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479754;
	bh=is3FBxTYkS7FSRoD9NtlavL7FHATqKP6Z3/mIzF2hoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeJH5paP86zEDfBmZJlRs3mv1GdGKq2KvPLaQ0Ii8anwKq3FTn0wgskqmFvAMWfax
	 eB82UFyrF8scjuoEMJAACjmM0+P4iSuZA4alPXBbAV7CSrQnnQVcU37f6F+iho9G9a
	 EdKWSq7noKPGXO7Bf43tweDbHE3AeEF1GfT/RpEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Kevin Berry <kpberry@google.com>
Subject: [PATCH 6.6 181/189] xfs: fix log recovery buffer allocation for the legacy h_size fixup
Date: Mon, 12 Aug 2024 18:03:57 +0200
Message-ID: <20240812160139.116618882@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

commit 45cf976008ddef4a9c9a30310c9b4fb2a9a6602a upstream.

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
Signed-off-by: Kevin Berry <kpberry@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_recover.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

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
-			kmem_free(hbp);
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
+				kmem_free(hbp);
+				hbp = xlog_alloc_buffer(log, hblks);
+			}
 		}
 	} else {
 		ASSERT(log->l_sectBBsize == 1);
-		hblks = 1;
 		hbp = xlog_alloc_buffer(log, 1);
 		h_size = XLOG_BIG_RECORD_BSIZE;
 	}


