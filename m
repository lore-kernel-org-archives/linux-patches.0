Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAD019F489;
	Tue, 18 Jun 2024 13:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716094; cv=none; b=bHMSF7yZcSTGfPY2o+vRo7ywEmXyHKT7+68yBOwjuzM/gR7JlOVAfFxLLpI7Nen5e4kkZ4WJ15ppN2/jSATPsJBzv2uXjpyqHXFUt4n3yuDExI8K8EHkH1PIyk6bzSta3K2SuTAPqWeFd7GwcRnu4sOrknSxPlQ1L66Pp/ocohw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716094; c=relaxed/simple;
	bh=+Tt96Z0bxczGwddH7cH+pd56IhYoG3yqkoN3KJoz+98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8H8gqi5jXk2cg1B96rkKOh4iMmQrhC9S9VN1oBaSK8fxWgfWhSu1ABL/cPyGPYpjIxnL970PrG8m9YNkX56P3LpfTL7gbo/4Y3pHSPj124OK1yHc9DLSG/VAzT+bjKSEQ59/7GhiUFgZVW0H+IEICw26li2AdodhOLdVCljPNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aykI5pke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aykI5pke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0FAC3277B;
	Tue, 18 Jun 2024 13:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716094;
	bh=+Tt96Z0bxczGwddH7cH+pd56IhYoG3yqkoN3KJoz+98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aykI5pkevXmAZpP5XPh/w0naHbkZN4nTTDMgZ29GUF2BpJ7y6v5xQtZdgjuwwNaDS
	 gYgK/YfKM8+fF4tWC8QNQD+b93md05e5nyERGVyN4oDy2oO/kEYWYcNgEUHPH1Gv7J
	 087sdWme5LouzlD0SreDXRQT4FZPNw/0VP7Qu3ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 531/770] nfsd: Unregister the cld notifier when laundry_wq create failed
Date: Tue, 18 Jun 2024 14:36:24 +0200
Message-ID: <20240618123427.809979466@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 62fdb65edb6c43306c774939001f3a00974832aa ]

If laundry_wq create failed, the cld notifier should be unregistered.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 322a208878f2c..55949e60897d5 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1543,12 +1543,14 @@ static int __init init_nfsd(void)
 		goto out_free_filesystem;
 	retval = register_cld_notifier();
 	if (retval)
-		goto out_free_all;
+		goto out_free_subsys;
 	retval = nfsd4_create_laundry_wq();
 	if (retval)
 		goto out_free_all;
 	return 0;
 out_free_all:
+	unregister_cld_notifier();
+out_free_subsys:
 	unregister_pernet_subsys(&nfsd_net_ops);
 out_free_filesystem:
 	unregister_filesystem(&nfsd_fs_type);
-- 
2.43.0



