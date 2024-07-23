Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3E115884E;
	Tue, 23 Jul 2024 18:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759925; cv=none; b=iMvkoE//0QAlAIb/o4KTZhww0KfdzfbIeBk5e/6jLYNPFTGwDOLEiJnfwxh/CUN9P03QEcHaF2ZWoJ2hY+06fkWQ25po+eRM+UTDM1TJtGTRtwFyqTMea4xFKKTq/8a3AME8bCLi85gXKg0e0OEQc77vgM0VHEIrH32WoI/L8e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759925; c=relaxed/simple;
	bh=To0kZLUDwCiyWTUfjCBuNvo6euwzZTJW7ur1kfj5xbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4YDP0GRL21V4B14SVU1BMMPgW7O6F7gQFwPehwmDKmmT0aOgeZOVraQaCgwd6Mkk/xt6IzlGHBCHdIBj7pHGjlF+ZaMqg2kS4K7UZqNWhfFjnTx6a0z11Y6sAYFQRJgc7druWox9WZ8NWI/vDyEQMYJtscy9z8bse4TtAwD38Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKUAUfO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKUAUfO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5306FC4AF0A;
	Tue, 23 Jul 2024 18:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759925;
	bh=To0kZLUDwCiyWTUfjCBuNvo6euwzZTJW7ur1kfj5xbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKUAUfO1GQu0IlDhfQXUnec/GcIVnGJ/dOeg4/Xk3I7tC2mgI+yqoPUKId1bwH6Qt
	 SpekLov0W9yPci7MBmCHygUxpuFsi/velPcYHhyxadfO/G+d610a0TUZQ3zh1/GEcy
	 tEDjw2irNiPm94Fg5byuIQLJLn+Nk+y+NRPrGn+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Mastykin <mastichi@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 045/163] NFSv4: Fix memory leak in nfs4_set_security_label
Date: Tue, 23 Jul 2024 20:22:54 +0200
Message-ID: <20240723180145.213675053@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 3a816c4a6d5e2..a691fa10b3e95 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6289,6 +6289,7 @@ nfs4_set_security_label(struct inode *inode, const void *buf, size_t buflen)
 	if (status == 0)
 		nfs_setsecurity(inode, fattr);
 
+	nfs_free_fattr(fattr);
 	return status;
 }
 #endif	/* CONFIG_NFS_V4_SECURITY_LABEL */
-- 
2.43.0



