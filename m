Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7956C314A86;
	Wed, 30 Sep 2026 18:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791225; cv=none; b=YXU93Y2sE+FF49qub56qS6BQXVkwz/P9NFzxfZ2wDgv1yd5goIf/CndbqjCJVcInOGgjmNYEluxMR4TESZyPzsoaU4rnBtFPf0ICbGk0UR5gQZ4CZ22IMTbLmvnD2m4yUu+MSXPDrseNN/dRVg0uCqdVc3alnCSZHwmwmZhtY4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791225; c=relaxed/simple;
	bh=GhBqsYIjf+WjwgwHTzTnku+cmyI7y/Nzd06OzPPEO3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGjyq4RXy/5q/XMSll5Rc2KOR85qm9ogXZ3E6FZEZZtDhEI2u9jEvrmY4pNzXtKGFln0Q4616EM/DhUphrocw0mCLZdKuKmXMgvVdpn4INcgq4IOf7Wqzxk1YV6SnANWMwAglRDu5OxrQonFlx6UxB0a+zfsN9kdh+LLgKrckbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVvVQZO9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVvVQZO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4271F000FF;
	Wed, 30 Sep 2026 18:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791224;
	bh=ZSj7L8k4n0DXYnrtEtRmzeKUbBukRa2Zll0fFo3mUTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVvVQZO9DCEDOBnxhSBRWkoxL9IDGaRQ3+Zwo+b4lsyYdq6z8XSXaBdU4b35Wnt7u
	 Q8lGcVL/AhfX/4x+2vE4vKE4jIKbj7n76Jbr9uVdlnNZFLT0mqBDOwzjXuAP4kgQRw
	 +LGQDulpjylWsTAlj4AdmyeJsFC7QijGJzuZCt6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 182/752] ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr
Date: Wed, 30 Sep 2026 17:20:52 +0200
Message-ID: <20260930152402.142995881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Liu <liuqiang@kylinos.cn>

[ Upstream commit d4d56b00c7df88cd5751e7415bdfabc9fdbc82a7 ]

ndr_encode_v4_ntacl() allocates sd_ndr.data via kzalloc() at entry.
If any subsequent ndr_write_*() call returns error during encoding,
the allocated sd_ndr.data won't be freed and causes memory leak.

Move kfree(sd_ndr.data) into out label to ensure the buffer gets
released on all success and error return paths.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 4804976c0c13f..8da562b11b6f6 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1510,8 +1510,8 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 	if (rc < 0)
 		pr_err("Failed to store XATTR ntacl :%d\n", rc);
 
-	kfree(sd_ndr.data);
 out:
+	kfree(sd_ndr.data);
 	kfree(acl_ndr.data);
 	kfree(smb_acl);
 	kfree(def_smb_acl);
-- 
2.53.0



