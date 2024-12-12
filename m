Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6A9216E2D;
	Thu, 12 Dec 2024 17:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024948; cv=none; b=ZOi04kMBDeqTNBA96SCLosN7uiDbYS0ZLQBz94+wyEtdmDEErw77RgdFXno93p57m7Qqcfy7/PoV6jrz4ayblGHZpBqgFpgXdVyhhDOmrM2xhDBsQxvFx+VGCUT7g5bW5Ub5YuEwxM54PzF7ssGZQ0Mkn/e2G+z3Htm7TeBu1+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024948; c=relaxed/simple;
	bh=pyXDda+7f5ZiyjPRvv6L5dwWyOItut5y2+KGTPUecm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BG+EeSbBL57bCnfIvE722C2uAAEB6LAWXcR2AKD/Du76QGoc293vf4JIVyRIXoIkU1ogWAZH1FYYl3f+uzXfmPDrR6sE0+dgUB8yGeO6GTul8GMtYO/4R99ozZEE3tOB1pmYoVorHBqvH/plw+OOeo9prJEDYXHhuGAeGVwun5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3CbyPzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3CbyPzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6151C4CECE;
	Thu, 12 Dec 2024 17:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024948;
	bh=pyXDda+7f5ZiyjPRvv6L5dwWyOItut5y2+KGTPUecm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3CbyPzpq9lENIsML2EQwN4mfVrZLX1HOozA3q0TxVZfIXL7h5gkX3KQzRgH9x3+4
	 2SYVz6iezYkWQFgnyyXgSlsLuUAOafW5IgxB9OhXxm8h5yFaIC+AbK/hSOQENDRfkz
	 ums8PWsYbA6OK6KxGv+3QYZaGdfn7dS5eealwxrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>
Subject: [PATCH 5.10 450/459] ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"
Date: Thu, 12 Dec 2024 16:03:08 +0100
Message-ID: <20241212144311.546914994@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heming Zhao <heming.zhao@suse.com>

This reverts commit dfe6c5692fb5 ("ocfs2: fix the la space leak when
unmounting an ocfs2 volume").

In commit dfe6c5692fb5, the commit log "This bug has existed since the
initial OCFS2 code." is wrong. The correct introduction commit is
30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()").

The influence of commit dfe6c5692fb5 is that it provides a correct
fix for the latest kernel. however, it shouldn't be pushed to stable
branches. Let's use this commit to revert all branches that include
dfe6c5692fb5 and use a new fix method to fix commit 30dd3478c3cd.

Fixes: dfe6c5692fb5 ("ocfs2: fix the la space leak when unmounting an ocfs2 volume")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/localalloc.c |   19 -------------------
 1 file changed, 19 deletions(-)

--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1010,25 +1010,6 @@ static int ocfs2_sync_local_to_main(stru
 		start = bit_off + 1;
 	}
 
-	/* clear the contiguous bits until the end boundary */
-	if (count) {
-		blkno = la_start_blk +
-			ocfs2_clusters_to_blocks(osb->sb,
-					start - count);
-
-		trace_ocfs2_sync_local_to_main_free(
-				count, start - count,
-				(unsigned long long)la_start_blk,
-				(unsigned long long)blkno);
-
-		status = ocfs2_release_clusters(handle,
-				main_bm_inode,
-				main_bm_bh, blkno,
-				count);
-		if (status < 0)
-			mlog_errno(status);
-	}
-
 bail:
 	if (status)
 		mlog_errno(status);


