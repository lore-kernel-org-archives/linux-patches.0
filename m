Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2A580620;
	Mon,  8 Apr 2024 13:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584057; cv=none; b=qExig3mM+LkQM/ofiVYRrDyQblNl2d4D8NqRqzFI6PQo/21/qDMMnra/3UfIEht7UzdVBqnKOnRKUkdhgGh38Y0KDGSdsKFo+N1O4U0RkRUoWmn4/T1l/qIZyTyapZnSYehdD/vfSdbsx9g3SawhAMmAq2n4Qen2PahEb+R+C8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584057; c=relaxed/simple;
	bh=9nJfqOBCSYlk8iI7EBqaRxafmLUvIIhJWKyBDnourOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFP+i4WwUTCuZIIn/YOxVF1ee2UeypXBf5wYnFz2Ek75F+e7Ji8uVhRMlixPP+LgICk3p7xyaImQMbX55CjtUQSk9YA2j1N9rv6caSDVVF9DzAwHjqH2Tqw9Ihq8HfqWLRgPMHxTwyR6cGcAF4ecbfpkbeQw/lEFYhzqI7RNba0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvyH/cQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvyH/cQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8839C43390;
	Mon,  8 Apr 2024 13:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584057;
	bh=9nJfqOBCSYlk8iI7EBqaRxafmLUvIIhJWKyBDnourOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvyH/cQxG0QlAtxQZDpw1c46BTz6F+TvgXhWKqZtmpgg8LbCTPnPb1WVaSbWisFmR
	 kxGMPUHVyopYA6THPt9z/QEerMmrG22lB6DCVRkcdWu1yDsLgRhFM28XisZ7CPCaAn
	 2+U9JDGj2Ey1Z5Adcbb2l9bR7XA1Ck14r21EJAQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 327/690] nfsd: Unregister the cld notifier when laundry_wq create failed
Date: Mon,  8 Apr 2024 14:53:13 +0200
Message-ID: <20240408125411.457706095@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 62fdb65edb6c43306c774939001f3a00974832aa ]

If laundry_wq create failed, the cld notifier should be unregistered.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
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



