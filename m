Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBE3189910;
	Tue,  8 Oct 2024 12:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392360; cv=none; b=o0QpX/rM3ZETuec5uD8QivrrWFHqAthE/UQ9pTmkqq2tslBUGr0cQ6IXHNG36MpNpXLd/jDrr4OGflxOKe/VaXD79cFn8FPrPzw+AOVB1nIcXcAdtqwmRzdXhi5rgl/F1Y0d+JctJ0PW3OwqLILBo5KUYXwBMiSu8UvbKtr5M4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392360; c=relaxed/simple;
	bh=2q1u9m8tAstS1UauF+BvemKWHynZHGO2KdluZH1lP0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+FfrmNrHK6KlFYncIk6NhBFYXuXCQ8seQs0UXsJfNHdsblYk67R/tdA3MWSdEfkNEhZm5URAZQ9PT61GbzIB+qkHEPqvUh7gPdRaOW5BoEFfQutpMFcc/PIdf3mpLh31liLmZS2Q/Q3Uy0itvGfqvxb95sWXcI9shy/s70wjos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RN/WZlxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RN/WZlxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F12C4CECF;
	Tue,  8 Oct 2024 12:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392360;
	bh=2q1u9m8tAstS1UauF+BvemKWHynZHGO2KdluZH1lP0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RN/WZlxVrCONIHbgC8ZTtxUxXpzZPpza3HWwjd9EhAH89h/behTAP0Nxq5lRSlDia
	 dlP3MuadaeGFtgM2EZOcM4dxWA37INtIMlyNEnGj1k+HH8iSyQVhBMDS8+ZH8eHBq8
	 mV94aoBFYl6+MiRNYwk+yLq8XuRlzkJOhjU4zepw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.11 393/558] ext4: fix incorrect tid assumption in ext4_wait_for_tail_page_commit()
Date: Tue,  8 Oct 2024 14:07:03 +0200
Message-ID: <20241008115717.748133854@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

commit dd589b0f1445e1ea1085b98edca6e4d5dedb98d0 upstream.

Function ext4_wait_for_tail_page_commit() assumes that '0' is not a valid
value for transaction IDs, which is incorrect.  Don't assume that and invoke
jbd2_log_wait_commit() if the journal had a committing transaction instead.

Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240724161119.13448-2-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5279,8 +5279,9 @@ static void ext4_wait_for_tail_page_comm
 {
 	unsigned offset;
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
-	tid_t commit_tid = 0;
+	tid_t commit_tid;
 	int ret;
+	bool has_transaction;
 
 	offset = inode->i_size & (PAGE_SIZE - 1);
 	/*
@@ -5305,12 +5306,14 @@ static void ext4_wait_for_tail_page_comm
 		folio_put(folio);
 		if (ret != -EBUSY)
 			return;
-		commit_tid = 0;
+		has_transaction = false;
 		read_lock(&journal->j_state_lock);
-		if (journal->j_committing_transaction)
+		if (journal->j_committing_transaction) {
 			commit_tid = journal->j_committing_transaction->t_tid;
+			has_transaction = true;
+		}
 		read_unlock(&journal->j_state_lock);
-		if (commit_tid)
+		if (has_transaction)
 			jbd2_log_wait_commit(journal, commit_tid);
 	}
 }


