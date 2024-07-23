Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705CB15886B;
	Tue, 23 Jul 2024 18:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759202; cv=none; b=aAp3msg05JgjyZ7YpzJTRSrPXDhhLdfGcvxR6XtRDEUzUG1BEXfiBeHq5CkoWImDj0lECSCjjyE+Dq+FVB5/CMBtMdqH0zxdacbG8sUhnk+V9o6hNmU6fBoX6/RHrVGQtSC3cWzCwlxNAuDqN+p3AwpnnX0Ufq83ad0HQn+AulQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759202; c=relaxed/simple;
	bh=aWTcZps628oBgLQheuwPxZFCQ96p6TsatEnsCJ0KO/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbk5OOkeKnkRlUwXHANlZ07TQdyZaRixboqFj3Ny87nn0/yOocepI9HMATjq+UZBfd6Sr+GnnAkEM+c3eylrOd2P5AtfqzAw7V5Faar9trgBSEO7Qb+uEQJCDQS3flYCiHbDCYx+c0W2O/yFQLg30CkFrmYUB+g7uythG4lTIWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDRb8BWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDRb8BWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0B8C4AF0A;
	Tue, 23 Jul 2024 18:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759202;
	bh=aWTcZps628oBgLQheuwPxZFCQ96p6TsatEnsCJ0KO/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDRb8BWUb8utvjESp+nAJ5vqznGHnIJ8w4AabahT56RUffPcgMCMftjeR3tiqWsDn
	 ecDrnGeQ2WWqf+lmXXV4wzAPNySFxuIOQseQB8X+28EoDCNbBdZtzHAcwPpQxUGOet
	 E9hAYEIg5aY3tP0RKEIzR8EqPGFqA/HlHYzmeTtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Mastykin <mastichi@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/105] NFSv4: Fix memory leak in nfs4_set_security_label
Date: Tue, 23 Jul 2024 20:23:14 +0200
Message-ID: <20240723180404.669339394@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Mastykin <mastichi@gmail.com>

[ Upstream commit aad11473f8f4be3df86461081ce35ec5b145ba68 ]

We leak nfs_fattr and nfs4_label every time we set a security xattr.

Signed-off-by: Dmitry Mastykin <mastichi@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index ec641a8f6604b..cc620fc7aaf7b 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6274,6 +6274,7 @@ nfs4_set_security_label(struct inode *inode, const void *buf, size_t buflen)
 	if (status == 0)
 		nfs_setsecurity(inode, fattr);
 
+	nfs_free_fattr(fattr);
 	return status;
 }
 #endif	/* CONFIG_NFS_V4_SECURITY_LABEL */
-- 
2.43.0



