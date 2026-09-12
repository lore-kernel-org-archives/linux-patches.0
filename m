Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95783542F8;
	Sat, 12 Sep 2026 11:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212741; cv=none; b=kQnHElk58SF5vUYQKWanJ5r6d8w4kLAVK/7I4lmHEEdPCeJUxqFBzREIYqU8LbUu+kqJ9Cr77tK3cFoVnTm63DKBVL1hUOBeMAD2WAynla/KdcMPjw9gnmv/RnH0J9dafNjCjg4lKp6IACEHa7QtrGwW4p+6UPh41gUoXVUZyRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212741; c=relaxed/simple;
	bh=LDfrocHC7nM248jeE2/RcbBO3WgI3szsMRFCuNgczQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZ4KAfRbjxmmNwuJjCLtLjJuwrL5zdF8Rwqj9nOleu5zr8zMSs/tLcwArkn+n/WZeniupGRFDg5PaAlbWmFMI8l85jAm1b5eIFxkbBniBRaZaLdYacrKd+TazwyohkgWl538jAzTqMirEFVEKUehbjl/+Ru4dcpHpE5Z8aKuAno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIFRptYZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIFRptYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849E31F000FF;
	Sat, 12 Sep 2026 11:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212740;
	bh=XkLebUoaCWAbYxMslv4cA8AFWBC1ou9RqWBxwLt8aSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rIFRptYZbM+7j35sxtSGTR044g/kJnNmkj3HBlBQejbzPpLGXqVmdAaIiGydowAxd
	 EdtlmZiurL8n+R2dG+g8T+B4XlHHRRg2j1TX9uCs2htHq2ZJkSIwaOHbb8qow8BbyY
	 qC7I20VpL3lhOeaxNNr3QAOVTq+NBVpZnkQksQHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alberto Salvia Novella <es20490446e@gmail.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>,
	Yifan Zhao <zhaoyifan28@huawei.com>
Subject: [PATCH 6.18 1497/1518] erofs: relax sanity check for tail pclusters due to ztailpacking
Date: Sat, 12 Sep 2026 09:01:06 +0200
Message-ID: <20260912065657.426803659@linuxfoundation.org>
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
index 97a664f81169e..28d99f9e23bfa 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -729,7 +729,8 @@ static int z_erofs_map_sanity_check(struct inode *inode,
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



