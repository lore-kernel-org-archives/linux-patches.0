Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E833B6BB29;
	Thu, 11 Apr 2024 10:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832210; cv=none; b=E6Yu0WwXwOSPvvaGBj5mq+QBfA3Py4npClD18dh/4iIO0Z3jg3e9YrFGlBwL1McwBMbOo7tgX/oz2mnDPKWVBnHK5iRgr6jykOZBezY6T/bweiiAQAOkM71Z+FytAwk7/951H1u1yn/nydyNriVfnpN2gx3Cc20Nsw7c5Xb59AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832210; c=relaxed/simple;
	bh=L+bPlZagvwu7i3VHR4dHEtxgmzK/3VmQ+763kpHN9Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1cCDl/fxVJmqAWtrBV3e77csusKOnVuGpFiDxHUupuw1AU/4wAuwUa/zHSIrjcA7tFG50CrmR34upfUXhTNMtuSFwzZIjxUuuraZbcsdk1LhDzQbUAMKCkhOpF/jEqSLIc8cXNZaFkHTPcehrWSMAlSspodG2+jjq/P8DTeqKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILZw/j7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILZw/j7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703A0C433C7;
	Thu, 11 Apr 2024 10:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832209;
	bh=L+bPlZagvwu7i3VHR4dHEtxgmzK/3VmQ+763kpHN9Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILZw/j7X2NS+DGc1JBtJGIKIexrLN1rbNrIaLOi9fM0yhpFOHSHcHebn7j88vcMFC
	 WPV6z1bA9aop0EyHyP5Yh8+7IL7Bc/fByf7odo8mCMmuXH7A4naijPB3F06sAXDknY
	 SlI2KByOb4IVU4nmE3e02Cd0DgtwrnrKLBhkpaAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 265/294] ext4: forbid commit inconsistent quota data when errors=remount-ro
Date: Thu, 11 Apr 2024 11:57:08 +0200
Message-ID: <20240411095443.533732732@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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
index e386d67cff9d1..0149d3c2cfd78 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6205,6 +6205,10 @@ static int ext4_write_dquot(struct dquot *dquot)
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
@@ -6221,6 +6225,10 @@ static int ext4_acquire_dquot(struct dquot *dquot)
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
@@ -6240,6 +6248,10 @@ static int ext4_release_dquot(struct dquot *dquot)
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



