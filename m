Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD3D13BACD;
	Thu, 11 Apr 2024 10:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832622; cv=none; b=EalYzUCo6V9evGQkParBJzJGZfxCOg+bXPiNfF6WqoS8pIuHsOncJoC2H1EVcm0dqCP96mxHPBOys4+zwMxdsVRwY3c6Z+SwwmPcbbbJdxwd8SMf0bhyVlB74B+j1TswXccZKrltTH6VrfsPzOTe1TfzT+87nttpDN1LCNlCX2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832622; c=relaxed/simple;
	bh=zSKUN4LzRl7M3Hq2QQ8Qm9aK2eJM4+rF7BmiQIRfJHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UX1WEa6Ojchhc9IiIAZKjSUIOA7eUUS6Xzo/qpyMW7Agh/9n1njZYNLZJxXKdtUoDqCTNMWwf3aab0uhUafFtjNaupm0rEeFqRgQ1ddibaKNHouHxY9UqgONkYGVPojPtOt7hdpP9t29FY2LNSJIoiL5WYYdNy+USiygyy+uIBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/jN66eL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/jN66eL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA96C433C7;
	Thu, 11 Apr 2024 10:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832622;
	bh=zSKUN4LzRl7M3Hq2QQ8Qm9aK2eJM4+rF7BmiQIRfJHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/jN66eLadKOdl2xsyL1ySwUUs4+lmqtuPF5wwQWucRoMkeaQU5b9kwVNpW2xVkK1
	 o1jhAhQnnslWwGXv/78PQuUBN4xozxkCa/B3U/AoSFQcGeL6WMa+jfJZesXTVXxxv3
	 UZ2fooZyhSSgmF8Iy6vyfkb9AObMb0c0WZp4cnBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/57] ext4: forbid commit inconsistent quota data when errors=remount-ro
Date: Thu, 11 Apr 2024 11:57:36 +0200
Message-ID: <20240411095408.846601596@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8b276b95a7904..b09b7a6b7a154 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6170,6 +6170,10 @@ static int ext4_write_dquot(struct dquot *dquot)
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
@@ -6186,6 +6190,10 @@ static int ext4_acquire_dquot(struct dquot *dquot)
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
@@ -6205,6 +6213,10 @@ static int ext4_release_dquot(struct dquot *dquot)
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



