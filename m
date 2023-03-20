Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3501C29
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E4EC4339B;
	Mon, 20 Mar 2023 15:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325163;
	bh=w7ncPlp2FMxPWW8bhuvD7WOkeGLvgIrCC3mbaCLn7j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4M765DdxXDrIhf2qOS1rpJDzk+7OLX5Qs2llblytmrInPfxqd5/fangPK7P3TzWM
	 dosbue09fQhCNyMivbJZdVb0S4O45SnRdi7PUWM7K7HxJJ/HpbumcdFGVBO22YHV0p
	 KaY+WKX82AS98rfnHZkvA5ZpXrsgCE0cBZfRFwiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	syzbot+0c73d1d8b952c5f3d714@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 073/115] ext4: fix possible double unlock when moving a directory
Date: Mon, 20 Mar 2023 15:54:45 +0100
Message-Id: <20230320145452.492954755@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
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
@@ -3898,10 +3898,8 @@ static int ext4_rename(struct user_names
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


