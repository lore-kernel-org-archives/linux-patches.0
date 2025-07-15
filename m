Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA422E267F;
	Tue, 15 Jul 2025 13:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586216; cv=none; b=FNTFuPV9y3QisqlDuBuTozj5XrpLmj/IX7Fh6PHtVSxVs1BuhsWRYUPDw6uo7sXjVs/1ptIQWliJHnbNhQqnS555K3mzOtREgIrnqBfc6D7HkAqTxDF2J0TWJuHV8ORgvPUop+6M97Ujz9AoFwD7LlDuVlS9sYKfTO1PRoRbTPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586216; c=relaxed/simple;
	bh=ofkntiCQivDgf8MoXVnTcearlwWwg6C9Y+ivGCOmRJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sytPEfHyd0jexSbOFEGqumpy5RNLBoObx2FbskAXlxFPkg/w/xiXP3ufrXkY07oImDn3QUiWd3eCVFTPdDgPf8monc2MLZzvQWkCjYYc4vpboAH8iTVi8/HKoNG6BN+oDD3nr5BFJeUzOJPenlN9PN9pq3s6lil4Ud/t3QjNkv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11BXq4b9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11BXq4b9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD548C4CEE3;
	Tue, 15 Jul 2025 13:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586216;
	bh=ofkntiCQivDgf8MoXVnTcearlwWwg6C9Y+ivGCOmRJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11BXq4b9Y5Y3IBGxoJZ8dwfwzdln2jaam5/Jigkr+aX/otHCTNHV0LRrbuT/mevp9
	 SGTUld8VjQMKNoH2EmAyPygY2vgE/4nrG0GiRx3imcCsI59EtK2+AXFd+rYpG79qPF
	 MAp9sBDvtDsOfr7C066ehv97q5g9pOC1FnPt+K9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 59/77] ksmbd: fix a mount write count leak in ksmbd_vfs_kern_path_locked()
Date: Tue, 15 Jul 2025 15:13:58 +0200
Message-ID: <20250715130754.095185055@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 277627b431a0a6401635c416a21b2a0f77a77347 ]

If the call of ksmbd_vfs_lock_parent() fails, we drop the parent_path
references and return an error.  We need to drop the write access we
just got on parent_path->mnt before we drop the mount reference - callers
assume that ksmbd_vfs_kern_path_locked() returns with mount write
access grabbed if and only if it has returned 0.

Fixes: 864fb5d37163 ("ksmbd: fix possible deadlock in smb2_open")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/vfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 7afb2412c4d43..4804976c0c13f 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1280,6 +1280,7 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 
 		err = ksmbd_vfs_lock_parent(parent_path->dentry, path->dentry);
 		if (err) {
+			mnt_drop_write(parent_path->mnt);
 			path_put(path);
 			path_put(parent_path);
 		}
-- 
2.39.5



