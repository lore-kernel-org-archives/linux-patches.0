Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8523770B;
	Thu, 17 Apr 2025 18:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915382; cv=none; b=Z5IMGT8b03VHOTLt1ziZHFKoeX5XENfWwbFqC/TKiirO5S+BoPewHxOzBcXCzj8/+SKP9TU80blJI+XV2mOVVt69448yUYdMi1fhOS2OY8uDdZYMKiQWjVU2IMz2q3lp5XZLyY9Ss5pLsuutQlWjzOI3T1asWDGeQ45R6aWP3Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915382; c=relaxed/simple;
	bh=85NLhwv/U7RZtapRhyJ3N/gvuxa8fnSZqa8T8cOTI6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKMZofScxWsvwy+/Ss8pCFrQxdk5MFlnOEvq9sWD1O0LMeRpXYpdx22juvdLFiw8KVJ+4khxPTDnwQYiTzjJ0fBFbSR/GucQYdoK0jhGzXFfV1ALCkZUrfs0R45/Z3kMZjHeupOjLIdb1EeDLf3Dpb5qTyf4LXYgjJArs42bsQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpa/zrNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpa/zrNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4A9C4CEF4;
	Thu, 17 Apr 2025 18:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915382;
	bh=85NLhwv/U7RZtapRhyJ3N/gvuxa8fnSZqa8T8cOTI6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpa/zrNobd3fOESHGt78wjRQ7y+9DQvp2DVlclva+ShsNcqAV0rZ2Qg1TdtJIDlQG
	 8J1MmYDTMjiQG+LNQIzWcWZ/pAc7hl1nQLTV5XlySm/0eCdH6dW//IXd1TlKomuHb0
	 mvdHHnwKGmRB1XL7CGBRXm6xp8wdKAPmQSzX2Y5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/393] ext4: protect ext4_release_dquot against freezing
Date: Thu, 17 Apr 2025 19:48:38 +0200
Message-ID: <20250417175111.974774357@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

[ Upstream commit 530fea29ef82e169cd7fe048c2b7baaeb85a0028 ]

Protect ext4_release_dquot against freezing so that we
don't try to start a transaction when FS is frozen, leading
to warnings.

Further, avoid taking the freeze protection if a transaction
is already running so that we don't need end up in a deadlock
as described in

  46e294efc355 ext4: fix deadlock with fs freezing and EA inodes

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20241121123855.645335-3-ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d3795c6c0a9d8..4291ab3c20be6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6906,12 +6906,25 @@ static int ext4_release_dquot(struct dquot *dquot)
 {
 	int ret, err;
 	handle_t *handle;
+	bool freeze_protected = false;
+
+	/*
+	 * Trying to sb_start_intwrite() in a running transaction
+	 * can result in a deadlock. Further, running transactions
+	 * are already protected from freezing.
+	 */
+	if (!ext4_journal_current_handle()) {
+		sb_start_intwrite(dquot->dq_sb);
+		freeze_protected = true;
+	}
 
 	handle = ext4_journal_start(dquot_to_inode(dquot), EXT4_HT_QUOTA,
 				    EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb));
 	if (IS_ERR(handle)) {
 		/* Release dquot anyway to avoid endless cycle in dqput() */
 		dquot_release(dquot);
+		if (freeze_protected)
+			sb_end_intwrite(dquot->dq_sb);
 		return PTR_ERR(handle);
 	}
 	ret = dquot_release(dquot);
@@ -6922,6 +6935,10 @@ static int ext4_release_dquot(struct dquot *dquot)
 	err = ext4_journal_stop(handle);
 	if (!ret)
 		ret = err;
+
+	if (freeze_protected)
+		sb_end_intwrite(dquot->dq_sb);
+
 	return ret;
 }
 
-- 
2.39.5



