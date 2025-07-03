Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4387F2ED857;
	Thu,  3 Jul 2025 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554771; cv=none; b=TwL2Oqc3KQl2mKGsb/WY6ar/5wUYX5qK5vmiexTrDvNHpTBIEbfqXv+gG1yyiWC+QV0nhLfOC0cjOZxosRFEjvQAVYWJzrbuiDBeuPcrBgH5WSLhgomgX4KPX9svwx2H+K2ukn7Z7nRSqxEm/UQb8oNCdXdPsX+B3HLH4PFq7Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554771; c=relaxed/simple;
	bh=iBP0omoQKHOoiIXDv2nL0riXmuxU5DttCNXqiIJpSmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7Hxcnt4NxB5aPvuapQ6+8annnpzFshM/TfMdvf95NyNgCdjoRzO5nV6GVuLBhdFitoOzsJoXMNlCGSfMn4EhE4Orcx3FyiS3WTWfEswjEBFskh9MTK7lDeQXldaIZXqcd5/lYRR4Nh57TOe0a1fO3hScX227yssJP9jA2IMKBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3B3XemA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3B3XemA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6E2C4CEE3;
	Thu,  3 Jul 2025 14:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554771;
	bh=iBP0omoQKHOoiIXDv2nL0riXmuxU5DttCNXqiIJpSmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3B3XemAzPtZLgJ7le3e2KAVU4NiIvrHrQiK5yf/oRn3nSepOxvSAmGSKwOyKYkeX
	 1+RydPJYYgb4JuPFpmlLPYySh4y6gb57ZaVUbtIr0N0r1DJbtgtKcVgM9FZMayOeoD
	 +OaLoZHIWAtitBetC9jRMoRQYt+7EHjZo0+4uKgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 074/263] ceph: fix possible integer overflow in ceph_zero_objects()
Date: Thu,  3 Jul 2025 16:39:54 +0200
Message-ID: <20250703144007.274500662@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kandybka <d.kandybka@gmail.com>

[ Upstream commit 0abd87942e0c93964e93224836944712feba1d91 ]

In 'ceph_zero_objects', promote 'object_size' to 'u64' to avoid possible
integer overflow.

Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Kandybka <d.kandybka@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 851d70200c6b8..a7254cab44cc2 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2616,7 +2616,7 @@ static int ceph_zero_objects(struct inode *inode, loff_t offset, loff_t length)
 	s32 stripe_unit = ci->i_layout.stripe_unit;
 	s32 stripe_count = ci->i_layout.stripe_count;
 	s32 object_size = ci->i_layout.object_size;
-	u64 object_set_size = object_size * stripe_count;
+	u64 object_set_size = (u64) object_size * stripe_count;
 	u64 nearly, t;
 
 	/* round offset up to next period boundary */
-- 
2.39.5



