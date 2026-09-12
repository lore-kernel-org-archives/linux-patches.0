Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138833AFD15;
	Sat, 12 Sep 2026 09:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204011; cv=none; b=kbqDvquH/iI65C+Ycslr0SWc0OrrZh+QujTa1Rm8QRPozd+sZf/DbQ8lMDJzKf/jItj0MvnsqbJueFRpjIJLW5sXqLc2MfWqcTDQhtV+QU3d8Qek5P35TX8ceCDdmNh7r7TjVHjziZrRutztgVHh3RMp5DjOKBF3Y4cWRuajki0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204011; c=relaxed/simple;
	bh=emJ6fM+G3zDeY4LTxZbIAOqklTA3nB5/eB7+b893Tys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYZKlOfEG+ja5IoTM89A6iCdbD95e1z01rtExJ/0zWrRAi8dmBJnV6ZAYmzxmIs/YgDG0aL2x6Vjue3SyKX+WNojQ2q2hCNhrFHGX20PW+QI94yZBY15Jf/1ml/5xQlN2ckyiZqQyjab2dp3ok9OaxbGpexPv8M8lmU87ZLdZKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EiqdzgNm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiqdzgNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8960D1F000FF;
	Sat, 12 Sep 2026 09:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204009;
	bh=JrPCV1UWb8FoqvVALiEJ5xK53wPvUzbZnp03tmScepY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EiqdzgNmev8xRPxIx5mNM0HIukGTpuJvXPp9wBGxvg++zmltvDyjxXI3wfoeT5hpC
	 vT2lqeNvurmBNsrPOetNa5ZcyEEJaxtsqpZGQOZOA7VqXCbwiV9In00+foai51PDku
	 rkdMUrjFcj4FUIcQ90AiTqx35vl6SV62jUMkML4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shirisha G <shirisha@linux.ibm.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1526/1815] erofs: fix unused pcluster_pools for higher page sizes
Date: Sat, 12 Sep 2026 08:54:36 +0200
Message-ID: <20260912065724.830052937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

[ Upstream commit 988c3c186c730590a71df8adc1424c5578ef8bae ]

pcluster_pool[] hardcodes {1,4,16,64,128,Z_EROFS_PCLUSTER_MAX_PAGES+1},
but the assumption of Z_EROFS_PCLUSTER_MAX_PAGES == 256 is only right
for 4k page sizes. For higher page sizes like 16k or 64k, This results
in us ending up with clusters bigger than what we will ever use, since
we only support upto 1MB of compressed data. For example, on 64k page
size we will only ever use clusters with nrpages= 1, 4 and 17.

This patch fixes the allocation for such higher pages sizes by adding
some compile time checks.

Below are the clusters created right after boot on a 64KB page size
machine

$cat /proc/slabinfo | grep pcluster | cut -d" " -f1:

Before the patch:

erofs_pcluster-1
erofs_pcluster-4
erofs_pcluster-16
erofs_pcluster-17
erofs_pcluster-64
erofs_pcluster-128

After the patch:

erofs_pcluster-1
erofs_pcluster-4
erofs_pcluster-17

Fixes: 9f6cc76e6ff0 ("erofs: introduce physical cluster slab pools")
Reported-by: Shirisha G <shirisha@linux.ibm.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 74520e9102596..0e9cac8ee12d3 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -128,7 +128,17 @@ struct z_erofs_pcluster_slab {
 #define _PCLP(n) { .maxpages = n }
 
 static struct z_erofs_pcluster_slab pcluster_pool[] __read_mostly = {
-	_PCLP(1), _PCLP(4), _PCLP(16), _PCLP(64), _PCLP(128),
+	_PCLP(1),
+	_PCLP(4),
+#if Z_EROFS_PCLUSTER_MAX_PAGES > 16
+	_PCLP(16),
+#endif
+#if Z_EROFS_PCLUSTER_MAX_PAGES > 64
+	_PCLP(64),
+#endif
+#if Z_EROFS_PCLUSTER_MAX_PAGES > 128
+	_PCLP(128),
+#endif
 	_PCLP(Z_EROFS_PCLUSTER_MAX_PAGES + 1)
 };
 
-- 
2.53.0



