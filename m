Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F533A5E6F;
	Thu, 17 Sep 2026 15:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660338; cv=none; b=oLQ5kibJT0GlUzyk6DkRGFTLixybZqBab1e15pGn8L0HrngakKvSw5eon6sKpdZ9L5JGSlBtL/cA4C1BfoB2LMTX67npBE7uxHE3Qwdn3IJA0tZYayyUPvp9lsF8obrrI+3qF9cgJVGGYzKgcnyFkBe7hxlk6ubi6dKsuvbD6Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660338; c=relaxed/simple;
	bh=pPTsWa3qMnfC4WmzEJBo2gSuvgM+6UtcXduh25ovX7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGx7FZtqjo6h/lR+bVZaeW3KZXGb4997cWVKM2Rx90GzD2/YaFDbQ4DQn3KxHITgkInv2LK8jVx3h/CC+fpdqOQ4YjotPB1dCUngIeFVUQk2vUUiocdpcacBMmq2sedPFHwsnnc/P3i17cQrjwrwH5JrPeDj/db530v+PhFY9WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/JA07WG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/JA07WG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7081F000FF;
	Thu, 17 Sep 2026 15:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660336;
	bh=EcYFnlW/8bMDLN6TivMylkE6LkoWLXjKYUXezizYq+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/JA07WGS3auLDV8oRhidqWz0B4/JfrhrhUqspDdYmvshuARQGO1Ynxaoij8vCaAR
	 SM6Nq10dHVlfR9hNtp+T1BfxqVNiUfkvtXQNOo3/uJM2qvU7Aze9riQCTK9H5tLt2M
	 jz2Z7cd1WnKnge1MMjKap2LsEBSmL/u+ZfCOZ6EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+df1db6e034b3953e19f5@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Ian Kent <raven@themaw.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 558/733] fs: autofs: fix memory leak in autofs_fill_super()
Date: Thu, 17 Sep 2026 16:14:26 +0100
Message-ID: <20260917151406.202605157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -323,8 +323,10 @@ static int autofs_fill_super(struct supe
 		return -ENOMEM;
 
 	root_inode = autofs_get_inode(s, S_IFDIR | 0755);
-	if (!root_inode)
+	if (!root_inode) {
+		autofs_free_ino(ino);
 		return -ENOMEM;
+	}
 
 	root_inode->i_uid = ctx->uid;
 	root_inode->i_gid = ctx->gid;


