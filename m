Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A95746444;
	Tue, 10 Sep 2024 09:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961019; cv=none; b=ETvuKnzu/SiChfR79KlGTNm394h8v7dNUdUgQZaYbjWyAGguMDKIgidpNUjcwW0vMa3uSXgg4mGI/5PoaAcm16Xqp/2/XpCE1M5OBkiJqsejuH0B1zbocwAOfII9XXscqoYDu1mJnrReRRkiGqi6cV6tqF7rnkeVsiseZE0H12k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961019; c=relaxed/simple;
	bh=c6Wi75THa7bMcuRRpvuVh3no7h31K2jJ7vtfwTs8v1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQyXF6uh8K4MA3SEKYI+ix7/f26n2O+c2os8Sg4O20efwUyRR/ek/hwfQFr8VxXlTVllEUNMj9UAqtYKqi0PmC/kgEFMuHgPR2I0X7EZClWcKBZ24AzaCKn0goR2SB9GgQaekYMUeBuV7qsEGIJFRD0trYgortlgoonkl1mFBZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVxrCNhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVxrCNhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E93C4CEC3;
	Tue, 10 Sep 2024 09:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961018;
	bh=c6Wi75THa7bMcuRRpvuVh3no7h31K2jJ7vtfwTs8v1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVxrCNhMaaha8Mpi+GtzxuMhtUzTrW/3FIjRsIVgE8ycvRIMgF/iEqasQnjodD+MI
	 QsVmDjJgy+8rfu/sWqO1L2KH7fjckfgH8G1YhFcAbRpDfuHv8ce7rQDSrndvdcQg0G
	 9EsFeS+XUq6/IpsqIfxD6BFDnKEi8xPE9w4/IhS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 25/96] nilfs2: fix state management in error path of log writing function
Date: Tue, 10 Sep 2024 11:31:27 +0200
Message-ID: <20240910092542.551035492@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 6576dd6695f2afca3f4954029ac4a64f82ba60ab upstream.

After commit a694291a6211 ("nilfs2: separate wait function from
nilfs_segctor_write") was applied, the log writing function
nilfs_segctor_do_construct() was able to issue I/O requests continuously
even if user data blocks were split into multiple logs across segments,
but two potential flaws were introduced in its error handling.

First, if nilfs_segctor_begin_construction() fails while creating the
second or subsequent logs, the log writing function returns without
calling nilfs_segctor_abort_construction(), so the writeback flag set on
pages/folios will remain uncleared.  This causes page cache operations to
hang waiting for the writeback flag.  For example,
truncate_inode_pages_final(), which is called via nilfs_evict_inode() when
an inode is evicted from memory, will hang.

Second, the NILFS_I_COLLECTED flag set on normal inodes remain uncleared.
As a result, if the next log write involves checkpoint creation, that's
fine, but if a partial log write is performed that does not, inodes with
NILFS_I_COLLECTED set are erroneously removed from the "sc_dirty_files"
list, and their data and b-tree blocks may not be written to the device,
corrupting the block mapping.

Fix these issues by uniformly calling nilfs_segctor_abort_construction()
on failure of each step in the loop in nilfs_segctor_do_construct(),
having it clean up logs and segment usages according to progress, and
correcting the conditions for calling nilfs_redirty_inodes() to ensure
that the NILFS_I_COLLECTED flag is cleared.

Link: https://lkml.kernel.org/r/20240814101119.4070-1-konishi.ryusuke@gmail.com
Fixes: a694291a6211 ("nilfs2: separate wait function from nilfs_segctor_write")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1828,6 +1828,9 @@ static void nilfs_segctor_abort_construc
 	nilfs_abort_logs(&logs, ret ? : err);
 
 	list_splice_tail_init(&sci->sc_segbufs, &logs);
+	if (list_empty(&logs))
+		return; /* if the first segment buffer preparation failed */
+
 	nilfs_cancel_segusage(&logs, nilfs->ns_sufile);
 	nilfs_free_incomplete_logs(&logs, nilfs);
 
@@ -2072,7 +2075,7 @@ static int nilfs_segctor_do_construct(st
 
 		err = nilfs_segctor_begin_construction(sci, nilfs);
 		if (unlikely(err))
-			goto out;
+			goto failed;
 
 		/* Update time stamp */
 		sci->sc_seg_ctime = ktime_get_real_seconds();
@@ -2135,10 +2138,9 @@ static int nilfs_segctor_do_construct(st
 	return err;
 
  failed_to_write:
-	if (sci->sc_stage.flags & NILFS_CF_IFILE_STARTED)
-		nilfs_redirty_inodes(&sci->sc_dirty_files);
-
  failed:
+	if (mode == SC_LSEG_SR && nilfs_sc_cstage_get(sci) >= NILFS_ST_IFILE)
+		nilfs_redirty_inodes(&sci->sc_dirty_files);
 	if (nilfs_doing_gc())
 		nilfs_redirty_inodes(&sci->sc_gc_inodes);
 	nilfs_segctor_abort_construction(sci, nilfs, err);


