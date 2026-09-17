Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2747F3A63F3;
	Thu, 17 Sep 2026 18:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668292; cv=none; b=uw5rf9HL5cCVkZvr6+RUOqn2lTF4n+4ZTnrGQPmuE1hWxn7iRBVVCr14bNPm2rWUVjBVoCuC8G933bLbUZh9A/f97+FUqrt+L4pNdB4sQjOq4QzWh8ypdt5M6cAlWqiquhycieNat9tTLFNZSbSAMvihPOhdnZ1cJ1JUhwMiXrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668292; c=relaxed/simple;
	bh=Mtl7vdQeqVgdlWnAzFlXv46glSh8rfmZ23QneUMZCv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mexb5RhQkIv+4FK0RAvXeLq7fDaroCoPzKPMyb6j71XkwoAxmzz8N9NV7vY679u+BJLVH4SrNsH/U3mzMzIJzibwW8MPCi1Ae6F8UCGfFzXWc3fzvbJmzci4K8JIVqADzNL8bvyzDLyg4rRlwbRTYEmmM9LgndF5AU/bM+/B0+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7A5b5qv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7A5b5qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5701F000FF;
	Thu, 17 Sep 2026 18:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668291;
	bh=kgn7upM93JPJ8PCYIIPhtiUyLak2mmUALfCsgxfpaJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7A5b5qvtc7EVvqq9vPw7V72YJyNPuGeZLSBtqK7+Mi8IWk1bt91RPSka+TRgplNc
	 pjzWmQ3M1txsuQCeiehw98penDSmWOT19bk7PLPHRbc377bh2DDl9+V5iRj+VTy5Vq
	 PseZ7eh+uzUbthmPIri+zaLWNmnD+adzRSfImCno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0377/1102] ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr
Date: Thu, 17 Sep 2026 16:05:20 +0100
Message-ID: <20260917151549.118344462@linuxfoundation.org>
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
index 6a897956ed1cd..5904aa3aa63b5 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1659,14 +1659,15 @@ int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
 
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



