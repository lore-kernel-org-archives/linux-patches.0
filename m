Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464B42C21F6;
	Tue, 12 Aug 2025 18:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024520; cv=none; b=Bd8GzA67ZI8H1S24e34OtaOmJUsoh11CDbIDKhHS1UxSdrrN2B8NU5SnlNCCTo3NkAWy4ml7uK6XdNvCNyiC8VxsgdPyxUFWUGlxk01xhg5uMtIsRLEkfNV0isMXbfYC14fnlgTYGYs7+dvARWYZpE0V1QIHFIGkztShQKjLY1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024520; c=relaxed/simple;
	bh=DsvTHY1FdOj2ncR/yWiPlxHHqLKkwrTWBzVdOJOO6U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzzJqmV6mxu7+Uuyu5abw4CdiJFwS2yqeSO4E0T8qjuuthp3Tum5vXDKR0NozFKYQ+25YbKB9s7JecUz5JFCV8jpakqg849RtyVqSY1srFCkiFzj2kBHHZDM/PgO77f5uPKuA9vALZdwnfJC9MnsTD6DuamgVutEjhXH+D29jkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvr08RUu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvr08RUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59640C4CEF0;
	Tue, 12 Aug 2025 18:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024519;
	bh=DsvTHY1FdOj2ncR/yWiPlxHHqLKkwrTWBzVdOJOO6U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yvr08RUu6PvZ0wbKNHYR9eCDxNHqDV4o/ph1Nln2UHQbsN05WHDhzfVmb+71Ae25i
	 ndeZvUntV8WurB3Pv8Xq4Pd+x+d+0LpNffVeFUiybVP1ZMfqBk9KoJaEWOkjdy7Wr2
	 /vBRJD17qrwt3pQ6gEjHj2latN5jGe5sgq/r7nQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 398/627] ext4: fix inode use after free in ext4_end_io_rsv_work()
Date: Tue, 12 Aug 2025 19:31:33 +0200
Message-ID: <20250812173434.437193636@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit c678bdc998754589cea2e6afab9401d7d8312ac4 ]

In ext4_io_end_defer_completion(), check if io_end->list_vec is empty to
avoid adding an io_end that requires no conversion to the
i_rsv_conversion_list, which in turn prevents starting an unnecessary
worker. An ext4_emergency_state() check is also added to avoid attempting
to abort the journal in an emergency state.

Additionally, ext4_put_io_end_defer() is refactored to call
ext4_io_end_defer_completion() directly instead of being open-coded.
This also prevents starting an unnecessary worker when EXT4_IO_END_FAILED
is set but data_err=abort is not enabled.

This ensures that the check in ext4_put_io_end_defer() is consistent with
the check in ext4_end_bio(). Otherwise, we might add an io_end to the
i_rsv_conversion_list and then call ext4_finish_bio(), after which the
inode could be freed before ext4_end_io_rsv_work() is called, triggering
a use-after-free issue.

Fixes: ce51afb8cc5e ("ext4: abort journal on data writeback failure if in data_err=abort mode")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250708111504.3208660-1-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/page-io.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 179e54f3a3b6..3d8b0f6d2dea 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -236,10 +236,12 @@ static void dump_completed_IO(struct inode *inode, struct list_head *head)
 
 static bool ext4_io_end_defer_completion(ext4_io_end_t *io_end)
 {
-	if (io_end->flag & EXT4_IO_END_UNWRITTEN)
+	if (io_end->flag & EXT4_IO_END_UNWRITTEN &&
+	    !list_empty(&io_end->list_vec))
 		return true;
 	if (test_opt(io_end->inode->i_sb, DATA_ERR_ABORT) &&
-	    io_end->flag & EXT4_IO_END_FAILED)
+	    io_end->flag & EXT4_IO_END_FAILED &&
+	    !ext4_emergency_state(io_end->inode->i_sb))
 		return true;
 	return false;
 }
@@ -256,6 +258,7 @@ static void ext4_add_complete_io(ext4_io_end_t *io_end)
 	WARN_ON(!(io_end->flag & EXT4_IO_END_DEFER_COMPLETION));
 	WARN_ON(io_end->flag & EXT4_IO_END_UNWRITTEN &&
 		!io_end->handle && sbi->s_journal);
+	WARN_ON(!io_end->bio);
 
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 	wq = sbi->rsv_conversion_wq;
@@ -318,12 +321,9 @@ ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
 void ext4_put_io_end_defer(ext4_io_end_t *io_end)
 {
 	if (refcount_dec_and_test(&io_end->count)) {
-		if (io_end->flag & EXT4_IO_END_FAILED ||
-		    (io_end->flag & EXT4_IO_END_UNWRITTEN &&
-		     !list_empty(&io_end->list_vec))) {
-			ext4_add_complete_io(io_end);
-			return;
-		}
+		if (ext4_io_end_defer_completion(io_end))
+			return ext4_add_complete_io(io_end);
+
 		ext4_release_io_end(io_end);
 	}
 }
-- 
2.39.5



