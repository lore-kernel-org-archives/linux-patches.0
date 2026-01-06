Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106F0352F90;
	Tue,  6 Jan 2026 17:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720159; cv=none; b=AnJcDvzwge29Tl3pwHKCwa03aZIRG/sQcpm6rJWDeEjU75nBWj3d8pLK+96jWqBtsNBjqKJJMYzqo0H+YxYAWfynfABEUmAstbzcKsjRYOMqn/G/IjmDZ2RM7RbpHjaHEAWX90O+xQ0U5+VkLpVOYJ83nxyrag6od8VlhJUI5hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720159; c=relaxed/simple;
	bh=JtEtQQou62b79YSi+hnk8NGszOzjxoCIMB2oguriCM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzaNmSJsqovI+j/MGjX1jKgSijffog55OMNVEGzFnEmv7JEYYslI2/Fb8t48Ds00fgTMce4Io8CC02FHxiB0QUGfvtvdyEiJ1WThkyrNRS9sEuMkyLdrd4gQ8R8iHsq3340R85z6/brcQyb5Wilp3EawL4MGeptLB0MTTQrJQYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8yW7V6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8yW7V6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7802DC116C6;
	Tue,  6 Jan 2026 17:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720158;
	bh=JtEtQQou62b79YSi+hnk8NGszOzjxoCIMB2oguriCM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8yW7V6/L09kn3onOszWwFcU4ZuSNFwekk0bHEUDoumoixN4Ocj+XUjFmzkLkMY0y
	 /DZSvP9eLwEN7PWy++gtl+nH1YsNTDVQxzEk18StuYxR/XezuGThoIuYyWLDx3a0Zf
	 Nul8QkUz6sjCocYg6DIa1h3Y4hB4IJiqHXgCKJfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/567] cifs: Fix memory and information leak in smb3_reconfigure()
Date: Tue,  6 Jan 2026 17:58:54 +0100
Message-ID: <20260106170456.948362290@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit cb6d5aa9c0f10074f1ad056c3e2278ad2cc7ec8d ]

In smb3_reconfigure(), if smb3_sync_session_ctx_passwords() fails, the
function returns immediately without freeing and erasing the newly
allocated new_password and new_password2. This causes both a memory leak
and a potential information leak.

Fix this by calling kfree_sensitive() on both password buffers before
returning in this error case.

Fixes: 0f0e357902957 ("cifs: during remount, make sure passwords are in sync")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 17133adfe798..ee9c95811477 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1011,6 +1011,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	rc = smb3_sync_session_ctx_passwords(cifs_sb, ses);
 	if (rc) {
 		mutex_unlock(&ses->session_mutex);
+		kfree_sensitive(new_password);
+		kfree_sensitive(new_password2);
 		return rc;
 	}
 
-- 
2.51.0



