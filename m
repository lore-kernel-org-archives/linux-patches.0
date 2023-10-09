Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201AA1A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSpQsFjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B655C433C8;
	Mon,  9 Oct 2023 13:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857824;
	bh=AOBR5gMaGwwyLWPOTUrWjlVAGbDV7xosvXDE2FnBSnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSpQsFjYPMi9Fdh6G0ZDVVLc6BaWF+TXp3tvnhpDCrSjCoyLgCIZnP/yJJm1gqqCr
	 36+eR9er1+SkPtfGTJJXVbJry9rjOeSyQ7/92A5QnM+iCp56W11roZcbPw+Qi2cBo9
	 Xj8CuvxgasZv/O1tO00gHCXsARN4+MB4+xiAMivU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 160/162] btrfs: fix an error handling path in btrfs_rename()
Date: Mon,  9 Oct 2023 15:02:21 +0200
Message-ID: <20231009130127.342659173@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit abe3bf7425fb695a9b37394af18b9ea58a800802 upstream.

If new_whiteout_inode() fails, some resources need to be freed.
Add the missing goto to the error handling path.

Fixes: ab3c5c18e8fa ("btrfs: setup qstr from dentrys using fscrypt helper")
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9400,8 +9400,10 @@ static int btrfs_rename(struct user_name
 
 	if (flags & RENAME_WHITEOUT) {
 		whiteout_args.inode = new_whiteout_inode(mnt_userns, old_dir);
-		if (!whiteout_args.inode)
-			return -ENOMEM;
+		if (!whiteout_args.inode) {
+			ret = -ENOMEM;
+			goto out_fscrypt_names;
+		}
 		ret = btrfs_new_inode_prepare(&whiteout_args, &trans_num_items);
 		if (ret)
 			goto out_whiteout_inode;


