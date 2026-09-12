Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7CBCA6F;
	Sat, 12 Sep 2026 11:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211514; cv=none; b=KTy9pDd4BevpJdszpgRc5vJ/P/UmBBTNfoyt8kXY1zuk4ic3tgjRbcjfHCm3/AYxQR+GAYCT//+vNqZSIDe4uEVd5jykyBwROsIUgG3kDTMd7Ea2O/99lnY4vi8DuND2VLXXqlAq8TUGOmZxcW+cknE899EXla84iWkYyde2Lmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211514; c=relaxed/simple;
	bh=+Q93SslfwmMsPErlGLktIIGqobzsAQ20jgHhan0ViEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/JI8nHOV4MEqEW+cCyvb30bS/WNhrbj8YMzSbPq09WFUfvuqBm8jVmRf4zKrmD0LwJavQJ0kTFjWfzxuHuKMRQGQNSD50bePplk+ZZSKLvb1aPtDeLxTR6CASPLsZrqGcha2oBeipwjBXaV2WdEZcmCRdSpJSjJKn9M1vwpblU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fD+jl38; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fD+jl38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6391F000FF;
	Sat, 12 Sep 2026 11:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211513;
	bh=+uO9Ckci9Klyrke72vRbvlIZTh38YsHqmU7DcpHFXOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0fD+jl38cATuMykMDodzc1txfkChGgDSwZmQAK3nyKbLDm2HcTubvLpqDPCpyj+Fn
	 A/Ci5KCNiHIej/K5nHQ+QFB6gWzK4fLI9FElxggbLkHiY6x4H0jwx0m8NfAELzDuW3
	 Rb65TXrMCa23h3L3AI6hdPdY//zo4E+H2ZV5pUqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shirisha G <shirisha@linux.ibm.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1239/1518] erofs: fix unused pcluster_pools for higher page sizes
Date: Sat, 12 Sep 2026 08:56:48 +0200
Message-ID: <20260912065651.534874945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 691e39cf3c332..e07c0253893eb 100644
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



