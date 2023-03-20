Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2699A1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C685C433EF;
	Mon, 20 Mar 2023 15:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324514;
	bh=A/TqCKazcQsdBj1myxRcBs2U2PKjH7eWeaAp3tdPSds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLaXlU++4IBykFqOZL6o3zK9DOzQCjjbqd61/h/KlxIDJ+Z0t5YNBlGvwNlGBte8O
	 G9Cz7AWsWCW0Dr3RpNN46fp3suMB8ojrD+1l0jZHczrwJ/i6+66+YeCeainJNYFgRv
	 5J7LjzFFtKV9QjSNP4fYLUmY75U/RC1PBuaUqxHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	syzbot+0c73d1d8b952c5f3d714@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 44/60] ext4: fix possible double unlock when moving a directory
Date: Mon, 20 Mar 2023 15:54:53 +0100
Message-Id: <20230320145432.738340806@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
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
@@ -3866,10 +3866,8 @@ static int ext4_rename(struct inode *old
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


