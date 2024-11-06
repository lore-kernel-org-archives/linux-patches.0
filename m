Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A877A1D5AD7;
	Wed,  6 Nov 2024 12:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895009; cv=none; b=WAdPzONMF31kLmVofl0VageCdYdISwqF2hRtaMmCTJLrcS0qY8satwvkCjjskneF6t3IwhSM/Z6AmLEfyXACLEvtarbXytillgTdZRmSRsxDLu+3jSv8KBlsPMZpvSvc/hd4GqizK2nJTHx1xTV1W1zUNlCsMNQQvmG8Vxmu0n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895009; c=relaxed/simple;
	bh=ZDIod1yHk6DpIBigq5UMeOAxDxQAvsld2EsOwHAlLTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1ZsYz8rsChWuwjyYThFetErR3vSOSbT59N83BV0lsfom6M4tsX5Kwbx7l2lws/q8ZZ/pjCk4fJSl5iXBYu5jB3frftckea65P3AKo+VubENBbkkVwGkEUBLpVBmoKjSNs0sgRCPyd/Ooa171cWVWnNIF1ctlUr8/bXCjFYUhUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlemliYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlemliYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2D5C4CECD;
	Wed,  6 Nov 2024 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895009;
	bh=ZDIod1yHk6DpIBigq5UMeOAxDxQAvsld2EsOwHAlLTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlemliYuuxqmBpCAdbxTELKsQxAWoL/ubNxBdryipE9BweQfbun1GiBAmb6N44M6B
	 QOzB5odi7xD6I2N/ADJoNnpA7g18+22F0zJv+mdOvAXNFHPUeDPSmNcdZZZsPJYPL0
	 elpzxUqjTXlPAHJI4zSG9eknAfjTBLaPw871xpmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/350] ext4: return error on ext4_find_inline_entry
Date: Wed,  6 Nov 2024 13:00:02 +0100
Message-ID: <20241106120322.723585678@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit 4d231b91a944f3cab355fce65af5871fb5d7735b ]

In case of errors when reading an inode from disk or traversing inline
directory entries, return an error-encoded ERR_PTR instead of returning
NULL. ext4_find_inline_entry only caller, __ext4_find_entry already returns
such encoded errors.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://patch.msgid.link/20240821152324.3621860-3-cascardo@igalia.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: c6b72f5d82b1 ("ext4: avoid OOB when system.data xattr changes underneath the filesystem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 71bb3cfc5933c..ee9f19709eda1 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1658,8 +1658,9 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 	void *inline_start;
 	int inline_size;
 
-	if (ext4_get_inode_loc(dir, &iloc))
-		return NULL;
+	ret = ext4_get_inode_loc(dir, &iloc);
+	if (ret)
+		return ERR_PTR(ret);
 
 	down_read(&EXT4_I(dir)->xattr_sem);
 	if (!ext4_has_inline_data(dir)) {
@@ -1690,7 +1691,10 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 
 out:
 	brelse(iloc.bh);
-	iloc.bh = NULL;
+	if (ret < 0)
+		iloc.bh = ERR_PTR(ret);
+	else
+		iloc.bh = NULL;
 out_find:
 	up_read(&EXT4_I(dir)->xattr_sem);
 	return iloc.bh;
-- 
2.43.0



