Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583D44431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D329CC433EF;
	Wed, 15 Mar 2023 12:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882530;
	bh=74lLmyFO+apqg8p9pAMYXM6bur1XN6Zv4gATIq2JuYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twsgqfb/rMWjNR7ztyFKT2wrYaaDyqwm1NlQAoT8rWNV6bBYKj93MEBMhh7cVMrvO
	 9ryVVlFY0fAad1JGODFRtj0FpJ5kh/1D+ajW8rrwfxg+EFTYNC7cL/ZFimCQ4MWjHy
	 ZCfJmAHJ7YYbEzAoWJgUXQVZhb9kA8yjOkfCxyrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+38695a20b8addcbc1084@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/39] udf: Detect system inodes linked into directory hierarchy
Date: Wed, 15 Mar 2023 13:12:27 +0100
Message-Id: <20230315115721.739996578@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

[ Upstream commit 85a37983ec69cc9fcd188bc37c4de15ee326355a ]

When UDF filesystem is corrupted, hidden system inodes can be linked
into directory hierarchy which is an avenue for further serious
corruption of the filesystem and kernel confusion as noticed by syzbot
fuzzed images. Refuse to access system inodes linked into directory
hierarchy and vice versa.

CC: stable@vger.kernel.org
Reported-by: syzbot+38695a20b8addcbc1084@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 7436337914b19..77421e65623a1 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1871,8 +1871,13 @@ struct inode *__udf_iget(struct super_block *sb, struct kernel_lb_addr *ino,
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(inode->i_state & I_NEW))
+	if (!(inode->i_state & I_NEW)) {
+		if (UDF_I(inode)->i_hidden != hidden_inode) {
+			iput(inode);
+			return ERR_PTR(-EFSCORRUPTED);
+		}
 		return inode;
+	}
 
 	memcpy(&UDF_I(inode)->i_location, ino, sizeof(struct kernel_lb_addr));
 	err = udf_read_inode(inode, hidden_inode);
-- 
2.39.2



