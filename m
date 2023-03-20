Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D766B1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5703EC433D2;
	Mon, 20 Mar 2023 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325646;
	bh=CrlgYa5+8GUkSasgpBUKSlDHJhu07CrQBRkPfPGcSoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2DIFMd+QwWVE+UCTX9ZL3xdP1V+6JWuIkzljrKhe/CPzTZWI5LeRGAl9eUMQogJS
	 EQGvLy/BI604JAhjOfzCvs0plrNPUPtu8UJTf65Yz43bmy0qUcEWQikefpw7lrma5K
	 JOhVpjwR8Y2HV+pG02XUhIIKSwmkyL55rI3vhFyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	syzbot+0c73d1d8b952c5f3d714@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 116/198] ext4: fix possible double unlock when moving a directory
Date: Mon, 20 Mar 2023 15:54:14 +0100
Message-Id: <20230320145512.434945183@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Theodore Ts'o <tytso@mit.edu>

commit 70e42feab2e20618ddd0cbfc4ab4b08628236ecd upstream.

Fixes: 0813299c586b ("ext4: Fix possible corruption when moving a directory")
Link: https://lore.kernel.org/r/5efbe1b9-ad8b-4a4f-b422-24824d2b775c@kili.mountain
Reported-by: Dan Carpenter <error27@gmail.com>
Reported-by: syzbot+0c73d1d8b952c5f3d714@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3884,10 +3884,8 @@ static int ext4_rename(struct user_names
 				goto end_rename;
 		}
 		retval = ext4_rename_dir_prepare(handle, &old);
-		if (retval) {
-			inode_unlock(old.inode);
+		if (retval)
 			goto end_rename;
-		}
 	}
 	/*
 	 * If we're renaming a file within an inline_data dir and adding or


