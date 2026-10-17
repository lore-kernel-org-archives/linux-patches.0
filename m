Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C750D2C026C;
	Sat, 17 Oct 2026 16:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254184; cv=none; b=tPuVlZutcGmBonmkugRrX+d1/5s/sBScCHrB+7ZFW5ItfhIV8zLIJZgroxHXF+LGxpP8miw8Y6AW0AynCa2AN2s+m9JmgdsVzHbXHw49MEjNdHxX7NgpD6L8R3eVwQ5h9S//PnpHw88pOGJGaPL4jAPkmi0QAegyEFeURHFrdEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254184; c=relaxed/simple;
	bh=5pUDS6zJD1v7AkHliI3k+pWpEHUwzYQyJvX5FKXeC+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPYZwZJ57IFXDJ2QhrPFl4W+2D2WVB/pMEAKNkhAmnZHMe1VgnMsR6EsbDm8FhNV4+uM4bMX72WR8iQGIkS8vgsweYtKlAmG8d3cc/Nj/yc4hMTRpB6RLDxrCJKyUC01rbh8lDpAyQrNp8zhP+p2gPzWsoy6NzjqHPo+uSZGjwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b000DPYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b000DPYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDE01F000C4;
	Sat, 17 Oct 2026 16:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254183;
	bh=SoJsVRUtSvd+TWMePM4frUSqaOw9juHAHfT9yzZDuoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b000DPYt2Pf1SOwSdJyxyyIlrd8p/iVzyS4T62YMWjnFqR8RQCjejt6AEzNIwinIl
	 ADOsq3MCwkK8NV+FdtOTeweMp19h0WCk3OnJThL1wIzMqbWNmF33rGJxu3r7kpH4L2
	 wQLmIotpitxcu4O3CzHG0Tgr+g0db/WryhnI2Sss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 363/869] erofs: fix metabuf leak in inode xattr initialization
Date: Sat, 17 Oct 2026 17:53:24 +0200
Message-ID: <20261017160046.414575661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Jia Zhu <zhujia.zj@bytedance.com>

[ Upstream commit 79b09c54c6563df9846ca3094bcfd72082c3e1d7 ]

commit bb88e8da0025 ("erofs: use meta buffers for xattr operations")
converted xattr operations to use on-stack erofs_buf instances.
erofs_init_inode_xattrs() uses such a metabuf while reading the inline
xattr header and shared xattr id array.

Some error paths after erofs_read_metabuf() leave through out_unlock
without dropping the metabuf, so the folio reference can leak.

Consolidate the cleanup at out_unlock. erofs_put_metabuf() is a
no-op if no folio has been acquired, and this keeps all paths after
taking EROFS_I_BL_XATTR_BIT covered by a single cleanup site.

Fixes: bb88e8da0025 ("erofs: use meta buffers for xattr operations")
Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Fixes: bb88e8da0025 ("erofs: use meta buffers for xattr operations")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/xattr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index 60d2cf26e837e..9753df4e95a24 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -47,6 +47,8 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 	if (wait_on_bit_lock(&vi->flags, EROFS_I_BL_XATTR_BIT, TASK_KILLABLE))
 		return -ERESTARTSYS;
 
+	it.buf = __EROFS_BUF_INITIALIZER;
+
 	/* someone has initialized xattrs for us? */
 	if (test_bit(EROFS_I_EA_INITED_BIT, &vi->flags))
 		goto out_unlock;
@@ -76,7 +78,6 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 		goto out_unlock;
 	}
 
-	it.buf = __EROFS_BUF_INITIALIZER;
 	erofs_init_metabuf(&it.buf, sb);
 	it.pos = erofs_iloc(inode) + vi->inode_isize;
 
@@ -93,7 +94,6 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 	vi->xattr_shared_xattrs = kmalloc_array(vi->xattr_shared_count,
 						sizeof(uint), GFP_KERNEL);
 	if (!vi->xattr_shared_xattrs) {
-		erofs_put_metabuf(&it.buf);
 		ret = -ENOMEM;
 		goto out_unlock;
 	}
@@ -112,13 +112,13 @@ static int erofs_init_inode_xattrs(struct inode *inode)
 		vi->xattr_shared_xattrs[i] = le32_to_cpu(*(__le32 *)it.kaddr);
 		it.pos += sizeof(__le32);
 	}
-	erofs_put_metabuf(&it.buf);
 
 	/* paired with smp_mb() at the beginning of the function. */
 	smp_mb();
 	set_bit(EROFS_I_EA_INITED_BIT, &vi->flags);
 
 out_unlock:
+	erofs_put_metabuf(&it.buf);
 	clear_and_wake_up_bit(EROFS_I_BL_XATTR_BIT, &vi->flags);
 	return ret;
 }
-- 
2.53.0



