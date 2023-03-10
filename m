Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0C8848C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413CAC433D2;
	Fri, 10 Mar 2023 14:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458214;
	bh=tKXc9PD8kMdRNHG7iiu0WcI/VFuH20BQFz0w364ybGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3H4VgN7fBxhya/zD8KWc4dzfpuwCe/V9I1lsjqOvIrSglwvlNPC7XjHAn0QjvzQb
	 S9Mn6Ms7y4USkr48/uVpBIZHd9ZUi1Z8290LEYbWf1CgV1aaSZFu11UHYrs+LC4IAu
	 yLDC3V3V89Zcfs6/p0Gkc+eDpWFUCrU+7W1Rasio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 203/252] ubifs: Rectify space budget for ubifs_xrename()
Date: Fri, 10 Mar 2023 14:39:33 +0100
Message-Id: <20230310133725.209267834@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 1b2ba09060e41adb356b9ae58ef94a7390928004 ]

There is no space budget for ubifs_xrename(). It may let
make_reservation() return with -ENOSPC, which could turn
ubifs to read-only mode in do_writepage() process.
Fix it by adding space budget for ubifs_xrename().

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216569
Fixes: 9ec64962afb170 ("ubifs: Implement RENAME_EXCHANGE")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/dir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index f054c12a0f939..89c5c2abc0faf 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1549,6 +1549,10 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 		return err;
 	}
 
+	err = ubifs_budget_space(c, &req);
+	if (err)
+		goto out;
+
 	lock_4_inodes(old_dir, new_dir, NULL, NULL);
 
 	time = current_time(old_dir);
@@ -1574,6 +1578,7 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	unlock_4_inodes(old_dir, new_dir, NULL, NULL);
 	ubifs_release_budget(c, &req);
 
+out:
 	fscrypt_free_filename(&fst_nm);
 	fscrypt_free_filename(&snd_nm);
 	return err;
-- 
2.39.2



