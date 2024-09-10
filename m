Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF21143880;
	Tue, 10 Sep 2024 10:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964126; cv=none; b=RHSpdhc4fqGXr4yeKKJ8dyQMad6wRg7nkOXd13L2FhwFGa8r1rBAIARDf3eljzoSh1+ZDiwxsd92yggOuGjFlWCgd/Ic0Gt/m0iXbpv6dHkUn2UjqYMgTlkJP0KL4X9PN/XfFjfbxngxp50XG+IKQlV/2jjRqc38/ZnRxYXoXsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964126; c=relaxed/simple;
	bh=KQYvDRa3LF61P8zhPGQ3voyj03QRFFCdKk82+mL3i6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rg8CJ3wuZUvnb5NMphATMnXNgInGYt0U0G6JZN7hXxDoxPqJqZzpn2CaZEVxhIJt4Bt/gxn3DobrN5iuzb/714Jr+iaOlHCBRqmBl4pZYt5cbYHjkRodW+YDx5m6QSDbqWa6JjyjlQlYhWfrxL0p7b7jYwx67CS1giJgCheGdnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXKgx/ZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXKgx/ZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E663CC4CEC3;
	Tue, 10 Sep 2024 10:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964126;
	bh=KQYvDRa3LF61P8zhPGQ3voyj03QRFFCdKk82+mL3i6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXKgx/ZRo8pgPFGa5z1OGTiHrK7Txy2r5+EtyEF6pQ6Db1bRHWosFWius1SJp3JFN
	 my/FNzpzr0XA1oXoRMI1mASv15HIWer16DLbH0BgYpLn1PUnzwKojqhAIfCbHoJ+Gj
	 MaGQB8B11H0YSpq+c2BWUaEd8tLORgcyPnkKbrwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/269] fs/ntfs3: One more reason to mark inode bad
Date: Tue, 10 Sep 2024 11:31:03 +0200
Message-ID: <20240910092610.908973988@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit a0dde5d7a58b6bf9184ef3d8c6e62275c3645584 ]

In addition to returning an error, mark the node as bad.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 45b687aff700..f7c381730b39 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1601,8 +1601,10 @@ int ni_delete_all(struct ntfs_inode *ni)
 		asize = le32_to_cpu(attr->size);
 		roff = le16_to_cpu(attr->nres.run_off);
 
-		if (roff > asize)
+		if (roff > asize) {
+			_ntfs_bad_inode(&ni->vfs_inode);
 			return -EINVAL;
+		}
 
 		/* run==1 means unpack and deallocate. */
 		run_unpack_ex(RUN_DEALLOCATE, sbi, ni->mi.rno, svcn, evcn, svcn,
-- 
2.43.0



