Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A5D51A159;
	Thu, 17 Sep 2026 17:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666528; cv=none; b=dzuNyxTx3fw4F1wDJko0d8Ft7WQhXE8B7OrYDuv21vbakYLBKC3bBSzQWZ+Oek5elgkFoSOHzhD7kKQqxE9AvCVyEe3PMQZuO2+o8FJ9CEX63mlaOyyazudw6vof3hC8phRbN7SaYUpyjwsegod9Wt+aKlJjBsHp3z/opn0/yCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666528; c=relaxed/simple;
	bh=4y4dDJrHE/C7L7e9gyyYNxlcvndYanIGyy7Lbyfzl2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAdPJwEQgN4DQYl94lKUK8c3rhuBv1/S/FCt2dxKSb4c5SQGRc15+wZYafLpU4V9duHQy3i1ljz0587gzM34jj1muOkknRwIpQb2P8J6jNuQlhzOsMOx/VLxEc+TD3m7hx81ceZz0xiF9QO2nZdP5mhFZbKBIjP+0g7itJ0pw7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXSTUHeF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXSTUHeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67821F000FF;
	Thu, 17 Sep 2026 17:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666527;
	bh=Llfm/ACT8mozvZoxlzXZ80EaKWgt3lzs8iLGl/Z6ufQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nXSTUHeFwhgwhTctPxAOsJJKdZQvFWjmN8Ntdd7ScP8HmC+uykLhVNhSeUBdfzkgr
	 rT8bGQH2bj2E2J4Ptdqo4NDwUuI2rScd3UtqIGogDtyALjMV3jn0tbY1GmdCV5IkP5
	 E3b6Qera5itWebK9f5tMTQsBA2S6+yTzGEvSBEug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+df1db6e034b3953e19f5@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Ian Kent <raven@themaw.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 1028/1250] fs: autofs: fix memory leak in autofs_fill_super()
Date: Thu, 17 Sep 2026 16:13:43 +0100
Message-ID: <20260917151619.930399630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeffin Philip <jeffinphilip14@gmail.com>

commit 5ab54837fce04a1c9923d0bfd3d5de51fdc768b3 upstream.

In autofs_fill_super(), we create a new inode using
autofs_new_ino(), however, if we fail to create root_inode,
(that is, root_inode failure path), we return -ENOMEM without
freeing the new inode(ino) that we created causing a memory leak.
Fix this by adding autofs_free_ino() to free the inode we created
in root_inode failure path before returning ENOMEM.

Reported-by: syzbot+df1db6e034b3953e19f5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=df1db6e034b3953e19f5
Fixes: 66917f85db60 ("autofs: add: new_inode check in autofs_fill_super()")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Link: https://patch.msgid.link/20260903081048.132524-1-jeffinphilip14@gmail.com
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/autofs/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -322,8 +322,10 @@ static int autofs_fill_super(struct supe
 		return -ENOMEM;
 
 	root_inode = autofs_get_inode(s, S_IFDIR | 0755);
-	if (!root_inode)
+	if (!root_inode) {
+		autofs_free_ino(ino);
 		return -ENOMEM;
+	}
 
 	root_inode->i_uid = ctx->uid;
 	root_inode->i_gid = ctx->gid;


