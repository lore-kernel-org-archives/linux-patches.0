Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51293A6B7F;
	Wed, 30 Sep 2026 18:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794644; cv=none; b=ZPu8ITOpI8Q6qfBrs5qWmGLRNAjpLzxPvjEu/nIwLYiBxlUwGkM0st6YjnubJFCJSJdrl+VOBWi2hSmqmNUWL8DM0Yq47ULRmtVLyzcka2O+p4lqXz54yrFAV6qauHbBhMwCKZ0scEtS7LTvAKbIycC354LtrlHJX/f88OgB56g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794644; c=relaxed/simple;
	bh=QqZXmw1CrkfBsOPNnY3IYHRkkUlwiwIxNkvnmoKpnzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkSerYy0Zwq37dt8tV7xnURG8L5v9IaCNUz79iCPEgBkXFzMH6EmUAT+ncdZ3krS6IKcm7EZOay1Z1nDLACtIwxyWcFp5dMOQ4jzxjyfZWNgEw1M3Jup1zUvLkutqMsE11pjTx3EBbqGc/AsMsDdudqTOJLZVPh2cr+2xjw8kY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7LBMyKs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7LBMyKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0DA1F000FF;
	Wed, 30 Sep 2026 18:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794642;
	bh=0fRzgJwxt6w6hnKtywhhIywxk8Ekor7axmJAKB8uBZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P7LBMyKsNCIDDT8IznMFtXrcPfPtzAzaEmaP/VxE8kCcXTBCWYkxDipbe41t0tEdv
	 oi+UG+Cb5k3of43CqNFq9P4HHHH1ybFC1U3Pe3G6QDTPqCgFRfiHdTimn7ACIAH6Sf
	 Mo35POggOpF3Wx9Xq7MV46kwhxbWtfRFYbGEnYUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0276/1193] ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr
Date: Wed, 30 Sep 2026 17:16:00 +0200
Message-ID: <20260930152440.295000410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index bdd33c5554292..41d4abc7ca410 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1637,14 +1637,15 @@ int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
 
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



