Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DDA248869;
	Mon, 23 Jun 2025 13:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685155; cv=none; b=iTe6Ow2emSyW43ONUxVzLDsNMizRDLc1S/puGFUxqQiwFlvbycC1WZVDzGGZZTwvsU7KuRM+FFcwxKBHPjcad7xDXVFQVJcXNXnaNoYg097freMzPBOOc3HV+IHdjJrY2jrp2AdeCf8qFoz5tg0jDgQBgYXyIHN15BU953UaUFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685155; c=relaxed/simple;
	bh=Rhao7MCkW4AMQ5R+775uHrqaMQFjLZvWOwNU77oPElY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbHzFufFCbsDpSTqIRjoyPcSIXZne2Y0pOvkxvF2gXepo7YwNdgW/Kjh7h9aWyMC35SelzXDgDiyTrvbZMFXVZkV2LVStiw3mXqvkby9gPtW12YVBFPGExlUcYBJwuJhBxT4K+PqjOrKco6KXH4Z9ShUygxtC4C1sDJpO+rDYEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUGRTmel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUGRTmel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76C6C4CEEA;
	Mon, 23 Jun 2025 13:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685155;
	bh=Rhao7MCkW4AMQ5R+775uHrqaMQFjLZvWOwNU77oPElY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUGRTmelghWr6RwbCf7akh1NbUnK/AXKwTdXf5lFCgC1+90AHjWIt5q8K4/nwL/WG
	 cZ+6vZlsWkSqq+kBDxPdoxsoUmjJx43sCs+JThFswvprObd2Un+OJbVgFOgR9WBmEs
	 YVPKR3rnfM8L8d/ZnfjPWb4AKMwHwbje/91E0YIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/411] gfs2: gfs2_create_inode error handling fix
Date: Mon, 23 Jun 2025 15:02:36 +0200
Message-ID: <20250623130633.361853311@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit af4044fd0b77e915736527dd83011e46e6415f01 ]

When gfs2_create_inode() finds a directory, make sure to return -EISDIR.

Fixes: 571a4b57975a ("GFS2: bugger off early if O_CREAT open finds a directory")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 763d8dccdfc13..a7af9904e3edb 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -640,7 +640,8 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (!IS_ERR(inode)) {
 		if (S_ISDIR(inode->i_mode)) {
 			iput(inode);
-			inode = ERR_PTR(-EISDIR);
+			inode = NULL;
+			error = -EISDIR;
 			goto fail_gunlock;
 		}
 		d_instantiate(dentry, inode);
-- 
2.39.5



