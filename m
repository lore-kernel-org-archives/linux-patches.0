Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F594BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04522C433D2;
	Tue,  7 Mar 2023 18:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214333;
	bh=Py1bmzYKjFEgUWI+o+vUve/ty30Xarky/J0VLTL8Vfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSbjHlA497etNj8d6xci2U+DF60HLkylD8gNehcoqpLrABcTadacvitObGnwdeD9E
	 OrluRQTYGO9Wc+8zjSJxMeQrGaaB8XpkFPWQh/ZpoH3wMr67dVM3GEKN2BGUL2lSjk
	 ES1A9JB7auyVydeVCRV9LnkIR27+4M5oQpxXVUOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 788/885] ext4: Fix possible corruption when moving a directory
Date: Tue,  7 Mar 2023 18:02:02 +0100
Message-Id: <20230307170036.133148515@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

commit 0813299c586b175d7edb25f56412c54b812d0379 upstream.

When we are renaming a directory to a different directory, we need to
update '..' entry in the moved directory. However nothing prevents moved
directory from being modified and even converted from the inline format
to the normal format. When such race happens the rename code gets
confused and we crash. Fix the problem by locking the moved directory.

CC: stable@vger.kernel.org
Fixes: 32f7f22c0b52 ("ext4: let ext4_rename handle inline dir")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230126112221.11866-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3872,9 +3872,16 @@ static int ext4_rename(struct user_names
 			if (new.dir != old.dir && EXT4_DIR_LINK_MAX(new.dir))
 				goto end_rename;
 		}
+		/*
+		 * We need to protect against old.inode directory getting
+		 * converted from inline directory format into a normal one.
+		 */
+		inode_lock_nested(old.inode, I_MUTEX_NONDIR2);
 		retval = ext4_rename_dir_prepare(handle, &old);
-		if (retval)
+		if (retval) {
+			inode_unlock(old.inode);
 			goto end_rename;
+		}
 	}
 	/*
 	 * If we're renaming a file within an inline_data dir and adding or
@@ -4006,6 +4013,8 @@ end_rename:
 	} else {
 		ext4_journal_stop(handle);
 	}
+	if (old.dir_bh)
+		inode_unlock(old.inode);
 release_bh:
 	brelse(old.dir_bh);
 	brelse(old.bh);


