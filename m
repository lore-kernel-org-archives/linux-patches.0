Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F98934DCDF;
	Tue, 26 Aug 2025 13:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216098; cv=none; b=QlcpnmKQntq9VgCFi/awGmp/PFgZ/iPrcxL3eQ/t2zmvr4ZFghRb96EyuqcKsSnNXaUNXD1L19pztOZ0xyV291/7vBJyyXxkO2xrZFf+xabb2k30r6OYHmaKvtPw3RdELWPK3ugbacqq94zlvHcCZ5PfrvY7x3aAkD2NTxLAdKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216098; c=relaxed/simple;
	bh=Hdbj4oV2GBlceI3UZQFkEGTcu16X5BCZqF2yL6a64FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQ0bfRmxkxJROL8Afp7JHFX+sr7hZ7VD9d4gDtLmf7e1dTeeYsMVI1h8q0jEPJyZ4sgAePWh5QCbhFb9LMH4p6AbJLMdO5jos8u6g6Lvh7AmGxDPlUlcqV4lRv1AFtjebwGuSdV/5D5oV7ZipMI8Qxel4fPkxzNHiEeHE6UXuLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngsPuE6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngsPuE6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0735C4CEF1;
	Tue, 26 Aug 2025 13:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216098;
	bh=Hdbj4oV2GBlceI3UZQFkEGTcu16X5BCZqF2yL6a64FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngsPuE6tGjyqTZOVDSXwwsraE4dMxV+Di33U2OwAu0/CYezm9aLoqTZ0ZwBceqE23
	 Iav8lLBDOFB/mSSAjFpcMQl1tHi1I/3XKzPnKsNz2qG7AzO/KP9C1SOj2/yYMsTZNM
	 kc7uG1J/PqMa3klD1vYoGYnLDgKKXFQyIMYAEKCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+1107451c16b9eb9d29e6@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 283/644] hfsplus: dont use BUG_ON() in hfsplus_create_attributes_file()
Date: Tue, 26 Aug 2025 13:06:14 +0200
Message-ID: <20250826110953.391707038@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit c7c6363ca186747ebc2df10c8a1a51e66e0e32d9 ]

When the volume header contains erroneous values that do not reflect
the actual state of the filesystem, hfsplus_fill_super() assumes that
the attributes file is not yet created, which later results in hitting
BUG_ON() when hfsplus_create_attributes_file() is called. Replace this
BUG_ON() with -EIO error with a message to suggest running fsck tool.

Reported-by: syzbot <syzbot+1107451c16b9eb9d29e6@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=1107451c16b9eb9d29e6
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/7b587d24-c8a1-4413-9b9a-00a33fbd849f@I-love.SAKURA.ne.jp
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/xattr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
index 71fb2f8e9117..7ad3071debd6 100644
--- a/fs/hfsplus/xattr.c
+++ b/fs/hfsplus/xattr.c
@@ -172,7 +172,11 @@ static int hfsplus_create_attributes_file(struct super_block *sb)
 		return PTR_ERR(attr_file);
 	}
 
-	BUG_ON(i_size_read(attr_file) != 0);
+	if (i_size_read(attr_file) != 0) {
+		err = -EIO;
+		pr_err("detected inconsistent attributes file, running fsck.hfsplus is recommended.\n");
+		goto end_attr_file_creation;
+	}
 
 	hip = HFSPLUS_I(attr_file);
 
-- 
2.39.5



