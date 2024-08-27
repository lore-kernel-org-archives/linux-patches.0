Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0E21BFE06;
	Tue, 27 Aug 2024 14:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770280; cv=none; b=QIVe+b/ODWQXQHP2awhgDcymAZ1gEFyuOAwzUBh9w2iTMj1F/tmTcpeoReXpnGhmKOUlaEWPHrCqc+HobKNyFTSs0JWd7FtHvUUp6Y29/QGE68sbfLIXJ0U9j0t9DMuIa+bYZw3ESrQcc5iwQmPqg1vBbyOpH9Touq6YiiqunGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770280; c=relaxed/simple;
	bh=n6Eg2WJHGTpnRBevrxN6JH4f0pJVOK1OLQDXA2t++AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXIGLaxNFD+pkzB6qxbgMbc2Wt8kFHM1FUHgn7jKD6O03i2a7DCHO+HH/EduS26RxaC8xLJPjqYfdGCnqFxqoEXz0AITVAf5coSbd0iAmpWsXJ8xFUvBmNHFCaz3h9XM3AwThtYmOE2lRjO1eHzs1ZwPFnu5ufu5rB8iI9fPrhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gi9TeXuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gi9TeXuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CABC4DDFF;
	Tue, 27 Aug 2024 14:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770280;
	bh=n6Eg2WJHGTpnRBevrxN6JH4f0pJVOK1OLQDXA2t++AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gi9TeXuzxaxPadHgCvhzU1Vzj0wRKNqZvLW3Kn9D6y7xSVo6dkE/yAO0sJ7ePKtk3
	 lgdURJCKwqjyIOq4DKIKLoyCx62Io0MFbSRt4SIxwUgXBnVk2EG0ibvm3C3wtydSUA
	 n8go87O8xwEGJDB7lwK1KQpQlqz1VPY2dPm2pyEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/341] ext4: do not trim the group with corrupted block bitmap
Date: Tue, 27 Aug 2024 16:36:25 +0200
Message-ID: <20240827143849.277345965@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 172202152a125955367393956acf5f4ffd092e0d ]

Otherwise operating on an incorrupted block bitmap can lead to all sorts
of unknown problems.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f55ab800a7539..870397f3de559 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6953,6 +6953,9 @@ __releases(ext4_group_lock_ptr(sb, e4b->bd_group))
 	bool set_trimmed = false;
 	void *bitmap;
 
+	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)))
+		return 0;
+
 	last = ext4_last_grp_cluster(sb, e4b->bd_group);
 	bitmap = e4b->bd_bitmap;
 	if (start == 0 && max >= last)
-- 
2.43.0



