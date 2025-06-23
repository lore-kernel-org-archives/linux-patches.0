Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEB2347DD;
	Mon, 23 Jun 2025 13:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686229; cv=none; b=KwVZbrPlkMiBCk/WlN40kHItzZLnTdMOJo0+NfsX+8rkXQRtS6kyecN65WeyA9exW9hA8txnWziWgkrAGlBBehD0n9Xof7E/rtPhz+Az4gi9BXNuh6j5oJAr3Wrq9oN2Nb6siITlTtRh/GR2v3gxQwtMIplh6OX1uR9a10rerk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686229; c=relaxed/simple;
	bh=TNvn5ZW+PBMMW0td5o30Rl7NF6/hjtKvLFPvWcuO7hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAosTtIqN16i3hP8bQBKM4wvprbiNybbb5Myw+v/JQHSyFwAuyU2Vz5HNWFM/+8SJb7jo9fh3pMqOP7Hz439js0iQ/OSz6ix1NgQtsTzcnT9Sj3Lx6O+aNS1NMuZGhczLLZ8eAzehfFwf7mkMAc6O2QUcTcltfivYwbvs9ixNQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eR5+Jhkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eR5+Jhkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D59C4CEEA;
	Mon, 23 Jun 2025 13:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686228;
	bh=TNvn5ZW+PBMMW0td5o30Rl7NF6/hjtKvLFPvWcuO7hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eR5+JhknQ+pOfsp3kCLSxdFs4oswYXMDQrsNKVXGz8+V9ixRTc68YgqL1xRE4BzjJ
	 gOjDS9h1afuH5eVoTGY4MUb5E6dwfr8Ztvhz7zTyIozoVleE7XPe5kVVYf6jUCTRWb
	 zk/kTVeHtIhAJzn+/qk0qNQVpSoe6d3xCdXjbF7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maninder Singh <maninder1.s@samsung.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 028/414] NFSD: unregister filesystem in case genl_register_family() fails
Date: Mon, 23 Jun 2025 15:02:45 +0200
Message-ID: <20250623130642.730171906@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maninder Singh <maninder1.s@samsung.com>

commit ff12eb379554eea7932ad6caea55e3091701cce4 upstream.

With rpc_status netlink support, unregister of register_filesystem()
was missed in case of genl_register_family() fails.

Correcting it by making new label.

Fixes: bd9d6a3efa97 ("NFSD: add rpc_status netlink support")
Cc: stable@vger.kernel.org
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2345,7 +2345,7 @@ static int __init init_nfsd(void)
 		goto out_free_cld;
 	retval = register_filesystem(&nfsd_fs_type);
 	if (retval)
-		goto out_free_all;
+		goto out_free_nfsd4;
 	retval = genl_register_family(&nfsd_nl_family);
 	if (retval)
 		goto out_free_all;
@@ -2353,6 +2353,8 @@ static int __init init_nfsd(void)
 
 	return 0;
 out_free_all:
+	unregister_filesystem(&nfsd_fs_type);
+out_free_nfsd4:
 	nfsd4_destroy_laundry_wq();
 out_free_cld:
 	unregister_cld_notifier();


