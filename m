Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0695F190074;
	Tue, 10 Sep 2024 10:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963166; cv=none; b=ZdS9/XpoWP/la16CzeCmLCe3tauoEQknZbq5n4qpXA+sZU4TijlFi9O8ZlOC/zGBloFsBjPRUYM/IcElY4bYuS61IkXiJtirlJTa9yqesy6SM5n7AoSqjDubR6GdQfz011bD3eDWbtofscUqvhFpm/CaHQY46PoJ2ZIeMYcTr1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963166; c=relaxed/simple;
	bh=HQDcirlXf2Dp7MG3fxIDuFPD2bwsg73hQQgNlB41K8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJrw5URupAbkMdpzn4cvV6ycoBXNKVEkyTVJBQlamDDvk7CwPkFYGwPQQ696Bw+Z3SKN1zpgb+V6qDMgZiaGceebcGzuJDT4uSwLgoXqnOhZPcSV4i5zZYyNugp51nHdeRPYaLvCENUoIDmBuGMdLRr5Eh34v/spjNUugfdMjOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWzKcu/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWzKcu/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75226C4CEC3;
	Tue, 10 Sep 2024 10:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963165;
	bh=HQDcirlXf2Dp7MG3fxIDuFPD2bwsg73hQQgNlB41K8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWzKcu/vYfVSQqEJqXsyQ9UgfpEXO6zez9yrn6KTvCyN0CpBshWVWMC1pCFLox6Ha
	 F/De4H+4lX58XpG6hV9o4APpo6XQ4D45BP4UiNhLII3WSH9IM6VMGnMW1R8FoVGFWG
	 bVYTFo32I/3UScwx7HsfEyNP2E6u0gQvJ9ZIuH2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangyun <yangyun50@huawei.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/192] fuse: fix memory leak in fuse_create_open
Date: Tue, 10 Sep 2024 11:33:01 +0200
Message-ID: <20240910092604.419839515@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

From: yangyun <yangyun50@huawei.com>

[ Upstream commit 3002240d16494d798add0575e8ba1f284258ab34 ]

The memory of struct fuse_file is allocated but not freed
when get_create_ext return error.

Fixes: 3e2b6fdbdc9a ("fuse: send security context of inode on file")
Cc: stable@vger.kernel.org # v5.17
Signed-off-by: yangyun <yangyun50@huawei.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 3b7887312ac0..aa2be4c1ea8f 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -618,7 +618,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 
 	err = get_create_ext(&args, entry, mode);
 	if (err)
-		goto out_put_forget_req;
+		goto out_free_ff;
 
 	err = fuse_simple_request(fm, &args);
 	free_ext_value(&args);
-- 
2.43.0



