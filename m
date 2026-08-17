Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4E643B6F2;
	Mon, 17 Aug 2026 14:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976256; cv=none; b=E/qnOTQRxju0ON5uxM/+UGtp7SUOfJLfYxWdCy5LePRlgy6ObTUhNXQGM0pDNA5/VbrlZAiSqhYsDm7La8xmkp+ZJNlktKN2ZkX/fd1S/+DAxIFe5kBaUpwbfgZplGZ8N5pi5VIFAjFETFr1ixdu+uzRKccD3hhowUIFZ0KrBCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976256; c=relaxed/simple;
	bh=4/2hgGjwdP2U8CPQlNh9nNZejRgjvbpfVk7Rf2VwrgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlJucQR9HezPGNuEG1XyNKJR5W8tpse4UqYl3jp/5XU7LVPqZKlardZZvchH4aHZ/ph2v5RhTd3mYZ8/F8nLb96V6wvRfKYSlebp4bxwVmGIMI2wNpi2ZcjKrduOwRo15NFaijDbLegslXF5N5E5g1QAu+wRA84vZZ0AGfvRuVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1k8xbJMH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1k8xbJMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953911F000E9;
	Mon, 17 Aug 2026 14:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976255;
	bh=zy0swo2pWr7kr0dHhFfkBRyr7o4iqKIOE8yoqLGxnMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1k8xbJMHrmWsBZBRXKGzrsMZWjjF/YmJlap4j0BRg17X5uU7ioSDr5YwtnAqTKisU
	 vuHXr+7syINeYuzJrasGSYbgHJYkva0WBiJPIB+oomJXGnWf0/janQBNhRA74Egsog
	 1/3/wObrQ8GubThWZ2fl42uOfhR0GYZxLBnF43Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 309/389] mount: honour SB_NOUSER in the new mount API
Date: Mon, 17 Aug 2026 15:32:28 +0200
Message-ID: <20260817132551.063411212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 6dd3c6884cd9defb511284b566cef5ac8f657dbf ]

One should *not* be allowed to mount one of those, new API or not.

Reported-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://patch.msgid.link/20260602020444.GP2636677@ZenIV
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[Denis: rename new_mnt -> newmount.mnt]
[Denis: use goto err_unlock instead of direct return]
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index e9b8d516f1919..fcb9ab4617754 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3657,6 +3657,11 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 		ret = PTR_ERR(newmount.mnt);
 		goto err_unlock;
 	}
+	if (newmount.mnt->mnt_sb->s_flags & SB_NOUSER) {
+		mntput(newmount.mnt);
+		ret = -EINVAL;
+		goto err_unlock;
+	}
 	newmount.dentry = dget(fc->root);
 	newmount.mnt->mnt_flags = mnt_flags;
 
-- 
2.53.0



