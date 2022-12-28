Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E3E1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A26AC433EF;
	Wed, 28 Dec 2022 14:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239592;
	bh=zPd9wA/Kfd+TTI/wzCKaqIq+arnjdtnw2EMi6MkCHdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0CKTVszR0zBBWJEjl5b48zvRUF9Lc5UMxyvoAPqgtsclhQGqt/M/RZuDcpSNVrbZL
	 QothmCruF96Wmnh0ZtXAydbmcRSU6G9kO980k404Ns/+11YfEIrILxfSk/c6hdXjJb
	 OIioYjq9uxrNFROd1pLGxfqqIyvEjPsWyVEEPHzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/731] NFSv4: Fix a credential leak in _nfs4_discover_trunking()
Date: Wed, 28 Dec 2022 15:35:54 +0100
Message-Id: <20221228144303.722324146@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e83458fce080dc23c25353a1af90bfecf79c7369 ]

Fixes: 4f40a5b55446 ("NFSv4: Add an fattr allocation to _nfs4_discover_trunking()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index dcc0677d1546..3c9ed63710a9 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3987,7 +3987,7 @@ static int _nfs4_discover_trunking(struct nfs_server *server,
 
 	page = alloc_page(GFP_KERNEL);
 	if (!page)
-		return -ENOMEM;
+		goto out_put_cred;
 	locations = kmalloc(sizeof(struct nfs4_fs_locations), GFP_KERNEL);
 	if (!locations)
 		goto out_free;
@@ -4003,6 +4003,8 @@ static int _nfs4_discover_trunking(struct nfs_server *server,
 	kfree(locations);
 out_free:
 	__free_page(page);
+out_put_cred:
+	put_cred(cred);
 	return status;
 }
 
-- 
2.35.1



