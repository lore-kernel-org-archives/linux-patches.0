Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3BA1C004A;
	Tue, 18 Jun 2024 12:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714637; cv=none; b=aFiNh8pFfOQnKAQCxRDNSK+/S9to5dRuKVa3MXTFyqaCdZqLeXfIiZbwNsA1TEWyKK8t4Cf6+QFgeTJ8pzF6qpQOJkP1HLroQYbS37esFEfmTKpgYtDgyDFw347gndIpYpUm6hmtuAzVtZBuSdotRm9RtX2bVKS4HgVtg7hp4qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714637; c=relaxed/simple;
	bh=1Q0jGxD/WUyXPJnsluUlEb11yybSjkw+3QCx+00icsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWC69RpL2dDyWDuUxMM5TPCo6+hspYT1GeeMM+sxvT4QgfM07TN+2AoHRiO9BG4FHUAlazBZkRVDXB9p1oKwZgDli7NXET98a7IWhMZRAenqBqox51S8XcO3VDMeqi9EBRAn/KY7+aHr7XElZHhto5o0QyCu53kY6jy7VgvGVuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9L2E24b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9L2E24b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE42C3277B;
	Tue, 18 Jun 2024 12:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714636;
	bh=1Q0jGxD/WUyXPJnsluUlEb11yybSjkw+3QCx+00icsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9L2E24bzrKDdjPDt/LW5wSb1M7VpnSYR3OthjMIpsWZCGECQqAJe7SO+Y76RRCV5
	 oYduBfi0bx0tHAxme0qPDaL2Aaq1fYq4a+mQ/LPykhIlwWTVfQYJoTdsjWSS0LYFDQ
	 oAUrPDuUVyn3+k0wSXTp10KYY+lwUGcNGi7uUrcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Guobin <huangguobin4@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/770] nfsd: Fix error return code in nfsd_file_cache_init()
Date: Tue, 18 Jun 2024 14:27:41 +0200
Message-ID: <20240618123407.611312410@linuxfoundation.org>
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

From: Huang Guobin <huangguobin4@huawei.com>

[ Upstream commit 231307df246eb29f30092836524ebb1fcb8f5b25 ]

Fix to return PTR_ERR() error code from the error handling case instead of
0 in function nfsd_file_cache_init(), as done elsewhere in this function.

Fixes: 65294c1f2c5e7("nfsd: add a new struct file caching facility to nfsd")
Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index e30e1ddc1aceb..d0748ff04b92f 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -684,6 +684,7 @@ nfsd_file_cache_init(void)
 	if (IS_ERR(nfsd_file_fsnotify_group)) {
 		pr_err("nfsd: unable to create fsnotify group: %ld\n",
 			PTR_ERR(nfsd_file_fsnotify_group));
+		ret = PTR_ERR(nfsd_file_fsnotify_group);
 		nfsd_file_fsnotify_group = NULL;
 		goto out_notifier;
 	}
-- 
2.43.0



