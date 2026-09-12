Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F202D0C94;
	Sat, 12 Sep 2026 13:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218571; cv=none; b=J76LUR0hF5YgjeOjxt44qQK+mOcIvtvL9ADPrZNQ3H4jz/irqK3Un90zxput//f9sktUGFi0MFt2OJnTkEfjflZdomuQJCXQSR6QE0+HLyJLOzG5EnOlCezgWsbzHHH5yrBrdy8s4g67mVTQRCEzEJMM/LmJx8+TKteIcjEXSl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218571; c=relaxed/simple;
	bh=h1jI0Ofn3ARN9ZMDdvQkt3/lBKVnv+VFjMIMmp9RkAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bs9I9LleJ2klA3dHMPBeNxOU8RfwT7lNY3qaqxpHvpDitzzqEchVPcP+wlmPmQe6RsCymhvi/c4wW/k6ozI+FFwiv+hbMy9FFFQp+nj3tBF9xltEvt48vgSGiFMk7GFig5HigfD2kM9FBG8GEntFjCwcg7+WghufPp43p5u079s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcBePRbC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcBePRbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AC01F000FF;
	Sat, 12 Sep 2026 13:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218570;
	bh=G0PnSu3iraCUVAMcc0ycGSkCws3HmFMido8vDD/52zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XcBePRbCQGGz26JHEco1i+p+EvPB07/YU9ayHb2CtqzdeH6m6FluQUdhNd7xMXAvo
	 TuCElVDtEMNSJrfu2wY3E5W1g/ReENWE73e7w48Yf/rfBgxfXncRWOP+QaWUoBL6U6
	 vUTZ82WxdKo7p87xyBnGYRryBsH8FW5TEJUMka/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shirisha G <shirisha@linux.ibm.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1173/1376] erofs: fix unused pcluster_pools for higher page sizes
Date: Sat, 12 Sep 2026 08:59:59 +0200
Message-ID: <20260912065633.695124227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 335427d05908c..eab5a8eed8486 100644
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



