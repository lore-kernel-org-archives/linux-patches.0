Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0316A35A92D;
	Fri,  9 Jan 2026 12:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960460; cv=none; b=dVvIpZJVPFH6gqt8EHkyppnzXhaqEpWPOnyqjFGRKA6r1t/jQNAAfnvktynPB8kuHiK/Hb+OSwQ5/T2pqQbmND27XzX7zcuF7ZYsbAq26vvFF/iAlUe1ask7R5Yk1jhW3qRn/YBMlp1wL3eUuro+MYBMyFC5lWXkmkd26J+8g54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960460; c=relaxed/simple;
	bh=oogJmf3jWsoZP8sIXJiCZghc6mUFps+AToIMedNNtEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puxcQn8aC8kTTJ3zFfIynL4X28rzzhKePZ3CRJ8c3Ui+1asDoFJpcBGNAOgByGCbBOyy1RADFDbI26IVPoMHeiTvH9MTkWv6HyOEzicS5LQzHc+LFl5Y6F4h4bB7QV8uVEDn0+xQ70/0SDXHKruI0+blW67sRMe3OEa4UyzsDNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7lU5Xtp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7lU5Xtp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864E1C4CEF1;
	Fri,  9 Jan 2026 12:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960459;
	bh=oogJmf3jWsoZP8sIXJiCZghc6mUFps+AToIMedNNtEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7lU5XtpyZhesNPlO7Ea7jQAJ6kwmyQj4tEeOPim8ZEPs09S6+VOHjKXFIDeMQlRb
	 Ep6XrQCv/3ryHtTVMdrPQoh5ysEjFIu8sv9YimpPJ7A/aM2SidqEX3SwDyYvVlQwPL
	 DE+TWrZGij6nezduPgigaT470S2sHqv3/tE0lnHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 411/737] cifs: Fix memory and information leak in smb3_reconfigure()
Date: Fri,  9 Jan 2026 12:39:10 +0100
Message-ID: <20260109112149.457434261@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6358f2483c86..37b04c23ee89 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -979,6 +979,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	rc = smb3_sync_session_ctx_passwords(cifs_sb, ses);
 	if (rc) {
 		mutex_unlock(&ses->session_mutex);
+		kfree_sensitive(new_password);
+		kfree_sensitive(new_password2);
 		return rc;
 	}
 
-- 
2.51.0



