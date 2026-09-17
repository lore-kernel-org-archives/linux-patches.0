Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E4C4848B1;
	Thu, 17 Sep 2026 18:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671044; cv=none; b=a47BwdoBvFeS/AfwGZlCPK+fk/JW0+4h4EHdpznAasIsUifbxVJ5fHYu+eoX1fCGOcRtR8BPY7ef+oJIVYamZP/FoMHyEBBqxjJBknMK0TSoQjvh0Qh9TExtjJUj+JhKTDYOrHFtlhCIKOzzUDuaJ+MzUJhUnqXe76ielEjBF+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671044; c=relaxed/simple;
	bh=Cl03GqdC50K+9u/uZMfILOgnGZHkt99D3WvAVbPDXSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T66D26N+bL+QoAZvixSdvGuJWbPrRXG/HYRO0tRYVK8UMR8VydPXg1Z9chI72SDvroqs62uTvfYMYPmGmYlicEE3rfwLIlWcsUA765ZjkQffmExGU0c27ID/7BMDvA+Jhg5kRP9iNlUO+SosTTbNbC1SAv/p94EXwpfiJoZ1fjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6HBBZlL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6HBBZlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176751F000FF;
	Thu, 17 Sep 2026 18:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671042;
	bh=rHZ0hcYcaaWz3amPpBvxexdXp7XsVY3iGagk2v6eWjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w6HBBZlLSmdtCd3EYAU/g7nVWjiIV419t0oP3H08q23DWpUPURYm91v1yQ/WyjLSh
	 3FTcsUSsLKgt6D7V+44Q8SkTO+PsIpo+DxwzclxyTmUOgLu4th9lkjbSzNNc+RWqwg
	 mNj3dspU4+hQBdegXVpRd/bZcp6rRptC4NiqvxXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+df1db6e034b3953e19f5@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Ian Kent <raven@themaw.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 0851/1102] fs: autofs: fix memory leak in autofs_fill_super()
Date: Thu, 17 Sep 2026 16:13:14 +0100
Message-ID: <20260917151601.902976956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


