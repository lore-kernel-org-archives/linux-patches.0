Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEFC27056D;
	Tue, 30 Sep 2025 15:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245826; cv=none; b=POiUTtpFsf7dorvrgCc6ESy0cn/wT3IN5S5RERT9l+LrpWqTiE2ir1bSUCzp/Oo8kTOg/84USalp11KMlt7TXQFWktESUF5QDbzjJTITski88tApbW9mCvmBGorHa6DdW+MGkI0Sae0IA8TrTB+mi1yzaqMZphKERu44wRawAyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245826; c=relaxed/simple;
	bh=OxXtkoew6U2XrpmxwRrVBcz0Qfn8W3hD0RiJKRIhmf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbyAYT0VO775Zq/pDOGif7jnZCvFUTeoypLKjv1Mr/hCsRiB7Ut4s1iL4Yg6fYAgk57QXtPRWYKf1F3vBH3NgcDaEjzgQyH6Q+nCmmTr1szwvddH+cfzgnttAqDx2W4nDpabr5+n65E7JXtbimXgbLsS0GFZI97O+cay8jRa/fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BozC+B5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BozC+B5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824EFC4CEF0;
	Tue, 30 Sep 2025 15:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245825;
	bh=OxXtkoew6U2XrpmxwRrVBcz0Qfn8W3hD0RiJKRIhmf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BozC+B5tRRaUwfFPiV+7COV3wmZpVj8OamZt4u9DxebSCCZ6qVIKatU+kaFf/5utS
	 szMSEdiGVB5AD4RBXZLrvdoqmeFQKqZ5CQexX6DSHPXE+9HmC9iyKKluBdfRyKvEcu
	 +jF+3QmnyDbu31uic0z6oXQKfAUS+s+9DFAJpXHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 54/91] smb: client: fix wrong index reference in smb2_compound_op()
Date: Tue, 30 Sep 2025 16:47:53 +0200
Message-ID: <20250930143823.435177293@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

From: Sang-Heon Jeon <ekffu200098@gmail.com>

[ Upstream commit fbe2dc6a9c7318f7263f5e4d50f6272b931c5756 ]

In smb2_compound_op(), the loop that processes each command's response
uses wrong indices when accessing response bufferes.

This incorrect indexing leads to improper handling of command results.
Also, if incorrectly computed index is greather than or equal to
MAX_COMPOUND, it can cause out-of-bounds accesses.

Fixes: 3681c74d342d ("smb: client: handle lack of EA support in smb2_query_path_info()") # 6.14
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 0cc80f472432a..79641d1ee8675 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -641,7 +641,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 
 	tmp_rc = rc;
 	for (i = 0; i < num_cmds; i++) {
-		char *buf = rsp_iov[i + i].iov_base;
+		char *buf = rsp_iov[i + 1].iov_base;
 
 		if (buf && resp_buftype[i + 1] != CIFS_NO_BUFFER)
 			rc = server->ops->map_error(buf, false);
-- 
2.51.0



