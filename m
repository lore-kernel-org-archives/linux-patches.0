Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A50346FD2;
	Thu, 30 Jul 2026 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421449; cv=none; b=e8IZKOSNf9Z07YkCSfzFKbWKNdSL09Ed33R9u4fnnePQWs1SNLDet0VtRnudCQoyt98WHmkpRLW6GRDHmZ4SizWzv6Cqunbndchm47HgJlyU96XhO3rHqon/4SiuYtpwSvRdFR1y0y71mndwjjGLsdyTvCMckdaEhTwmC0VXb/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421449; c=relaxed/simple;
	bh=APWdGz3K2YAIBvGGvTGvkvSTH3gfvlhIyEuQ9qKGwfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mh1M7RTzObFHVhGaU7fEZk0GVp/xaCFCvaZ1WJ8WQTuuA7C/gXSygtOjB1FqEMN4IFiFCd8FtzHHiHlhlY4mfyH9HosHJM+GyNb2JkkO3RUEzGpOu3k1XJR48PtqyWzYLk/M47gaXg38z6c/QM1GtBxNilsF71OlwBeDuPcgJdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYxVSPOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYxVSPOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701F91F000E9;
	Thu, 30 Jul 2026 14:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421448;
	bh=hOusZO2mZF12XdTe2ygVaLbXNk3m9Xbr1w4GBQCORwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SYxVSPOEb6oOVwzLb5pTtFI+e4Uu/8yYtKfB1IvnNXq/9sHcR/SGvpN048uoVZG4b
	 0Hdv+6c9VKU02e+3T0B+ZRjbTjWQ2aTi27L8saSh2m33NHmhlpX0k2Ad0cKWpyzVWR
	 d6nzC8oOtsWH4i8B29DLAfsulPFI7WLnkvWz6Wjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alberto Salvia Novella <es20490446e@gmail.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>
Subject: [PATCH 7.1 080/744] erofs: relax sanity check for tail pclusters due to ztailpacking
Date: Thu, 30 Jul 2026 16:05:53 +0200
Message-ID: <20260730141445.972169359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit d3386e17393bec1341cfeedb9d08d6846ccd6fb2 ]

If the tail data can be inlined into the inode meta block, it should
be converted into a regular tail pcluster.

In principle, it should be converted into an uncompressed pcluster if
there is not enough gain to use compression (map->m_llen < map->m_plen);
but since there are various shipped images, relax the condition for
ztailpacking tail pcluster fallback instead of reporting corruption
incorrectly.

Reported-and-tested-by: Yifan Zhao <zhaoyifan28@huawei.com>
Reported-by: Alberto Salvia Novella <es20490446e@gmail.com>
Closes: https://github.com/erofs/erofs-utils/issues/51
Fixes: a5242d37c83a ("erofs: error out obviously illegal extents in advance")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index e1a02a2c8406bf..53e8a9f2fb9109 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -721,7 +721,8 @@ static int z_erofs_map_sanity_check(struct inode *inode,
 				  map->m_algorithmformat, EROFS_I(inode)->nid);
 			return -EFSCORRUPTED;
 		}
-		if (EROFS_MAP_FULL(map->m_flags) && map->m_llen < map->m_plen) {
+		if (EROFS_MAP_FULL(map->m_flags) && map->m_llen < map->m_plen &&
+		    map->m_la + map->m_llen < inode->i_size) {
 			erofs_err(inode->i_sb, "too much compressed data @ la %llu of nid %llu",
 				  map->m_la, EROFS_I(inode)->nid);
 			return -EFSCORRUPTED;
-- 
2.53.0



