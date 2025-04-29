Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E0C24C098;
	Tue, 29 Apr 2025 16:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945260; cv=none; b=UWG5Kz2iy5z6AdS5n5l9PVGcZOry0iJxAegmnQ8dOXHXVKQp0fA6ktXi2jJ5Gr+iumIwAOx1Y8Zsq4r/XpeF94R6fMg1QQMlauY2Qt9T7iTOK5FpCKuAE3Q++3puKn+iXpjmLRKYL5OIzzrQ77sWGp/r02YmG1xgYzph54JKzgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945260; c=relaxed/simple;
	bh=f88Hp7hMO1QdcYkEz+yto7CkGUNYT3uf0jul7l7Y1ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmASkn36sjRihg6t0N3x53N/E2gmEw3nFzd1++zj6jwCrygtP7iHaVw+x9pUbrr1yIuSUDKANMQi9erKkb3rCoCnVkgwMDFE1v+eWtAf0R2JUbiDq8GIekZjMUcb4sT42FHu+jvbU7u569GGPBW1G5mKBaH0PRt6C/T9CLXLyBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=py9Z5N9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="py9Z5N9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3C3C4CEE3;
	Tue, 29 Apr 2025 16:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945260;
	bh=f88Hp7hMO1QdcYkEz+yto7CkGUNYT3uf0jul7l7Y1ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=py9Z5N9KbsgfxOSfEZvjHyCKKJmL487ZIHLuHeIyxheNsR6JD4C4HOI1BvWxN/Ldy
	 2zzG6zP5Tiu6Z4/Pyiho9JHMsgE03tbbX7u5hy2Ur91WSny/CHXzWcphFyfs841bPd
	 R75PRmiMrWhlB0DAcz/ZM7dOKBYuSxg5L3zy/084=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/179] ext4: protect ext4_release_dquot against freezing
Date: Tue, 29 Apr 2025 18:39:24 +0200
Message-ID: <20250429161050.350876231@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6307adb16621a..0d4d50c8038fd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5809,18 +5809,35 @@ static int ext4_release_dquot(struct dquot *dquot)
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



