Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0826753D0D2;
	Thu, 17 Sep 2026 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664763; cv=none; b=P1K6KdjxtabTA6tvTN04xWpvNQWFC6zC1ZrGbdm+MAWVyvaWFjPjJeoNaI0tX7eyZE6EPYk16LJXmKY2yIvwFI9BiadvhXOdWTXsVrGp3b09dXaOVEJLNPmZIy7X1DwsNRFSYeP+4RAF5fGA1tURiqcAyFYv4TWNai2hkbPlN78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664763; c=relaxed/simple;
	bh=lRfjYWc1mQxk+sVn8C11p91Nm4NT6b2RJgCW5ennew0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoOSKlTn6RMglk7AW8HF+gPidp1VwRivFKcmiQwGyI+CAFE+crlhvtDJAidqG4X07UZEki9fP0RSzlPFMrH9ukwUT6VsDOx+qlwgI3eIfVhQ9uco1fj6tO6JAlmAXObrKmIHU4cEaRk98SUR4GCLk+03RE+SuLpI2Jz6mXrqd0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLgtz/vK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLgtz/vK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B98C1F000FF;
	Thu, 17 Sep 2026 17:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664761;
	bh=ETgbp5dYP1wsGwWekSPvS4pKdWPP7VEJW0AqtWlkpVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLgtz/vKtvaoHVbClLNyJMvoJ6sYuWF7QbVXcPALCRiiCi6OgyzvFfvdlJAxqLo8B
	 +VZbSDKusdc7XK1gUjTb3OXsQ0iuT008Hp09RenQQJh8lzXemcF+4zZf7idWNijMYO
	 lg24Pyu31qvQCSBU7crzYR5yiXpjP6oIADnsdkLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0481/1250] ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr
Date: Thu, 17 Sep 2026 16:04:36 +0100
Message-ID: <20260917151605.003567075@linuxfoundation.org>
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

From: Qiang Liu <liuqiang@kylinos.cn>

[ Upstream commit 7ac657bb9c5c1b0f7bdf1fa6d3ad532f969be5cf ]

Free ndr buffer data when ndr_encode_dos_attr() returns error
to avoid memory leak.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 938f83d647c52..4c9d46c50b600 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1661,14 +1661,15 @@ int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
 
 	err = ndr_encode_dos_attr(&n, da);
 	if (err)
-		return err;
+		goto out;
 
 	err = ksmbd_vfs_setxattr(idmap, path, XATTR_NAME_DOS_ATTRIBUTE,
 				 (void *)n.data, n.offset, 0, get_write);
 	if (err)
 		ksmbd_debug(SMB, "failed to store dos attribute in xattr\n");
-	kfree(n.data);
 
+out:
+	kfree(n.data);
 	return err;
 }
 
-- 
2.53.0



