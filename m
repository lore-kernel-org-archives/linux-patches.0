Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628EB146A71;
	Thu, 11 Apr 2024 10:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831313; cv=none; b=XEgLiiztetqFPF2UC14ZH/OCdSZKOsL21RLqbZ/3t0tqm4wuE8zcE0v46UVP8np4p00or+6x6w9OMendvO/H4nycz9c5dcWpzkTrCLwBlTd7ZIx66YNDCiL/EYK8+9SbjqXpBZJDT8yDGQdSCFjbPVCr+IPKK0YUvGJPHBaqGBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831313; c=relaxed/simple;
	bh=ur5XYLMQIeNEfu7kqJbPOLTgWN/vAcoNJVK3VqJLHDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZ5ZIQeK1RZfVbrHnPUbk44tNGCe+lwH9WSy7MYFPPnkpXdjVYa+NvQvgSjKlS3JoQWnIcYhc6jOhdiAGbQfgRC5m6EPndhaejgZyT5LtBgfdWJkSBTlAmmWNCNov5kSeesXHJGt8g4a5sDGMiMl5BOCRHQeIK82BdJ8Yo0n+co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuPRWULJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuPRWULJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAD0C433F1;
	Thu, 11 Apr 2024 10:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831313;
	bh=ur5XYLMQIeNEfu7kqJbPOLTgWN/vAcoNJVK3VqJLHDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuPRWULJoZNI0I2VhRhMZxTzWWg/n+u52paqcnuFFps8eW8fhPtwFMU6ZGqo6lDJH
	 rpBrzxJYIaaZOUqj0lL87SozByiTqQxDSwRjxJNvT2LqdqzG6xr4XqpJFXEMCWui5q
	 s9ZEX/d8m3FjaTxvjDq12HeK8Jg4m1qzyRSNYV5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/114] ext4: forbid commit inconsistent quota data when errors=remount-ro
Date: Thu, 11 Apr 2024 11:56:30 +0200
Message-ID: <20240411095418.788725203@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit d8b945fa475f13d787df00c26a6dc45a3e2e1d1d ]

There's issue as follows When do IO fault injection test:
Quota error (device dm-3): find_block_dqentry: Quota for id 101 referenced but not present
Quota error (device dm-3): qtree_read_dquot: Can't read quota structure for id 101
Quota error (device dm-3): do_check_range: Getting block 2021161007 out of range 1-186
Quota error (device dm-3): qtree_read_dquot: Can't read quota structure for id 661

Now, ext4_write_dquot()/ext4_acquire_dquot()/ext4_release_dquot() may commit
inconsistent quota data even if process failed. This may lead to filesystem
corruption.
To ensure filesystem consistent when errors=remount-ro there is need to call
ext4_handle_error() to abort journal.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240119062908.3598806-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ea4d8f11e7bb..83fc3f092a0c7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6865,6 +6865,10 @@ static int ext4_write_dquot(struct dquot *dquot)
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_commit(dquot);
+	if (ret < 0)
+		ext4_error_err(dquot->dq_sb, -ret,
+			       "Failed to commit dquot type %d",
+			       dquot->dq_id.type);
 	err = ext4_journal_stop(handle);
 	if (!ret)
 		ret = err;
@@ -6881,6 +6885,10 @@ static int ext4_acquire_dquot(struct dquot *dquot)
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_acquire(dquot);
+	if (ret < 0)
+		ext4_error_err(dquot->dq_sb, -ret,
+			      "Failed to acquire dquot type %d",
+			      dquot->dq_id.type);
 	err = ext4_journal_stop(handle);
 	if (!ret)
 		ret = err;
@@ -6900,6 +6908,10 @@ static int ext4_release_dquot(struct dquot *dquot)
 		return PTR_ERR(handle);
 	}
 	ret = dquot_release(dquot);
+	if (ret < 0)
+		ext4_error_err(dquot->dq_sb, -ret,
+			       "Failed to release dquot type %d",
+			       dquot->dq_id.type);
 	err = ext4_journal_stop(handle);
 	if (!ret)
 		ret = err;
-- 
2.43.0



