Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EA9200BA
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyGW9dg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E88C433C8;
	Mon,  6 Nov 2023 13:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276571;
	bh=+xLBHA0chZR9ni5Oh1uz7f+bSjcqPwPbhCgr6/2QZOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyGW9dg5SkKlaq3/bQF6kehsptyUAERBiWRkpD5Ht3a3cUQURFx8jXc/vIZ6pOew3
	 d7jQ+/xsMWKtZFTXI9KkafJjJhqDDDJ7f+4hUSNlKg66qSoztsekdbu/lmp66YK9pq
	 yLsQIpwFS+zLjA/IGiz6MR7h8cxbxP0hCw/QY9Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 25/88] fs/ntfs3: Do not allow to change label if volume is read-only
Date: Mon,  6 Nov 2023 14:03:19 +0100
Message-ID: <20231106130306.713298678@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit e52dce610a2d53bf2b5e94a8843c71cb73a91ea5 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index d699819c70a14..32c5de5699929 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -498,7 +498,12 @@ static ssize_t ntfs3_label_write(struct file *file, const char __user *buffer,
 	struct super_block *sb = pde_data(file_inode(file));
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
 	ssize_t ret = count;
-	u8 *label = kmalloc(count, GFP_NOFS);
+	u8 *label;
+
+	if (sb_rdonly(sb))
+		return -EROFS;
+
+	label = kmalloc(count, GFP_NOFS);
 
 	if (!label)
 		return -ENOMEM;
-- 
2.42.0



