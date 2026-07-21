Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1186D43D4FE;
	Tue, 21 Jul 2026 21:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667917; cv=none; b=Bqrz9PCLx0bMxKDECNgUiA1zpZxzIc3ZEaKCKBOqZhQAhmBnl0fQuRS8wVbSNUoE38tLCWEQCm+jpEhZ6O+GxLxGd9ojA02RlNwOxrkSprTkBAUCr7TZqojyAUnuWmkVJZf7hJmlwMw2Yg2ZhIPn2gJosbf/Pxd/k6h5Zzjb+/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667917; c=relaxed/simple;
	bh=aehnxljrLyyB6lKbVOX+byMXpfdo+v9X7cPSjPy6qRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOjuR2Enlzoz7ZWTWYnmETHxNOi87ciKXbAnfq/b92pdVs69wOOcFdGA1Wpo2J5R32WKAE6/N3O96oNFTJ63D7nzizSlqHGgUh3qqGJthPanKA1whtzlt4fZrDtzuOspMh3wU5eRG94NFeSmlIfadTUfT2XZw+MVtWnRTl1NdA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oa2Fehas; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oa2Fehas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0214C1F000E9;
	Tue, 21 Jul 2026 21:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667914;
	bh=eLDRk6k8uNwFYU05OVnrR9OvkNZLmOVvBEDvX3RQdcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oa2FehaszmMKgznpBYcYTq6XlX51pmP5PshZc9EdWoPWVcJoUGoRnmoSB92Og/erp
	 BUG2OC4tv5jffiOa/b8xmIpPYpkrOj0sAVn3VuMjp18u6Nc72VuTignQfRP6sYuSgu
	 o0A3xo+VtiWWaxlnUBwUimqOIfjYBEpfOGzVeRRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Andy Wu <Andy.Wu@sony.com>,
	Aoyama Wataru <wataru.aoyama@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1239/1266] exfat: move free cluster out of exfat_init_ext_entry()
Date: Tue, 21 Jul 2026 17:27:56 +0200
Message-ID: <20260721152509.540108309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 4e1aa22fea106014397455506d1383d519c4d3d1 ]

exfat_init_ext_entry() is an init function, it's a bit strange
to free cluster in it. And the argument 'inode' will be removed
from exfat_init_ext_entry(). So this commit changes to free the
cluster in exfat_remove_entries().

Code refinement, no functional changes.

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Andy Wu <Andy.Wu@sony.com>
Reviewed-by: Aoyama Wataru <wataru.aoyama@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 942296784b2a ("exfat: preserve benign secondary entries during rename and move")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/dir.c   |    3 ---
 fs/exfat/namei.c |    7 ++++---
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -584,9 +584,6 @@ int exfat_init_ext_entry(struct inode *i
 		if (!ep)
 			return -EIO;
 
-		if (exfat_get_entry_type(ep) & TYPE_BENIGN_SEC)
-			exfat_free_benign_secondary_clusters(inode, ep);
-
 		exfat_init_name_entry(ep, uniname);
 		exfat_update_bh(bh, sync);
 		brelse(bh);
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1089,13 +1089,14 @@ static int exfat_rename_file(struct inod
 		}
 		exfat_update_bh(old_bh, sync);
 		brelse(old_bh);
+
+		exfat_remove_entries(inode, p_dir, oldentry,
+			ES_IDX_FIRST_FILENAME + 1, num_old_entries);
+
 		ret = exfat_init_ext_entry(inode, p_dir, oldentry,
 			num_new_entries, p_uniname);
 		if (ret)
 			return ret;
-
-		exfat_remove_entries(inode, p_dir, oldentry, num_new_entries,
-			num_old_entries);
 	}
 	return 0;
 }


