Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45CF34D4C2;
	Fri, 21 Nov 2025 13:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733183; cv=none; b=jUZ7jaoNdaOU+XVdkNS/WYfUctaDSGDxWDzj1BgDyQKxYqp6W1sWkaJacBKQg7ryDBtnkuuwWlSRKvIsLtYRcFq8TLfy+3A6eP6IWs8Dywol23XZxXF9QAv9Bff0UiE/Pvbd7bzLvzENZMfNbHlYAyRoyu621i1sKz1OPTdssg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733183; c=relaxed/simple;
	bh=DUyrikUyICw1TzvsCOyw5iN9Ucur/TVLjLVHV7rOCJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=st8bQjNSQ0TYN8UhMSVtDvgjFMGp9y3FWYmr90P5bfDbVwJhT/Jd493LVxN9Zb1iYwc6Yi86/TqYZ5kQEoaAam5HNRGDsyGqOSFTgHnJjZTmgFMsPCjPtmfYalnYZqK/ameuoQ4uQSNE9sGJflXeOQL/1SGfc2bLIZ85iNQurxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSN643lB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSN643lB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E85C4CEFB;
	Fri, 21 Nov 2025 13:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733183;
	bh=DUyrikUyICw1TzvsCOyw5iN9Ucur/TVLjLVHV7rOCJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSN643lBVKuNP2YS+27X8GkUdjc4pdNvWF6x16Jlt7lkLI+/7MA3aofmlAMWTW5jt
	 Sqy40Cr3dqhnW34EsMvUP6Rge6CEy2+AZUUyOYIg1saQrJgZ16n9zfYT02UO34keOA
	 m6dKx1fDxuM5tM9Qc5AS5vHc5cWydlNuBxZwrDRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Shuhao Fu <sfual@cse.ust.hk>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 379/529] smb: client: fix refcount leak in smb2_set_path_attr
Date: Fri, 21 Nov 2025 14:11:18 +0100
Message-ID: <20251121130244.510107908@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Shuhao Fu <sfual@cse.ust.hk>

[ Upstream commit b540de9e3b4fab3b9e10f30714a6f5c1b2a50ec3 ]

Fix refcount leak in `smb2_set_path_attr` when path conversion fails.

Function `cifs_get_writable_path` returns `cfile` with its reference
counter `cfile->count` increased on success. Function `smb2_compound_op`
would decrease the reference counter for `cfile`, as stated in its
comment. By calling `smb2_rename_path`, the reference counter of `cfile`
would leak if `cifs_convert_path_to_utf16` fails in `smb2_set_path_attr`.

Fixes: 8de9e86c67ba ("cifs: create a helper to find a writeable handle by path name")
Acked-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 232a3c2890556..d6086394d0b84 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1128,6 +1128,8 @@ static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	smb2_to_name = cifs_convert_path_to_utf16(to_name, cifs_sb);
 	if (smb2_to_name == NULL) {
 		rc = -ENOMEM;
+		if (cfile)
+			cifsFileInfo_put(cfile);
 		goto smb2_rename_path;
 	}
 	in_iov.iov_base = smb2_to_name;
-- 
2.51.0



